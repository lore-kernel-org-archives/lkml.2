Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab0KLNAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:00:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab0KLNAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tErYRsrg01eh/P08VNtwAI4OoLNhxxc3s2omkBksO5i7T6Dm15iR9qdTmuQO+hoPac
         umPHK1+BN4IlIp1Ct+4Q==
MIME-Version: 1.0
In-Reply-To: <1289561817.2084.240.camel@laptop>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<1289492117-18066-2-git-send-email-andi@firstfloor.org>
	<4CDC2DDD.50508@linux.vnet.ibm.com>
	<4CDC3845.4030104@linux.intel.com>
	<4CDC4628.8020109@linux.vnet.ibm.com>
	<20101111194936.GJ18718@basil.fritz.box>
	<1289505587.2084.193.camel@laptop>
	<20101111201259.GL18718@basil.fritz.box>
	<1289507858.2084.195.camel@laptop>
	<20101112102748.GA8020@basil.fritz.box>
	<AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com>
	<1289561817.2084.240.camel@laptop>
Date: Fri, 12 Nov 2010 14:00:43 +0100
Message-ID: <AANLkTinjzZnv8dzfKPzgGtRnk5C-XsAt=gyf_4G0+gf8@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
        paulus <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 12:36 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2010-11-12 at 11:49 +0100, Stephane Eranian wrote:
>> The difficulty with PEBS-LL (load latency) is not so much the encoding of the
>> latency. It is more how to expose the data back to user. You get a full PEBS
>> record for each miss. So you get the PEBS machine state + data addr, miss
>> latency, and data source (where did the line come from). We have already
>> discussed how to expose machine state in general. I'll work on a patch for this.
>
> Frederic was working on this PERF_SAMPLE_REGS stuff as well for his copy
> the stack top and let dwarfs go wild at it patches.
>
Ok, I'll talk to him again about this then.

>> So we can get the general PEBS machine state out. However, the question is
>> how do we expose data addr, latency, data source? We can reuse the
>> SAMPLE_ADDR for the data address. Sample IP would point to the load
>> instruction (with help from LBR to correct the off by one issue). For
>> the latency
>
> Right, PERF_SAMPLE_IP and PERF_SAMPLE_ADDR
>
>> and data source, I proposed using pseudo regs and leveraging the sampled machine
>> state mechanism. An alternative may be to define a new record type that would b
>> generic enough to be reusable, for instance { instr_addr, data_addr,
>> latency, data_src, flags; }.
>
> I'm not sure I like the idea of pseudo regs.. I'm afraid it'll get messy
> quite quickly. Load-latency is a bit like IBS that way, terribly messy.
>

I don't understand what aspect you think is messy. When you are sampling
cache misses, you expect to get the tuple (instr addr, data addr, latency,
data source). That is what you get with AMD IBS, Nehalem PEBS-LL and
also Itanium D-EAR. I am sure IBM Power has something similar as well.
To collect this, you can either store the info in registers (AMD, Itanium)
or in a buffer (PEBS). But regardless of that you will always have to expose
the tuple. We have a solution for two out of 4 fields that reuses the existing
infrastructure. We need something else for the other two.

We should expect that in the future PMUs will collect more than code addresses.
