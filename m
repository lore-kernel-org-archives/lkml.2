Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1ECLBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:01:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1ECLBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:01:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
Date: Tue, 3 May 2011 13:02:08 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201105030044.51661.rjw@sisk.pl> <50363.1304379012@localhost>
In-Reply-To: <50363.1304379012@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031302.08910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 03, 2011, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 May 2011 00:44:51 +0200, "Rafael J. Wysocki" said:
> 
> > +	if (WARN_ON(usermodehelper_is_disabled()))
> > +		return -EBUSY;
> > +
> 
> Since this is a "no user serviceable parts inside" type of error, so I guess
> WARN_ON rather than a printk(KERN_WARNING is a good idea so we get
> a traceback pointing out the offending driver.
> 
> I have to wonder 2 things though:
> 
> 1) What percent of the time the missing firmware (or other issues, like the
> display not being resumed yet) will prevent the WARN_ON output from making it
> to the display *anyhow*, so the user *still* hits the power button to try again?

Although the WARN_ON output will probably not make it to the user's screen
immediately, the resume will continue without the delay, because error code
will be returned as soon as the WARN_ON triggers.

The user will likely notice the device not working after the resume and will
look at dmesg output. :-)

> 2) What percent of the time the WARN_ON output will itself make the user
> think the resume has died rather than just being slow, causing them to power
> cycle and hope for a clean boot?
> 
> Maybe something like this instead?
> 
> 	if (WARN_ON(usermodehelper_is_disable()))) {
> 		printk(KERN_WARNING "Resume continuing, but firmware for %s not loaded", device);

It's useful, but I'd rather do

 		dev_info(device, "firmware: %s will not be loaded\n", name);

> 		return -EBUSY;
> 	}
> 
> (or whatever that %s actually needs to work)
> 
> All the same, it still looks better than what we're doing now.

OK, updated patch is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Print a warning if firmware is requested when tasks are frozen

Some drivers erroneously use request_firmware() from their ->resume()
(or ->thaw(), or ->restore()) callbacks, which is not going to work
unless the firmware has been built in.  This causes system resume to
stall until the firmware-loading timeout expires, which makes users
think that the resume has failed and reboot their machines
unnecessarily.  For this reason, make _request_firmware() print a
warning and return immediately with error code if it has been called
when tasks are frozen and it's impossible to start any new usermode
helpers.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |    5 +++++
 include/linux/kmod.h          |    1 +
 kernel/kmod.c                 |    8 ++++++++
 3 files changed, 14 insertions(+)

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
@@ -521,6 +521,11 @@ static int _request_firmware(const struc
 	if (!firmware_p)
 		return -EINVAL;
 
+	if (WARN_ON(usermodehelper_is_disabled())) {
+		dev_info(device, "firmware: %s will not be loaded\n", name);
+		return -EBUSY;
+	}
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
