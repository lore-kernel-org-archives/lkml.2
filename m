Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2HMN2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab2HMN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:28:43 -0400
Date: Mon, 13 Aug 2012 15:24:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v2 2/5] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120813132443.GB5269@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-3-git-send-email-bigeasy@linutronix.de> <20120808125709.GA4504@redhat.com> <50226700.9000606@linutronix.de> <20120808145345.GA8171@redhat.com> <20120809044356.GA3163@in.ibm.com> <20120809170953.GA27835@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809170953.GA27835@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Sebastian Andrzej Siewior wrote:
>
> v1..v2: re-use auprobe->fixups for fixups

Yes, but

> @@ -46,6 +46,8 @@ struct arch_uprobe_task {
>  #ifdef CONFIG_X86_64
>  	unsigned long			saved_scratch_register;
>  #endif
> +#define UPROBE_CLEAR_TF			(1 << 0)
> +	unsigned int			restore_flags;
>  };

this patch still adds restore_flags into arch_uprobe_task.

>  static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
>  {
> -	bool fix_ip = true, fix_call = false;	/* defaults */
> +	bool fix_ip = true, fix_call = false, fix_tf = false;	/* defaults */
>  	int reg;
>  
>  	insn_get_opcode(insn);	/* should be a nop */
>  
>  	switch (OPCODE1(insn)) {
> +	case 0x9d:
> +		/* popf */
> +		fix_tf = true;
> +		break;
>  	case 0xc3:		/* ret/lret */
>  	case 0xcb:
>  	case 0xc2:
> @@ -277,6 +284,8 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
>  		auprobe->fixups |= UPROBE_FIX_IP;
>  	if (fix_call)
>  		auprobe->fixups |= UPROBE_FIX_CALL;
> +	if (fix_tf)
> +		auprobe->fixups |= UPROBE_TF_CHANGES;
>  }

I won't insist, but do we really need fix_tf? "case 0x9d" could simply
add UPROBE_TF_CHANGES.

Oleg.

