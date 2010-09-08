Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab0IHRMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:12:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57141 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0IHRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:11:59 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Jan Blunck <jblunck@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>
Subject: Re: [RFC 3/4] Disable scheduler tick when we are running SCHED_FIFO tasks
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
	<1283948964-6418-4-git-send-email-jblunck@suse.de>
	<1283949943.23762.16.camel@laptop>
	<20100908142826.GI7436@bolzano.suse.de>
Date: Wed, 08 Sep 2010 19:11:53 +0200
In-Reply-To: <20100908142826.GI7436@bolzano.suse.de> (Jan Blunck's message of
	"Wed, 8 Sep 2010 16:28:26 +0200")
Message-ID: <87iq2gw46e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck <jblunck@novell.com> writes:

> On Wed, Sep 08, Peter Zijlstra wrote:
>
>> On Wed, 2010-09-08 at 14:29 +0200, Jan Blunck wrote:
>> > This patch is disabling the scheduler tick to go off when there is a task
>> > with SCHED_FIFO policy running. Since these tasks are not timesliced anyway
>> > we only care about timers, softirqs and such stuff just like when we disable
>> > the tick during idle periods.
>> > 
>> 
>> Also, doesn't this break any and all jiffies users?
>> 
>
> Sure. It was enough to make FTQ run.
>
>> And you need to restart the tick on call_rcu() and everything else that
>> requires the tick for processing.
>> 
>
> I realized that before as well but somehow forgot about it. Checking for a
> disabled timer tick on syscall entry would help. Like we do on irq entry as
> well.

That doesn't help the gettimeofday/clock_gettime vDSOs
which access jiffie like state in user space.

I guess you could force the vdso to call into the kernel
during such a region, but you cannot force it for an
process that is already context switched in this path
when the option is first enabled.

I guess it would work if you force all the vDSOs
to always do a system call at boot, but that's pretty
costly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
