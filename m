Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839Ab2KBNxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:53:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18163 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2KBNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:53:50 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EaluEUCYuSkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=U_9UZLlTPtUA:10 a=e_WWyB8VTG0ISMvLWkIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351864429.4004.131.camel@gandalf.local.home>
Subject: Re: [PATCH] [PATCH] x86: Don't clobber top of pt_regs in nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: sqazi@google.com, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Nov 2012 09:53:49 -0400
In-Reply-To: <1351864310.4004.130.camel@gandalf.local.home>
References: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
	 <1351731872.4004.112.camel@gandalf.local.home>
	 <5092D31C020000780008EB6B@nat28.tlf.novell.com>
	 <1351864310.4004.130.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 09:51 -0400, Steven Rostedt wrote:
> On Thu, 2012-11-01 at 19:53 +0000, Jan Beulich wrote:
> 
> > There doesn't appear to be anything special about these adjustments, so I
> > don't see what help would be required here - it ought to be the normal use
> > of CFI_ADJUST_CFA_OFFSET that needs adding.
> 
> This change look fine to you?
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 52edf92..7ba5342 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1796,10 +1796,12 @@ repeat_nmi:
>  
>  	/* Make another copy, this one may be modified by nested NMIs */
>  	addq $(10*8), %rsp
> +	CFI_ADJUST_CFA_OFFSET -10*8
>  	.rept 5
>  	pushq_cfi -6*8(%rsp)
>  	.endr
>  	subq $(5*8), %rsp
> +	CFI_ADJUST_CFA_OFFSET 5*8
>  
>  	CFI_DEF_CFA_OFFSET SS+8-RIP
>  end_repeat_nmi:
> 

Is that second one even needed? Or will the CFI_DEF_CFA_OFFSET SS+8-RIP
fix it?

-- Steve


