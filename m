Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0KYNtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:49:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38641 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0KYNtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PlSu0GGWyhrgBzLx7k+zaLbja8GjBdnUi+j2/QzTu3qmq64hN1rAo6MDG3kSilxeOu
         vBmwiNGmYccuss8oK/7O6jB+Z3h41c1hP1rS8cDDymIEa/O7E1atxxm5hBpABzBwvnZI
         ejgWYQvioAeC54N8sVcXIN/CeJUiwueVuT0gw=
Subject: Re: [PATCH 2/2] The new jhash implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1290690908-794-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1290690908-794-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290690908-794-3-git-send-email-kadlec@blackhole.kfki.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 14:49:03 +0100
Message-ID: <1290692943.2858.303.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 14:15 +0100, Jozsef Kadlecsik a écrit :
> The current jhash.h implements the lookup2() hash function by Bob Jenkins.
> However, lookup2() is outdated as Bob wrote a new hash function called
> lookup3(). The new hash function
> 
> - mixes better than lookup2(): it passes the check that every input bit
>   changes every output bit 50% of the time, while lookup2() failed it.
> - performs better: compiled with -O2 on Core2 Duo, lookup3() 20-40% faster
>   than lookup2() depending on the key length.
> 
> The patch replaces the lookup2() implementation of the 'jhash*'
> functions with that of lookup3().
> 
> You can read a longer comparison of the two and other hash functions at
> http://burtleburtle.net/bob/hash/doobs.html.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/jhash.h |  136 +++-----------------------------------------
>  lib/Makefile          |    2 +-
>  lib/jhash.c           |  153 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 162 insertions(+), 129 deletions(-)
>  create mode 100644 lib/jhash.c
> 
...

I agree jhash() should be not be inlined.

I am not sure for other variants.

> +u32 jhash(const void *key, u32 length, u32 initval)
> +{
> +	u32 a, b, c;
> +	const u8 *k = key;
> +
> +	/* Set up the internal state */
> +	a = b = c = JHASH_INITVAL + length + initval;
> +
> +	/* All but the last block: affect some 32 bits of (a,b,c) */
> +	while (length > 12) {
> +		a += k[0] + ((u32)k[1]<<8) + ((u32)k[2]<<16) + ((u32)k[3]<<24);

disassembly code on x86_32 for the previous line :

  26:	66 90                	xchg   %ax,%ax
  28:	0f b6 72 01          	movzbl 0x1(%edx),%esi
  2c:	0f b6 4a 02          	movzbl 0x2(%edx),%ecx
  30:	c1 e6 08             	shl    $0x8,%esi
  33:	c1 e1 10             	shl    $0x10,%ecx
  36:	8d 0c 0e             	lea    (%esi,%ecx,1),%ecx
  39:	0f b6 32             	movzbl (%edx),%esi
  3c:	8d 34 31             	lea    (%ecx,%esi,1),%esi
  3f:	0f b6 4a 03          	movzbl 0x3(%edx),%ecx
  43:	c1 e1 18             	shl    $0x18,%ecx
  46:	8d 0c 0e             	lea    (%esi,%ecx,1),%ecx

or (CONFIG_CC_OPTIMIZE_FOR_SIZE=y) :

  1b:	0f b6 7b 01          	movzbl 0x1(%ebx),%edi
  1f:	c1 e7 08             	shl    $0x8,%edi
  22:	89 7d f0             	mov    %edi,-0x10(%ebp)
  25:	0f b6 7b 02          	movzbl 0x2(%ebx),%edi
  29:	c1 e7 10             	shl    $0x10,%edi
  2c:	03 7d f0             	add    -0x10(%ebp),%edi
  2f:	89 7d f0             	mov    %edi,-0x10(%ebp)
  32:	0f b6 3b             	movzbl (%ebx),%edi
  35:	03 7d f0             	add    -0x10(%ebp),%edi
  38:	89 7d f0             	mov    %edi,-0x10(%ebp)
  3b:	0f b6 7b 03          	movzbl 0x3(%ebx),%edi
  3f:	c1 e7 18             	shl    $0x18,%edi
  42:	03 7d f0             	add    -0x10(%ebp),%edi


I suggest :

#include <linux/unaligned/packed_struct.h>
...
	a += __get_unaligned_cpu32(k);
	b += __get_unaligned_cpu32(k+4);
	c += __get_unaligned_cpu32(k+8);

Fits nicely in registers.
 



> +		b += k[4] + ((u32)k[5]<<8) + ((u32)k[6]<<16) + ((u32)k[7]<<24);
> +		c += k[8] + ((u32)k[9]<<8) + ((u32)k[10]<<16) + ((u32)k[11]<<24);
> +		__jhash_mix(a, b, c);
> +		length -= 12;
> +		k += 12;
> +	}
> +	/* Last block: affect all 32 bits of (c) */
> +	/* All the case statements fall through */
> +	switch (length) {
> +	case 12: c += (u32)k[11]<<24;
> +	case 11: c += (u32)k[10]<<16;
> +	case 10: c += (u32)k[9]<<8;
> +	case 9:  c += k[8];
> +	case 8:  b += (u32)k[7]<<24;
> +	case 7:  b += (u32)k[6]<<16;
> +	case 6:  b += (u32)k[5]<<8;
> +	case 5:  b += k[4];
> +	case 4:  a += (u32)k[3]<<24;
> +	case 3:  a += (u32)k[2]<<16;
> +	case 2:  a += (u32)k[1]<<8;
> +	case 1:  a += k[0];
> +		 __jhash_final(a, b, c);
> +	case 0: /* Nothing left to add */
> +		break;
> +	}
> +
> +	return c;
> +}
> +EXPORT_SYMBOL(jhash);



