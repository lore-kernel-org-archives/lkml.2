Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1LSOTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:19:38 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:58687 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1LSOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:19:34 -0500
Date: Mon, 19 Dec 2011 15:19:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
Message-ID: <20111219151926.53bede67@de.ibm.com>
In-Reply-To: <4EEF3F7B.9080405@parallels.com>
References: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au>
	<20111219080813.GB30432@elte.hu>
	<20111219101134.3c2c0db5@de.ibm.com>
	<20111219103513.GA17928@elte.hu>
	<20111219133151.4d14af80@de.ibm.com>
	<4EEF3F7B.9080405@parallels.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11121914-0342-0000-0000-00000063D08C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 17:43:23 +0400
Glauber Costa <glommer@parallels.com> wrote:

> On 12/19/2011 04:31 PM, Martin Schwidefsky wrote:
> > On Mon, 19 Dec 2011 11:35:13 +0100
> > Ingo Molnar<mingo@elte.hu>  wrote:
> >
> >>
> >> * Martin Schwidefsky<schwidefsky@de.ibm.com>  wrote:
> >>
> >>> On Mon, 19 Dec 2011 09:08:13 +0100
> >>> Ingo Molnar<mingo@elte.hu>  wrote:
> >>>
> >>>>
> >>>> * Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
> >>>>
> >>>>> Hi all,
> >>>>>
> >>>>> Today's linux-next merge of the tip tree got a conflict in
> >>>>> fs/proc/uptime.c between commit c3e0ef9a298e ("[S390] fix cputime
> >>>>> overflow in uptime_proc_show") from the cputime tree and commit
> >>>>> 3292beb340c7 ("sched/accounting: Change cpustat fields to an array") from
> >>>>> the tip tree.
> >>>>>
> >>>>> I fixed it up (I think - see below) and can carry the fix as necessary.
> >>>>>
> >>>>> Generally, you guys seem to be working a little at cross purposes ...
> >>>>
> >>>> Agreed.
> >>>>
> >>>> Martin, could you please send Peter and me a pull request of the
> >>>> current cputime bits merged on top of tip:sched/core? Those bits
> >>>> should go upstream via the scheduler tree.
> >>>>
> >>>
> >>> All of it including "[S390] cputime: add sparse checking and
> >>> cleanup" or just the fix for uptime ?
> >>
> >> I suspect we can take it all if it's all scheduling/time
> >> related, and add new patches to sched/core to keep it all
> >> concentrated in a single tree?
> >
> > Ok, will do. Just one question: are you sure that you want the cpustat array
> > to be u64 instead of cputime64_t? The content of the cpustat array is defined
> > by the architecture semantics of cputime64_t, for CONFIG_VIRT_CPU_ACCOUNTING=y
> > this is not a jiffy counter. If the array is u64 we won't get the sparse
> > checking when reading from cpustat.
> >
> 
>  From where I stand, all I care about is for it to be an array. 
> Otherwise the cgroup code get quite messy. At the time, and discussing 
> this with peterz, it made sense to change it to u64.
> 
> If my mind doesn't fail me, the main reason being it cputime64 is u64 
> everywhere, and it was just preventing us from doing simple assignments,
> like cpustat[idx] += tmp.
> 
> But if for whatever reason you want to move it back to cputime64_t, and 
> the maintainers agree so,I am fine with that, as long as you don't 
> revert to the old scheme of having a struct filled with fields.

Yes, I would like to have it converted back to cputime64_t. In fact cputime64_t
is a u64 but with a little twist, it has __nocast attached to it. This came out
of the discussion with Peter, he suggested to use sparse to warn about
unannotated conversions between cputime and scalar types. I want to have an
automated way to find these because for architectures with VIRT_CPU_ACCOUNTING
the cputime values are not jiffies.

I have implemented the sparse __nocast approach in the large patch on the
cputime branch. Which now clashes with the conversion of cpustat to an array.
Oh well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

