Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0ETJYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:24:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0ETJYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:24:05 -0400
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the 
 type of a raw sample
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
	 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 11:23:33 +0200
Message-ID: <1274347413.5605.13636.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 10:10 +0200, Stephane Eranian wrote:
> I still don't understand why you need all of this to encode IBS.
> I still believe that with attr.config there is plenty of bits to choose
> from. I do understand the need for PERF_SAMPLE_RAW. I think
> there is no other way.
> 
> You simply need to pick an encoding to mark the config as IBS. You
> need two bits for this: 00 regular counters, 01 IBS Fetch, 10 IBS op.
> Regular counters use 43 bits, IBS fetch uses 58, IBS op uses 52.
> So you could use bits 62-63 for instance. You don't need to encode
> the sampling period in attr.config for either IBS. You can use
> attr.sample_period, so you free up 16 bits.
> 
> I understand that IBS may evolve and thus may use more bits. But
> you still have at least 16 bits of margin.
> 
> Users and tools would rely on an library to provide the event encoding.
> No need to come up with some raw hex number on the cmdline. 

No need for any of that afaict, how about:

For Instruction-Fetch:

  0:15 sample-period (r/w)
 16:31 cnt           (r/w)
 32:47 latency       (r/w)
    48 enable        (r/w)
    49 valid         (r/w)
 50:56               (ro)
    57 randomized    (r/w)


For Instruction-Execution:

  0:15 sample-period (r/w)
    17 enable        (r/w)
    18 valid         (r/w)

So if we add perf_event_attr::latency (can also be used for
PEBS-load-latency, can Sparc/PowerPC/ARM/SH use this too?), we can
encode these IBS things as:

  0x87 Instruction Fetch Stall -- Ins-Fetch 
  0xC0 Retired Instructions    -- Ins-Exec
  
When we set perf_event_attr::precise > 0

The Ins-Exec will have to re-construct the actual event->count by adding
sample-period on each interrupt, as it seems we lack an actual counter
in hardware.

Furthermore, these counters will have to deal with sample-period > 2^16
by 'ignoring' interrupts until we get ->period_left down to 0.

The extra data could possibly be exposed through attaching non-sampling
group events and using SAMPLE_READ, like L1-misses, although
reconstructing the count from just one bit seems 'interesting'. 

The IbsFetchLinAd/IbsOpRip would go straight into PERF_SAMPLE_IP by
replacing pt_regs->ip I guess.

IbsDcLinAd goes into PERF_SAMPLE_ADDR

