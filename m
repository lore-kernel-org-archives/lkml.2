Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1C2WYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:24:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32828 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab1C2WY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:24:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6300"; a="82806074"
Message-ID: <4D925C18.7040202@codeaurora.org>
Date: Tue, 29 Mar 2011 15:24:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Simon Glass <sjg@google.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ARM: Use generic BUG() handler
References: <1300307259-834-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1300307259-834-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2011 1:27 PM, Simon Glass wrote:
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index 6146279..4f22346 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -80,6 +80,18 @@ SECTIONS
>  
>  	PERCPU(PAGE_SIZE)
>  
> +	/*
> +	* .exit.text is discarded at runtime, not link time, to deal with
> +	*  references from bug_table
> +	*/
> +	.exit.text : AT(ADDR(.exit.text)) {
> +		EXIT_TEXT
> +	}
> +
> +	.exit.data : AT(ADDR(.exit.data)) {
> +		EXIT_DATA
> +	}
> +
>  #ifndef CONFIG_XIP_KERNEL
>  	. = ALIGN(PAGE_SIZE);
>  	__init_end = .;

Should this be using the ARM_EXIT_KEEP macro instead? It seems like you
could add another condition to that macro like:

#if (defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)) || defined(CONFIG_GENERIC_BUG)
#define ARM_EXIT_KEEP(x)        x
#else
#define ARM_EXIT_KEEP(x)
#endif


and then drop this hunk here. Plus, this might be better because if you
have BUG=n and SMP_ON_UP=n you can drop the exit sections at link time
still, but with your patch they get dropped at runtime, right?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

