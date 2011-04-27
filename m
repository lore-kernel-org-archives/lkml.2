Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1D0His (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:38:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43432 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab1D0Hip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:38:45 -0400
Date: Wed, 27 Apr 2011 09:38:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Cernekee <cernekee@gmail.com>, mingo@elte.hu,
        akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
        David.Woodhouse@intel.com, lethal@linux-sh.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Conny Seidel <conny.seidel@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
Message-ID: <20110427073839.GA16718@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Michael Bohan <mbohan@codeaurora.org>,
	Santosh Shilimkar <santosh.shilimkar@ti.com>,
	Kevin Cernekee <cernekee@gmail.com>, mingo@elte.hu,
	akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
	David.Woodhouse@intel.com, lethal@linux-sh.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Conny Seidel <conny.seidel@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <4DB604C7.8090305@codeaurora.org>
 <BANLkTimPHaiiiVC_A6jtUtaa_pYJuhepYg@mail.gmail.com>
 <4DB65EEC.7060604@ti.com>
 <4DB733D4.3000002@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DB733D4.3000002@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:06:28PM -0700, Michael Bohan wrote:
> On 4/25/2011 10:58 PM, Santosh Shilimkar wrote:
> >On 4/26/2011 5:48 AM, Kevin Cernekee wrote:
> >>On Mon, Apr 25, 2011 at 4:33 PM, Michael Bohan<mbohan@codeaurora.org>
> >>wrote:
> >>>I was curious if this scenario was accounted for in the design of the
> >>>console CPU notifier. One workaround for this problem is to remove
> >>>CPU_DEAD
> >>>from the possible actions in console_cpu_notify(). In fact, v1-v4 of the
> >>>patch above did not have CPU_DEAD, CPU_DYING or CPU_DOWN_FAILED in
> >>>the list
> >>>of actions. I wasn't able to track down why the other cases were
> >>>added in
> >>>the final patch.
> >>
> >>Here is the background information on the CPU_{DEAD,DYING,DOWN_FAILED}
> >>cases:
> >>
> >>http://lkml.org/lkml/2010/6/29/65
> >That's right.
> >May be the change log for commit '034260d67' would have been
> >bit more descriptive about the CPU hot-plug events.
> 
> Thanks for the clarification. Now regarding the problem, it seems
> like we can't be taking a semaphore in that path. That is to say, we
> can't be calling console_lock from within stop_machine. A few
> options that come to mind:
> 
> -Use console_trylock and accept the possibility that the output is
> not guaranteed to be synchronous with the hotplug operation.
> -Defer the console output emission (eg. workqueue) during hotplug.
> -Hybrid of the two: if the console_trylock fails, then we defer the
> console output emission.
> 
> Any opinions? I can submit a patch if one of these approaches is reasonable.

Great, whatever you guys come up with, we'd like to give it a run too.
We (AMD) hit the same issue in one of our tests but in our case we end
up in an endless loop of the state machine at stop_machine_cpu_stop()
since the core being offlined cannot ack the state transition to
STOPMACHINE_EXIT due to a similar reason.

One possible fix is dropping CPU_DYING from console_cpu_notify()
since it is called into by the offlining path in
kernel/cpu.c::take_cpu_down().

Thanks.

-- 
Regards/Gruss,
    Boris.
