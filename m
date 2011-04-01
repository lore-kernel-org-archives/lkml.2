Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1DATeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:34:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50120 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1DATeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:34:44 -0400
Message-ID: <4D9628C8.3040309@zytor.com>
Date: Fri, 01 Apr 2011 12:34:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Maksym Planeta <mcsim.planeta@gmail.com>
CC: mingo@redhat.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] page: get_order() optimization
References: <1301685493-2567-1-git-send-email-mcsim.planeta@gmail.com>
In-Reply-To: <1301685493-2567-1-git-send-email-mcsim.planeta@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 12:18 PM, Maksym Planeta wrote:
> Loop was repalaced with __builtin_clz(). This still allows to precompute
> constants, but on some architectures it uses special instruction to
> calculate order.
> 
> Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> ---
>  include/asm-generic/getorder.h |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
> index 67e7245..fe8020c 100644
> --- a/include/asm-generic/getorder.h
> +++ b/include/asm-generic/getorder.h
> @@ -11,11 +11,9 @@ static inline __attribute_const__ int get_order(unsigned long size)
>  	int order;
>  
>  	size = (size - 1) >> (PAGE_SHIFT - 1);
> -	order = -1;
> -	do {
> -		size >>= 1;
> -		order++;
> -	} while (size);
> +	order = (__builtin_clzl(size) ^ (BITS_PER_LONG - 1));
> +	if (size == 0)
> +		order = 0;
>  	return order;
>  }
>  

You need to guard this with __GNUC__ >= 4; there are still laggards
using gcc 3.  Furthermore, on some platforms __builtin_clz*() does a
libgcc call which may be undesirable.

For the generic case, one can do something like this instead of a loop:

static inline unsigned int __clzl(unsigned long v)
{
        unsigned int p;

#if BITS_PER_LONG == 64
	p = 63;

	if (v & 0xffffffff00000000UL) {
		p -= 32;
		v >>= 32;
	}
#else
	p = 31;
#endif

        if (v & 0xffff0000) {
                p -= 16;
                v >>= 16;
        }
        if (v & 0xff00) {
                p -= 8;
                v >>= 8;
        }
        if (v & 0xf0) {
                p -= 4;
                v >>= 4;
        }
        if (v & 0xc) {
                p -= 2;
                v >>= 2;
        }
        if (v & 0x2) {
                p -= 1;
                v >>= 1;
        }

        return p;
}
