Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966020Ab2FAXSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:18:05 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39207 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965987Ab2FAXSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:18:00 -0400
Message-ID: <4FC94D74.70208@linux.vnet.ibm.com>
Date: Sat, 02 Jun 2012 04:47:08 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sam@ravnborg.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        vapier@gentoo.org, konrad@gaisler.com, tkhai@yandex.ru,
        sparclinux@vger.kernel.org
Subject: Re: [UPDATED PATCH 21/27] sparc32, smpboot: Use generic SMP booting
 infrastructure
References: <20120601.135612.699120609738854050.davem@davemloft.net> <20120601185448.GA19148@merkur.ravnborg.org> <4FC94693.5050707@linux.vnet.ibm.com> <20120601.185341.1462375672682064314.davem@davemloft.net>
In-Reply-To: <20120601.185341.1462375672682064314.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060123-5564-0000-0000-0000030A28EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2012 04:23 AM, David Miller wrote:

> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Date: Sat, 02 Jun 2012 04:17:47 +0530
> 
>>
>> Convert sparc32 to use the generic framework to boot secondary CPUs.
>>
>> Notes:
>> While removing the call to cpu_idle(), we can also remove the call to
>> cpu_panic() because we are calling BUG() in the generic code anyway.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Almost there, but not quite yet.
> 
> You can't get rid of the cpu_panic invocations, those have to be there
> after the *_callin calls to catch if they accidently return.
> 


Oh.. ok..

So can I do something like the following, or do you want me to specifically
add call cpu_panic and nop after every *_callin?

diff --git a/arch/sparc/kernel/trampoline_32.S b/arch/sparc/kernel/trampoline_32.S
index 7364ddc..9b2b81d 100644
--- a/arch/sparc/kernel/trampoline_32.S
+++ b/arch/sparc/kernel/trampoline_32.S
@@ -82,15 +82,12 @@ cpu3_startup:
        call    smp4m_callin
         nop
 
-       b,a     smp_do_cpu_idle
+       b,a     do_panic
 
        .text
        .align  4
 
-smp_do_cpu_idle:
-       call    cpu_idle
-        mov    0, %o0
-
+do_panic:
        call    cpu_panic
         nop
 
@@ -147,7 +144,7 @@ sun4d_cpu_startup:
        call    smp4d_callin
         nop
 
-       b,a     smp_do_cpu_idle
+       b,a     do_panic
 
 #ifdef CONFIG_SPARC_LEON
 
@@ -206,6 +203,6 @@ leon_smp_cpu_startup:
        call    leon_callin
         nop
 
-       b,a     smp_do_cpu_idle
+       b,a     do_panic

