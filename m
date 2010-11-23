Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0KWKRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:17:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0KWKRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QqdjEzy2RqbK8e0W6Fyysp0Ghd6EA3xi7CXgDWGNa3sSP4FQen7GFJm5O7ooI5g9TR
         PCHoZXEyJtd+upx6y0kg==
MIME-Version: 1.0
In-Reply-To: <1290340877.2245.124.camel@localhost>
References: <1290340877.2245.124.camel@localhost>
Date: Tue, 23 Nov 2010 11:17:09 +0100
Message-ID: <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin,

On Sun, Nov 21, 2010 at 1:01 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> +static void uncore_pmu_enable_all(void)
> +{
> +       u64 ctrl;
> +
> +       /*
> +        * (0xFULL << 48): 1 of the 4 cores can receive NMI each time
> +        * but we don't know which core will receive the NMI when overflow happens
> +        */

That does not sound right. If you set bit 48-51 to 1, then all 4 cores
will receive EVERY
interrupt, i.e., it's a broadcast. That seems to contradict your
comment: 1 of the 4. Unless
you meant, they all get the interrupt and one will handle it, the
other will find nothing to
process. But I don't see the atomic op that would make this true in
uncore_handle_irq().

I also think that if you want all processors to receive the
interrupts, then the mask should
be 0xff when HT is on. The manual is rather obscure on this, but it
does make sense.


> +       ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | (0xFULL << 48);
> +       ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
> +
> +       /*
> +        * Freeze the uncore pmu on overflow of any uncore counter.
> +        * This makes unocre NMI handling easier.
> +        */
> +       ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_FRZ;
> +
> +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
> +}
> +
