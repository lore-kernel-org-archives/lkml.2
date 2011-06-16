Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab1FPTfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:35:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41895 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab1FPTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=NTFNZOuuQHbyWjQ9rjMD16Hp3jYZdMrbP51dEDl0H4/YO/YaUjJb/gUAg3+u8X3oid
         BnbZDivTbUgjqPVhMFyaCp0bB6uNr84zFxsEKsUs2jrV5XMAwa6EEvSkSuOio/ms17Zq
         ZDhPYqIex07ysO4khOzGDi2eTFu6o9+EZYVOg=
Date: Thu, 16 Jun 2011 22:34:56 +0300
From: Pekka Paalanen <pq@iki.fi>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Faking MMIO ops? Fooling a driver
Message-ID: <20110616223456.5cfdec2b@farn.lan>
In-Reply-To: <BANLkTi=-wXnXNJY3R+3Q+KSaJhtxHgrhZw@mail.gmail.com>
References: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com>
	<BANLkTinUxRGkXeOtBSKi51n3Q_rZEp1gUg@mail.gmail.com>
	<4DFA4672.5080307@lwfinger.net>
	<BANLkTi=-wXnXNJY3R+3Q+KSaJhtxHgrhZw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 21:19:04 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> W dniu 16 czerwca 2011 20:07 użytkownik Larry Finger
> <Larry.Finger@lwfinger.net> napisał:
> > On 06/16/2011 12:20 PM, Rafał Miłecki wrote:
> >>
> >> W dniu 16 czerwca 2011 16:44 użytkownik Rafał Miłecki
> >> <zajec5@gmail.com>  napisał:
> >>>
> >>> I analyze MMIO dumps of closed source driver and found such a
> >>> place: W 2 3855.911536 9 0xb06003fc 0x810 0x0 0
> >>> R 2 3855.911540 9 0xb06003fe 0x0 0x0 0
> >>> W 2 3855.911541 9 0xb06003fe 0x0 0x0 0
> >>>
> >>> After translation:
> >>>  phy_read(0x0810) ->  0x0000
> >>> phy_write(0x0810)<- 0x0000
> >>>
> >>> So it's quite obvious, the driver is reading PHY register,
> >>> masking it and writing masked value. Unfortunately from just
> >>> looking at such place we can not guess the mask driver uses.
> >>>
> >>> I'd like to fake value read from 0xb06003fe to be 0xFFFF.
> >>> Is there some ready method for doing such a trick?
> >>>
> >>> Dump comes from Kernel hacking → Tracers → MMIO and
> >>> ndiswrapper.
> >>
> >> I can see values in MMIO trace struct are filled in
> >> arch/x86/mm/mmio-mod.c in "pre" and "post". However still no
> >> idea how to hack the returned value.

If you want to do it that way, the idea is to overwrite
the right CPU register in mmio-mod.c:post(). You would test for
the address you want to mess with, and then "invert"
get_ins_reg_val() to overwrite the register with your own value.

> >> Should I try hacking read[bwl] instead? :|
> >
> > Probably. I do not see any way to trace and modify the results
> > for a particular address without special code.
> 
> Did you success with writing some special code? Following patch
> does not seem to work for me:
> 
> 
> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index e0ffa3d..448e4ff 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -23,6 +23,8 @@
>  #define mmiowb() do {} while (0)
>  #endif
> 
> +static int zajec = 0;
> +
>  /*****************************************************************************/
>  /*
>   * readX/writeX() are used to access memory mapped devices. On
> some @@ -40,6 +42,11 @@ static inline u8 __raw_readb(const
> volatile void __iomem *addr)
>  #ifndef __raw_readw
>  static inline u16 __raw_readw(const volatile void __iomem *addr)
>  {
> +	if (zajec++ < 10)
> +		printk(KERN_INFO "[ZAJEC] %d\n", *addr);
> +	if (*addr == 0xfaafc000)
> +		printk(KERN_INFO "[ZAJEC] Bingo!\n");
> +	//0x1381a8d8
>  	return *(const volatile u16 __force *) addr;
>  }
>  #endif
> 
> Should I modify different readw? Path include/asm-generic/io.h
> sounds sane to me, so I modified this one.

Are you sure that code is ever used on your arch?
For instance, it seems that arch/x86/include/asm/io.h
defines a different __raw_readw.


Cheers.

-- 
Pekka Paalanen
http://www.iki.fi/pq/

