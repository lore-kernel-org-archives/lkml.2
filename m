Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab1FNLlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab1FNLlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:41:19 -0400
Message-ID: <4DF748C2.10009@redhat.com>
Date: Tue, 14 Jun 2011 14:40:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab>	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>	<4DF63B7A.1030805@redhat.com> <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
In-Reply-To: <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 08:13 PM, Tony Luck wrote:
> On Mon, Jun 13, 2011 at 9:31 AM, Avi Kivity<avi@redhat.com>  wrote:
> >  I don't think a user_return_notifier is needed here.  You don't just want to
> >  do things before a userspace return, you also want to do them soon.  A user
> >  return notifier might take a very long time to run, if a context switch
> >  occurs to a thread that spends a lot of time in the kernel (perhaps a
> >  realtime thread).
> >
> >  So I think the best choice here is MCE ->  irq_work ->  realtime kernel thread
> >  (or work queue)
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

Aren't these events extraordinarily rare?  I think we can afford a 
little inefficiency there.

Even with mce -> irq_work -> rt thread, we're unlikely to return to the 
task as the rt thread will displace the task.  It may be migrated to an 
idle cpu, but even then we may be able to drop the page before it gets 
back to userspace.

> So if we can do:
>
>    MCE ->  irq_work ->  make-task-not-runnable ->  thread-or-work-queue
>
> in a reliable way, then that would meet the needs.  PeterZ didn't like the
> idea of setting TASK_STOPPED or _UNINTERRUPTIBLE in NMI
> context in the MC handler - but I think he was okay with it inside the
> irq_work handler.

How about signalling it with a kernel-internal signal?

I don't think that doing anything to the task is correct, though, as the 
problem is with the page, not the task itself.  In fact if the task is 
executing a vgather instruction, or if another thread munmap()s the 
page, it may not hit the same page again when re-executed.

-- 
error compiling committee.c: too many arguments to function

