Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0FNDrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 23:47:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33708 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0FNDrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 23:47:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C15A5D1.1040104@jp.fujitsu.com>
Date: Mon, 14 Jun 2010 12:45:21 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com> <20100612102558.GA4000@elte.hu>
In-Reply-To: <20100612102558.GA4000@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/12 19:25), Ingo Molnar wrote:
> 
> * Huang Ying <ying.huang@intel.com> wrote:
> 
>> NMI can be triggered even when IRQ is masked. So it is not safe for NMI 
>> handler to call some functions. One solution is to delay the call via self 
>> interrupt, so that the delayed call can be done once the interrupt is 
>> enabled again. This has been implemented in MCE and perf event. This patch 
>> provides a unified version and make it easier for other NMI semantic handler 
>> to take use of the delayed call.
> 
> Instead of introducing this extra intermediate facility please use the same 
> approach the unified NMI watchdog is using (see latest -tip): a perf event 
> callback gives all the extra functionality needed.
> 
> The MCE code needs to be updated to use that - and then it will be integrated 
> into the events framework.

Hi Ingo,

I think this "NMI delayed call mechanism" could be a part of "the events
framework" that we are planning to get in kernel soon.  At least APEI will
use NMI to report some hardware events (likely error) to kernel.  So I
suppose we will go to have a delayed call as an event handler for APEI.

Generally speaking "event" can occur independently of the situation.
NMI can tell us some of external events, expecting urgent reaction for
the event, but we cannot do everything in NMI context.  Or we might have
a sudden urge to generate an internal event while interrupts are disabled.

I agree that generating a self interrupt is reasonable solution.
Note that it could be said that both of "MCE handled (=event log should
be delivered to userland asap)" and "perf events pending (=pending events
should be handled asap)" are kind of internal event that requires urgent
handling in non-NMI kernel context.  One question here is why we should
have different vectors for these events that uses same mechanism.

How about calling the vector LOCAL_EVENT_VECTOR or so?
I guess there should be better name if it is possible to inject an event
to other cpus via IPI with this vector...


Thanks,
H.Seto


