Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0KYRVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:21:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46534 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0KYRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z9tbiOU2hdigrpt9fAMNgafYgA1TgpZR3XabSoWsyOOp1fPpxFLnr3W9UsA1dk8B4D
         ixktCKwP9okWWuOQQb9OIRD/10WpBbs1xM9vjADtQMkDUJPCpRTshvHpm/ryRj0bwZY6
         YVX7SBzvVPPp6+5g46jSVeSrnakVkTVeZZfQI=
Subject: Re: [PATCH 2/2] The new jhash implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.DEB.2.00.1011251520270.1198@blackhole.kfki.hu>
References: <1290690908-794-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290690908-794-3-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290692943.2858.303.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011251520270.1198@blackhole.kfki.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 18:21:09 +0100
Message-ID: <1290705669.2858.381.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 15:41 +0100, Jozsef Kadlecsik a écrit :

...

> +/* __jhash_mix -- mix 3 32-bit values reversibly. */
> +#define __jhash_mix(a, b, c)			\
> +{						\
> +	a -= c;  a ^= rol32(c, 4);  c += b;	\
> +	b -= a;  b ^= rol32(a, 6);  a += c;	\
> +	c -= b;  c ^= rol32(b, 8);  b += a;	\
> +	a -= c;  a ^= rol32(c, 16); c += b;	\
> +	b -= a;  b ^= rol32(a, 19); a += c;	\
> +	c -= b;  c ^= rol32(b, 4);  b += a;	\
> +}
> +
> +/* __jhash_final - final mixing of 3 32-bit values (a,b,c) into c */
> +#define __jhash_final(a, b, c)			\
> +{						\
> +	c ^= b; c -= rol32(b, 14);		\
> +	a ^= c; a -= rol32(c, 11);		\
> +	b ^= a; b -= rol32(a, 25);		\
> +	c ^= b; c -= rol32(b, 16);		\
> +	a ^= c; a -= rol32(c, 4);		\
> +	b ^= a; b -= rol32(a, 14);		\
> +	c ^= b; c -= rol32(b, 24);		\
> +}
> +

So we now have a special __jhash_final(a, b, c) thing for the last
values.



> +/* jhash_3words - hash exactly 3, 2 or 1 word(s) */
> +u32 jhash_3words(u32 a, u32 b, u32 c, u32 initval)
> +{
> +	a += JHASH_INITVAL;
> +	b += JHASH_INITVAL;
> +	c += initval;
> +
> +	__jhash_mix(a, b, c);
> +
> +	return c;
> +}
> +EXPORT_SYMBOL(jhash_3words);


But you dont use it in jhash_3words().


I do think jhash_3words() should stay inlined, unless maybe
CONFIG_CC_OPTIMIZE_FOR_SIZE=y

We hit it several time per packet in network stack in RX path.

Once in skb_get_rxhash() (unless device fills skb->rxhash)
Once at least in conntrack (if used).
Once in UDP or TCP stack



