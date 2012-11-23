Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab2KWDva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:51:30 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:34813 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab2KWDv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:51:29 -0500
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 22:51:28 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QW50b24gVm9yb250c292?= <anton.vorontsov@linaro.org>
Cc: =?UTF-8?B?QW5kcmV3IE1vcnRvbg==?= <akpm@linux-foundation.org>,
        linaro-kernel@lists.linaro.org,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Sm9obiBTdHVsdHo=?= <john.stultz@linaro.org>,
        =?UTF-8?B?SmFzb24gV2Vzc2Vs?= <jason.wessel@windriver.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxMC8xMF0gQVJNOiBGSVE6IEdldCByaWQgb2YgaW5pdF9G?=
 =?UTF-8?B?SVEoKQ==?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [188.134.40.128]
Date: Fri, 23 Nov 2012 07:40:30 +0400
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net> <1353631803-4853-10-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1353631803-4853-10-git-send-email-anton.vorontsov@linaro.org>
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1353642030.851395840@f20.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAN3pXqQ010924

> The function only saves initial arch-specific "no FIQ" instruction, by
> placing the code into set_fiq_handler() we can:
> 
> - Have less code and logic in the platform-specific files;
> - Have the code that manages FIQ vector overwriting in one place, i.e.
>   don't spread the logic around.
> 
> p.s. Also, I noticed that we saved no_fiq_insn w/o bothering about
> !CONFIG_CPU_USE_DOMAINS case, but set_fiq_handler() handles this case
> specifically. I wonder, was that on purpose, e.g. it does not matter for
> init_FIQ(), or it was just overlooked? In the latter case, the patch fixes
> the issue.
...
> diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
> index 9bf3a60..3602df6 100644
> --- a/arch/arm/kernel/fiq.c
> +++ b/arch/arm/kernel/fiq.c
> @@ -49,6 +49,7 @@
>  #include <asm/mach/irq.h>
>  
>  static unsigned long no_fiq_insn;
> +static int got_no_fiq_insn;
>  
>  /* Default reacquire function
>   * - we always relinquish FIQ control
> @@ -78,11 +79,14 @@ void show_fiq_list(struct seq_file *p, int prec)
>  
>  void set_fiq_handler(void *start, unsigned int length)
>  {
> -#if defined(CONFIG_CPU_USE_DOMAINS)
> -	memcpy((void *)0xffff001c, start, length);
> -#else
> -	memcpy(vectors_page + 0x1c, start, length);
> +	unsigned long *addr = (void *)0xffff001c;
> +
> +#ifndef CONFIG_CPU_USE_DOMAINS
> +	addr = vectors_page + 0x1c;
>  #endif
> +	if (!cmpxchg(&got_no_fiq_insn, 0, 1))
> +		no_fiq_insn = *addr;
> +	memcpy(addr, start, length);
>  	flush_icache_range(0xffff001c, 0xffff001c + length);
>  	if (!vectors_high())
>  		flush_icache_range(0x1c, 0x1c + length);
> @@ -126,8 +130,3 @@ EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
>  EXPORT_SYMBOL(__get_fiq_regs);	/* defined in fiqasm.S */
>  EXPORT_SYMBOL(claim_fiq);
>  EXPORT_SYMBOL(release_fiq);
> -
> -void __init init_FIQ(void)
> -{
> -	no_fiq_insn = *(unsigned long *)0xffff001c;

it seems that this is wrong. In this case we have an uninitialized variable and
sequential call claim_fiq and release_fiq could be fatal. FIXME please.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
