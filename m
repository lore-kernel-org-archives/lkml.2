Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2HQHGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:06:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2HQHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:06:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 23/31] arm64: Debugging support
Date: Fri, 17 Aug 2012 07:06:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulrich.weigand@linaro.org
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <20120816104748.GI31784@mudshark.cambridge.arm.com> <201208161249.35008.arnd@arndb.de>
In-Reply-To: <201208161249.35008.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208170706.07821.arnd@arndb.de>
X-Provags-ID: V02:K0:x/xYMEAbgldRiVzz2rPDdkWkABTMXy4liIO5QNoCdgZ
 W/bQwOm6Ro3+W/0vVsNoqguUaGPhGNwQWGM3KujXXn0Q0+a6ve
 L/OYdbntq7vJbIGAstZ/oyfC/5XwlNltB/xehVb1nSNAlfmmC4
 s+zvzSauY/0kA0Rzh7l459wO0RV5kDbCiOvNrPiDKuoPLB+tWM
 mYq3jpkhnjDjRaAYREk8gnvwc5/ra5+2GAG+U1LRxG4AiO+8la
 viYsEA9WBmWwZzvcN7Ft6qC3AHsz7NGjGqF0T3zyfdL2naseaw
 1it8R1LbhvecUU9xdykFnjxsu/ZP1cUccU3tDbDSZJnAyPJ7Vr
 4qvNZbNG8XMtg3rkuD5k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Arnd Bergmann wrote:
> On Thursday 16 August 2012, Will Deacon wrote:
> > On Wed, Aug 15, 2012 at 04:07:36PM +0100, Arnd Bergmann wrote:
> > > On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > > From what I can tell, there is no support for 32 bit processes debugging
> > > 64 bit ones. Is that something you plan to add in the future, or do you
> > > consider that out of scope? In either case, a comment would be helpful.
> > 
> > That can't really work because the debugger won't be able to manipulate
> > child pointers properly without us adding a new ptrace interface (and then,
> > I still wonder about how feasible it really is). I can add a comment.
> 
> You can already have a 32 bit gdb that is able to do remote debugging of
> 64 bit processes using a gdb server process. I guess it wouldn't be
> too strange to have a ptrace extension to allow the native case as well.
> I agree it's not a high priority.
> 
> > > > +long arch_ptrace(struct task_struct *child, long request,
> > > > +		 unsigned long addr, unsigned long data)
> > > > +{
> > > > +	int ret;
> > > > +	unsigned long *datap = (unsigned long __user *)data;
> > > > +
> > > > +	switch (request) {
> > > > +		case PTRACE_GET_THREAD_AREA:
> > > > +			ret = put_user(child->thread.tp_value, datap);
> > > > +			break;
> > > > +
> > > > +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> > > > +		case PTRACE_GETHBPREGS:
> > > > +			ret = ptrace_gethbpregs(child, addr, datap);
> > > > +			break;
> > > > +
> > > > +		case PTRACE_SETHBPREGS:
> > > > +			ret = ptrace_sethbpregs(child, addr, datap);
> > > > +			break;
> > > > +#endif
> > > > +
> > > > +		default:
> > > > +			ret = ptrace_request(child, request, addr, data);
> > > > +			break;
> > > > +	}
> > > > +
> > > > +	return ret;
> > > > +}
> > > 
> > > Is there a reaons why these are not regsets but have their own ptrace
> > > commands? I believe new architectures should generally not add ptrace
> > > commands any more.
> > 
> > I could probably add some regset wrappers about the hbp accessors (which we
> > have to keep for the compat ptrace interface). I'll have a think as it might
> > even make sense to have different regsets for breakpoints and watchpoints.
> > 
> > As for the the tls, is it worth having a regset with only one register?
> 
> Better ask the gdb folks. I'm adding Uli to Cc, maybe he has some insight.

Sorry for the dumb question, but why do you even need PTRACE_GET_THREAD_AREA
for 64 bit tasks? I thought the thread pointer is a GPR, or is this just
for compat tasks?

	Arnd
