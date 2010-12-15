Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0LORxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:53:36 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:45851 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751226Ab0LORxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:53:35 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: HAC8Q_sVM1nXKGqbfS.QtdQO76DNjqnNsZUFe9GGq9AKsN5
 HVnsYxbHvJLclWjl5k2E5LHx.Gq5KhUH1U78rxsh4WB2hcmUJkuqhX9TIWH8
 8EFszRtlTpaE17BBqqifv4_rY_zGfbXgl8CJHbkISP7vD4G0oxZQQWDStLK_
 VT31KDDt3J1VTC4WDzTm1Znuw5ItA0b.h5C1UpW8_cApssDDe6C3.LVjuJYV
 s5NFosan5n6IFAv9Fe0QkQwXdAklAmJXJTzEZZHsThMnz4GSfcsoHKs8Xy9b
 Uj4f2zFsYNS_E7NWRrAMbYIdtvkHbgYA_jO28WWfq.kCw_8I-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 11:53:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
In-Reply-To: <4D08FC9A.8040702@zytor.com>
Message-ID: <alpine.DEB.2.00.1012151149560.14964@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com> <4D081225.8000007@zytor.com> <alpine.DEB.2.00.1012151011550.12186@router.home> <alpine.DEB.2.00.1012151020030.12470@router.home>
 <4D08FC9A.8040702@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, H. Peter Anvin wrote:

> >  cmpxchg16b_cpuops_emu:
> >  	pushf
> >  	cli
> >
>
> Could we rename it this_cpu_cmpxchg16b_emu or something like that?

Ok. New fixup patch:



Subject: x86, percpu: Rename cmpxchg16b_cpuops_emu to this_cpu_cmpxchg16b_emu

Rename the function to make clear what it is used for. Also add some comments
to explain the nature of the atomicness.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |    2 +-
 arch/x86/lib/cmpxchg16b_emu.S |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/lib/cmpxchg16b_emu.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/cmpxchg16b_emu.S	2010-12-15 10:57:21.000000000 -0600
+++ linux-2.6/arch/x86/lib/cmpxchg16b_emu.S	2010-12-15 11:47:50.000000000 -0600
@@ -23,14 +23,18 @@
  * %rcx : high 64 bits of new value
  * %al  : Operation successful
  */
-ENTRY(cmpxchg16b_cpuops_emu)
+ENTRY(this_cpu_cmpxchg16b_emu)
 CFI_STARTPROC

 #
 # Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
 # al not via the ZF. Caller will access al to get result.
 #
-cmpxchg16b_cpuops_emu:
+# Note that this is only useful for a cpuops operation. Meaning that we
+# do *not* have a fully atomic operation but just an operation that is
+# *atomic* on a single cpu (as provided by the this_cpu_xx class of macros)
+#
+this_cpu_cmpxchg16b_emu:
 	pushf
 	cli

@@ -53,6 +57,6 @@ cmpxchg16b_cpuops_emu:

 CFI_ENDPROC

-ENDPROC(cmpxchg16b_cpuops)
+ENDPROC(this_cpu_cmpxchg16b_emu)


Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-15 11:48:09.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-15 11:48:26.000000000 -0600
@@ -520,7 +520,7 @@ do {									\
 	typeof(o2) __o2 = o2;						\
 	typeof(o2) __n2 = n2;						\
 	typeof(o2) __dummy;						\
-	alternative_io("call cmpxchg16b_cpuops_emu\n\t" P6_NOP4,		\
+	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,		\
 			"cmpxchg16b %%gs:(%%rsi)\n\tsetz %0\n\t",	\
 			X86_FEATURE_CX16,				\
 		    	ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),	\
