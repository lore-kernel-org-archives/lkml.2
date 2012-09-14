Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2INNhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:37:39 -0400
Received: from ares07.inai.de ([5.9.24.206]:51488 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2INNhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:37:38 -0400
Date: Fri, 14 Sep 2012 15:37:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Jim Rees <rees@umich.edu>
cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
In-Reply-To: <20120914123014.GB29160@umich.edu>
Message-ID: <alpine.LNX.2.01.1209141501450.18169@frira.zrqbmnf.qr>
References: <20120821212910.GD18637@fieldses.org> <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr> <1347614276.26071.15.camel@thorin> <20120914123014.GB29160@umich.edu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-09-14 14:30, Jim Rees wrote in an odd quote style
(the > are mine):

>Bernd Petrovitsch wrote:
>
>  A pure K&R-C version would use a string:
>  ----  snip ----
>  #define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
>  ----  snip ----
>  (if I converted them properly into hexadecimal) and that gives a "char"
>  which is happily promoted to whatever one needs in that place.
>
>1. That may give you a signed char on some architectures, which is not what
>you want (although it doesn't matter since the values are all < 128)

Convert.

>2. If you put this in a .h, you'll get multiple copies of the array

The gcc compiler is smart enough to optimize that away. A string
literal is known at compile-time and immutable by definition.
sizeof(i) is a compile-time constant, also by definition. Therefore,
any "foo"[bar] is resolvable at compile time. Even gcc -O0 knows that.

That makes it possible to write
  char f[base10len(whatever)];
without depending on C99 VLAs.

>Pure K&R:
>
>base10.h:
>extern unsigned char base10len_vals[];
>#define base10len(i) (base10len_vals[sizeof(i)])
>
>base10.c:
>unsigned char base10len_vals[] = {1,3,5,8,10,13,15,17,20};
>
>But I still like my way better.

Your way does not function as originally desired.

 * base10len(i) no longer expands to a compile-time constant

 * you will definitely have a variable base10len_vals in your
   objects, so you waste a read operation whenever it is used.
