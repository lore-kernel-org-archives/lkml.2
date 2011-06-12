Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1FLKae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 06:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab1FLKad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 06:30:33 -0400
Message-ID: <4DF4952F.5030808@redhat.com>
Date: Sun, 12 Jun 2011 13:30:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with user_return_notifier
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com> <4DF478F5.6090507@redhat.com> <20110612102443.GA19060@aftab>
In-Reply-To: <20110612102443.GA19060@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 01:24 PM, Borislav Petkov wrote:
> On Sun, Jun 12, 2011 at 04:29:41AM -0400, Avi Kivity wrote:
> >  On 06/10/2011 12:35 AM, Luck, Tony wrote:
> >  >  From: Tony Luck<tony.luck@intel.com>
> >  >
> >  >  Ingo wrote:
> >  >  >   We already have a generic facility to do such things at
> >  >  >   return-to-userspace: _TIF_USER_RETURN_NOTIFY.
> >  >
> >  >  This just a proof of concept patch ... before this can become
> >  >  real the user-return-notifier code would have to be made NMI
> >  >  safe (currently it uses hlist_add_head/hlist_del, which would
> >  >  need to be changed to Ying's NMI-safe single threaded lists).
> >
> >  You could use irq_work_queue() to push this into an irq context, which
> >  is user-return-notifier safe.
>
> Maybe I'm missing something but it looks like irq_work_queue() queues
> work which is run in irq_work_run() with IRQs disabled. However, user
> return notifiers are run after IRQs get enabled in entry_64.S. And we
> want to run memory_failure() with IRQs enabled.
>
> More importantly, we want to be able to do the following:
>
> * run #MC handler which queues work
>
> * when returning to userspace, preempt and schedule that previously
> queued work _before_ the process that caused the MCE gets to execute.

Yes.

> Imagine this scenario:
>
> Your userspace process causes a data cache read error due to either
> alpha particles or maybe because the DRAM device containing the process
> page is faulty and generates ECC errors which the ECC code cannot
> correct, i.e. an uncorrectable error we definitely want to handle; IOW
> Action Required MCE.
>
> Now, if you get lucky and this page is mapped only by the process that
> caused the MCE, you could unmap it, mark it PageReserved and cause the
> process to refault. But in order to do that, you want to execute the
> memory_failure() handler _before_ you schedule the process again.
>
> In the instruction cache read error case, you don't have processor
> context to return to (or you're being too conservative and don't want to
> risk it) so you kill the process, which is pretty easy to do.
>
> Does that make a bit more sense? Tony?
>

You're missing the flow.  The MCE handler calls irq_work_queue(), which 
schedules a user return notifier, which does any needed processing in 
task context.


-- 
error compiling committee.c: too many arguments to function

