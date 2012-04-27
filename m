Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2D0ORK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:17:10 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42623 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760216Ab2D0ORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:17:09 -0400
Date: Fri, 27 Apr 2012 07:17:04 -0700
From: Tejun Heo <tj@kernel.org>
To: "Pavel V. Panteleev" <pp_84@mail.ru>
Cc: linux-mm <linux-mm@kvak.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        andi <andi@firstfloor.org>
Subject: Re: percpu allocator
Message-ID: <20120427141704.GH27486@google.com>
References: <E1SNhwY-0007ui-V7.pp_84-mail-ru@f220.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1SNhwY-0007ui-V7.pp_84-mail-ru@f220.mail.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 01:58:26PM +0400, Pavel V. Panteleev wrote:
> I have the following problem with pcpu embed allocator in kernel
> 2.6.33.1. pcpu_embed_first_chunk() function allocate only size_sum =
> (ai->static_size + ai->reserved_size + ai->dyn_size) for an unit in
> the group. So, for 4 groups (1 unit in each) and with memory only on
> the first node I have the following:
> 
> pcpu_embed_first_chunk(): ai->groups[0].base_offset=0x0
> pcpu_embed_first_chunk(): ai->groups[1].base_offset=0xa000
> pcpu_embed_first_chunk(): ai->groups[2].base_offset=0x14000
> pcpu_embed_first_chunk(): ai->groups[3].base_offset=0x1e000
> 
>  pcpu_embed_first_chunk(): ai->unit_size=0x10000
> 
> It means, that for each group memory of size_sum=0xa000 is used
> only. So, in the case of memory only on the first node, memory for
> the following group will be allocated near the memory of the
> previous group. Even though memory of size_sum=0xa000 is used only,
> but ai->unit_size=0x10000.
>
> After filling group_offsets and group_sizes in
> pcpu_setup_first_chunk() function we have, that (group_offsets[i] +
> group_sizes[i]) can be larger than group_offsets[i+1]. But in
> pcpu_get_vm_areas() function there is checker, which tell us, that
> such situation is impossible:
> 
> BUG_ON(start2 >= start && start2 < end);
> 
> May be I should not use embed allocator in such situation? 

Nice catch.  pcpu_embed_first_chunk() allocates full unit and then
free whatever is unused (for alignment, IIRC) before proceeding to the
next group.  What it should do is first allocate and prepare all
groups and then free whatever is unused.  I'll write up a patch.

Thanks.

-- 
tejun
