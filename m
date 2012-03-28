Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2C1Kbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:31:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49557 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab2C1Kbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:31:51 -0400
Message-ID: <4F72E893.9070502@gmail.com>
Date: Wed, 28 Mar 2012 13:31:47 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <CAK1hOcOCG19U3sZAPDSH=BYsjgDMJ0VXjcoXV4EaoL30-dTO+A@mail.gmail.com> <4F72A80F.7000801@gmail.com> <201203281213.07856.vda.linux@googlemail.com>
In-Reply-To: <201203281213.07856.vda.linux@googlemail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.03.28 13:13, Denys Vlasenko wrote:
> Third: switch to algorithm #1 and test whether it fares better.
> To do that, go to test_new.c
> and replace
>    #if LONG_MAX>  ((1UL<<31)-1) || LLONG_MAX>  ((1ULL<<63)-1)
> with
>    #if 1   ////LONG_MAX>  ((1UL<<31)-1) || LLONG_MAX>  ((1ULL<<63)-1)
> (there are two instances of this line there),
> then recompile and rerun the test, and post the result.

After applied following diff:


--- test_new.org.c      2012-03-28 13:25:14.000000000 +0300
+++ test_new.c  2012-03-28 13:25:30.000000000 +0300
@@ -7,7 +7,7 @@
   * (with permission from the author, Douglas W. Jones).
   */

-#if LONG_MAX > ((1UL<<31)-1) || LLONG_MAX > ((1ULL<<63)-1)
+#if 1 ////LONG_MAX > ((1UL<<31)-1) || LLONG_MAX > ((1ULL<<63)-1)
  /* Formats correctly any integer in [0, 999999999] */
  static noinline_for_stack
  char *put_dec_full9(char *buf, unsigned q)
@@ -106,7 +106,7 @@
   * Else (if long is 32 bits and long long is 64 bits) we use second one.
   */

-#if LONG_MAX > ((1UL<<31)-1) || LLONG_MAX > ((1ULL<<63)-1)
+#if 1 ///LONG_MAX > ((1UL<<31)-1) || LLONG_MAX > ((1ULL<<63)-1)

  /* First algorithm: generic */


I have following compile output:
$ arm-linux-gnueabi-gcc -O2 -Wall test_new.c -o test_new
test_new.c: In function ‘number’:
test_new.c:118: error: impossible constraint in ‘asm’
test_new.c:118: error: impossible constraint in ‘asm’
test_new.c:118: error: impossible constraint in ‘asm’

but affter this diff:
--- test_new-with-ifdefs.c      2012-03-28 13:29:04.000000000 +0300
+++ test_new.c  2012-03-28 13:29:12.000000000 +0300
@@ -1,4 +1,4 @@
-#include "test_header.c"
+#include "test_header_arm.c"

  /* Decimal conversion is by far the most typical, and is used
   * for /proc and /sys data. This directly impacts e.g. top performance

compiles fine.

result are:
./test_new2
Conversions per second: 8:5420000 123:4452000 123456:3556000 12345678:3368000 
123456789:2904000 2^32:2412000 2^64:1556000
Conversions per second: 8:5428000 123:4500000 123456:3644000 12345678:3328000 
123456789:2832000 2^32:2408000 2^64:1572000
Conversions per second: 8:5372000 123:4396000 123456:3644000 12345678:3368000 
123456789:2900000 2^32:2392000 2^64:1532000
Conversions per second: 8:5424000 123:4500000 123456:3608000 12345678:3284000 
123456789:2896000 2^32:2416000 2^64:1572000

btw: previovios version (test_new) still running, now is at:
Tested 2446852096

roma1390

