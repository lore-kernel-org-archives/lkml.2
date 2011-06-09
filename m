Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1FIM6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:58:20 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:29841
	"EHLO CH1EHSOBE018.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757364Ab1FIM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:58:19 -0400
X-SpamScore: -18
X-BigFish: VPS-18(z21eNz1432N98dK4015Lzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMIXC7-02-3O9-02
X-M-MSG: 
Date: Thu, 9 Jun 2011 14:57:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: John Lumby <johnlumby@hotmail.com>
CC: Maynard Johnson <maynardj@us.ibm.com>,
        oprofile list <oprofile-list@lists.sourceforge.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile, x86: Fix nmi-unsafe callgraph support in,
 2.6.27 and later
Message-ID: <20110609125742.GP20052@erda.amd.com>
References: <COL116-W380DF5357514E3CC28BB66A38F0@phx.gbl>
 <4DD5046F.3000807@us.ibm.com>
 <4DD53BC8.2010208@hotmail.com>
 <20110607105259.GE20052@erda.amd.com>
 <4DEE2F09.6090803@hotmail.com>
 <20110607171822.GI20052@erda.amd.com>
 <4DEFB4DC.7030206@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DEFB4DC.7030206@hotmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.06.11 13:43:56, John Lumby wrote:
> I am also a bit confused by the kernel's statement that it's a NULL 
> pointer deref.     I had previously found that the pointer contains 
> 0x0000000a,  not NULL.   Does the kernel call it NULL for any invalid 
> value?   Or am I misunderstanding it.    Anyway ...

0x0000000a is also considered a NULL pointer access, typically this
happens if a member of a struct which points to NULL is accessed.

> 
> Have you or anyone tried this on an intel x86?     I'm just curious 
> whether it's everyone or only me.

>From your other mail:

"EIP is at print_context_stack=0x45/0xb0

and from a machine-code listing, I found that that offset corresponds 
to the line

       addr = *stack;

in arch/x86/kernel/dumpstack.c"

Actually this should not happen, because of checking the stack pointer
in valid_stack_ptr(). So could you apply the change below and test if
this throws a bug message?

Thanks,

-Robert


diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index e2a3f06..37693f5 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -73,6 +73,8 @@ static inline int valid_stack_ptr(struct thread_info *tinfo,
                        void *p, unsigned int size, void *end)
 {
        void *t = tinfo;
+
+       BUG_ON(p < (void *)THREAD_SIZE);
        if (end) {
                if (p < end && p >= (end-THREAD_SIZE))
                        return 1;


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

