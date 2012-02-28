Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2B1ItJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:49:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab2B1ItH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:49:07 -0500
Date: Tue, 28 Feb 2012 09:48:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        systemtap@sourceware.org, anderson@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: Re: [PATCH v3 -tip] [BUGFIX] x86/kprobes: Fix to recover
 instructions on optimized path
Message-ID: <20120228084828.GK21106@elte.hu>
References: <20120223083703.GA26781@elte.hu>
 <20120224095412.8462.55698.stgit@localhost.localdomain>
 <20120227093421.GA10078@elte.hu>
 <4F4C4182.1040706@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4C4182.1040706@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2012/02/27 18:34), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >> +
> >> +#ifdef CONFIG_OPTPROBES
> >> +static unsigned long __recover_optprobed_insn(struct kprobe *kp,
> >> +					      kprobe_opcode_t *buf,
> >> +					      unsigned long addr)
> >> +{
> >> +	long offs = addr - (unsigned long)kp->addr - 1;
> >> +	struct optimized_kprobe *op = container_of(kp, struct optimized_kprobe, kp);
> >> +
> >> +	/*
> >> +	 * If the kprobe can be optimized, original bytes which can be
> >> +	 * overwritten by jump destination address. In this case, original
> >> +	 * bytes must be recovered from op->optinsn.copied_insn buffer.
> >> +	 */
> >> +	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> >> +	if (addr == (unsigned long)kp->addr) {
> >> +		buf[0] = kp->opcode;
> >> +		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
> >> +	} else
> >> +		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
> >> +
> >> +	return (unsigned long)buf;
> >> +}
> >> +#endif
> > 
> > Why not stick this into a new kprobes-opt.c file?
> 
> Would you mean that I should split all optprobe stuffs into 
> new file?

Yeah, that would be sensible I think - and it might help avoid 
similar complications in the future.

Could (and probably should) be done in a separate patch - to 
keep the bits that you already fixed and tested intact.

> > This should be a separate, kprobes_recover_opt() method and 
> > be inside kprobes-opt.c as well.
> 
> OK, I'll do that. But I think it should be separated work. 
> Just for the bugfix, I think this should go into this style, 
> because this should be pushed into stable tree too.

I don't think we can push such a large and complex looking patch 
into v3.3 (let alone into -stable) - it's v3.4 material, and 
that's why I asked for the cleaner split-out as well. This 
optprobes code is really non-obvious at the moment and a 
split-out might improve that and might make future fixes easier 
to merge.

Thanks,

	Ingo
