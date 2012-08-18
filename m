Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2HROwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 10:52:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:38694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2HROww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 10:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="204407679"
Message-ID: <502FAC3F.1030803@linux.intel.com>
Date: Sat, 18 Aug 2012 07:52:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Chris Friesen <chris.friesen@genband.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com> <20120817184100.GA13369@srcf.ucam.org> <502E90F3.2000702@linux.intel.com> <20120817184705.GB13369@srcf.ucam.org> <502E9F45.6030606@genband.com> <20120817195033.GA15589@srcf.ucam.org> <502EA680.4080608@genband.com> <CAJRGBZygPfmRcVmMzDiCrf7uJVDb_6pHsrfthdERmUZnDfygWw@mail.gmail.com>
In-Reply-To: <CAJRGBZygPfmRcVmMzDiCrf7uJVDb_6pHsrfthdERmUZnDfygWw@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/2012 7:33 AM, Luming Yu wrote:
> saving mode. But obviously, we need to spread as much as possible
> across all cores in another socket(to race to idle). So from the
> example above, we see a threshold that we need to reference before
> selecting one from two complete different policy: spread or not
> spread... As long as there is hardware limitation, we could always
> need knob like that referenced threshold to adapt on different
> hardware in one kernel....

I think the physics are slightly simpler, if you abstract it one level.

every reasonable system out there has things that can be off if all cores are in the deep power state,
that have to be on if even one of them is alive. On "big core" Intel, that's uncore and memory controller,
on small core (atom/phone) Intel that is the chipset fabric only. On ARM it might be something else. On all of
them it's some clocks, PLLs, voltage regulators etc etc.

not all chips are advanced enough to aggressively these things off when they could, but most are nowadays.

so in abstract, there's a power offset that gets you from 0 to 1, Lets call this P0
there is also a power offset to go from 1 to 2, but that's smaller than 0->1. Lets call this Pc

or rather, 0->1 has the same kind of offset as 1->2 plus some extra offset.. so P0 = Pbase + Pc

there's also an energy cost for waking a cpu up (and letting it go back to sleep afterwards)... call it Ewake

so the abstract question is
you're running a task A on cpu 0
you want to also run a task B, which you estimate to run for time T

it's more energy efficient to wake a 2nd cpu if

Ewake < T * Pbase

(this assumes all cores are the same, you get a more complex formula if that's not the case, where T is even core specific)


there is no hardware policy *switch* in such formula, only parameters.
If Pbase = 0 (e.g. your hardware has no extra power savings), then the formula very naturally leads to one extreme of the behavior
if Ewake is very high, then it leads to the other extreme.

The only other variable is the user preference between power and performance balance.. but that's a pure preference, not hardware
specific anymore.




