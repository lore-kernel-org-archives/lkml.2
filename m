Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab0L1XBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:01:20 -0500
Received: from mailfilter3.ihug.co.nz ([203.109.136.3]:1029 "EHLO
	mailfilter67.ihug.co.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752510Ab0L1XBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:01:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL76GU12XLpw/2dsb2JhbACkMXS+fYVKBIsEh3w
X-IronPort-AV: E=Sophos;i="4.60,241,1291546800"; 
   d="scan'208";a="122413453"
Date: Wed, 29 Dec 2010 12:01:16 +1300
From: Ralph Loader <suckfish@ihug.co.nz>
To: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Ralph Loader <suckfish@ihug.co.nz>
Subject: Re: [PATCH] Fix some incorrect use of positive error codes.
Message-Id: <20101229120116.9eeb9261.suckfish@ihug.co.nz>
In-Reply-To: <alpine.LNX.2.00.1012271227260.16569@pobox.suse.cz>
References: <20101226185718.aa60e0cd.suckfish@ihug.co.nz>
	<alpine.LNX.2.00.1012271227260.16569@pobox.suse.cz>
X-Mailer: Sylpheed 3.1.0beta5 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> wrote:
> Could you please split the staging bits and submit them separately to 
> Greg?

As Jiri requested, the staging fixes as a separate commit.  I'll repost the non-staging changes as a separate commit also.

Cheers,
Ralph.

staging: Fix some incorrect use of positive error codes.

Use -E... instead of just E... in a few places where negative error
codes are expected by a functions callers.  These were found by grepping
with coccinelle & then inspecting by hand to determine which were bugs.

The staging/cxt1e1 driver appears to intentionally use positive E...
error codes in some places, and negative -E... error codes in others,
making it hard to know which is intended where - very likely I missed
some problems in that driver.

Signed-off-by: Ralph Loader <suckfish@ihug.co.nz>
---
 drivers/staging/ath6kl/os/linux/ioctl.c            |   10 +++++-----
 drivers/staging/bcm/InterfaceMisc.c                |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 +-
 drivers/staging/cxt1e1/linux.c                     |    2 +-
 .../staging/westbridge/astoria/device/cyasdevice.c |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index d5f7ac0..0b10376 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -440,7 +440,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
             if (ar->rssi_map[j+1].rssi < ar->rssi_map[j].rssi) {
                 SWAP_THOLD(ar->rssi_map[j+1], ar->rssi_map[j]);
             } else if (ar->rssi_map[j+1].rssi == ar->rssi_map[j].rssi) {
-                return EFAULT;
+                return -EFAULT;
             }
         }
     }
@@ -449,7 +449,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
             if (ar->rssi_map[j+1].rssi < ar->rssi_map[j].rssi) {
                 SWAP_THOLD(ar->rssi_map[j+1], ar->rssi_map[j]);
             } else if (ar->rssi_map[j+1].rssi == ar->rssi_map[j].rssi) {
-                return EFAULT;
+                return -EFAULT;
             }
         }
     }
@@ -2870,7 +2870,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                              gpio_output_set_cmd.enable_mask,
                                              gpio_output_set_cmd.disable_mask);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
             }
             up(&ar->arSem);
@@ -2950,7 +2950,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                                gpio_register_cmd.gpioreg_id,
                                                gpio_register_cmd.value);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
 
                 /* Wait for acknowledgement from Target */
@@ -3041,7 +3041,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
             } else {
                 ret = ar6000_gpio_intr_ack(dev, gpio_intr_ack_cmd.ack_mask);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
             }
             up(&ar->arSem);
diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
index 8fc893b..72be09f 100644
--- a/drivers/staging/bcm/InterfaceMisc.c
+++ b/drivers/staging/bcm/InterfaceMisc.c
@@ -102,7 +102,7 @@ InterfaceWRM(PS_INTERFACE_ADAPTER psIntfAdapter,
 	if((psIntfAdapter->psAdapter->StopAllXaction == TRUE) && (psIntfAdapter->psAdapter->chip_id >= T3LPB))
 	{
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, WRM, DBG_LVL_ALL,"Currently Xaction is not allowed on the bus...");
-		return EACCES;
+		return -EACCES;
 	}
 
 	if(psIntfAdapter->bSuspended ==TRUE || psIntfAdapter->bPreparingForBusSuspend == TRUE)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 979a494..b68bc54 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -1369,7 +1369,7 @@ wl_iw_iscan_set_scan(struct net_device *dev,
 	if (g_scan_specified_ssid) {
 		WL_TRACE(("%s Specific SCAN already running ignoring BC scan\n",
 			  __func__));
-		return EBUSY;
+		return -EBUSY;
 	}
 
 	memset(&ssid, 0, sizeof(ssid));
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index c793028..7af4887 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -548,7 +548,7 @@ do_set_port (struct net_device * ndev, void *data)
         return -EINVAL;             /* get card info */
 
     if (pp.portnum >= ci->max_port) /* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     memcpy (&ci->port[pp.portnum].p, &pp, sizeof (struct sbecom_port_param));
     return mkret (c4_set_port (ci, pp.portnum));
diff --git a/drivers/staging/westbridge/astoria/device/cyasdevice.c b/drivers/staging/westbridge/astoria/device/cyasdevice.c
index c76e383..0889730 100644
--- a/drivers/staging/westbridge/astoria/device/cyasdevice.c
+++ b/drivers/staging/westbridge/astoria/device/cyasdevice.c
@@ -389,7 +389,7 @@ EXPORT_SYMBOL(cyasdevice_gethaltag);
 static int __init cyasdevice_init(void)
 {
 	if (cyasdevice_initialize() != 0)
-		return ENODEV;
+		return -ENODEV;
 
 	return 0;
 }
-- 
1.7.3.4

