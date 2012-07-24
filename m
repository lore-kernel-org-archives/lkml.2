Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2GXOcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:32:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2GXOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:32:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cyril Chemparathy <cyril@ti.com>
Subject: Re: [RFC 17/23] ARM: add machine desc hook for early memory/paging initialization
Date: Tue, 24 Jul 2012 14:32:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nico@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-18-git-send-email-cyril@ti.com>
In-Reply-To: <1343092165-9470-18-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241432.27790.arnd@arndb.de>
X-Provags-ID: V02:K0:bwDiyTalmMvfsBFkEHQk9AnCgnbFuiOVO8qPMcd9gDV
 FHmDd2QyX4UI05TdwtL1nSUOJkGtpENhf5RPQIwVTIa7sOr/vk
 Z7VguENl2+d0EdoQ+GJ4tHAzBPftAfC9EFc+JxH87JrkjFjmci
 Co1jV+lzME2TG3/cmqOk5g0eP7u2dPkXIockwl2AQFFaY/43Nl
 htjgbG1FM3P4NrLinsz6VfQaUZqOS9HUAJsrybow5PCPcnK7oL
 U4KvoZfeOrt8WzPngN+3RSBpT7+zDKVm/HFD56AjtSmH+1Q3FX
 CkBE/y7sBX+Dfqy600qoYt7gIOqJze3FEDKzEabiVn++hmUISh
 T0DQVNIMrlaw9j1IkurA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012, Cyril Chemparathy wrote:
> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> index 0b1c94b..49e9c2a 100644
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -39,6 +39,7 @@ struct machine_desc {
>                                          struct meminfo *);
>         void                    (*reserve)(void);/* reserve mem blocks  */
>         void                    (*map_io)(void);/* IO mapping function  */
> +       void                    (*init_meminfo)(void);
>         void                    (*init_early)(void);
>         void                    (*init_irq)(void);
>         struct sys_timer        *timer;         /* system tick timer    */
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index e15d83b..7cbe292 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -964,6 +964,9 @@ void __init setup_arch(char **cmdline_p)
>  
>         parse_early_param();
>  
> +       if (mdesc->init_meminfo)
> +               mdesc->init_meminfo();
> +
>         sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
>         sanity_check_meminfo();
>         arm_memblock_init(&meminfo, mdesc);

The function pointers in that structure are ordered by execution time,
and you call init_meminfo just before ->reserve, so it should go there.

I wonder if it's better to just do the setup in the reserve callback,
which would be a slight abuse of that interface but also keep down
the number of early callbacks.

	Arnd
