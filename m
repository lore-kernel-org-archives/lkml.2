Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1GHRfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:35:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50869 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab1GHRfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:35:01 -0400
Date: Fri, 8 Jul 2011 18:34:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: "mingo@redhat.com" <mingo@redhat.com>,
        "dengcheng.zhu@gmail.com" <dengcheng.zhu@gmail.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "anton@samba.org" <anton@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "emunson@mgebm.net" <emunson@mgebm.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcree@orcon.net.nz" <mcree@orcon.net.nz>,
        "mingo@elte.hu" <mingo@elte.hu>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf: Remove the nmi parameter from the
 swevent and overflow interface
Message-ID: <20110708173442.GB31972@e102144-lin.cambridge.arm.com>
References: <tip-agjev8eu666tvknpb3iaj0fg@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-agjev8eu666tvknpb3iaj0fg@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Jul 01, 2011 at 04:21:25PM +0100, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  a8b0ca17b80e92faab46ee7179ba9e99ccb61233
> Gitweb:     http://git.kernel.org/tip/a8b0ca17b80e92faab46ee7179ba9e99ccb61233
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 27 Jun 2011 14:41:57 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 1 Jul 2011 11:06:35 +0200
> 
> perf: Remove the nmi parameter from the swevent and overflow interface
> 
> The nmi parameter indicated if we could do wakeups from the current
> context, if not, we would set some state and self-IPI and let the
> resulting interrupt do the wakeup.
> 
> For the various event classes:
> 
>   - hardware: nmi=0; PMI is in fact an NMI or we run irq_work_run from
>     the PMI-tail (ARM etc.)
>   - tracepoint: nmi=0; since tracepoint could be from NMI context.
>   - software: nmi=[0,1]; some, like the schedule thing cannot
>     perform wakeups, and hence need 0.
> 
> As one can see, there is very little nmi=1 usage, and the down-side of
> not using it is that on some platforms some software events can have a
> jiffy delay in wakeup (when arch_irq_work_raise isn't implemented).
> 
> The up-side however is that we can remove the nmi parameter and save a
> bunch of conditionals in fast paths.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Whilst you updated the arch code in this series, you forgot to update the
oprofile perf backend. I think you want something as simple as:


diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index 59acf9e..94796f3 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -31,7 +31,7 @@ static int num_counters;
 /*
  * Overflow callback for oprofile.
  */
-static void op_overflow_handler(struct perf_event *event, int unused,
+static void op_overflow_handler(struct perf_event *event,
                        struct perf_sample_data *data, struct pt_regs *regs)
 {
        int id;


although I haven't tried it.

Cheers,

Will
