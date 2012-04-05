Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2DEI0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:26:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43530 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DEI0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <smp-call-function-lockup-1@mdm.bga.com>
References: <CA+1xoqeqyFT0eHS2k+vskPFQ-5gJ_Uq1HVsq2DA2sS1uN9C0vw@mail.gmail.com>
 <smp-call-function-lockup-1@mdm.bga.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 5 Apr 2012 10:25:39 +0200
Message-ID: <CA+1xoqcg3of9QSJRcvtr7TvzuS+7_4oFQNd0WS1MYYgc-Fu2Gg@mail.gmail.com>
Subject: Re: CPU softlockup due to smp_call_function()
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 6:06 AM, Milton Miller <miltonm@bga.com> wrote:
>
> On Wed, 4 Apr 2012 about 22:12:36 +0200, Sasha Levin wrote:
>> I've starting seeing soft lockups resulting from smp_call_function()
>> calls. I've attached two different backtraces of this happening with
>> different code paths.
>>
>> This is running inside a KVM guest with the trinity fuzzer, using
>> today's linux-next kernel.
>
> Hi Sasha.
>
> You have two different call sites (arch/x86/mm/pageattr.c
> cpa_flush_range and net/core/dev.c netdev_run_todo), and both use
> call on_each_cpu with wait=1.
>
> I tried a few options but can't get close enough to your compiled
> length of 2a0 to know if the code is spinning on the first
> csd_lock_wait in csd_lock or in the second csd_lock_wait after the
> call to arch_send_call_function_ipi_mask (aka smp_ops + 0x44 in my
> x86_64 compile).  Please check your disassembly and report.

Hi Milton,

# addr2line -i -e /usr/src/linux/vmlinux ffffffff8111f30e
/usr/src/linux/kernel/smp.c:102
/usr/src/linux/kernel/smp.c:554

So It's the 2nd lock.

I'll work on adding the debug code mentioned in your mail.
