Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0KHS3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab0KHS3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:29:10 -0500
Date: Mon, 8 Nov 2010 13:28:04 -0500
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v2] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101108182804.GR4823@redhat.com>
References: <1289234675-2400-1-git-send-email-dzickus@redhat.com>
 <20101108180518.GA5375@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108180518.GA5375@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 07:05:23PM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 08, 2010 at 11:44:35AM -0500, Don Zickus wrote:
> > I ran into a scenario where while one cpu was stuck and should have panic'd
> > because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
> > stack dumps on to the console.  Upon investigation, I noticed that when writing
> > to the console and also when dumping the stack, the watchdog is touched.
> > 
> > This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
> > just spins forever.
> > 
> > This change causes the semantics of touch_nmi_watchdog to be changed slightly.
> > Previously, I accidentally changed the semantics and we noticed there was a
> > codepath in which touch_nmi_watchdog could be touched from a preemtible area.
> > That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
> > it was the acpi code.
> > 
> > My attempt here re-introduces the change to have the touch_nmi_watchdog() code
> > only touch the local cpu instead of all of the cpus.  But instead of using
> > __get_cpu_var(), I use the __raw_get_cpu_var() version.
> > 
> > This avoids the preemption problem.  However my reasoning wasn't because I was
> > trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
> > then interrupts should be enabled to and the NMI watchdog will have no reason
> > to trigger.  So it won't matter if the wrong cpu is touched because the percpu
> > interrupt counters the NMI watchdog uses should still be incrementing.
> > 
> > V2:  remove touch_all_nmi_watchdog code
> 
> 
> Are you sure you did? :)

Hmm.. Odd.  I remember making and committing the changes.  But now I can't
find them.

Thanks for catching that! I'll send out a version 3.

Cheers,
Don
