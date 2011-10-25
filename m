Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1JYXog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 19:44:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1JYXoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 19:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <1319528012-19006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1319528012-19006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 25 Oct 2011 19:44:14 -0400
X-Google-Sender-Auth: LMr4bVRSB-8Ew7ws3UQ_80sfyZk
Message-ID: <CAJaTeTp2w85UHnmH-PPMZsQGQMNa-93kw-tjmDxA_wjJXkYQcQ@mail.gmail.com>
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 03:33, Mark Brown wrote:
> Rather than requiring architectures that use gpiolib but don't have any
> need to define anything custom to copy an asm/gpio.h provide a Kconfig
> symbol which architectures must select in order to include gpio.h and
> for other architectures just provide the trivial implementation directly.

i don't think this is generally how asm-generic is handled.  instead, how about:
 - move the duplicate code to asm-generic/gpio.h
 - have the arches which merely need asm-generic/gpio.h add "generic-y
+= gpio.h" to their include/asm/Kbuild
 - for arches which need to override these common funcs in some way,
add #ifdef protection to the asm-generic/gpio.h

and it seems like with slightly more work, this path allow you to
merge most of arch/sh/include/asm/gpio.h.  and it has the advantage of
not needing new Kconfig symbols.

for example, with asm-generic/atomic.h, it does:
#ifndef atomic_sub_return
static inline int atomic_sub_return(int i, atomic_t *v)
{ ... common implementation ... }
#endif

and then any arch that wants to override it does:
#define atomic_sub_return atomic_sub_return
static inline int atomic_sub_return(int i, atomic_t *v) { weirdness }
#include <asm-generic/atomic.h>
-mike
