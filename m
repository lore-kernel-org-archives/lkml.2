Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893Ab2ILRhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:37:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:57235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760594Ab2ILRhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:37:35 -0400
Message-ID: <1347471446.15764.67.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 12 Sep 2012 19:37:26 +0200
In-Reply-To: <CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
References: <1347466967.15764.63.camel@twins>
	 <CABPqkBQsJr_Cp36Df-etOaHhGh8T6XVngraDQt52ZtKahr6KBQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 18:42 +0200, Stephane Eranian wrote:
> We use FREEZE_LBR_ON_PMI to sync LBR data with counter overflows.
> That means, LBR is already frozen by the time we get to the handler. But
> that means we need to re-enable LBR when we leave the handler. I don't
> think EOI is going to magically re-enable it. So we need to touch DEBUGCTL
> in the irq handler. 

Ah, so I do think EIO will re-enable LBR, also the handler is wrapped in
x86_pmu::{dis,en}able_all() which does end up calling
intel_pmu_lbr_{dis,en}able_all(). However that leaves the MSR in the
exact same state on exit as it was on enter, so that's not a problem for
the: read-modify-write change.

Its just that the x86_pmu::disable() for the throttle could leave the
MSR in a different state on exit than it entered with. This patch avoids
that.
