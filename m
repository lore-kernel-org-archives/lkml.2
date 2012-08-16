Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2HPMtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:49:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2HPMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:49:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 23/31] arm64: Debugging support
Date: Thu, 16 Aug 2012 12:49:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulrich.weigand@linaro.rg
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151507.36174.arnd@arndb.de> <20120816104748.GI31784@mudshark.cambridge.arm.com>
In-Reply-To: <20120816104748.GI31784@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161249.35008.arnd@arndb.de>
X-Provags-ID: V02:K0:kDvn9I2jRylowamjJz1P9uWhTjOaguP4D5TP34tMH7U
 LCp4dkeYlow5oYfrv4iBWfkIUwg0hiniToK9Og+YCRmUdwP0Ss
 +nLPmeQYp59Dgq4yeHTZzM9fIqFQBAm9h7EafmzwtVH7dKaSsO
 iP5PWG1eGqWJ5j7jheI7IhOjHxNqrOUgGJifa5bv/VbTbxoK6T
 QrW2qp346knwbGwDrIKqgptqs9GZSf3r9QAtyCS7yQHeudKsS3
 SG185waVeusn2CstPCkFGYdrr5H16vxLMiz/zf6+1nGLfKwW9b
 VtOd47KjXjU2b1Iw9tVxHV4HTbslV+Jg4+3CKvwTfJYS1okmJ3
 lt+yF2A2C2gvpH72j65o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Will Deacon wrote:
> On Wed, Aug 15, 2012 at 04:07:36PM +0100, Arnd Bergmann wrote:
> > On Tuesday 14 August 2012, Catalin Marinas wrote:

> > From what I can tell, there is no support for 32 bit processes debugging
> > 64 bit ones. Is that something you plan to add in the future, or do you
> > consider that out of scope? In either case, a comment would be helpful.
> 
> That can't really work because the debugger won't be able to manipulate
> child pointers properly without us adding a new ptrace interface (and then,
> I still wonder about how feasible it really is). I can add a comment.

You can already have a 32 bit gdb that is able to do remote debugging of
64 bit processes using a gdb server process. I guess it wouldn't be
too strange to have a ptrace extension to allow the native case as well.
I agree it's not a high priority.

> > > +long arch_ptrace(struct task_struct *child, long request,
> > > +		 unsigned long addr, unsigned long data)
> > > +{
> > > +	int ret;
> > > +	unsigned long *datap = (unsigned long __user *)data;
> > > +
> > > +	switch (request) {
> > > +		case PTRACE_GET_THREAD_AREA:
> > > +			ret = put_user(child->thread.tp_value, datap);
> > > +			break;
> > > +
> > > +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> > > +		case PTRACE_GETHBPREGS:
> > > +			ret = ptrace_gethbpregs(child, addr, datap);
> > > +			break;
> > > +
> > > +		case PTRACE_SETHBPREGS:
> > > +			ret = ptrace_sethbpregs(child, addr, datap);
> > > +			break;
> > > +#endif
> > > +
> > > +		default:
> > > +			ret = ptrace_request(child, request, addr, data);
> > > +			break;
> > > +	}
> > > +
> > > +	return ret;
> > > +}
> > 
> > Is there a reaons why these are not regsets but have their own ptrace
> > commands? I believe new architectures should generally not add ptrace
> > commands any more.
> 
> I could probably add some regset wrappers about the hbp accessors (which we
> have to keep for the compat ptrace interface). I'll have a think as it might
> even make sense to have different regsets for breakpoints and watchpoints.
> 
> As for the the tls, is it worth having a regset with only one register?

Better ask the gdb folks. I'm adding Uli to Cc, maybe he has some insight.

	Arnd
