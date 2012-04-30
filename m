Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2D3Kyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 06:54:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39651 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2D3Kyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 06:54:49 -0400
Date: Mon, 30 Apr 2012 12:54:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Message-ID: <20120430105440.GC9303@aftab.osrc.amd.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
 <1335603099-2624-3-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335603099-2624-3-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 04:51:38PM +0800, Alex Shi wrote:
> x86 has no flush_tlb_range support in instruction level. Currently the
> flush_tlb_range just implemented by flushing all page table. That is not
> the best solution for all scenarios. In fact, if we just use 'invlpg' to
> flush few lines from TLB, we can get the performance gain from later
> remain TLB lines accessing.
> 
> But the 'invlpg' instruction costs much of time. Its execution time can
> compete with cr3 rewriting, and even a bit more on SNB CPU.
> 
> So, on a 512 4KB TLB entries CPU, the balance points is at:
> 512 * 100ns(assumed TLB refill cost) =
> x(TLB flush entries) * 140ns(assumed invlpg cost)
> 
> Here, x is about 360, that is about 5/8 of 512 entries.
> 
> But with the mysterious CPU pre-fetcher and page miss handler Unit, the
> assumed TLB refill cost is far lower then 100ns in sequential access. And
> 2 HT siblings in one core makes the memory access more faster if they are
> accessing the same memory. So, in the patch, I just do the change when
> the target entries is less than 1/16 of whole active tlb entries.
> Actually, I have no data support for the percentage '1/16', so any
> suggestions are welcomed.

You could find the proper value empirically here by replacing the
FLUSHALL_BAR thing with a variable and exporting it through procfs or
sysfs or whatever, only for testing purposes, and letting mprotect.c
set it to a different value each time. Then run a bunch of times with
different thread counts and invalidation entries count and see which
combination performs best.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
