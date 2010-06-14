Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0FNNyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 09:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab0FNNyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 09:54:37 -0400
Date: Mon, 14 Jun 2010 09:54:03 -0400
From: Don Zickus <dzickus@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100614135403.GH4894@redhat.com>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C15A5D1.1040104@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:45:21PM +0900, Hidetoshi Seto wrote:
> (2010/06/12 19:25), Ingo Molnar wrote:
> > 
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> >> NMI can be triggered even when IRQ is masked. So it is not safe for NMI 
> >> handler to call some functions. One solution is to delay the call via self 
> >> interrupt, so that the delayed call can be done once the interrupt is 
> >> enabled again. This has been implemented in MCE and perf event. This patch 
> >> provides a unified version and make it easier for other NMI semantic handler 
> >> to take use of the delayed call.
> > 
> > Instead of introducing this extra intermediate facility please use the same 
> > approach the unified NMI watchdog is using (see latest -tip): a perf event 
> > callback gives all the extra functionality needed.
> > 
> > The MCE code needs to be updated to use that - and then it will be integrated 
> > into the events framework.
> 
> Hi Ingo,
> 
> I think this "NMI delayed call mechanism" could be a part of "the events
> framework" that we are planning to get in kernel soon.  At least APEI will
> use NMI to report some hardware events (likely error) to kernel.  So I
> suppose we will go to have a delayed call as an event handler for APEI.
> 
> Generally speaking "event" can occur independently of the situation.
> NMI can tell us some of external events, expecting urgent reaction for
> the event, but we cannot do everything in NMI context.  Or we might have
> a sudden urge to generate an internal event while interrupts are disabled.
> 
> I agree that generating a self interrupt is reasonable solution.
> Note that it could be said that both of "MCE handled (=event log should
> be delivered to userland asap)" and "perf events pending (=pending events
> should be handled asap)" are kind of internal event that requires urgent
> handling in non-NMI kernel context.  One question here is why we should
> have different vectors for these events that uses same mechanism.

I think the perf event subsytem can log events in NMI context already and
deliver them to userspace when the NMI is done.  This is why I think Ingo
wants MCE to be updated to sit on top of the perf event subsytem to avoid
re-invent everything again.

Then again I do not know enough about the MCE stuff to understand what you
mean when an event comes in but you can't handle it in an NMI-safe
context.  An example would be helpful.

Cheers,
Don
