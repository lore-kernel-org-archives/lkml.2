Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1GHSph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1GHSpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:45:36 -0400
Date: Fri, 8 Jul 2011 20:42:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, chris@zankel.net,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH] xtensa: prevent arbitrary read in ptrace
Message-ID: <20110708184250.GA31307@redhat.com>
References: <1310083434.2139.4.camel@anubis> <20110708112706.9014d306.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708112706.9014d306.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08, Andrew Morton wrote:
>
> On Thu, 07 Jul 2011 20:03:54 -0400
> Dan Rosenberg <drosenberg@vsecurity.com> wrote:
>
> > Prevent an arbitrary kernel read. Check the user pointer with
> > access_ok() before copying data in.
> >
> > Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> > Cc: stable@kernel.org
> > ---
> >  arch/xtensa/kernel/ptrace.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
> > index c72c947..ddce75e 100644
> > --- a/arch/xtensa/kernel/ptrace.c
> > +++ b/arch/xtensa/kernel/ptrace.c
> > @@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
> >  	elf_xtregs_t *xtregs = uregs;
> >  	int ret = 0;
> >
> > +	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
> > +		return -EIO;
>
> This should be -EFAULT, methinks?

Also, it seems that ptrace_setxregs/ptrace_getxregs could be static?

The patch looks "obviously correct" but I don't understand this code.

Hmm. We don't read/write the XTENSA_HAVE_COPROCESSORS data, but use
sizeof(elf_xtregs_t) anyway. This looks a bit strange but I guess
this doesn't matter.

Oleg.

