Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab1BYNXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:23:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45286 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182Ab1BYNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:23:46 -0500
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	 <1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 13:23:39 +0000
Message-ID: <1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
> Assign the registers used in the inline assembly immediately
> before the inline assembly block. This ensures the compiler
> doesn't optimize away dead register assignments when it
> shouldn't.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/scm.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
> index ba57b5a..5eddf54 100644
> --- a/arch/arm/mach-msm/scm.c
> +++ b/arch/arm/mach-msm/scm.c
> @@ -264,13 +264,16 @@ u32 scm_get_version(void)
>  {
>         int context_id;
>         static u32 version = -1;
> -       register u32 r0 asm("r0") = 0x1 << 8;
> -       register u32 r1 asm("r1") = (u32)&context_id;
> +       register u32 r0 asm("r0");
> +       register u32 r1 asm("r1");
> 
>         if (version != -1)
>                 return version;
> 
>         mutex_lock(&scm_lock);
> +
> +       r0 = 0x1 << 8;
> +       r1 = (u32)&context_id;
>         asm volatile(
>                 __asmeq("%0", "r1")
>                 __asmeq("%1", "r0")


Whoa, have you seen the compiler `optimise' the original assignments
away? Since there is a use in the asm block, the definition shouldn't
be omitted. What toolchain are you using?

Will

