Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761085Ab2ILSTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:19:09 -0400
Received: from [205.233.59.134] ([205.233.59.134]:55685 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760995Ab2ILSTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:19:06 -0400
Message-ID: <1347473860.15764.78.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 12 Sep 2012 20:17:40 +0200
In-Reply-To: <CABPqkBSJu05YztcL435FH_rpcwWAi8czC9uUdiq3M0AjJ+_5Mg@mail.gmail.com>
References: <1347466967.15764.63.camel@twins>
	 <CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
	 <1347471446.15764.67.camel@twins> <1347471911.15764.72.camel@twins>
	 <CABPqkBSJu05YztcL435FH_rpcwWAi8czC9uUdiq3M0AjJ+_5Mg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 20:00 +0200, Stephane Eranian wrote:
> On Wed, Sep 12, 2012 at 7:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2012-09-12 at 19:37 +0200, Peter Zijlstra wrote:
> >> Ah, so I do think EIO will re-enable LBR,
> >
> > OK, it does not, but the:
> >
> >>  also the handler is wrapped in
> >> x86_pmu::{dis,en}able_all() which does end up calling
> >> intel_pmu_lbr_{dis,en}able_all().
> >
> > Thing does the re-enable for us,
> >
> 
> >>  However that leaves the MSR in the
> >> exact same state on exit as it was on enter, so that's not a problem for
> >> the: read-modify-write change.
> >
> > in a safe way.
> Well, I think it does even when we have to stop events (x86_pmu_stop)
> because the buffer is full. Looks like we always re-enable lbr.

How so, without the proposed patch, the intel_pmu_disable_event() can do
intel_pmu_lbr_disable() which decrements cpuc->lbr_users, so the final
intel_pmu_enable_all()->intel_pmu_lbr_enable_all() will be a NOP,
leaving LBR disabled, where we entered the NMI with LBR enabled.

>  So looks like the handler is a wash for debugctl.

As for BTS, it looks like we don't throttle the thing at all, so we
shouldn't ever get to the asymmetric thing, right?
