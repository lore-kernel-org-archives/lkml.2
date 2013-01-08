Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3AHLZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:25:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45621 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3AHLZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:25:08 -0500
Date: Tue, 8 Jan 2013 16:54:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] uprobes/x86: Change __skip_sstep() to actually
 skip	the whole insn
Message-ID: <20130108112422.GB1325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121230154657.GA28488@redhat.com>
 <20121230154719.GA28510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121230154719.GA28510@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010811-9360-0000-0000-00000EE54EFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-30 16:47:19]:

> __skip_sstep() doesn't update regs->ip. Currently this is correct
> but only "by accident" and it doesn't skip the whole insn. Change
> it to advance ->ip by the length of the detected 0x66*0x90 sequence.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/uprobes.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index c71025b..4e33a35 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -680,8 +680,11 @@ static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		if (auprobe->insn[i] == 0x66)
>  			continue;
> 
> -		if (auprobe->insn[i] == 0x90)
> +		if (auprobe->insn[i] == 0x90) {
> +			regs->ip = uprobe_get_swbp_addr(regs);
> +			regs->ip += i + 1;
>  			return true;
> +		}
> 
>  		break;
>  	}
> -- 
> 1.5.5.1
> 

