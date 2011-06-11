Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1FKDu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 23:50:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab1FKDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 23:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=sCSrhBnR9KPqnIES86PNdQwrD3GC/5a8+dPOFOinh/cWefo2x0l+WGEW1S2yyh7/D7
         YJlDFcKb90RuHm35NUI93efcozlaLOskPL6qBMcYeib1iL3QsNXmLoaUX+u3oFac3d84
         jL9XV2VKcNwYha3FbgecEpCKaE3qK0ZObnl/8=
MIME-Version: 1.0
From: Jonathan Elchison <JElchison@Gmail.com>
Date: Fri, 10 Jun 2011 23:50:05 -0400
X-Google-Sender-Auth: NAsjJ4u1gGfxFE0khx7gm0clQAM
Message-ID: <BANLkTimUSvQi9CPgO+cCUrEdQq-+ohbzFg@mail.gmail.com>
Subject: [PATCH] m68k: Patch for broken lsl64() "old code" with incorrect shift
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:

[PATCH] m68k: Patch for broken lsl64() "old code" with incorrect shift


[2.] Full description of the problem/report:

In arch/m68k/math-emu/multi_arith.h, lsl64() doesn't calculate a
correct HI_WORD(*dest) when count < 32, due to an incorrect shift
operation.  This line:

    HI_WORD(*dest) = (HI_WORD(*dest) << count) | (LO_WORD(*dest) >> count);

...should be...

    HI_WORD(*dest) = (HI_WORD(*dest) << count) | (LO_WORD(*dest) >>
(32 - count));

This function is ifdef'd out, marked as "old code".  However, I fell
into the same trap into which I suspect others have fallen (or will
fall):  On rare occasion when I need to implement my own library
functions, I depend on the Linux kernel to provide solid code.  This
bug, albeit in old code, led me astray.

I'm asking that this old code (lsl64) be corrected or removed.


[3.] Keywords (i.e., modules, networking, kernel):

kernel, arch, m68k, math-emu, multi_arith.h, lsl64


[4.] Kernel information

2.6.39.1


[5.] Most recent kernel version which did not have the bug:

Unknown


[6.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt)

N/A


[7.] A small shell script or example program which triggers the
problem (if possible)

-----------------------------------------------------------------
#include <stdio.h>

#define LO_WORD(ll) (((unsigned int *) &ll)[1])
#define HI_WORD(ll) (((unsigned int *) &ll)[0])

static inline void lsl64_broken(int count, unsigned long long *dest)
{
	if (count < 32) {
		HI_WORD(*dest) = (HI_WORD(*dest) << count)
		    | (LO_WORD(*dest) >> count);
		LO_WORD(*dest) <<= count;
		return;
	}
	count -= 32;
	HI_WORD(*dest) = LO_WORD(*dest) << count;
	LO_WORD(*dest) = 0;
}

static inline void lsl64_fixed(int count, unsigned long long *dest)
{
	if (count < 32) {
		HI_WORD(*dest) = (HI_WORD(*dest) << count)
		    | (LO_WORD(*dest) >> (32 - count));
		LO_WORD(*dest) <<= count;
		return;
	}
	count -= 32;
	HI_WORD(*dest) = LO_WORD(*dest) << count;
	LO_WORD(*dest) = 0;
}

static inline void lsr64(int count, unsigned long long *dest)
{
	if (count < 32) {
		LO_WORD(*dest) = (LO_WORD(*dest) >> count)
		    | (HI_WORD(*dest) << (32 - count));
		HI_WORD(*dest) >>= count;
		return;
	}
	count -= 32;
	LO_WORD(*dest) = HI_WORD(*dest) >> count;
	HI_WORD(*dest) = 0;
}

int main( void )
{
	long long testVal = 0x0000100000001000L;
	long long testVal_broken = testVal;
	long long testVal_fixed = testVal;
	
	printf( "begin testVal_broken =\t\t0x%016llx\n", testVal_broken );
	lsr64( 1, &testVal_broken );
	printf( "intermediate testVal_broken =\t0x%016llx\n", testVal_broken );
	lsl64_broken( 1, &testVal_broken );
	printf( "final testVal_broken =\t\t0x%016llx\n", testVal_broken );
	printf( "final matches begin?\t\t%s\n", testVal_broken == testVal ?
"TRUE" : "FALSE" );

	printf( "\nbegin testVal_fixed =\t\t0x%016llx\n", testVal_fixed );
	lsr64( 1, &testVal_fixed );
	printf( "intermediate testVal_fixed =\t0x%016llx\n", testVal_fixed );
	lsl64_fixed( 1, &testVal_fixed );
	printf( "final testVal_fixed =\t\t0x%016llx\n", testVal_fixed );
	printf( "final matches begin?\t\t%s\n", testVal_fixed == testVal ?
"TRUE" : "FALSE" );

	return 0;
}
-----------------------------------------------------------------


[8.] Environment

Found via code inspection


[9.] Patch

Signed-off-by: Jonathan Elchison <jelchison@gmail.com>

-----------------------------------------------------------------
diff -up linux-2.6/arch/m68k/math-emu/multi_arith.h
linux-2.6_orig/arch/m68k/math-emu/multi_arith.h
--- linux-2.6/arch/m68k/math-emu/multi_arith.h	2011-06-10
22:50:32.538711320 -0400
+++ linux-2.6_orig/arch/m68k/math-emu/multi_arith.h	2011-06-10
22:47:43.407285452 -0400
@@ -236,7 +236,7 @@ static inline void lsl64(int count, unsi
 {
 	if (count < 32) {
 		HI_WORD(*dest) = (HI_WORD(*dest) << count)
-		    | (LO_WORD(*dest) >> (32 - count));
+		    | (LO_WORD(*dest) >> count);
 		LO_WORD(*dest) <<= count;
 		return;
 	}
-----------------------------------------------------------------


[10.] Responses

Please personally CC me on responses to this post.

--
Jonathan Elchison
jelchison@gmail.com
