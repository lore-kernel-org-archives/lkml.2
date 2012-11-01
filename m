Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992664Ab2KAXDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:03:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51942 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992576Ab2KAXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:03:44 -0400
Date: Thu, 1 Nov 2012 16:03:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: shmem_getpage_gfp VM_BUG_ON triggered. [3.7rc2]
In-Reply-To: <20121101191052.GA5884@redhat.com>
Message-ID: <alpine.LNX.2.00.1211011546090.19377@eggly.anvils>
References: <20121025023738.GA27001@redhat.com> <alpine.LNX.2.00.1210242121410.1697@eggly.anvils> <20121101191052.GA5884@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Dave Jones wrote:
> On Wed, Oct 24, 2012 at 09:36:27PM -0700, Hugh Dickins wrote:
>  > On Wed, 24 Oct 2012, Dave Jones wrote:
>  > 
>  > > Machine under significant load (4gb memory used, swap usage fluctuating)
>  > > triggered this...
>  > > 
>  > > WARNING: at mm/shmem.c:1151 shmem_getpage_gfp+0xa5c/0xa70()
>  > > 
>  > > 1148                         error = shmem_add_to_page_cache(page, mapping, index,
>  > > 1149                                                 gfp, swp_to_radix_entry(swap));
>  > > 1150                         /* We already confirmed swap, and make no allocation */
>  > > 1151                         VM_BUG_ON(error);
>  > > 1152                 }
>  > 
>  > That's very surprising.  Easy enough to handle an error there, but
>  > of course I made it a VM_BUG_ON because it violates my assumptions:
>  > I rather need to understand how this can be, and I've no idea.
> 
> I just noticed we had a user report hitting this same warning, but
> with a different trace..
> 
> : [<ffffffff8105b84f>] warn_slowpath_common+0x7f/0xc0
> : [<ffffffff8105b8aa>] warn_slowpath_null+0x1a/0x20
> : [<ffffffff81143c73>] shmem_getpage_gfp+0x7f3/0x830
> : [<ffffffff81158c9d>] ? vma_adjust+0x3ed/0x620
> : [<ffffffff81143f02>] shmem_file_aio_read+0x1f2/0x380
> : [<ffffffff8118e487>] do_sync_read+0xa7/0xe0
> : [<ffffffff8118eda9>] vfs_read+0xa9/0x180
> : [<ffffffff8118eeca>] sys_read+0x4a/0x90
> : [<ffffffff816226e9>] system_call_fastpath+0x16/0x1b

Equally explicable by Hannes's hypothesis;
but useful supporting evidence, thank you.

Except... earlier in the thread you explained how you hacked
#define VM_BUG_ON(cond) WARN_ON(cond)
to get this to come out as a warning instead of a bug,
and now it looks as if "a user" has here done the same.

Which is very much a user's right, of course; but does
make me wonder whether that user might actually be davej ;)

Never mind, whatever, it's more justification for the fix - which
I've honestly not forgotten, but somehow not got around to sending
(with a couple of others even longer outstanding).  On its way
shortly, for some unpredictable value of shortly.

Hugh
