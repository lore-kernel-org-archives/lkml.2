Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1KOFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 00:47:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45148 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1KOFrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 00:47:36 -0500
X-AuditID: b753bd60-981cbba000006f66-db-4ec1fcf5d9b1
X-AuditID: b753bd60-981cbba000006f66-db-4ec1fcf5d9b1
Message-ID: <4EC1FCED.5040908@hitachi.com>
Date: Tue, 15 Nov 2011 14:47:25 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 1/5] x86: add user_mode_vm check in stack_overflow_check
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp> <20111107055235.7928.85338.stgit@ltc219.sdl.hitachi.co.jp> <20111110195203.GA22646@phenom.dumpdata.com>
In-Reply-To: <20111110195203.GA22646@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/11 4:52), Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 07, 2011 at 02:52:35PM +0900, Mitsuo Hayasaka wrote:
>> The kernel stack overflow is checked in stack_overflow_check(),
>> which may wrongly detect the overflow if the stack pointer
>> pointed to the kernel stack accidentally.
> 
> I think you mean to say 'points'.

Yes. Thank you for your correction.

> 
> How do we accidently point the stack pointer to the kernel stack?

I guess it may happen due to a kind of stack overflow, although
I've not succeeded to `accidentally' point the stack pointer to
the kernel stack yet...

At least, we can intentionally cause the overflow message, using the
following program in user space although the overflow does not occur.

=============================================
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	unsigned long long dummyRSP;

	printf("PID:%d\n", getpid());
	printf("Input dummyRSP address: ");
	scanf("%Lx", &dummyRSP);
	printf("DummyRSP address is %Lx\n", dummyRSP);
	puts("Replace RSP with dummyRSP...");
	__asm__ ("movq %0,%%rsp": : "r" (dummyRSP));
	while(1) ;
}
=============================================

We need to give this program a dummy RSP address that must point to
an overflow address in kernel stack and can be gotten using tools such
as crash. These steps are summarized as follows.

(1) Execute this program and get the pid.
(2) Execute crash and put "task <pid>"
(3) Get the address indicated by stack field of task_struct
(4) Input the address to this program

The big problem is that user space program can directly control the
stack overflow checking in kernel space, regardless of intentional or
accidental operation. In other words, the kernel stack overflow is
never detected after execution of this program.

So, I would like to fix this problem.

> 
>>
>> This patch adds user-mode-vm checking before it to avoid this
>> misdetection and bails out early if the user stack is used.
>>
>> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> ---
>>
>>  arch/x86/kernel/irq_64.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
>> index acf8fbf..69bca46 100644
>> --- a/arch/x86/kernel/irq_64.c
>> +++ b/arch/x86/kernel/irq_64.c
>> @@ -38,6 +38,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
>>  #ifdef CONFIG_DEBUG_STACKOVERFLOW
>>  	u64 curbase = (u64)task_stack_page(current);
>>  
>> +	if (user_mode_vm(regs))
>> +		return;
>> +
>>  	WARN_ONCE(regs->sp >= curbase &&
>>  		  regs->sp <= curbase + THREAD_SIZE &&
>>  		  regs->sp <  curbase + sizeof(struct thread_info) +
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

