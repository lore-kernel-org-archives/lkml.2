Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1DQIot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 04:44:49 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:29922
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab1DQIon convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 04:44:43 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK9371O1432N98dKef8Kzz1202hzz8275bhz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJSGA9-02-DCR-02
X-M-MSG: 
Date: Sun, 17 Apr 2011 10:44:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
Message-ID: <20110417084432.GM31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <BANLkTikg5mJNDTqNMRz3AtjfnAa6mLdtHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <BANLkTikg5mJNDTqNMRz3AtjfnAa6mLdtHw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.04.11 11:52:54, Stephane Eranian wrote:
> On Fri, Apr 15, 2011 at 5:27 PM, Robert Richter <robert.richter@amd.com> wrote:

> >        event code      counter         failure         possible solution
> >
> > 1)      0x043           PMC[2:0]        0               1
> >        0x02E           PMC[3,0]        3               0
> >        0x003           PMC3            FAIL            3
> >
> I am not sure I understand this failure case. If I recall
> the scheduler looks at the weight of each event first:
> 
>                                             weight
> 1)      0x043           PMC[2:0]  3
>         0x02E           PMC[3,0]   2
>         0x003           PMC3        1
> 
> Then, it schedules in increasing weight order. So it will
> schedule weight 1, 2, 3. For weight 1, it will find counter3,
> for weight 2, it will take counter0, for  weight 3, it will
> take counter 1 given 0 is already used.
> 
> Or am I reading your example the wrong way?

No, I have to admit this one was taken out of my mind and I picked
a wrong example for the special problem I was thinking about. The
above works as you described because of the constraint's weights.

I don't have an example with existing constraints, but consider the
following (theoretical) one:

counter: 3210		Failure:	Solution:

e1	   xx		  xo		  ox
e2	  xx 		 xo		 ox
e3	 x x 		o x		o x
e4	 x  x		x  F		x  o

The special with the above is that two events (e1 and e2) must be
rescheduled to schedule e4. This means that swapping counters of only
one already scheduled event is not sufficient. A counter of a third
event must be freed, this counter is then taken by the second event.

> The fact that counter have overlapping constraints
> should not matter. In fact this is what happens with
> counters without constraints.

An event set containing constraints with following conditions is
problematic:

 (c1->weight <= c2->weight && (c1->cmask & c2->cmask != c1->cmask))

Basically this means both constraints do not overlap completly. You
can't select then the correct counter without knowing the events with
higher weights that will be scheduled later.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

