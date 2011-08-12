Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1HLTny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:43:54 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2080 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751180Ab1HLTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:43:53 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz936eK179dN1432N98dKzz1202hzz5eeeM8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPTYSW-02-5IO-02
X-M-MSG: 
Date: Fri, 12 Aug 2011 21:43:44 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20110812194344.GJ11702@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311959236.5890.420.camel@twins>
 <20110801052128.GW4590@erda.amd.com>
 <1312284595.1147.96.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1312284595.1147.96.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.11 07:29:55, Peter Zijlstra wrote:
> On Mon, 2011-08-01 at 07:21 +0200, Robert Richter wrote:
> 
> > IBS is supposed to be architectural spec'ed, meaning there are no
> > family checks. IBS features are detected using cpuid.
> > 
> > So the version of the raw sampling data format could be specified with
> > the u32 capability variable. I could put the caps value to the raw
> > sample data too right after the size field. An additional advantage
> > would be that 64 bit values are memory alligned then.
> 
> Seems like a good filler :-)
> 
> > The Branch Target Address register that has been added to newer cpus
> > could simply be extended to the raw data sample, the data would still
> > be backward compatible. Userland can detect it existence from the
> > sample size or (better) from the ibs caps.
> 
> Caps would be better.

Will take caps here.

While thinking about this I realized we have to encode the pmu type
actually in the sample, because there could be one sampling file with
multiple samples from different pmus. So attr.type must be encoded and
additionaly also its mapping to the name for dynamically added pmus.
Hmm?

Somthing like this content:

 perf.data header (once): "ibs_op" -> type = 7
 perf.data sample (each): type = 7

Maybe we use the reserved field of PERF_SAMPLE_CPU for it?

> 
> > Though it is treated architectural, it isn't in the AMD64 Architecture
> > Programmer's Manual (APM). The 10h BKDG is a good source, but extended
> > IBS features are described in the family 12h bkdg (same as for 15h)
> > and the capabilities are in the cpuid spec:
> > 
> >  http://support.amd.com/us/Processor_TechDocs/41131.pdf
> >  http://support.amd.com/us/Processor_TechDocs/25481.pdf 
> 
> Right, so comparing Fam10 to Fam12,
> 
> + IbsOpCtl.19:58
> + IbsOpData.38
> - IbsOpData2.4:5

Yeah, good catch. This is due to the different northbridge
implementations. I will ask the hw guys how to handle this.

> + IbsOpData3.19

This is already in Fam10h RefC. There is also no caps bit, but should
be always clear on systems without 1G pages.

-Robert

> + IbsBrTarget
> 
> Curious that they removed a few bits, those don't seem to be enumerated
> in the IBS capability field either.
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

