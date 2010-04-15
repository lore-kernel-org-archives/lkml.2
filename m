Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab0DOVpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:45:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40735 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab0DOVpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oHuTNLOqiTba56ef+Z/KHm/MAsIJeWJDO3UHWo2vnhzR3+FpWrWfffv5oEDmvtpNoi
         qV0N7rfnIkh7Fu5dZcSV72Ye6emf9Nejo8EnU3SK1ycPc/wA7DL5ch05976+LLgeH61M
         6d97bliK6CtWAYKG9WSVPxsl88Ze+WCMmdKP4=
MIME-Version: 1.0
In-Reply-To: <20100415210357.GG5069@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
Date: Thu, 15 Apr 2010 14:45:02 -0700
X-Google-Sender-Auth: 8051f9227757ea7d
Message-ID: <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Chase Douglas <chase.douglas@canonical.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 2:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Apr 14, 2010 at 12:20:16PM -0400, Chase Douglas wrote:
>> This change adds a tracing_off_event() call to stop tracing on schedule
>> bugs unless tracing_off=none was specified on the commandline.
>>
>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> ---
>>  kernel/sched.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 6af210a..439f036 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -3590,6 +3590,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
>>  {
>>       struct pt_regs *regs = get_irq_regs();
>>
>> +     tracing_off_event(TRACE_EVENT_BUG);
>> +
>>       printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
>>               prev->comm, prev->pid, preempt_count());
>
>
>
> I would rather call that a TRACE_EVENT_WARN as this is what happens: we
> warn but we continue.

I tend to think of the TRACE_EVENT_* as an indication of severity and
whether we want to stop the trace by default. From a distro
standpoint, the likelihood that we want to continue tracing after a
__schedule_bug is pretty low. It's easiest if we don't have to tell
our users to add a kernel command line, especially since grub in
Ubuntu 10.04 LTS is difficult to interact with for end users.

Now I'm not much of an upstream developer (at least not yet), so if it
makes much more sense to continue by default from a development
standpoint, then perhaps it's better to make it continue by default. I
just think that the frequency of hitting this should be low enough
that it won't trip people up. And when it does, maybe that gives more
incentive to fix the schedule bug :).

-- Chase
