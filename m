Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2HPKsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:48:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44845 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab2HPKr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:47:59 -0400
Date: Thu, 16 Aug 2012 11:47:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 23/31] arm64: Debugging support
Message-ID: <20120816104748.GI31784@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-24-git-send-email-catalin.marinas@arm.com>
 <201208151507.36174.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151507.36174.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:07:36PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +const struct user_regset_view *task_user_regset_view(struct task_struct *task)
> > +{
> > +#ifdef CONFIG_AARCH32_EMULATION
> > +	if (test_tsk_thread_flag(task, TIF_32BIT))
> > +		return &user_aarch32_view;
> > +#endif
> > +	return &user_aarch64_view;
> > +}
> 
> Ah, nice. So you support 64 bit debuggers debugging 32 bit processes, right?

That should work if the debugger can deal with it, yes.

> From what I can tell, there is no support for 32 bit processes debugging
> 64 bit ones. Is that something you plan to add in the future, or do you
> consider that out of scope? In either case, a comment would be helpful.

That can't really work because the debugger won't be able to manipulate
child pointers properly without us adding a new ptrace interface (and then,
I still wonder about how feasible it really is). I can add a comment.

> > +long arch_ptrace(struct task_struct *child, long request,
> > +		 unsigned long addr, unsigned long data)
> > +{
> > +	int ret;
> > +	unsigned long *datap = (unsigned long __user *)data;
> > +
> > +	switch (request) {
> > +		case PTRACE_GET_THREAD_AREA:
> > +			ret = put_user(child->thread.tp_value, datap);
> > +			break;
> > +
> > +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> > +		case PTRACE_GETHBPREGS:
> > +			ret = ptrace_gethbpregs(child, addr, datap);
> > +			break;
> > +
> > +		case PTRACE_SETHBPREGS:
> > +			ret = ptrace_sethbpregs(child, addr, datap);
> > +			break;
> > +#endif
> > +
> > +		default:
> > +			ret = ptrace_request(child, request, addr, data);
> > +			break;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> Is there a reaons why these are not regsets but have their own ptrace
> commands? I believe new architectures should generally not add ptrace
> commands any more.

I could probably add some regset wrappers about the hbp accessors (which we
have to keep for the compat ptrace interface). I'll have a think as it might
even make sense to have different regsets for breakpoints and watchpoints.

As for the the tls, is it worth having a regset with only one register?

Will
