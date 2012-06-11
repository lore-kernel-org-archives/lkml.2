Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2FKPCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:02:25 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:39934 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755033Ab2FKPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:02:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: AJG3d2EVM1lLEiR5w4Id_D4raHQQhRW6_y_RhDp_aCuA9Rm
 xP3rNY2s_a0Y3.hLxwhSvaoegh.PNv6b1AaJxlBhM3mO9QabpVr8EEEik823
 pQGGp2vAInG2QpZp8qDJPf0DOFmGkO3gLuK5p4g4E6YAfrM0oYISvp6XHt3N
 LtY0tdUa3DgDEc.t35TmWT5rv9.ky0A8xwtkujI8Qh74ssa9UXgEstr_1ZCa
 aeMMNoO4vjX4H2c6g1Pu6cSyWEwM27G9l2lNFEsRA8a8advdPu6ZShFJn3pX
 PXJ1Ykb92D9a19GTOq0yIbaqNY0BOt5KbTx0iBLEV8SpEPYSMIrx4IGmBFsR
 GPt.XiCA8R7mk84RvO61xflD3fCEOCPt_886UE3JhpiPodafw.hlmdLmX9vi
 xDHruVnp_RSeYcxkk5V_wqsbw3Wc2El2sL3aM
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 10:02:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] mempolicy: remove all mempolicy sharing
In-Reply-To: <1339406250-10169-3-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1206110944120.31180@router.home>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com> <1339406250-10169-3-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more attempts to cleanup changelogs:

> The problem was created by a reference count imbalance. Example, In following case,
> mbind(addr, len) try to replace mempolicies of vma1 and vma2 and then they will
> be share the same mempolicy, and the new mempolicy has MPOL_F_SHARED flag.

The bug that we saw <where ? details?> was created by a refcount
imbalance. If mbind() replaces the memory policies of vma1 and vma and
they share the same shared mempolicy (MPOL_F_SHARED set) then an imbalance
may occur.

>   +-------------------+-------------------+
>   |     vma1          |     vma2(shmem)   |
>   +-------------------+-------------------+
>   |                                       |
>  addr                                 addr+len
>
> Look at alloc_pages_vma(), it uses get_vma_policy() and mpol_cond_put() pair
> for maintaining mempolicy refcount. The current rule is, get_vma_policy() does
> NOT increase a refcount if the policy is not attached shmem vma and mpol_cond_put()
> DOES decrease a refcount if mpol has MPOL_F_SHARED.

alloc_pages_vma() uses the two function get_vma_policy() and
mpol_cond_put() to maintain the refcount on the memory policies. However,
the current rule is that get_vma_policy() does *not* increase the refcount
if the policy is not attached to a shm vma. mpol_cond_put *does* decrease
the refcount if the memory policy has MPOL_F_SHARED set.

> In above case, vma1 is not shmem vma and vma->policy has MPOL_F_SHARED! then,
> get_vma_policy() doesn't increase a refcount and mpol_cond_put() decrease a
> refcount whenever alloc_page_vma() is called.
>
> The bug was introduced by commit 52cd3b0740 (mempolicy: rework mempolicy Reference
> Counting) at 4 years ago.
>
> More unfortunately mempolicy has one another serious broken. Currently,
> mempolicy rebind logic (it is called from cpuset rebinding) ignore a refcount
> of mempolicy and override it forcibly. Thus, any mempolicy sharing may
> cause mempolicy corruption. The bug was introduced by commit 68860ec10b
> (cpusets: automatic numa mempolicy rebinding) at 7 years ago.

Memory policies have another issue. Currently the mempolicy rebind logic
used for cpuset rebinding ignores the refcount of memory policies.
Therefore, any memory policy sharing can cause refcount mismatches. The
bug was ...

> To disable policy sharing solves user visible breakage and this patch does it.
> Maybe, we need to rewrite MPOL_F_SHARED and mempolicy rebinding code and aim
> to proper cow logic eventually, but I think this is good first step.

Disabling policy sharing solves the breakage and that is how this patch
fixes the issue for now. Rewriting the shared policy handling with proper
COW logic support will be necessary to cleanly address the
problem and allow proper sharing of memory policies.

