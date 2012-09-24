Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2IXJEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:04:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52715 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2IXJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:04:18 -0400
MIME-Version: 1.0
In-Reply-To: <1343971271-13355-2-git-send-email-linux@horizon.com>
References: <1343971271-13355-1-git-send-email-linux@horizon.com> <1343971271-13355-2-git-send-email-linux@horizon.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 24 Sep 2012 11:03:57 +0200
Message-ID: <CAK1hOcOO7MoDDzJgKJ+2dra5n3ogyKR+mKyTh+o_isgRi3yRxQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
To: George Spelvin <linux@horizon.com>
Cc: mina86@mina86.com, hughd@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 7:21 AM, George Spelvin <linux@horizon.com> wrote:
> The same multiply-by-inverse technique can be used to
> convert division by 10000 to a 32x32->64-bit multiply.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>  lib/vsprintf.c |   60 +++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 27 deletions(-)
>
> This is something of an RFC, I haven't benchmarked the helper
> function.  But it sure cleans up the code!

Can you please do that before you send alterations
to the code which *was* benchmarked?


> +static
> +unsigned put_dec_helper4(char *buf, unsigned x)
> +{
> +        uint32_t q = (x * (uint64_t)0x346DC5D7) >> 43;
> +
> +        put_dec_full4(buf, x - q * 10000);
> +        return q;
>  }
>
>  /* Based on code by Douglas W. Jones found at
> @@ -277,28 +292,19 @@ char *put_dec(char *buf, unsigned long long n)
>         d3  = (h >> 16); /* implicit "& 0xffff" */
>
>         q   = 656 * d3 + 7296 * d2 + 5536 * d1 + ((uint32_t)n & 0xffff);
> +       q = put_dec_helper4(buf, q);
> +
> +       q += 7671 * d3 + 9496 * d2 + 6 * d1;
> +       q = put_dec_helper4(buf+4, q);
> +
> +       q += 4749 * d3 + 42 * d2;
> +       q = put_dec_helper4(buf+8, q);
>
> -       buf = put_dec_full4(buf, q % 10000);
> -       q   = q / 10000;
> -
> -       d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
> -       buf = put_dec_full4(buf, d1 % 10000);
> -       q   = d1 / 10000;
> -
> -       d2  = q + 4749 * d3 + 42 * d2;
> -       buf = put_dec_full4(buf, d2 % 10000);
> -       q   = d2 / 10000;
> -
> -       d3  = q + 281 * d3;
> -       if (!d3)
> -               goto done;
> -       buf = put_dec_full4(buf, d3 % 10000);
> -       q   = d3 / 10000;
> -       if (!q)
> -               goto done;
> -       buf = put_dec_full4(buf, q);
> - done:
> -       while (buf[-1] == '0')
> +       q += 281 * d3;
> +       buf += 12;
> +       if (q)
> +               buf = put_dec_trunc8(buf, q);
> +       else while (buf[-1] == '0')
>                 --buf;

gcc was already doing that optimization for us.
It will use a larger constant and shift, but that
changes neither size nor speed.

Moreover, put_dec_helper4 will get inlined,
so the generated assembly code will be very similar.

Here is the comparison of the x86-32 assembly
of the fragment which does "x / 10000" thing,
before and after the patch:

-01 c6                  add    %eax,%esi
-b8 59 17 b7 d1         mov    $0xd1b71759,%eax
-f7 e6                  mul    %esi
-89 d3                  mov    %edx,%ebx
-89 f2                  mov    %esi,%edx
-c1 eb 0d               shr    $0xd,%ebx

+01 c7                  add    %eax,%edi
+b8 d7 c5 6d 34         mov    $0x346dc5d7,%eax
+f7 e7                  mul    %edi
+89 55 e8               mov    %edx,-0x18(%ebp)
+8b 5d e8               mov    -0x18(%ebp),%ebx
+89 fa                  mov    %edi,%edx
+89 45 e4               mov    %eax,-0x1c(%ebp)
+c1 eb 0b               shr    $0xb,%ebx

Poor gcc got confused, and generated somewhat
worse code (spilling and immediately reloading upper
part of 32x32->64 multiply).

Please test and benchmark your changes to this code
before submitting them.

-- 
vda
