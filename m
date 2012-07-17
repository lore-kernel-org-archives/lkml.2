Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2GQTQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:16:51 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2GQTQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:16:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Tue, 17 Jul 2012 21:22:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com> <CAMP5XgfF3RF1hSonS_QrC8jQZyCcNfwGYZcCxnew02Rp3-CXKA@mail.gmail.com> <CAHO5Pa3nWvmWY9jFZ-4ayvjGAV-4Vhs5sS18dbzniJp8wZYmoQ@mail.gmail.com>
In-Reply-To: <CAHO5Pa3nWvmWY9jFZ-4ayvjGAV-4Vhs5sS18dbzniJp8wZYmoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207172122.26201.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 17, 2012, Michael Kerrisk wrote:
> On Tue, Jul 17, 2012 at 12:04 AM, Arve Hjønnevåg <arve@android.com> wrote:
> > On Mon, Jul 16, 2012 at 4:00 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Monday, July 16, 2012, Michael Kerrisk wrote:
> >>> Arve, Rafael,
> >>>
> >>> On Tue, May 1, 2012 at 7:33 AM, Arve Hjønnevåg <arve@android.com> wrote:
> >>> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> >>> > wakeup_source will be active to prevent suspend. This can be used to
> >>> > handle wakeup events from a driver that support poll, e.g. input, if
> >>> > that driver wakes up the waitqueue passed to epoll before allowing
> >>> > suspend.
> >>>
> >>> It's late it the -rc series,
> >>
> >> Well, exactly. :-)
> 
> If someone had CCed linux-api@ along the way (as per
> Documentation/SubmitChecklist), it might have helped ;-)

Well, it still _is_ late.

> >>> but it strikes me that CAP_EPOLLWAKEUP is
> >>> a poor name for the capability that governs the use of EPOLLWAKEUP.
> >>> While on the one hand some capabilities are overloaded
> >>> (https://lwn.net/Articles/486306/), on the other hand we should avoid
> >>> adding individual capabilities for each new API feature (otherwise
> >>> capabilities become administratively unwieldy).
> >>>
> >>> This capability is not really about "EPOLL". It's about the ability to
> >>> block system suspend. Therefore, IMO, a better name would be something
> >>> like: CAP_BLOCK_SUSPEND. This name is better because there might be
> >>> some other API feature that is later added that also has the effect of
> >>> preventing system suspends, and we could reasonably govern that
> >>> feature with the same capability.
> >
> > We already have another api, "/sys/power/wake_lock", that allow
> > user-space to block suspend. Do we want to apply this capability that
> > api as well, or only to apis that do not have other ways to restrict
> > access?
> 
> Well, the question is: is there a governor on the use of
> /sys/power/wake_lock? It makes sense either they are both governed
> (preferably by the same mechanism, I would have thought), or neither
> is.
> 
> >>> Does that seem sensible to you? I can send a patch for the name change.
> >>
> >> I'm not sure what Arve thinks about that, but I'd be fine with that.
> >>
> >> Arve, what do you think?
> >>
> >
> > CAP_BLOCK_SUSPEND is fine with me, but if it does not apply to the
> > sysfs interface, then the comment should probably mention this.
> 
> I've sent a patch, but omitted mention of API details in the comments.
> Maybe that can be changed afterward, when a decision has been reached
> about governing /sys/power/wake_lock.

I'm going to push your patch for v3.5, but then I'm considering the following
one for v3.6.  I wouldn't like to make more changes in v3.5-rc at this point,
if possible.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Sleep: Require CAP_BLOCK_SUSPEND to use wake_lock/wake_unlock

Require processes wanting to use the wake_lock/wake_unlock sysfs
files to have the CAP_BLOCK_SUSPEND capability, which also is
required for the eventpoll EPOLLWAKEUP flag to be effective, so that
all interfaces related to blocking autosleep depend on the same
capability.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/wakelock.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/kernel/power/wakelock.c
===================================================================
--- linux.orig/kernel/power/wakelock.c
+++ linux/kernel/power/wakelock.c
@@ -9,6 +9,7 @@
  * manipulate wakelocks on Android.
  */
 
+#include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -188,6 +189,9 @@ int pm_wake_lock(const char *buf)
 	size_t len;
 	int ret = 0;
 
+	if (!capable(CAP_BLOCK_SUSPEND))
+		return -EPERM;
+
 	while (*str && !isspace(*str))
 		str++;
 
@@ -231,6 +235,9 @@ int pm_wake_unlock(const char *buf)
 	size_t len;
 	int ret = 0;
 
+	if (!capable(CAP_BLOCK_SUSPEND))
+		return -EPERM;
+
 	len = strlen(buf);
 	if (!len)
 		return -EINVAL;
