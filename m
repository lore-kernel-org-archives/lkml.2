Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0FBSph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab0FBSpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:45:35 -0400
Date: Wed, 2 Jun 2010 14:44:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
Message-ID: <20100602184459.GA15159@redhat.com>
References: <4C03C608.1040600@gmail.com>
 <20100601135004.GP15159@redhat.com>
 <4C051D44.7040203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C051D44.7040203@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 04:46:28PM +0200, Jiri Slaby wrote:
> On 06/01/2010 03:50 PM, Don Zickus wrote:
> > On Mon, May 31, 2010 at 04:22:00PM +0200, Jiri Slaby wrote:
> >> Hi,
> >>
> >> with -next I get the following errors while trying to hibernate in
> >> qemu-kvm after the image is stored on disk:
> > 
> > Is this the host that is hibernating or the guest?
> 
> Guest.
> 
> > KVM guests don't emulate the performance counters, so the nmi piece
> > shouldn't be functioning and the soft lockup piece just sits on top of an
> > hrtimer, so off the top of my head it is hard to imagine it intefering
> > with a sata driver.
> > 
> > I'll need your whole boot up log to see how the lockup detector
> > initialized itself.

Ok, so I found out what is causing the problem, not entirely sure why or
what the right fix is, but this patch should do the trick.

This is probably one of those fixing the symptoms but not the problem patch,
but I don't know enough about suspend/resume to understand what the real
problem is.

---->SNIP<---------------------
[lockup detector] don't return NOTIFY_BAD when cpu goes online for suspend

KVM guests do not support performance counter emulation, so if the nmi
watchdog piece is compiled in, it will always fail during boot.  The
failure returns NOTIFY_BAD when the cpu goes online in the cpu notifier
callback.  Returning NOTIFY_BAD causes hibernation to do really bad
things, so avoid doing that.

The cpu failure shouldn't be a critical failure anyway, so returning
NOTIFY_BAD was probably overstating things.

Signed-off-by: Don Zickus <dzickus@redhat.com>


diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6b7fad8..fda9770 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -550,8 +550,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (watchdog_enable(hotcpu))
-			return NOTIFY_BAD;
+		watchdog_enable(hotcpu)
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
