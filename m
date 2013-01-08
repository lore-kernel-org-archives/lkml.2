Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3AHMOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:14:03 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42581 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3AHMOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:14:01 -0500
Date: Tue, 8 Jan 2013 17:43:28 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Fix utask->xol_vaddr leak in pre_ssout()
Message-ID: <20130108121328.GH1325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175226.GA32108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121231175226.GA32108@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010812-5406-0000-0000-000003FE3648
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-31 18:52:26]:

> pre_ssout() should do xol_free_insn_slot() if arch_uprobe_pre_xol()
> fails, otherwise nobody will free the allocated slot.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

(one nit below)
> ---
>  kernel/events/uprobes.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 2ed6239..bd94d2c 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1306,6 +1306,7 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
>  {
>  	struct uprobe_task *utask;
>  	unsigned long xol_vaddr;
> +	int err;
> 
>  	utask = current->utask;
> 
> @@ -1316,7 +1317,13 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
>  	utask->xol_vaddr = xol_vaddr;
>  	utask->vaddr = bp_vaddr;
> 
> -	return arch_uprobe_pre_xol(&uprobe->arch, regs);
> +	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
> +	if (unlikely(err)) {
> +		xol_free_insn_slot(current);
> +		return err;
> +	}
> +
> +	return 0;
>  }

Nit: we could reduce a line or two with

	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
	if (unlikely(err))
		xol_free_insn_slot(current);

	return err;
> 
>  /*
> -- 
> 1.5.5.1
> 

