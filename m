Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0ETPtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:49:08 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:40634 "EHLO
	mail79-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752326Ab0ETPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:49:05 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432P98dN936eM1442J62a3Lzz1202hzzz32i2a8h43h63h)
X-Spam-TCS-SCL: 2:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L2Q6LC-02-CNJ-02
X-M-MSG: 
Date: Thu, 20 May 2010 17:48:51 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520154851.GS21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
 <20100520135819.GP21799@erda.amd.com>
 <AANLkTilSrJLHOpC0IkoMbiWxnCXHSgQhBUsSkm3fs6HG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTilSrJLHOpC0IkoMbiWxnCXHSgQhBUsSkm3fs6HG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 10:14:46, Stephane Eranian wrote:

> > We have some bits in the msrs that are reserved now, for perfctr and
> > also for ibs. We could start reusing it to mark a special sample type
> > and so on. So far, ok. Somewhen in the future there is a hw extensions
> > and these bits are not reserved anymore, what now?
> >
> You will always have the sampling period bits. Those will always be
> handled by attr->sample_period. And they correspond to the lower
> bits which are also used to encode the event select on regular counters.
> So you could identify IBS with special event selects in the lower 8 bits
> for instance.
> 
> IBS is a very model specific feature, as such the method you use to
> encode it may change.

> In my new proposal, I am not using reserved bits, I am using bits which
> are stored elsewhere in the attr structure.

Ok, maybe technically it is possible for ibs and perfctrs. You are
moving the sample count from the raw config out to sample_count
attribute, then the type is written to the new free space in the raw
config. In the kernel you do all of this in reverse order. This makes
programming events really difficult and confusing. I don't see an
advantage compared to the use of a raw_type.

> There is no guarantee your scheme will help there either. Nobody knows
> the interface to those new features. It may be that you will need more than
> 64 bits.

Right, for more than 64 bit the need another extension.

> What I am missing with raw_type is how it plays out with attr->type which
> already has RAW? Seems like you have a second level of raw.

"raw_type" is only valid together with (attr->type == PERF_TYPE_RAW).
Currently it is null (bp_type is unused and zeroed). So (raw_type ==
0) will leave everything as it is and uses the archtectures default
raw config. If we set raw_type to a value other than zero, we have a
special configuration for a special pmu feature. It looks sane to me.

> Well, I don't think you want to define an attribute for each and every
> bit of info returned by IBS. I think you need to return the IBSDATA regs
> as is and let the user pick and choose. Of course, the information can
> change, but IBS is model specific, it returns something richer than just
> a count.

I think, we all agree the ibs sample should be send back to userland
also as raw sample.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

