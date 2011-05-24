Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1EXVEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:04:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37383 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab1EXVEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:04:32 -0400
Date: Tue, 24 May 2011 23:04:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110524210417.GA21660@eferding.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
	Ingo Molnar <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
 <20110524173326.GA7635@gere.osrc.amd.com>
 <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:56:26AM -0700, Tony Luck wrote:
> > Maybe something like
> >
> > set_current_state(TASK_UNINTERRUPTIBLE);
> >
> > finish work in NMI context
> >
> > do remaining work in process context like sending appropriate signals
> > etc; finally:
> >
> > set_task_state(tsk, TASK_RUNNING)
> 
> That looks pretty easy - are their any weird side effects that I should
> be worried about?  My perf/event can't really include the "task" pointer
> (that sounds way too internal) - but I can provide the process id, so
> the "RAS daemon" that sees this event can look up the task to do that
> final set_task_state(tsk, TASK_RUNNING).

Actually, I was thinking more in the direction of doing this in a kernel
thread or workqueue without going back to the RAS daemon. Then you would
only need to save the task_struct ptr.

> Does this work in the threaded case? In the case where the task was in
> kernel context (but in a CONFIG_PREEMT=y kernel at some point
> where preemption is allowed)?

Well, IIUC and depending on the error, if it is severe enough, you would
want to run the remaining work right after the NMI handler finishes
without going to userspace.

Hmm..

-- 
Regards/Gruss,
Boris.
