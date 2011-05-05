Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1EEJ15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:27:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1EEJ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:27:56 -0400
Date: Thu, 5 May 2011 11:27:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [hid-picolcd] Avoid compile warning/error triggered by
 copy_from_user()
In-Reply-To: <20110504210842.50edc842@neptune.home>
Message-ID: <alpine.LNX.2.00.1105051126560.28291@pobox.suse.cz>
References: <20110504210842.50edc842@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Bruno Prémont wrote:

> With CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y compilation of PicoLCD
> driver fails on copy_from_user(), without it a warning is generated:
> 
>   CC [M]  drivers/hid/hid-picolcd.o
> In file included from /usr/src/linux-2.6/arch/x86/include/asm/uaccess.h:571,
>                  from /usr/src/linux-2.6/arch/x86/include/asm/sections.h:5,
>                  from /usr/src/linux-2.6/arch/x86/include/asm/hw_irq.h:26,
>                  from /usr/src/linux-2.6/include/linux/irq.h:359,
>                  from /usr/src/linux-2.6/arch/x86/include/asm/hardirq.h:5,
>                  from /usr/src/linux-2.6/include/linux/hardirq.h:7,
>                  from /usr/src/linux-2.6/include/linux/interrupt.h:12,
>                  from /usr/src/linux-2.6/include/linux/usb.h:15,
>                  from /usr/src/linux-2.6/drivers/hid/hid-picolcd.c:25:
> In function 'copy_from_user',
>     inlined from 'picolcd_debug_eeprom_write' at drivers/hid/hid-picolcd.c:1592:
> arch/x86/include/asm/uaccess_32.h:212: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
> 
> gcc-4.4.5 is not able to track size calculation when it is stored into
> a variable, thus tell copy_from_user() maximum size via
> min(*max-size*, *effective-size*) explicitly and inline how much to copy
> at most.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> --
> 
> diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> index b2f56a1..9d8710f 100644
> --- a/drivers/hid/hid-picolcd.c
> +++ b/drivers/hid/hid-picolcd.c
> @@ -1585,11 +1585,11 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
>  	memset(raw_data, 0, sizeof(raw_data));
>  	raw_data[0] = *off & 0xff;
>  	raw_data[1] = (*off >> 8) & 0xff;
> -	raw_data[2] = s < 20 ? s : 20;
> +	raw_data[2] = min((size_t)20, s);
>  	if (*off + raw_data[2] > 0xff)
>  		raw_data[2] = 0x100 - *off;
>  
> -	if (copy_from_user(raw_data+3, u, raw_data[2]))
> +	if (copy_from_user(raw_data+3, u, min((u8)20, raw_data[2])))

Hmm ... this is quite an obfuscation just for the sake of making gcc 
happy.

Do other versions of gcc get this right? (i.e. is this gcc bug?)

Don't we have similar problems all over the place in the kernel?

>  		return -EFAULT;
>  	resp = picolcd_send_and_wait(data->hdev, REPORT_EE_WRITE, raw_data,
>  			sizeof(raw_data));
> 

-- 
Jiri Kosina
SUSE Labs
