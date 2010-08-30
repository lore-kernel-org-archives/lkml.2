Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0H3JWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:22:40 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:14549 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab0H3JWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:22:35 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h5bem5bfn61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7YK3T-01-6JB-02
X-M-MSG: 
Date: Mon, 30 Aug 2010 11:09:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: oprofile: fix oprofile_arch_init behaviour on
 failure
Message-ID: <20100830090929.GU22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283107921-21464-4-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.10 14:52:01, Will Deacon wrote:
> The OProfile driver no longer calls oprofile_arch_exit when
> oprofile_arch_init return failure.
> 
> This patch fixes the x86 implementation of oprofile_arch_init
> to ensure that op_nmi_exit is called if necessary.
> 
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/x86/oprofile/init.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)
> 

>  int __init oprofile_arch_init(struct oprofile_operations *ops)
>  {
>  	int ret;
>  
> -	ret = -ENODEV;
> -
> -#ifdef CONFIG_X86_LOCAL_APIC
>  	ret = op_nmi_init(ops);
> -#endif
> -#ifdef CONFIG_X86_IO_APIC
>  	if (ret < 0)
> +#ifdef CONFIG_X86_IO_APIC
>  		ret = op_nmi_timer_init(ops);
> +#else
> +		return ret;
>  #endif
> +
>  	ops->backtrace = x86_backtrace;
>  
> +	if (ret < 0)
> +		op_nmi_exit();
> +

I don't see why we have to do this. All init functions above clean up
properly on failure. If op_nmi_init() succeeds we don't call
op_nmi_timer_init(), so we don't need to free it it either.

-Robert

>  	return ret;
>  }

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

