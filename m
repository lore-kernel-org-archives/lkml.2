Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2DCKsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:48:37 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13968 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab2DCKsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:48:36 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1WGOQ-02-8ZM-02
X-M-MSG: 
Date: Tue, 3 Apr 2012 12:48:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120403104824.GI16322@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <20120402191123.GA17124@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120402191123.GA17124@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.04.12 21:11:23, Ingo Molnar wrote:
> Mind posting some perf annotate output of any well-known kernel 
> function showing skiddy '-e cpu-cycles' output versus skid-less 
> '-e cpu-cycles:p' output?

This is what I got for _raw_spin_lock_irqsave (first perfctr, second
ibs).

-Robert


 # perf annotate -k vmlinux -s _raw_spin_lock_irqsave -i perf-r076.data | cat
  Percent |	Source code & Disassembly of vmlinux
 ------------------------------------------------
          :
          :
          :
          :	Disassembly of section .text:
          :
          :	ffffffff8145036a <_raw_spin_lock_irqsave>:
     0.00 :	ffffffff8145036a:       push   %rbp
     0.00 :	ffffffff8145036b:       mov    %rsp,%rbp
     0.00 :	ffffffff8145036e:       callq  ffffffff81456c40 <mcount>
     0.00 :	ffffffff81450373:       pushfq 
     0.00 :	ffffffff81450374:       pop    %rax
     0.00 :	ffffffff81450375:       cli    
     0.00 :	ffffffff81450376:       mov    $0x100,%edx
     0.00 :	ffffffff8145037b:       lock xadd %dx,(%rdi)
     0.00 :	ffffffff81450380:       mov    %dl,%cl
     0.00 :	ffffffff81450382:       shr    $0x8,%dx
    10.34 :	ffffffff81450386:       cmp    %dl,%cl
     0.00 :	ffffffff81450388:       je     ffffffff81450390 <_raw_spin_lock_irqsave+0x26>
    10.34 :	ffffffff8145038a:       pause  
    65.52 :	ffffffff8145038c:       mov    (%rdi),%cl
    13.79 :	ffffffff8145038e:       jmp    ffffffff81450386 <_raw_spin_lock_irqsave+0x1c>
     0.00 :	ffffffff81450390:       leaveq 
     0.00 :	ffffffff81450391:       retq   
 # perf annotate -k vmlinux -s _raw_spin_lock_irqsave -i perf-r076pp.data | cat
  Percent | Source code & Disassembly of vmlinux
 ------------------------------------------------
          :
          :
          :
          :	Disassembly of section .text:
          :
          :	ffffffff8145036a <_raw_spin_lock_irqsave>:
     0.00 :	ffffffff8145036a:       push   %rbp
     0.00 :	ffffffff8145036b:       mov    %rsp,%rbp
     0.00 :	ffffffff8145036e:       callq  ffffffff81456c40 <mcount>
     0.00 :	ffffffff81450373:       pushfq 
     0.00 :	ffffffff81450374:       pop    %rax
     0.00 :	ffffffff81450375:       cli    
     0.00 :	ffffffff81450376:       mov    $0x100,%edx
     0.00 :	ffffffff8145037b:       lock xadd %dx,(%rdi)
     2.78 :	ffffffff81450380:       mov    %dl,%cl
     0.00 :	ffffffff81450382:       shr    $0x8,%dx
     2.78 :	ffffffff81450386:       cmp    %dl,%cl
    11.11 :	ffffffff81450388:       je     ffffffff81450390 <_raw_spin_lock_irqsave+0x26>
    72.22 :	ffffffff8145038a:       pause  
     2.78 :	ffffffff8145038c:       mov    (%rdi),%cl
     8.33 :	ffffffff8145038e:       jmp    ffffffff81450386 <_raw_spin_lock_irqsave+0x1c>
     0.00 :	ffffffff81450390:       leaveq 
     0.00 :	ffffffff81450391:       retq   

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

