Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2JRHCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:02:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40393 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab2JRHCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:02:11 -0400
Date: Thu, 18 Oct 2012 12:33:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes: Use brw_mutex to fix register/unregister
 vs dup_mmap() race
Message-ID: <20121018070325.GJ11096@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121015190958.GA4799@redhat.com>
 <20121015191022.GA4823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121015191022.GA4823@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101807-1976-0000-0000-000012763196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This was always racy, but 268720903f87e0b84b161626c4447b81671b5d18
> "uprobes: Rework register_for_each_vma() to make it O(n)" should be
> blamed anyway, it made everything worse and I didn't notice.
> 
> register/unregister call build_map_info() and then do install/remove
> breakpoint for every mm which mmaps inode/offset. This can obviously
> race with fork()->dup_mmap() in between and we can miss the child.
> 
> uprobe_register() could be easily fixed but unregister is much worse,
> the new mm inherits "int3" from parent and there is no way to detect
> this if uprobe goes away.
> 
> So this patch simply adds brw_start/end_read() around dup_mmap(), and
> brw_start/end_write() into register_for_each_vma().
> 
> This adds 2 new hooks into dup_mmap() but we can kill uprobe_dup_mmap()
> and fold it into uprobe_end_dup_mmap().
> 
> Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

