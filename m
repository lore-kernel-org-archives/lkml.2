Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1JDJNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:13:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40989 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1JDJNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:13:18 -0400
Date: Tue, 4 Oct 2011 02:13:14 -0700
From: Tejun Heo <htejun@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20111004091314.GF15637@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
 <20110929192818.GB10425@mtj.dyndns.org>
 <20111003152126.GM18195@e102109-lin.cambridge.arm.com>
 <20111004075915.GE15637@dhcp-172-17-108-109.mtv.corp.google.com>
 <20111004090446.GA10071@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004090446.GA10071@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 04, 2011 at 10:04:46AM +0100, Catalin Marinas wrote:
> > The percpu part looks fine to me but I don't know how kmemleak works
> > to judge whether the kmemleak part is okay or not.  This just avoids
> > false positives from slab and would still require bumping up the early
> > log memory as # of cpus increases, right?
> 
> No, there is only one kmemleak call for each __percpu pointer (to the
> specific kmemleak_*_percpu function). The kmemleak expands the percpu
> pointer into corresponding blocks for each cpu but the early log only
> stores a single call.

Hmmm... but the following definitely seems O(#PCPU_ALLOCS * #CPUS)?
What am I missing?

+/*
+ * Log an early allocated block and populate the stack trace.
+ */
+static void early_alloc_percpu(struct early_log *log)
+{
+       unsigned int cpu;
+       const void __percpu *ptr = log->ptr;
+
+       for_each_possible_cpu(cpu) {
+               log->ptr = per_cpu_ptr(ptr, cpu);
+               early_alloc(log);
+       }
+}

Thanks.

-- 
tejun
