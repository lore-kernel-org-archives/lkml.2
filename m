Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1FNCuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:50:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44796 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1FNCua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:50:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF6CC58.8050601@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 11:50:00 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab>	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>	<4DF63B7A.1030805@redhat.com> <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
In-Reply-To: <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/14 2:13), Tony Luck wrote:
> On Mon, Jun 13, 2011 at 9:31 AM, Avi Kivity <avi@redhat.com> wrote:
>> I don't think a user_return_notifier is needed here.  You don't just want to
>> do things before a userspace return, you also want to do them soon.  A user
>> return notifier might take a very long time to run, if a context switch
>> occurs to a thread that spends a lot of time in the kernel (perhaps a
>> realtime thread).
>>
>> So I think the best choice here is MCE -> irq_work -> realtime kernel thread
>> (or work queue)
> 
> In the AO (action optional case (e.g. patrol scrubber) - there isn't much rush.
> We'd like to process things "soon" (before someone hits the corrupt location)
> but we don't need to take extraordinary efforts to make "soon" happen.
> 
> In the AR (action required - instruction or data fetch from a corrupted
> memory location) our main priority is making sure that we don't continue
> the task that hit the error - because we don't want to hit it again (as Boris
> said, on Intel cpus this is very disruptive to the system as every cpu is
> sent the machine check signal - and the code has to read a large number
> of slow "msr" registers to figure out what happened. If we can guarantee
> that we won't run this task - then the time pressure is greatly reduced.
> 
> So if we can do:
> 
>   MCE -> irq_work -> make-task-not-runnable -> thread-or-work-queue
> 
> in a reliable way, then that would meet the needs.  PeterZ didn't like the
> idea of setting TASK_STOPPED or _UNINTERRUPTIBLE in NMI
> context in the MC handler - but I think he was okay with it inside the
> irq_work handler.
> 
> -Tony

I've made small patches to clear things. Could you take a look?

These are based on my cleanup patch set:
https://lkml.org/lkml/2011/6/7/677

Thanks,
H.Seto

 arch/x86/kernel/cpu/mcheck/mce.c |   52 ++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 24 deletions(-)

Hidetoshi Seto (2):
      x86, mce: introduce mce_memory_failure_process
      x86, mce: rework use of TIF_MCE_NOTIFY


