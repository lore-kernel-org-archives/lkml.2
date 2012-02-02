Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2BBGNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 01:13:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48379 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2BBGNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 01:13:05 -0500
Message-ID: <4F2A296E.5080007@linaro.org>
Date: Thu, 02 Feb 2012 10:13:02 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Module/kthread/printk question/problem
References: <4F2963AA.3010306@linaro.org>  <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4F2969B7.4040202@linaro.org> <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 09:16 PM, Eric Dumazet wrote:

>> I realize this, but there was a second part of the question: what's the
>> better way to ensure that all test/X threads are really gone at some point of
>> testmod_exit()?
>>
>
> You could use kthread_stop()
>
> This way you can control all your kernel threads really exited before
> module cleanup.

Hm... if I try something like:

static void __exit testmod_exit(void)
{
	int i;

	wait_for_completion(&done);
	for (i = 0; i < nrthreads; i++)
		kthread_stop(threads[i]);
	kfree(threads);
}

typical result is:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = bf25c000
[00000000] *pgd=bf266831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT SMP
Modules linked in: testmod(O-)
CPU: 1    Tainted: G           O  (3.3.0-rc2 #3)
PC is at exit_creds+0x14/0xb4
LR is at __put_task_struct+0x64/0xac
pc : [<8004ed3c>]    lr : [<8002d254>]    psr: 20070113
sp : bd871f10  ip : 00000000  fp : 00000000
r10: 00000000  r9 : bd870000  r8 : 8000db48
r7 : 00000081  r6 : 00000000  r5 : 00000000  r4 : bfa734c0
r3 : 00000000  r2 : bd871f20  r1 : 00000460  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: bf25c04a  DAC: 00000015
Process rmmod (pid: 1330, stack limit = 0xbd8702f8)
Stack: (0xbd871f10 to 0xbd872000)
1f00:                                     bd86f500 bfa734c0 bfa734c8 8002d254
1f20: bfa734c0 800492ac 00000001 7f0003b8 7f000228 7f000110 7f000268 00000000
1f40: 7e87f6d8 80073d48 7f000268 00000880 bd871f54 00000000 74736574 00646f6d
1f60: 00000000 76f01000 bf223280 8000db48 bd870000 00000000 bd871f8c 802c05d8
1f80: bf223300 bf2232d8 00000000 800adefc 00f01400 271aee1c 00000880 7e87f6d8
1fa0: 000120a8 8000d980 00000880 7e87f6d8 7e87f6d8 00000880 00009778 7e87f6cc
1fc0: 00000880 7e87f6d8 000120a8 00000081 7e87f88c 000120bc 76f06000 00000000
1fe0: 76e8e590 7e87f6d4 00008f5d 76e8e59c 800f0110 7e87f6d8 0daa7fca 8afaa89a
[<8004ed3c>] (exit_creds+0x14/0xb4) from [<8002d254>] (__put_task_struct+0x64/0xac)
[<8002d254>] (__put_task_struct+0x64/0xac) from [<800492ac>] (kthread_stop+0x74/0x7c)
[<800492ac>] (kthread_stop+0x74/0x7c) from [<7f000110>] (testmod_exit+0x2c/0x54 [testmod])
[<7f000110>] (testmod_exit+0x2c/0x54 [testmod]) from [<80073d48>] (sys_delete_module+0x1b8/0x26c)
[<80073d48>] (sys_delete_module+0x1b8/0x26c) from [<8000d980>] (ret_fast_syscall+0x0/0x30)
Code: e1a04000 e59032ec e3a05000 e59002e8 (e5933000)

I suppose that __put_task_struct() was called for the thread when is 'partially dead'
(because it's somewhere in do_exit() called by kthread() after returning from thread's
function), but not 'dead enough' to finalize it with free_task().

So, the question is still open.

Dmitry
