Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab1EBWoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:44:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab1EBWoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:44:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
Date: Tue, 3 May 2011 00:44:51 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105030044.51661.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some drivers erroneously use request_firmware() from their ->resume()
(or ->thaw(), or ->restore()) callbacks, which is not going to work
unless the firmware has been built in.  This causes system resume to
stall until the firmware-loading timeout expires, which makes users
think that the resume has failed and reboot their machines
unnecessarily.  For this reason, make _request_firmware() print a
warning when it has been called when tasks are frozen and it's
impossible to start any new usermode helpers.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |    3 +++
 include/linux/kmod.h          |    1 +
 kernel/kmod.c                 |    8 ++++++++
 3 files changed, 12 insertions(+)

Index: linux-2.6/include/linux/kmod.h
===================================================================
--- linux-2.6.orig/include/linux/kmod.h
+++ linux-2.6/include/linux/kmod.h
@@ -113,5 +113,6 @@ extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
+extern bool usermodehelper_is_disabled(void);
 
 #endif /* __LINUX_KMOD_H__ */
Index: linux-2.6/kernel/kmod.c
===================================================================
--- linux-2.6.orig/kernel/kmod.c
+++ linux-2.6/kernel/kmod.c
@@ -301,6 +301,14 @@ void usermodehelper_enable(void)
 	usermodehelper_disabled = 0;
 }
 
+/**
+ * usermodehelper_is_disabled - check if new helpers are allowed to be started
+ */
+bool usermodehelper_is_disabled(void)
+{
+	return usermodehelper_disabled;
+}
+
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);
Index: linux-2.6/drivers/base/firmware_class.c
===================================================================
--- linux-2.6.orig/drivers/base/firmware_class.c
+++ linux-2.6/drivers/base/firmware_class.c
@@ -521,6 +521,9 @@ static int _request_firmware(const struc
 	if (!firmware_p)
 		return -EINVAL;
 
+	if (WARN_ON(usermodehelper_is_disabled()))
+		return -EBUSY;
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
