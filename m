Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2EIV2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:28:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:53226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab2EIV2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98268634"
Subject: Re: [PATCH 1/3] coredump: flush the fpu exit state for proper
 multi-threaded core dump
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Date: Wed, 09 May 2012 14:32:03 -0700
In-Reply-To: <20120509210551.GB334@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
	 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120509210551.GB334@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336599123.4634.42.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 23:05 +0200, Oleg Nesterov wrote:
> On 05/08, Suresh Siddha wrote:
> >
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -656,6 +656,11 @@ static void exit_mm(struct task_struct * tsk)
> >  		struct core_thread self;
> >  		up_read(&mm->mmap_sem);
> >
> > +		/*
> > +		 * Flush the live extended register state to memory.
> > +		 */
> > +		prepare_to_copy(tsk);
> 
> This doesn't look very nice imho, but I guess you understand this...
> 
> Perhaps we need an arch-dependent helper which saves the FPU regs
> if needed.
> 
> I can be easily wrong, but I did the quick grep and I am not sure
> we can rely on prepare_to_copy(). For example, it is a nop in
> arch/sh/include/asm/processor_64.h. But at the same time it has
> save_fpu().
> 
> OTOH, I am not sure it is safe to use prepare_to_copy() in exit_mm(),
> at least in theory. God knows what it can do...

There is an explicit schedule() just few lines below. And the schedule()
also will do the same thing. The thing is we want the user-specific
extended registers to be flushed to memory (used also in the fork path)
before we notify the core dumping thread that we reached the serializing
point, for the dumping thread to continue the dump process.

And to make this coredump specific, I really need to move it there as I
need to reliably find out if the core dump is in progress for this
thread.

Linus/Peter/Ingo, any comments?

thanks,
suresh

