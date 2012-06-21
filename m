Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2FUQOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:14:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60956 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759601Ab2FUQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:14:11 -0400
X-Authenticated: #27347261
X-Provags-ID: V01U2FsdGVkX19eX0s3JMVe22NG6/YRU0MHC/NVmWRqVHY+teXBVF
	lDvyBk5+IAKz/O
From: =?UTF-8?q?Beat=20K=C3=BCng?= <beat-kueng@gmx.net>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beat=20K=C3=BCng?= <beat-kueng@gmx.net>
Subject: [PATCH 1/1] firmware: option to prevent firmware loading from userspace
Date: Thu, 21 Jun 2012 18:13:54 +0200
Message-Id: <1340295234-31613-1-git-send-email-beat-kueng@gmx.net>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Initially I had a problem with resuming from hibernation (debian testing amd64
system). The kernel would simply wait for 60 sec when trying to resume. I found
out that the resume thread was trying to aquire the user mode helper lock. Which
was held by the firmware loader (module iwlwifi) trying to load a firmware. But
there was no user space app to reply to the request so the kernel was waiting
for a timeout that is set to 60 seconds.

I use built-in firmware anyway, so there is no use to wait for user space to get
a firmware. So I came up with the following patch (applies to 3.5-rc3):
(It's my first patch and I'd like to get involved in kernel hacking, so any help
or recommendations are appreciated)

Only consider firmware built into the kernel binary when loading firmware.
This saves time waiting for a userspace application like udev or a
timeout if there is no userspace application. Especially if a driver is
looking for different versions of a firmware.

Signed-off-by: Beat Küng <beat-kueng@gmx.net>
---
 drivers/base/Kconfig          |   10 ++++++++++
 drivers/base/firmware_class.c |    8 ++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 9b21469..b0a2259 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -107,6 +107,16 @@ config FIRMWARE_IN_KERNEL
 
 	  Say 'N' and let firmware be loaded from userspace.
 
+config FIRMWARE_DISABLE_USERSPACE
+	bool "Disable firmware loading from userspace"
+	depends on FIRMWARE_IN_KERNEL
+	default n
+	help
+	  Only consider firmware built into the kernel binary when loading firmware.
+	  This saves time waiting for a userspace application like udev or a
+	  timeout if there is no userspace application. Especially if a driver is
+	  looking for different versions of a firmware.
+
 config EXTRA_FIRMWARE
 	string "External firmware blobs to build into the kernel binary"
 	depends on FW_LOADER
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 5401814..7af8c3a 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -492,6 +492,14 @@ _request_firmware_prepare(const struct firmware **firmware_p, const char *name,
 		return NULL;
 	}
 
+#ifdef CONFIG_FIRMWARE_DISABLE_USERSPACE
+	dev_warn(device, "firmware: no built-in firmware %s. User space request is disabled\n"
+			, name);
+	release_firmware(firmware);
+	*firmware_p = NULL;
+	return NULL;
+#endif /* CONFIG_FIRMWARE_DISABLE_USERSPACE */
+
 	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
 	if (IS_ERR(fw_priv)) {
 		release_firmware(firmware);
-- 
1.7.9.1

