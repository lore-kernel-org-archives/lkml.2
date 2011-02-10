Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1BJTcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:32:55 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41678 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1BJTcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:32:52 -0500
Subject: Re: [PATCH 4/5] teach smaps_pte_range() about THP pmds
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20110210180801.GA3347@random.random>
References: <20110209195406.B9F23C9F@kernel>
	 <20110209195411.816D55A7@kernel>  <20110210180801.GA3347@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 10 Feb 2011 11:32:48 -0800
Message-ID: <1297366368.6737.14780.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 19:08 +0100, Andrea Arcangeli wrote:
> the locking looks wrong, who is taking the &walk->mm->page_table_lock,
> and isn't this going to deadlock on the pte_offset_map_lock for
> NR_CPUS < 4, and where is it released? This spin_lock don't seem
> necessary to me.
> 
> The right locking would be:
> 
>  spin_lock(&walk->mm->page_table_lock);
>  if (pmd_trans_huge(*pmd)) {
>    if (pmd_trans_splitting(*pmd)) {
>     spin_unlock(&walk->mm->page_table_lock);
>     wait_split_huge_page(vma->anon_vma, pmd);
>    } else {
>     smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
>     spin_unlock(&walk->mm->page_table_lock);
>     return 0;
>   } 

I was under the assumption that the mm->page_table_lock was already held
here, but I think that's wrong.  I'll go back, take another look, and
retest.

-- Dave

