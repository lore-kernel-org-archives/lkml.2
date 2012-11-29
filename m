Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2K2Tel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:34:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:33882 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2K2Tek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:34:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="256785862"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] sched, numa, mm: Add adaptive NUMA affinity support
References: <20121112160451.189715188@chello.nl>
	<20121112161215.782018877@chello.nl>
Date: Thu, 29 Nov 2012 11:34:15 -0800
In-Reply-To: <20121112161215.782018877@chello.nl> (Peter Zijlstra's message of
	"Mon, 12 Nov 2012 17:04:56 +0100")
Message-ID: <m2sj7sfbk8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> +
> +		down_write(&mm->mmap_sem);
> +		for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +			if (!vma_migratable(vma))
> +				continue;
> +			change_protection(vma, vma->vm_start, vma->vm_end, vma_prot_none(vma), 0);
> +		}

What happens if I have a 1TB process? Will you really unmap all of the
1TB in that timer?


>  
>  	case MPOL_PREFERRED:
>  		if (pol->flags & MPOL_F_LOCAL)
> -			polnid = numa_node_id();
> +			best_nid = numa_node_id();
>  		else
> -			polnid = pol->v.preferred_node;
> +			best_nid = pol->v.preferred_node;

So that's not the local node anymore?  That will change behaviour for
people using the NUMA affinity APIs explicitely.  I don't think that's a
good idea, if someone set the affinity explicitely the kernel better
follow that.

If you want to change behaviour for non DEFAULT like this
please use a new policy type.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
