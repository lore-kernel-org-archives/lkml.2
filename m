Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1IWMag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:30:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1IWMaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:30:35 -0400
Date: Fri, 23 Sep 2011 14:26:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 5/5] ptrace: implement PTRACE_LISTEN
Message-ID: <20110923122634.GA28898@redhat.com>
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <1308043218-23619-6-git-send-email-tj@kernel.org> <1316776650.5262.26.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316776650.5262.26.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Matt Fleming wrote:
>
> On Tue, 2011-06-14 at 11:20 +0200, Tejun Heo wrote:
>
> [...]
>
> > +	case PTRACE_LISTEN:
> > +		/*
> > +		 * Listen for events.  Tracee must be in STOP.  It's not
> > +		 * resumed per-se but is not considered to be in TRACED by
> > +		 * wait(2) or ptrace(2).  If an async event (e.g. group
> > +		 * stop state change) happens, tracee will enter STOP trap
> > +		 * again.  Alternatively, ptracer can issue INTERRUPT to
> > +		 * finish listening and re-trap tracee into STOP.
> > +		 */
> > +		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
> > +			break;
> > +
> > +		si = child->last_siginfo;
> > +		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP))
> > +			break;
>
> I've only just noticed this. You really don't want to break out of the
> switch while holding sighand->siglock. This should read,
>
> 		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP)) {
> 			unlock_task_sighand(child, &flags);
>			break;

OOOPS!!! Thanks... or perhaps the patch below.

This is must have for 3.1. I'll test it and send to Linus.

Good catch, thanks.

And I seem to see other "should be fixed before 3.1" problems in the
jobctl code.

Oleg.

--- x/kernel/ptrace.c
+++ x/kernel/ptrace.c
@@ -744,20 +744,17 @@ int ptrace_request(struct task_struct *c
 			break;
 
 		si = child->last_siginfo;
-		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP))
-			break;
-
-		child->jobctl |= JOBCTL_LISTENING;
-
-		/*
-		 * If NOTIFY is set, it means event happened between start
-		 * of this trap and now.  Trigger re-trap immediately.
-		 */
-		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
-			signal_wake_up(child, true);
-
+		if (likely(si && (si->si_code >> 8) == PTRACE_EVENT_STOP)) {
+			child->jobctl |= JOBCTL_LISTENING;
+			/*
+			 * If NOTIFY is set, it means event happened between start
+			 * of this trap and now.  Trigger re-trap immediately.
+			 */
+			if (child->jobctl & JOBCTL_TRAP_NOTIFY)
+				signal_wake_up(child, true);
+			ret = 0;
+		}
 		unlock_task_sighand(child, &flags);
-		ret = 0;
 		break;
 
 	case PTRACE_DETACH:	 /* detach a process that was attached. */

