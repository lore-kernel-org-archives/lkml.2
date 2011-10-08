Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1JHNIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:08:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab1JHNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:08:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Barry Song <21cnbao@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH v2] pinmux: add a driver for the CSR SiRFprimaII pinmux
Date: Sat, 08 Oct 2011 15:08:27 +0200
Message-ID: <3712698.4MAZQPafzW@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAGsJ_4xpYMzHGi09jt2Y9xCocYJ0iHYRfdvwCzcH65uaF2sP0g@mail.gmail.com>
References: <1314843744-2910-1-git-send-email-Baohua.Song@csr.com> <CACRpkdbb_5EZHT3=SNePbW-=NYjLSLzJgjEdEaBV7X=s6gxydw@mail.gmail.com> <CAGsJ_4xpYMzHGi09jt2Y9xCocYJ0iHYRfdvwCzcH65uaF2sP0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QttuMwZIBV663Pa7kQer0XsekCeKlBkJm/+gI/+NFED
 lqNcpCVQ0Clrt+/ygqZFVKwgtlideIaeeB3yJtW4xb2fXRrgdo
 zn1bjqIFfa7U6oRw7p2mTnH72JH7s6A7NGJRzbaOthJOPmWjuJ
 a6a1X3k7QnZa8ZQfm9/e++0G6E60Aq4xl+BJc4Lxl8sbho9hCK
 wHcJdFaoBBZwjwId/swwqaQHWuZxng6dID7EMj+418QDIzZTuG
 2BwC+1Mup/6Hrwlg+XTfK1XmO/uboj3mMiEOdrXK111NB/Femb
 GT0xuD4kLOBoJbmo4OXzjc02UggcyMScg4D2zOMjwtp9NJ2mdx
 /RE2lnPmTjEwQO3XGrIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 October 2011 19:58:23 Barry Song wrote:
> > You can probably simplify this and other things with
> > preprocessor macros if you want to, like:
> >
> > #define SIRF_FUNC_ENTRY(a) \
> > { .name = "##a##", .pins = ##a##_pins, .num_pins =
> > ARRAY_SIZE(##a##_pins), .padmux = &##a##_padmux }
> >
> > Then just:
> >
> > static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
> >     SIRF_FUNC_ENTRY(lcd_16bits),
> >
> >
> > The macro syntax is probably wrong, the preprocessor always
> > craze me out, but you get the idea.
> 
>  :-)  .name = "##a##"  should be changed to .name = #a
> 
> #name will convert name into a string "name"
> 

Better don't use string concatenation at all if you can avoid it.

A generic macro like

#define SIRF_PINMUX(_name, _pins, _padmux) \
	{ .name = (_name), .pins = (_pins), \
	  .num_pins = ARRAY_SIZE(_pins), padmux = (_padmux), }

is both very easy to understand for someone reading it casually and
lets you actually grep for where the identifiers are being used.

> static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
>     SIRF_FUNC_ENTRY(lcd_16bits),

for the first time, you have no clue what that does, but

static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
	SIRF_PINMUX("lcd_16bits", lcd_16bits_pins, &lcd_16bits_padmux),
	...
};

Makes it very clear what you are referencing here and needs no extra lines.

	Arnd
