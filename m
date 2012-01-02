Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2ABAKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 19:10:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55618 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2ABAKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 19:10:19 -0500
Date: Sun, 1 Jan 2012 18:10:14 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [m68k] in modpost: "strlen" [iscsi_target_mod.ko] undefined!
 (and others)
Message-ID: <20120102001014.GD25837@elie.hsd1.il.comcast.net>
References: <20111116181424.14920.7730.reportbug@ara5.mirbsd.org>
 <Pine.BSM.4.64L.1111301751500.12725@herc.mirbsd.org>
 <CAMuHMdW8t8Q7OqxJM602iLG4aSv1KMTY-fhiGS7hyy8xBReh1A@mail.gmail.com>
 <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1201012310590.20109@herc.mirbsd.org>
 <20120101233931.GA25837@elie.hsd1.il.comcast.net>
 <Pine.BSM.4.64L.1201012342490.20109@herc.mirbsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.BSM.4.64L.1201012342490.20109@herc.mirbsd.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thorsten Glaser wrote:

> I’d rather know why upstream doesn’t use -ffreestanding on
> _all_ architectures. A kernel is _not_ a hosted environment,
> and GCC is right to bring in problems like this.

It's to make optimizations that use the builtin functions (e.g.,
memcpy) work with less fuss.  If the kernel implements all the
relevant library functions, then it can be considered hosted as far as
GCC cares.

[...]
>                                (Nobody prevents GCC from using
> a memcpy builtin that uses, say, SSE instructions

Doesn't -mno-sse take care of that?

However, if you (this is the general "you", not just Thorsten) find
the following reasoning[1] compelling, feel free to propose a patch to
Makefile instead of arch/m68k/Makefile.  If others agree, some patches
for the x86 string functions to get the optimizations back could
follow, leaving everyone happy.

Ciao,
Jonathan

[1]
commit d6326c18
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jan 4 05:29:33 2005 -0800

    [PATCH] compile with -ffreestanding

    For the kernel, it would be logical to use -ffreestanding.  The kernel is
    not a hosted environment with a standard C library.

    The gcc option -ffreestanding is supported by both gcc 2.95 and 3.4, which
    covers the whole range of currently supported compilers.

    Regarding changes caused by this patch:

    Andi Kleen reported:
      Newer gcc rewrites sprintf(buf,"%s",str) to strcpy(buf,str) transparently.

    This is only true with unit-at-a-time (disabled on i386 but enabled on
    x86_64).  The Linux kernel doesn't offer a standard C library, and such
    transparent replacements of kernel functions with builtins are quite
    fragile.

    Even with -ffreestanding, it's still possilble to explicitely use a gcc
    builtin if desired.
