Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2CSWAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:00:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2CSWAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:00:52 -0400
Date: Mon, 19 Mar 2012 15:00:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-Id: <20120319150050.4ab474e1.akpm@linux-foundation.org>
In-Reply-To: <1331827471.18960.195.camel@twins>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
	<20120314161906.e53359d3.akpm@linux-foundation.org>
	<20120315080232.GA17163@tiehlicka.suse.cz>
	<20120315155413.GE3941@redhat.com>
	<1331827471.18960.195.camel@twins>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 17:04:31 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2012-03-15 at 11:54 -0400, Don Zickus wrote:
> > > > Why did watchdog() reset the scheduling policy seven instructions
> > > > before exiting?  Seems pointless.
> > > 
> > > It has been introduced by Thomas in cba9bd22. To be honest I don't
> > > understand why it makes a sense?
> > 
> > Yeah I noticed that too.  I didn't bother questioning it either when
> > it
> > went in.  I just assumed Thomas and Peter know scheduling a lot better
> > than I do. :-) 
> 
> I just dug through my IRC logs and the reason is that running the entire
> exit path as a highest priority RT task incurs a latency spike to other
> tasks running on the system (313us). Since there's absolutely no point
> in running the exit path as a RT task, tglx made it not do that.

IRC logs, huh?


--- a/kernel/watchdog.c~a
+++ a/kernel/watchdog.c
@@ -349,6 +349,10 @@ static int watchdog(void *unused)
 
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	/*
+	 * Drop the policy/priority elevation during thread exit to avoid a
+	 * scheduling latency spike.
+	 */
 	__set_current_state(TASK_RUNNING);
 	sched_setscheduler(current, SCHED_NORMAL, &param);
 	return 0;
_

