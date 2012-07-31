Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2GaMvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab2GaMvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:51:20 -0400
Date: Tue, 31 Jul 2012 14:48:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: mmap_region() corrupts mm->mm_rb if
	uprobe_mmap() fails
Message-ID: <20120731124805.GA485@redhat.com>
References: <20120728163157.GA22719@redhat.com> <20120731064730.GB5087@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731064730.GB5087@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Srikar Dronamraju wrote:
>
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -454,8 +454,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
> >  		if (retval)
> >  			goto out;
> >
> > -		if (file && uprobe_mmap(tmp))
> > -			goto out;
> > +		if (file)
> > +			uprobe_mmap(tmp);
>
> I am not comfortable with this fix.

OK, so what you suggest for now?

Please note that it is very trivial to crash the kernel. Just
do something like

	echo "p /bin/true:OFFSET_OF_SYSCALL_INSN" > /sys/kernel/debug/tracing/uprobe_events
	/bin/true

(or any other unsupported insn)

Yes sure, I agree that in the long term this change should be
reconsidered.

> I think the long term solution is as you mentioned, move the
> instruction analysis to register.

Exactly. And we already discusssed this, we have a lot of other
reasons to do this.

> Lets say there were 10 probes that were to be installed in that vma.
> we were able to install five probes and the 6th one happened to fail
> because of invalid instruction; we dont continue with the registering
> probes for the remaining 4 probes.

Yes. And I already have the patch. I didn't send it because, unlike
this fix, it depends on other changes (already in -tip).

Until we move analysis to register, until we teach the callers of
uprobe_mmap() to bailout (and please note that vma_adjust() ignores
the result too), uprobe_mmap() should not give up if install fails,
it should continue.

> The intention behind failing mmap()/fork() if uprobe_mmap failed,
> was to make sure that we always report the correct number of events.

Sure, I understand and agree.

But what we can do right now?

Oleg.

