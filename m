Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1IUQZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:25:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab1IUQZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:25:41 -0400
Message-ID: <4E7A0FD6.3080508@redhat.com>
Date: Wed, 21 Sep 2011 19:24:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Robert Richter <robert.richter@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-5-git-send-email-dzickus@redhat.com> <20110921100842.GA6063@erda.amd.com> <20110921140432.GP5795@redhat.com> <20110921151829.GC6063@erda.amd.com> <20110921161352.GU5795@redhat.com>
In-Reply-To: <20110921161352.GU5795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 07:13 PM, Don Zickus wrote:
> On Wed, Sep 21, 2011 at 05:18:30PM +0200, Robert Richter wrote:
> >  On 21.09.11 10:04:32, Don Zickus wrote:
> >  >  On Wed, Sep 21, 2011 at 12:08:42PM +0200, Robert Richter wrote:
> >  >  >  On 20.09.11 10:43:10, Don Zickus wrote:
> >  >  >  >  @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> >  >  >  >
> >  >  >  >   		handled += a->handler(type, regs);
> >  >  >  >
> >  >  >  >  +		/*
> >  >  >  >  + 		 * Optimization: only loop once if this is not a
> >  >  >  >  + 		 * back-to-back NMI.  The idea is nothing is dropped
> >  >  >  >  + 		 * on the first NMI, only on the second of a back-to-back
> >  >  >  >  + 		 * NMI.  No need to waste cycles going through all the
> >  >  >  >  + 		 * handlers.
> >  >  >  >  + 		 */
> >  >  >  >  +		if (!b2b&&  handled)
> >  >  >  >  +			break;
> >  >  >
> >  >  >  In rare cases we will lose nmis here.
> >  >  >
> >  >  >  We see a back-to-back nmi in the case if a 2 nmi source triggers
> >  >  >  *after* the nmi handler is entered. Depending on the internal cpu
> >  >  >  timing influenced by microcode and SMM code execution, the nmi may not
> >  >  >  entered immediately. So all sources that trigger *before* the nmi
> >  >  >  handler is entered raise only one nmi with no subsequent nmi.
> >  >
> >  >  Right, but that can only happen with the second NMI in the back-to-back
> >  >  NMI case.  Here the optimization is only for the first NMI, with the
> >  >  assumption that you will always have a second NMI if multiple sources
> >  >  trigger, so you can process those in the second iteration (assuming we
> >  >  correctly detect the back-to-back NMI condition).  Then when the second
> >  >  NMI comes in, we have no idea how many we dropped to get here so we
> >  >  process all the handlers based on the assumption we might not have another
> >  >  NMI behind us to make up for the dropped NMIs.
> >  >
> >  >  Unless I misunderstood your point above?
> >
> >  No, my point was that a second NMI might not be latched even if there
> >  are two nmi sources pending.
> >
> >  Your logic is correct but assumes you will always receive a second
> >  nmi. This is not always the case depending on the cpu's internal
> >  timing. Usually there is the following sequence for back-to-back nmis:
> >
> >  1. HW triggers first NMI, an NMI is pending.
> >  2. NMI handler is called, no NMI pending anymore.
> >  3. HW triggers a second NMI, an NMI is pending.
> >  4. Return from NMI handler.
> >  5. NMI handler is called again to serve the 2nd, no NMI pending anymore.
> >  6. Return from NMI handler.
> >
> >  The above is what your algorithm covers.
> >
> >  But in rare cases there is the following:
> >
> >  1. The cpu executes some microcode or SMM code.
> >  2. HW triggers the first NMI, an NMI is pending.
> >  3. HW triggers a second NMI, the NMI is still pending.
> >  4. The cpu finished microcode or SMM code.
> >  5. NMI handler is called, no NMI pending anymore.
> >  6. Return from NMI handler.
> >
> >  In this case the handler is called only once and the second nmi
> >  remains unhandled with you implementation.
> >
> >  I don't see a way how this could be catched without serving all
> >  handlers the first time. But as said, in favor of the optimization I
> >  think we can live with losing some NMIs.
>
> Ah, I get it know.  Crap.  Well I think Avi was pushing it to make those
> ticket_spin_locks work in virt land.  It seems like we should lean towards
> removing the optimization.  Avi?
>

Well, in virt land there are no SMIs, and we can guarantee that the 
queue length is always two.  So if these rare cases are okay for 
upstream, it'll be fine for virt.

-- 
error compiling committee.c: too many arguments to function

