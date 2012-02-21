Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2BUO0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:26:12 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:26685 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2BUO0K convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 21 Feb 2012 09:26:10 -0500
Message-Id: <4F43B78D020000780007435B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 21 Feb 2012 14:26:05 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mark Wielaard" <mjw@redhat.com>
Cc: "Frederic Weisbecker (commit_signer:4/25=16%)" <fweisbec@gmail.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Thomas Gleixner (maintainer:X86 ARCHITECTURE...)" 
	<tglx@linutronix.de>,
        "Andi Kleen (commit_signer:5/25=20%)" <ak@linux.intel.com>,
        "commit_signer:11/25=44%) Ingo Molnar (maintainer:X86 ARCHITECTURE..." 
	<mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        "commit_signer:4/25=16%) H. Peter Anvin (maintainer:X86 ARCHITECTURE..." 
	<hpa@zytor.com>
Subject: Re: [PATCH] x86-64: Fix CFI data for common_interrupt
References: <1329833177-13030-1-git-send-email-mjw@redhat.com>
In-Reply-To: <1329833177-13030-1-git-send-email-mjw@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.02.12 at 15:06, Mark Wielaard <mjw@redhat.com> wrote:
> Commit eab9e6 "x86-64: Fix CFI data for interrupt frames" introduced
> a DW_CFA_def_cfa_expression in the SAVE_ARGS_IRQ macro. To later define
> the CFA using a simple register+offset rule both register and offset
> need to be supplied. Just using CFI_DEF_CFA_REGISTER leaves the offset
> undefined. So use CFI_DEF_CFA with reg+off explicitly at the end of
> common_interrupt.

NAK, unless you can prove a path via which the offset will remain
unset until hitting a CFI_DEF_CFA_REGISTER. And if you indeed
found such a path, the entry point of the path is where the problem
ought to be fixed.

Are you perhaps thinking that .cfi_def_cfa_register invalidates
the offset in any way? That, to my knowledge, isn't the case, it
just replaces the CFA register with the one specified, leaving the
offset unchanged.

Jan

> Signed-off-by: Mark Wielaard <mjw@redhat.com>
> ---
>  arch/x86/kernel/entry_64.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 3fe8239..e00ef55 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -813,7 +813,7 @@ ret_from_intr:
>  
>  	/* Restore saved previous stack */
>  	popq %rsi
> -	CFI_DEF_CFA_REGISTER	rsi
> +	CFI_DEF_CFA rsi,0	/* needed after def_cfa_expression */
>  	leaq ARGOFFSET-RBP(%rsi), %rsp
>  	CFI_DEF_CFA_REGISTER	rsp
>  	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
> -- 
> 1.7.7.6



