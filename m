Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1IVNTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:19:48 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:37360 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab1IVNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:19:45 -0400
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
From: "Jon Medhurst (Tixy)" <jon.medhurst@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20110922130031.GK12025@e102109-lin.cambridge.arm.com>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
	 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
	 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
	 <20110921113906.GB2872@arm.com>
	 <20110921115553.GF17169@n2100.arm.linux.org.uk>
	 <1316676488.2053.9.camel@linaro1>
	 <CAHkRjk7B4Bmt2g6ptHO3TudXgrkr5rv4b--Hbx-mw7=MO9Q+BQ@mail.gmail.com>
	 <1316689606.2053.29.camel@linaro1>
	 <20110922115713.GJ12025@e102109-lin.cambridge.arm.com>
	 <1316693581.2053.38.camel@linaro1>
	 <20110922130031.GK12025@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 14:19:37 +0100
Message-ID: <1316697577.2053.48.camel@linaro1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 14:00 +0100, Catalin Marinas wrote:
> The unwinding fix should be simple (I haven't tested it yet):
> 
> 8<-----------------------------
> ARM: Ignore the unwinding information for the first instruction in a function
> 
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> When backtracing from the first instruction of a function, the prologue
> has not been executed and the unwinding information is not valid. This
> patch checks for this case and just assumes that the return address is
> in LR.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/kernel/unwind.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index d2cb0b3..946face 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -293,6 +293,16 @@ int unwind_frame(struct stackframe *frame)
>  		return -URC_FAILURE;
>  	}
>  
> +	/*
> +	 * Check for backtrace on the first instruction of a function. The
> +	 * prologue has not been executed yet and the unwinding information is
> +	 * not valid. Assume that the return address is in LR.
> +	 */
> +	if (idx.addr == frame->pc) {
> +		frame->pc = frame->lr;
> +		return URC_OK;
> +	}
> +
>  	ctrl.vrs[FP] = frame->fp;
>  	ctrl.vrs[SP] = frame->sp;
>  	ctrl.vrs[LR] = frame->lr;
> 

I've never looked at the unwinding code before but the one comment I
would make is: does the patch work with Thumb code? I.e. does bit zero
of idx.addr, frame->pc or frame->lr ever get set to indicate Thumb
state? And if so, they had better all get set otherwise it won't
work :-)

-- 
Tixy

