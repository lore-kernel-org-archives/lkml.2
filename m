Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1AEAOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:14:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44995 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1AEAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H2BwclziKuGojm9cz2WRdq1I21sqzX+otwSEW6XGdOLRUg5yctzRezFZmnRPgjjmtu
         pRWabv9F6LH6ItsvJf4m/o6cjuic3g8D/L2JHIiXKE+D6+7TMx6xBtz/54pvT9cQ5WNE
         7TDHAIRcieCKVcGBgc4JkESIN6BApnp7mzzN4=
Message-ID: <4D23B7D8.7090701@lwfinger.net>
Date: Tue, 04 Jan 2011 18:14:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
References: <4D1D0C61.9050800@lwfinger.net> <20101231003735.GA24101@gondor.apana.org.au> <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan> <20101231024653.GA24879@gondor.apana.org.au> <20101231085103.GA31935@darkside.kls.lan> <20110104043338.GA27604@gondor.apana.org.au> <20110104121957.GA27114@darkside.kls.lan> <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au>
In-Reply-To: <20110104224238.GA4978@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 04:42 PM, Herbert Xu wrote:
> On Tue, Jan 04, 2011 at 01:57:22PM +0100, Mario 'BitKoenig' Holbe wrote:
>>
>> # hexdump -n 512 -C /dev/hwrng
>> 00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
>> 00000010  ff ff ff ff ff ff ff 00  00 00 00 00 00 00 00 00  |................|
>> 00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
> 
> Weird.
> 
> Can you please try this patch against vanilla to print out the
> raw output of xstore?
> 
> diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
> index 794aacb..4408d4e 100644
> --- a/drivers/char/hw_random/via-rng.c
> +++ b/drivers/char/hw_random/via-rng.c
> @@ -24,6 +24,7 @@
>   * warranty of any kind, whether express or implied.
>   */
>  
> +#include <crypto/padlock.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/hw_random.h>
> @@ -34,7 +35,6 @@
>  #include <asm/i387.h>
>  
>  
> -#define PFX	KBUILD_MODNAME ": "
>  
>  
>  enum {
> @@ -85,13 +85,16 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
>  		:"D"(addr), "d"(edx_in));
>  
>  	irq_ts_restore(ts_state);
> +	printk(KERN_DEBUG "0x%x\n", *addr);
>  	return eax_out;
>  }
>  
>  static int via_rng_data_present(struct hwrng *rng, int wait)
>  {
> +	char buf[16 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
> +		((aligned(STACK_ALIGN)));
> +	u32 *via_rng_datum = (u32 *)PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);

If I didn't get lost in expanding all those macros, I think the above can end up
with what is essentially a negative value for the index of buf. Shouldn't the
right-hand side of the statement be

(u32 *)PTR_ALIGN(&buf[PADLOCK_ALIGNMENT], PADLOCK_ALIGNMENT);

That resolves to an index for buf from 0 to (PADLOCK_ALIGNMENT - 1).

Larry
