Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2DEMct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:32:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43553 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2DEMcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:32:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F7D8F16.9090904@redhat.com>
References: <CA+1xoqeqyFT0eHS2k+vskPFQ-5gJ_Uq1HVsq2DA2sS1uN9C0vw@mail.gmail.com>
 <4F7D8F16.9090904@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 5 Apr 2012 14:32:27 +0200
Message-ID: <CA+1xoqeeagx=OwV2XFQYb=ATOGtW0Zpyx6BOcVbu3hg+eiMqSA@mail.gmail.com>
Subject: Re: CPU softlockup due to smp_call_function()
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 2:24 PM, Avi Kivity <avi@redhat.com> wrote:
> On 04/04/2012 11:12 PM, Sasha Levin wrote:
>> Hi all,
>>
>> I've starting seeing soft lockups resulting from smp_call_function()
>> calls. I've attached two different backtraces of this happening with
>> different code paths.
>>
>> This is running inside a KVM guest with the trinity fuzzer, using
>> today's linux-next kernel.
>>
>> [ 6540.134009] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:1:38]
>> [ 6540.134048] irq event stamp: 286811770
>> [ 6540.134048] hardirqs last  enabled at (286811769):
>> [<ffffffff82669e74>] restore_args+0x0/0x30
>> [ 6540.134048] hardirqs last disabled at (286811770):
>> [<ffffffff8266b3ea>] apic_timer_interrupt+0x6a/0x80
>> [ 6540.134048] softirqs last  enabled at (286811768):
>> [<ffffffff810b746e>] __do_softirq+0x16e/0x190
>> [ 6540.134048] softirqs last disabled at (286811749):
>> [<ffffffff8266bdec>] call_softirq+0x1c/0x30
>> [ 6540.134048] CPU 0
>> [ 6540.134048] Pid: 38, comm: kworker/u:1 Tainted: G        W
>> 3.4.0-rc1-next-20120404-sasha-dirty #72
>> [ 6540.134048] RIP: 0010:[<ffffffff8111f30e>]  [<ffffffff8111f30e>]
>> smp_call_function_many+0x27e/0x2a0
>>
>
> This cpu is waiting for some other cpu to process a function (likely
> rps_trigger_softirq(), from the trace).  Can you get a backtrace on all
> cpus when this happens?
>
> It would be good to enhance smp_call_function_*() to do this
> automatically when it happens - it's spinning there anyway, so it might
> as well count the iterations and NMI the lagging cpu if it waits for too
> long.

What do you think about modifying the softlockup detector to NMI all
CPUs if it's going to panic because it detected a lockup?
