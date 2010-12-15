Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0LOMfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:35:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0LOMfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VvsP8oI6A4wu22jUj4DY05Xco5Qfi5aAJvHM63dKy9oKOpWofDpBJTGs5jUBXBGWcz
         wzcOsvCAbvBhWV3GIdgzz6Q/Jp3n1qwJ7RB7TCjXP8901dsJZz+YMILF7Xg5ImJzhG3v
         wtctKOqOgTH7kkKhxx2XrZhxX/Es3BfjHfQO8=
MIME-Version: 1.0
In-Reply-To: <1292302233-16194-6-git-send-email-johlstei@codeaurora.org>
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org>
	<1292302233-16194-6-git-send-email-johlstei@codeaurora.org>
Date: Wed, 15 Dec 2010 12:35:18 +0000
X-Google-Sender-Auth: AOseNiUhRN-Ug69oYdahQetCIKw
Message-ID: <AANLkTimnuTcv+5cWNzvV-Z=1LHsAmTojDSBJMjjOs7K+@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] msm: add SMP support for msm
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Steve Muckle <smuckle@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 December 2010 04:50, Jeff Ohlstein <johlstei@codeaurora.org> wrote:
> --- /dev/null
> +++ b/arch/arm/mach-msm/headsmp.S
[...]
> +ENTRY(msm_secondary_startup)
> +       mrc     p15, 0, r0, c0, c0, 5   @ MPIDR
> +       and     r0, r0, #15             @ What CPU am I
> +       adr     r4, 1f                  @ address of
> +       ldmia   r4, {r5, r6}            @ load curr addr and pen_rel addr
> +       sub     r4, r4, r5              @ determine virtual/phys offsets
> +       add     r6, r6, r4              @ apply
> +pen:
> +       wfe
> +       dsb                             @ ensure subsequent access is
> +                                       @ after event

As I wrote in a different e-mail, this DSB isn't actually needed as
the processor shouldn't speculate beyond the WFE. But it's harmless
anyway.

> --- /dev/null
> +++ b/arch/arm/mach-msm/platsmp.c
[...]
> +int boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +       static int cold_boot_done;
> +       unsigned long timeout;
> +       printk(KERN_DEBUG "Starting secondary CPU %d\n", cpu);
> +
> +       if (cold_boot_done == false) {
> +               prepare_cold_cpu(cpu);
> +               cold_boot_done = true;
> +       }
> +
> +       pen_release = cpu;
> +       __cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
> +       outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
> +       __asm__("sev");
> +       dsb();

What's the need for the dsb() here (one before SEV maybe)?

Also, do we need to add a "memory" clobber to the SEV asm, not sure
whether the compiler would try to reorder the code.

-- 
Catalin
