Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab1FMJzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:55:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52245 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1FMJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:55:41 -0400
Date: Mon, 13 Jun 2011 11:55:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Message-ID: <20110613095521.GA26316@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
 <4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
 <20110612223840.GA23218@aftab>
 <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
 <4DF5C36A.1040707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF5C36A.1040707@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 03:59:38AM -0400, Avi Kivity wrote:
> On 06/13/2011 08:31 AM, Tony Luck wrote:
> > On Sun, Jun 12, 2011 at 3:38 PM, Borislav Petkov<bp@amd64.org>  wrote:
> > >  On Thu, Jun 09, 2011 at 05:36:42PM -0400, Luck, Tony wrote:
> > >>  From: Tony Luck<tony.luck@intel.com>
> > >>
> > >>  Existing user return notifier mechanism is designed to catch a specific
> > >>  cpu just as it returns to run any task in user mode.  We also need a
> > >>  mechanism to catch a specific task.
> > >
> > >  Why do we need that? I mean, in the remaining patches we end up either
> > >  running memory_failure() or sending signals to a task. Can't we do it
> > >  all in the user return notifier and not have a different notifier for
> > >  each policy?
> >
> > Unless I'm mis-reading the user-return-notifier code, it is possible that
> > we'll context switch before we get to the notifier. At that point the
> > user-return-notifier TIF bit is passed on from our task to the newly
> > run-able task. But our task is still viable, so another cpu could grab
> > it and start running it ... then we have a race ... will the new task
> > that inherited the notifier unmap the page fast enough, or will there
> > be a loud BANG as the original task runs right into the machine
> > check again.
> 
> Right.  user-return-notifiers are really a per-cpu notifier, unrelated 
> to any specific task.  The use of per-task flags was an optimization.
> 
> If running into the MCE again is really bad, then you need something 
> more, since other threads (or other processes) could run into the same 
> page as well.

Well, the #MC handler runs on all CPUs on Intel so what we could do is
set the current task to TASK_STOPPED or _UNINTERRUPTIBLE or something
that doesn't make it viable for scheduling anymore.

Then we can take our time running the notifier since the "problematic"
task won't get scheduled until we're done. Then, when we finish
analyzing the MCE, we either kill it so it has to handle SIGKILL the
next time it gets scheduled or we unmap its page with error in it so
that it #PFs on the next run.

But no, I don't think we can catch all possible situations where a page
is mapped by multiple tasks ...

> If not, do we care?  Let it hit the MCE again, as long as 
> we'll catch it eventually.

... and in that case we are going to have to let it hit again. Or is
there a way to get to the tasklist of all the tasks mapping a page in
atomic context, stop them from scheduling and run the notifier work in
process context?

Hmmm..

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
