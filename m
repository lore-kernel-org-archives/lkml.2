Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3ABNRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:17:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3ABNQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:16:59 -0500
Date: Wed, 2 Jan 2013 14:16:26 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] uprobes/x86: Change __skip_sstep() to actually skip
 the whole insn
Message-ID: <20130102131626.GA18641@bandura.brq.redhat.com>
References: <20121230154657.GA28488@redhat.com>
 <20121230154719.GA28510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121230154719.GA28510@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 04:47:19PM +0100, Oleg Nesterov wrote:
> __skip_sstep() doesn't update regs->ip. Currently this is correct
> but only "by accident" and it doesn't skip the whole insn. Change
> it to advance ->ip by the length of the detected 0x66*0x90 sequence.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

  This change/routine is not obvious without the patch description, I
would appreciate some comment in the code. :) I believe it could help
some random developer in future.
  / I leave it to your judgement though /

Anton.
