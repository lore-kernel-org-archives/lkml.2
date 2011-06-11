Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1FKMBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 08:01:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55530 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1FKMBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 08:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UHSkTZGs55Kx6h9R1Xvx8T8XyVrOt6ze5uTwmii1FlSMXnoiSyNKDt+1YxbPxxhu76
         9iy/rP/KtfwVbDfGcK5CfV3ZFnm+hH2bMwe67K73qOFdMEfpIpqusDt5XCqdK7tZr8yz
         orcLjjTqvrYLJUqdmdk5bChxJNa7L8tn9+iNw=
MIME-Version: 1.0
In-Reply-To: <BANLkTimUSvQi9CPgO+cCUrEdQq-+ohbzFg@mail.gmail.com>
References: <BANLkTimUSvQi9CPgO+cCUrEdQq-+ohbzFg@mail.gmail.com>
Date: Sat, 11 Jun 2011 14:01:35 +0200
X-Google-Sender-Auth: JFMLml5M_2Z5nheckw__nkXhDBc
Message-ID: <BANLkTimz90oWNDYYNnpX5aDhJ192LhDkXA@mail.gmail.com>
Subject: Re: [PATCH] m68k: Patch for broken lsl64() "old code" with incorrect shift
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonathan Elchison <JElchison@gmail.com>
Cc: linux-m68k@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, David Huggins-Daines <dhd@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 05:50, Jonathan Elchison <JElchison@gmail.com> wrote:
> In arch/m68k/math-emu/multi_arith.h, lsl64() doesn't calculate a
> correct HI_WORD(*dest) when count < 32, due to an incorrect shift
> operation.  This line:
>
>    HI_WORD(*dest) = (HI_WORD(*dest) << count) | (LO_WORD(*dest) >> count);
>
> ...should be...
>
>    HI_WORD(*dest) = (HI_WORD(*dest) << count) | (LO_WORD(*dest) >>
> (32 - count));
>
> This function is ifdef'd out, marked as "old code".  However, I fell
> into the same trap into which I suspect others have fallen (or will
> fall):  On rare occasion when I need to implement my own library
> functions, I depend on the Linux kernel to provide solid code.  This
> bug, albeit in old code, led me astray.
>
> I'm asking that this old code (lsl64) be corrected or removed.

I think it's better to just remove all #ifdefed out parts in the code.

> diff -up linux-2.6/arch/m68k/math-emu/multi_arith.h
> linux-2.6_orig/arch/m68k/math-emu/multi_arith.h
> --- linux-2.6/arch/m68k/math-emu/multi_arith.h  2011-06-10
> 22:50:32.538711320 -0400
> +++ linux-2.6_orig/arch/m68k/math-emu/multi_arith.h     2011-06-10
> 22:47:43.407285452 -0400
> @@ -236,7 +236,7 @@ static inline void lsl64(int count, unsi
>  {
>        if (count < 32) {
>                HI_WORD(*dest) = (HI_WORD(*dest) << count)
> -                   | (LO_WORD(*dest) >> (32 - count));
> +                   | (LO_WORD(*dest) >> count);
>                LO_WORD(*dest) <<= count;
>                return;
>        }

The patch is reversed?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
