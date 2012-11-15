Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2KOGwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:52:20 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38632 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab2KOGwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:52:19 -0500
Date: Thu, 15 Nov 2012 12:27:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Arapov <anton@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] uprobes: Use percpu_rw_semaphore to fix
 register/unregister vs dup_mmap() race
Message-ID: <20121115065733.GB30378@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121114184929.GA6977@redhat.com>
 <20121114184953.GA6972@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121114184953.GA6972@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111506-3534-0000-0000-00000EF9A369
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-14 19:49:53]:

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
> So this patch simply adds percpu_down_read/up_read around dup_mmap(),
> and percpu_down_write/up_write into register_for_each_vma().
> 
> This adds 2 new hooks into dup_mmap() but we can kill uprobe_dup_mmap()
> and fold it into uprobe_end_dup_mmap().
> 


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

