Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1FMMk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:40:26 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49632 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1FMMkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:40:24 -0400
Date: Mon, 13 Jun 2011 14:40:03 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Message-ID: <20110613124003.GA27918@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
 <4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
 <20110612223840.GA23218@aftab>
 <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
 <4DF5C36A.1040707@redhat.com>
 <20110613095521.GA26316@aftab>
 <4DF5F729.4060609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF5F729.4060609@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:40:25AM -0400, Avi Kivity wrote:
> On 06/13/2011 12:55 PM, Borislav Petkov wrote:
> > >
> > >  If running into the MCE again is really bad, then you need something
> > >  more, since other threads (or other processes) could run into the same
> > >  page as well.
> >
> > Well, the #MC handler runs on all CPUs on Intel so what we could do is
> > set the current task to TASK_STOPPED or _UNINTERRUPTIBLE or something
> > that doesn't make it viable for scheduling anymore.
> >
> > Then we can take our time running the notifier since the "problematic"
> > task won't get scheduled until we're done. Then, when we finish
> > analyzing the MCE, we either kill it so it has to handle SIGKILL the
> > next time it gets scheduled or we unmap its page with error in it so
> > that it #PFs on the next run.
> 
> If all cpus catch it, do we even know which task it is?

Well, in the ActionRequired case, the error is obviously reported
through a #MC exception meaning that the core definitely generates the
MCE before we've made a context switch (CR3 change etc) so in that case
'current' will point to the task at fault.

The problem is finding which 'current' it is, from all the tasks running
on all cores when the #MC is raised. Tony, can you tell from the hw
which core actually caused the MCE? Is it the monarch, so to speak?

> On the other hand, it makes user return notifiers attractive, since
> they are per-cpu, and combined with MCE broadcast that turns them into
> a global event.

Yes, I think that having a global event makes error handling much safer.
It also gives you the proper amount of conservative optimism that you've
actually handled the error properly before returning to userspace.

I'm thinking that in cases were we have a page shared by multiple
processes, we still would want to run a 'main' user return notifier on
one core which does the rmap lookup _but_, _also_ very importantly, the
other cores still hold off from executing userspace until that main
notifier hasn't finished finding out how big the fallout is,i.e. how
many other processes would run into the same page.

> > But no, I don't think we can catch all possible situations where a page
> > is mapped by multiple tasks ...
> >
> > >  If not, do we care?  Let it hit the MCE again, as long as
> > >  we'll catch it eventually.
> >
> > ... and in that case we are going to have to let it hit again. Or is
> > there a way to get to the tasklist of all the tasks mapping a page in
> > atomic context, stop them from scheduling and run the notifier work in
> > process context?
> >
> > Hmmm..
> 
> Surely not in atomic context, but you can use rmap to find all mappers 
> of a given page.
> 
> So: MCE uses irq_work_queue() -> wake up a realtime task -> process the 
> mce, unmap the page, go back to sleep.

Yes, this is basically it. However, the other cores cannot schedule a
task which maps the compromized page until we haven't finished finding
and 'fixing' all the mappers.

So we either hold off the cores from executing userspace - in that
case no need to mark a task as unsuitable to run - or use the task
return notifiers in patch 10/10.

HOWEVER, AFAICT, if the page is mapped multiple times,
killing/recovering the current task doesn't help from another core
touching it and causing a follow-up MCE. So holding off all the cores
from scheduling userspace in some manner might be the superior solution.
Especially if you don't execute the #MC handler on all CPUs as is the
case on AMD.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
