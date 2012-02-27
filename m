Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab2B0WDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:03:20 -0500
Received: from mx2.parallels.com ([64.131.90.16]:44223 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab2B0WDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:03:18 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "dave.anglin@bell.net" <dave.anglin@bell.net>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
 for 64 bit.
Thread-Topic: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
 for 64 bit.
Thread-Index: AQHM9ZLLA74ijEZElUmnORY0ttBzN5ZRy/kAgAAGK4A=
Date: Mon, 27 Feb 2012 22:03:10 +0000
Message-ID: <1330380189.2822.95.camel@dabdike.int.hansenpartnership.com>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
	 <1330376359-23731-1-git-send-email-paul.gortmaker@windriver.com>
	 <1330378864.2822.92.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330378864.2822.92.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <496BC6AD6F19124DA3ABACE46EEAE210@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1RM3Scl021327

On Mon, 2012-02-27 at 21:41 +0000, James Bottomley wrote:
> On Mon, 2012-02-27 at 15:59 -0500, Paul Gortmaker wrote:
> > Using the 64 bit toolchains from kernel.org[1], one finds that
> > you can't build the a500_defconfig, because the Makefile will
> > stomp whatever value you have in your env. for CROSS_COMPILE.
> > 
> > This shows up since the kernel.org toolchains for parisc-64
> > do not have the "-gnu" prefix, and so you run into it always
> > saying hppa64-linux-gnu-gcc not found, regardless of the fact
> > you've not got "-gnu" put anywhere into CROSS_COMPILE.
> > 
> > Since you can set CROSS_COMPILE from the environment and/or set
> > it in your .config file, there really is no need for it to be
> > poked at by the Makefile at all.  So just delete it.
> > 
> > [1] ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.5.2/
> > 
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> > 
> > [v2: no ifdef/endif -- just delete the offending line.]
> > 
> > diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
> > index 55cca1d..a533367 100644
> > --- a/arch/parisc/Makefile
> > +++ b/arch/parisc/Makefile
> > @@ -31,7 +31,6 @@ ifdef CONFIG_64BIT
> >  UTS_MACHINE	:= parisc64
> >  CHECKFLAGS	+= -D__LP64__=1 -m64
> >  WIDTH		:= 64
> > -CROSS_COMPILE	:= hppa64-linux-gnu-
> >  else # 32-bit
> >  WIDTH		:=
> >  endif
> 
> We can't do that ... it crashes a standard build almost immediately
> because it doesn't pick the 64 bit compiler (and we have no biarch
> solution).
> 
> We need make on a 64 bit config to work out of the box.  It breaks
> with ?= as JDA pointed out because CROSS_COMPILE is always defined.
> Does this satisfy everyone?
> 
> James
> 
> ---
> 
> diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
> index 55cca1d..19ab7b2 100644
> --- a/arch/parisc/Makefile
> +++ b/arch/parisc/Makefile
> @@ -31,7 +31,11 @@ ifdef CONFIG_64BIT
>  UTS_MACHINE	:= parisc64
>  CHECKFLAGS	+= -D__LP64__=1 -m64
>  WIDTH		:= 64
> +
> +# FIXME: if no default set, should really try to locate dynamically
> +ifeq ($(CROSS_COMPILE),)
>  CROSS_COMPILE	:= hppa64-linux-gnu-
> +endif
>  else # 32-bit
>  WIDTH		:=
>  endif

There's an awful lot more than just this wrong with that Makefile.  For
instance, NATIVE can never be set because ifeq() isn't globbing in make
scripts ...  So I think a final (and dynamically choosing if unset)
solution is this one.

I'll stop now before I find something else wrong ...

James

---

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 55cca1d..c823f4a 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -23,24 +23,20 @@ NM		= sh $(srctree)/arch/parisc/nm
 CHECKFLAGS	+= -D__hppa__=1
 
 MACHINE		:= $(shell uname -m)
-ifeq ($(MACHINE),parisc*)
-NATIVE		:= 1
-endif
 
 ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1 -m64
 WIDTH		:= 64
-CROSS_COMPILE	:= hppa64-linux-gnu-
+
+# if no default set, try to find the corresponding 64 bit compiler
+ifeq ($(CROSS_COMPILE),)
+CROSS_COMPILE	:= $(shell $(CC) -dumpmachine | sed s/hppa-\\\(.*\\\)/hppa64-\\1-/)
+endif
 else # 32-bit
 WIDTH		:=
 endif
 
-# attempt to help out folks who are cross-compiling
-ifeq ($(NATIVE),1)
-CROSS_COMPILE	:= hppa$(WIDTH)-linux-
-endif
-
 OBJCOPY_FLAGS =-O binary -R .note -R .comment -S
 
 cflags-y	:= -pipe



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
