Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1FLKZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 06:25:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45647 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1FLKZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 06:25:03 -0400
Date: Sun, 12 Jun 2011 12:24:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with
 user_return_notifier
Message-ID: <20110612102443.GA19060@aftab>
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
 <4DF478F5.6090507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF478F5.6090507@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 04:29:41AM -0400, Avi Kivity wrote:
> On 06/10/2011 12:35 AM, Luck, Tony wrote:
> > From: Tony Luck<tony.luck@intel.com>
> >
> > Ingo wrote:
> > >  We already have a generic facility to do such things at
> > >  return-to-userspace: _TIF_USER_RETURN_NOTIFY.
> >
> > This just a proof of concept patch ... before this can become
> > real the user-return-notifier code would have to be made NMI
> > safe (currently it uses hlist_add_head/hlist_del, which would
> > need to be changed to Ying's NMI-safe single threaded lists).
> 
> You could use irq_work_queue() to push this into an irq context, which 
> is user-return-notifier safe.

Maybe I'm missing something but it looks like irq_work_queue() queues
work which is run in irq_work_run() with IRQs disabled. However, user
return notifiers are run after IRQs get enabled in entry_64.S. And we
want to run memory_failure() with IRQs enabled.

More importantly, we want to be able to do the following:

* run #MC handler which queues work

* when returning to userspace, preempt and schedule that previously
queued work _before_ the process that caused the MCE gets to execute.

Imagine this scenario:

Your userspace process causes a data cache read error due to either
alpha particles or maybe because the DRAM device containing the process
page is faulty and generates ECC errors which the ECC code cannot
correct, i.e. an uncorrectable error we definitely want to handle; IOW
Action Required MCE.

Now, if you get lucky and this page is mapped only by the process that
caused the MCE, you could unmap it, mark it PageReserved and cause the
process to refault. But in order to do that, you want to execute the
memory_failure() handler _before_ you schedule the process again.

In the instruction cache read error case, you don't have processor
context to return to (or you're being too conservative and don't want to
risk it) so you kill the process, which is pretty easy to do.

Does that make a bit more sense? Tony?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
