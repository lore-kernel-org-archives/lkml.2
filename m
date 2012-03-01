Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab2CAUzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:55:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40245 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab2CAUyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:54:39 -0500
Message-ID: <4F4FE1FA.1040008@zytor.com>
Date: Thu, 01 Mar 2012 12:54:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz> <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com> <4F4E6B98.2090306@zytor.com> <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com> <4F4EB0B9.2080906@zytor.com> <CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com> <4F4EBF44.60208@zytor.com> <CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com> <4F4EC19F.4050002@zytor.com> <CAKL7Q7rZyUNNP+jy5ajL2KSbC8S4LEQZWG3vuPVSvSOCd_ZGQg@mail.gmail.com> <CAKL7Q7q9r0mCoGWOFamHUG6ujfs=voyAZBZHChXVO34cjCbZbw@mail.gmail.com>
In-Reply-To: <CAKL7Q7q9r0mCoGWOFamHUG6ujfs=voyAZBZHChXVO34cjCbZbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 11:42 AM, Joshua C. wrote:
> diff --git a/arch/x86/include/asm/kbdleds.h b/arch/x86/include/asm/kbdleds.h
> new file mode 100644
> index 0000000..1446a65
> --- /dev/null
> +++ b/arch/x86/include/asm/kbdleds.h
> @@ -0,0 +1,41 @@
> +#ifndef _ASM_X86_KBDLEDS_H
> +#define _ASM_X86_KBDLEDS_H
> +
> +/*
> + * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
> + * This seems a good reason to start with NumLock off. On HIL keyboards
> + * of PARISC machines however there is no NumLock key and everyone expects
> + * the keypad to be used for numbers. That's why on X86 we ask the bios for
> + * the correct state.
> + */
> +
> +#ifdef CONFIG_X86
> +
> +#include<asm/setup.h>
> +
> +static inline int kbd_defleds(void)
> +{
> +	return boot_params.kbd_status&  0x20 ? (1<<  VC_NUMLOCK) : 0;
> +}
> +
> +#elif defined(CONFIG_PARISC)
                  ^^^^^^^^^^^^^

Sorry, you can't put non-x86 code in arch/x86.  There are two way to 
distribute this kind of stuff into arch directories:

1. You can define an ARCH_ symbol which indicates that <asm/kbdleds.h> 
is available; otherwise use the fallback routine;

2. You can define it in a .c file as an actual function in the affected 
architectures (x86 and parisc here) and then define it as a weak symbol 
(grep for __weak) in the common code.

If you don't want to bite off this distribution I can understand it 
(although it's not up to me, technically, since I'm not the maintainer 
of the vt subsystem) but if so leave this as an inline in a common place.

	-hpa
