Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2AZX2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:28:44 -0500
Received: from freebox.lhuard.fr.eu.org ([88.182.161.122]:43607 "EHLO
	coruscant.lhuard.fr.eu.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751323Ab2AZX2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:28:43 -0500
X-Greylist: delayed 1605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jan 2012 18:28:43 EST
From: =?utf-8?q?L=C3=A9na=C3=AFc_Huard?= <lenaic@lhuard.fr.eu.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Shift by one instruction in the perf annotate output
Date: Fri, 27 Jan 2012 00:01:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201270001.27765.lenaic@lhuard.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Using perf and zooming up to the annotated assembler, I noticed a “shift by 
one” issue between the assembler instructions and the reported consumed cycles 
in the left margin.
Each time a given instruction is expensive, the high event count appears on 
the line right after.
In order to validate that feeling, I tried to put an expensive instruction 
(division) inside a block of cheaper instructions (no operation). And here is 
the output of perf annotate:

    0,00 :          40041d:       nop
    0,00 :          40041e:       nop
    5,31 :          40041f:       nop                                                                                                                                               
    0,00 :          400420:       divl   (%rsp)
   84,18 :          400423:       nop                                                                                                                                               
    0,00 :          400424:       nop
    0,07 :          400425:       nop

I would have expected the 84,18 count to be in front of the “divl” instruction 
and not in front of the “nop” one.

I am running Linux and perf 3.2 but I remember that previous versions suffered 
from the same issue.

I don’t know if it could be specific to my cpu:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6
microcode       : 0xd0
cpu MHz         : 2394.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts tpr_shadow
bogomips        : 4807.89
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

This issue is not specific to the perf tool itself since I observe exactly the 
same thing with OProfile.
Here is the output of opannotate for the same piece of code:

               :  40041d:       nop
               :  40041e:       nop
   971  0.5636 :  40041f:       nop
     1 5.8e-04 :  400420:       divl   (%rsp)
165045 95.7904 :  400423:       nop
     4  0.0023 :  400424:       nop
    18  0.0104 :  400425:       nop

Once again, the high number of samples should have been collected in “divl” 
and not in “nop”.


Here is the small program I used to observe that phenomenon (x86(-64) 
specific):

#include <stdlib.h>
#include <stdio.h>

void divide( int  dividend,
             int  divisor,
             int *quotient,
             int *remainder )
{
  for( unsigned i = 0 ; i < 1000000000 ; i++ )
  __asm__ __volatile__
    ( "xor %%edx,%%edx;"
      "nop;"
      "nop;"
      "nop;"
      "divl %[divisor];"
      "nop;"
      "nop;"
      "nop;"
      : "=a" (*quotient), "=&d" (*remainder)
      : "a" (dividend), [divisor] "m" (divisor)
      );
}

int main()
{
  int quotient, remainder;
  divide( 1234, 100, &quotient, &remainder );
  printf( "%d = %d x %d + %d\n", 1234, 100, quotient, remainder );
  return EXIT_SUCCESS;
}

$ gcc -pipe -o div div.c -std=c99 -O3
$ perf record -g ./div
$ perf report -g
$ perf annotate main # -O3 made divide() inlined
