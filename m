Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0DUQdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:33:41 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48677
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755804Ab0DUQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:33:39 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432P98dN936eM1442J62a3Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L18J2Q-02-DPA-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 18:28:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
Message-ID: <20100421162804.GC6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271317461.32749.67.camel@laptop>
 <20100415151633.GN11907@erda.amd.com>
 <1271851865.4807.10284.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271851865.4807.10284.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 16:28:04.0791 (UTC) FILETIME=[9E5BB470:01CAE16F]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.04.10 14:11:05, Peter Zijlstra wrote:
> On Thu, 2010-04-15 at 17:16 +0200, Robert Richter wrote:
> > On 15.04.10 09:44:21, Peter Zijlstra wrote:
> > > On Tue, 2010-04-13 at 22:23 +0200, Robert Richter wrote:
> > > > This patch series introduces model specific events and impments AMD
> > > > IBS (Instruction Based Sampling) for perf_events.
> > > 
> > > I would much rather it uses the ->precise thing PEBS also uses,
> > > otherwise we keep growing funny arch extensions and end up with a
> > > totally fragmented trainwreck of an ABI.
> > 
> > I agree that an exiting flag could be reused. But the naming 'precise'
> > could be misleading. Maybe we rename it to 'model_spec' or something
> > else that underlines the idea of having model specific setups.
> 
> Right, so I really hate PERF_SAMPLE_RAW, and I'm considering simply
> removing that for PEBS as well, its just too ugly. If we want the
> register set we need to work on getting PERF_SAMPLE_REGS in a sensible
> shape.

The ABI should provide hw access to all pmu features. As it is not
possible to abstract these features for all models and architectures
in the same way and a new feature may work completely different, the
only solution I see is to provide a way to write to pmu registers and
receive sampling data unfiltered back. For IBS for example the data in
a sample does not fit into existing generic events. Making IBS generic
also does not help much, since it will not be available on different
models or architectures. Introducing event types that will never
reused do not need to be generalized, it is better to generalize the
way how to handle this kind of events. This is the reason I like the
model_spec/raw_config/raw_sample approach.

> As to the meaning for ->precise, its meant to convey the counters are
> not affected by skid and the like, I thought IBS provided exact IPs as
> well (/me should re-read the IBS docs).

Yes, the real rip is in the sample, but there is much more data than
that. So the rip is only a subset.

> The thing with something like ->model_spec and PERF_SAMPLE_RAW is that
> it doesn't provide a clear model, the user doesn't know what to expect
> of it, it could be anything.
> 
> We want the ABI to express clear concepts, and things like lets bypass
> everything and just dump stuff out to userspace really are to be avoided
> at all costs.

Of course, it could be anything. But this is not the intention. If
configs and buffers or close or exactly as the hw i/f, then it is
spec'ed and well defined. The user only have to know how to configure
a certain hw feature of a special model and how to get data back. This
is how IBS is implemented. Maybe this is the same that you have in
mind with PERF_SAMPLE_REG? This interface can then be reused for a
very different feature and this looks to me like a clear solution. I
do not see alternatives. And even if we process the samples in the
kernel somehow, in the end we pack it and send it to userspace.

> Sadly IBS seems to be an utter trainwreck in the concept department (I'm
> still struggling how to make a sensible interpretation of the data it
> gathers).

That's the point, there is no generalization of this type of data, but
still it is useful.

-Robert

> 
> The thing I absolutely want to avoid is the ABI becoming a fragmented
> trainwreck like oprofile is.
> 
> Also not using sample_period for the sample period is of course utterly
> unacceptable.
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

