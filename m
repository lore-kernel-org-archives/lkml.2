Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab3AIUhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:41627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab3AIUhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 13/80] b43legacy: Fix firmware loading when driver is built into the kernel
Date: Wed,  9 Jan 2013 12:35:05 -0800
Message-Id: <20130109201502.082996944@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 576d28a7c73013717311cfcb514dbcae27c82eeb upstream.

Recent versions of udev cause synchronous firmware loading from the
probe routine to fail because the request to user space times out.
The original fix for b43legacy (commit a3ea2c7) moved the firmware
load from the probe routine to a work queue, but it still used synchronous
firmware loading. This method is OK when b43legacy is built as a module;
however, it fails when the driver is compiled into the kernel.

This version changes the code to load the initial firmware file
using request_firmware_nowait(). A completion event is used to
hold the work queue until that file is available. The remaining
firmware files are read synchronously.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43legacy/b43legacy.h |    5 +++
 drivers/net/wireless/b43legacy/main.c      |   37 ++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -13,6 +13,7 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_driver_chipcommon.h>
+#include <linux/completion.h>
 
 #include <net/mac80211.h>
 
@@ -733,6 +734,10 @@ struct b43legacy_wldev {
 
 	/* Firmware data */
 	struct b43legacy_firmware fw;
+	const struct firmware *fwp;	/* needed to pass fw pointer */
+
+	/* completion struct for firmware loading */
+	struct completion fw_load_complete;
 
 	/* Devicelist in struct b43legacy_wl (all 802.11 cores) */
 	struct list_head list;
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1511,9 +1511,17 @@ static void b43legacy_print_fw_helptext(
 		     "and download the correct firmware (version 3).\n");
 }
 
+static void b43legacy_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct b43legacy_wldev *dev = context;
+
+	dev->fwp = firmware;
+	complete(&dev->fw_load_complete);
+}
+
 static int do_request_fw(struct b43legacy_wldev *dev,
 			 const char *name,
-			 const struct firmware **fw)
+			 const struct firmware **fw, bool async)
 {
 	char path[sizeof(modparam_fwpostfix) + 32];
 	struct b43legacy_fw_header *hdr;
@@ -1526,7 +1534,24 @@ static int do_request_fw(struct b43legac
 	snprintf(path, ARRAY_SIZE(path),
 		 "b43legacy%s/%s.fw",
 		 modparam_fwpostfix, name);
-	err = request_firmware(fw, path, dev->dev->dev);
+	b43legacyinfo(dev->wl, "Loading firmware %s\n", path);
+	if (async) {
+		init_completion(&dev->fw_load_complete);
+		err = request_firmware_nowait(THIS_MODULE, 1, path,
+					      dev->dev->dev, GFP_KERNEL,
+					      dev, b43legacy_fw_cb);
+		if (err) {
+			b43legacyerr(dev->wl, "Unable to load firmware\n");
+			return err;
+		}
+		/* stall here until fw ready */
+		wait_for_completion(&dev->fw_load_complete);
+		if (!dev->fwp)
+			err = -EINVAL;
+		*fw = dev->fwp;
+	} else {
+		err = request_firmware(fw, path, dev->dev->dev);
+	}
 	if (err) {
 		b43legacyerr(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
@@ -1578,7 +1603,7 @@ static void b43legacy_request_firmware(s
 			filename = "ucode4";
 		else
 			filename = "ucode5";
-		err = do_request_fw(dev, filename, &fw->ucode);
+		err = do_request_fw(dev, filename, &fw->ucode, true);
 		if (err)
 			goto err_load;
 	}
@@ -1587,7 +1612,7 @@ static void b43legacy_request_firmware(s
 			filename = "pcm4";
 		else
 			filename = "pcm5";
-		err = do_request_fw(dev, filename, &fw->pcm);
+		err = do_request_fw(dev, filename, &fw->pcm, false);
 		if (err)
 			goto err_load;
 	}
@@ -1605,7 +1630,7 @@ static void b43legacy_request_firmware(s
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals);
+		err = do_request_fw(dev, filename, &fw->initvals, false);
 		if (err)
 			goto err_load;
 	}
@@ -1625,7 +1650,7 @@ static void b43legacy_request_firmware(s
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals_band);
+		err = do_request_fw(dev, filename, &fw->initvals_band, false);
 		if (err)
 			goto err_load;
 	}


