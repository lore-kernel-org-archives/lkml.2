Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1CAPH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:07:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:41905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab1CAPH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:07:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,247,1297065600"; 
   d="scan'208";a="714709362"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikEUPRjFT2a4dt7J7F7WwAXM7Dgk-wM_gLNMFKB@mail.gmail.com>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>
	 <AANLkTi=eUnZqT3MF7Y8ONrnGh-7MoZJsefisWFR10p7d@mail.gmail.com>
	 <1298969141.4937.94.camel@minggr.sh.intel.com>
	 <AANLkTinP9zdHEoq96nf-eBektNc6g9fPRmjoQHTK1jKY@mail.gmail.com>
	 <AANLkTikEUPRjFT2a4dt7J7F7WwAXM7Dgk-wM_gLNMFKB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 23:07:25 +0800
Message-Id: <1298992045.2170.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 17:39 +0800, Stephane Eranian wrote:
> On Tue, Mar 1, 2011 at 9:57 AM, Stephane Eranian <eranian@google.com> wrote:
> > On Tue, Mar 1, 2011 at 9:45 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> >> On Tue, 2011-03-01 at 15:43 +0800, Stephane Eranian wrote:
> >>> On Mon, Feb 28, 2011 at 10:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >>> > On Mon, 2011-02-28 at 15:22 +0800, Lin Ming wrote:
> >>> >> This patch adds basic SandyBridge support, including hardware cache
> >>> >> events and PEBS events support.
> >>> >>
> >>> >> LLC-* hareware cache events don't work for now, it depends on the
> >>> >> offcore patches.
> >>> >
> >>> > What's the status of those, Stephane reported some problems last I
> >>> > remember?
> >>> >
> >>> I tried the trick I mentioned and it seems to work.
> >>>
> >>> Something like below with hwc->extra_alloc.
> >>> Could probably find a better name for that field.
> >>
> >> Stephane,
> >>
> >> I'll integrate below changes to the offcore patches, OK?
> >>
> > Let me try one more test on this.
> > I want to show the case the caused the problem in the first place.
> >
> 
> There you go:
> 
> $ task -e offcore_response_0:DMND_DATA_RD:local_dram -e
> offcore_response_0:DMND_DATA_RD:local_dram noploop 1
> 
> Here the two instances of offcore_response are in two different event groups.
> I instrumented get/put percore constraint routines. get1 is where you do the
> first allocation, get2 is where you do ref++.
> 
> The scheduling algorithm will do:
>   - submit 1st group
>   - schedule 1st group
>   - submit 2nd group
>   - schedule 1st + 2nd group
> 
> Which results in the following trace:
> 
> [  109.855713] CPU0 get1 cfg=1301b7 ref=1
> [  109.855717] CPU0 get2 cfg=1301b7 ref=2
> [  109.855718] CPU0 get2 cfg=1301b7 ref=3 <-- this one is bogus
> [  109.856606] CPU0 put cfg=1301b7 ref=2
> [  109.856609] CPU0 put cfg=1301b7 ref=1  <- don't free the resource

Do you mean the issue is still there even with your extra_alloc patch
applied?

> 
> [  109.856616] CPU0 get2 cfg=1301b7 ref=2
> [  109.856619] CPU0 get2 cfg=1301b7 ref=3
> [  109.856622] CPU0 get2 cfg=1301b7 ref=4
> [  110.742151] CPU0 put cfg=1301b7 ref=3
> [  110.742154] CPU0 put cfg=1301b7 ref=2
> 
> [  110.742160] CPU0 get2 cfg=1301b7 ref=3
> [  110.742161] CPU0 get2 cfg=1301b7 ref=4
> [  110.742163] CPU0 get2 cfg=1301b7 ref=5
> [  110.854448] CPU0 put cfg=1301b7 ref=4
> [  110.854450] CPU0 put cfg=1301b7 ref=3


