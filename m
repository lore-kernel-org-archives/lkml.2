Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161990Ab2CPWxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:53:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161971Ab2CPWw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:52:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Fri, 16 Mar 2012 23:57:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203162319.53460.rjw@sisk.pl> <201203162325.56303.chunkeey@googlemail.com>
In-Reply-To: <201203162325.56303.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203162357.10770.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 16, 2012, Christian Lamparter wrote:
> On Friday 16 March 2012 23:19:53 Rafael J. Wysocki wrote:
> > > On 03/04/2012 01:52 AM, Christian Lamparter wrote:
> > > 
> > > > During resume, the userhelper might not be available. However for
> > > > drivers which use the request_firmware_nowait interface, this will
> > > > only lead to a pointless WARNING and a device which no longer works
> > > > after the resume [since it couldn't get the firmware, because the
> > > > userhelper was not available to take the request].
> > > > 
> > > > In order to solve this "chicken or egg" dilemma, the code now
> > > > retries _nowait requests at one second intervals until the
> > > > "loading_timeout" time is up.
> > > > 
> > > > ---
> > > > I'm aware about the previous "request_firmware* in probe" discussions.
> > > > Unfortunately, the hardware needs firmware so there is no other way
> > > > around it. So please, I just wanted to know what the general opinion
> > > > about the idea behind this patch is.
> > 
> > BTW, I wonder what comments on this patch were posted?
> Only Alan Cox was kind enough to drop me a few words.
> 
> Why? Do you think it is actually sane from a specific POV?
> [Don't tell me you do :D !]

I don't think it's really wrong.

I agree that the WARN_ON() isn't really useful in the request_firmware_nowait()
case, because the user of that doesn't really know when exactly the firmware is
going to be requested, so it can't really do anything about the warning.

Moreover, failures of request_firmware_nowait() just because it happens to
race with system suspend (or something of that kind), just because of "bad"
timing, aren't really useful either.

So, I think it makes sense for it to wait until the firmware can be loaded.

I'd do that a bit differently, though, for example like in the appended patch
(untested).

Thanks,
Rafael

---
 drivers/base/firmware_class.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -20,6 +20,7 @@
 #include <linux/highmem.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
@@ -535,10 +536,31 @@ static int _request_firmware(const struc
 
 	read_lock_usermodehelper();
 
-	if (WARN_ON(usermodehelper_is_disabled())) {
+	if (nowait) {
+		int limit = loading_timeout * MSEC_PER_SEC;
+		int timeout = 10;  /* in msec */
+
+		while (usermodehelper_is_disabled()) {
+			read_unlock_usermodehelper();
+
+			msleep(timeout);
+			if (loading_timeout > 0) {
+				limit -= timeout;
+				if (limit <= 0) {
+					retval = -EBUSY;
+					goto out;
+				}
+			}
+			timeout += timeout;
+			if (loading_timeout > 0 && timeout > limit)
+				timeout = limit;
+
+			read_lock_usermodehelper();
+		}
+	} else if (WARN_ON(usermodehelper_is_disabled())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
-		goto out;
+		goto unlock;
 	}
 
 	if (uevent)
@@ -547,7 +569,7 @@ static int _request_firmware(const struc
 	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
 	if (IS_ERR(fw_priv)) {
 		retval = PTR_ERR(fw_priv);
-		goto out;
+		goto unlock;
 	}
 
 	if (uevent) {
@@ -572,9 +594,10 @@ static int _request_firmware(const struc
 
 	fw_destroy_instance(fw_priv);
 
-out:
+unlock:
 	read_unlock_usermodehelper();
 
+out:
 	if (retval) {
 		release_firmware(firmware);
 		*firmware_p = NULL;
