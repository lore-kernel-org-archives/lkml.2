Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2FRXJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:09:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42930 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2FRXJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:09:43 -0400
Date: Mon, 18 Jun 2012 16:09:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] memblock: Make sure reserved.regions is freed really
Message-ID: <20120618230939.GI32733@google.com>
References: <1339816331-23284-1-git-send-email-yinghai@kernel.org>
 <20120618220519.GD32733@google.com>
 <CAE9FiQUYsPFPnQvTsy9u3inM3hP5uWYtCRJMvQ=MvR7fCJTqzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUYsPFPnQvTsy9u3inM3hP5uWYtCRJMvQ=MvR7fCJTqzg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Yinghai.

On Mon, Jun 18, 2012 at 03:58:52PM -0700, Yinghai Lu wrote:
> > Hmmm... nice catch but I think it's a bit complex and ugly.  In this
> > case, we *know* that the region isn't gonna be split.  Maybe a better
> > option is to add something like the following?
> 
> how do you know __pa(memblock.reserved.regions) would not be merged
> with other entries
> in reserved.regions?
>
> >
> > void memblock_remove_region_by_ptr(struct memblock_type *type,
> >                                   struct memblock_region *r)
> > {
> >        WARN_ON(/* make sure @r is inside @type->regions */);
> >        memblock_remove_region(type, r - type->regions);
> > }
> 
> you want to change

Heh, you're right.  My suggestion was completely bonkers.  Sorry about
that.  Hmm.... how about separating out removal pre-expansion and
doing it before calling into free?  ie. something like

static int memblock_prepare_for_isolation(struct memblock_type *type)
{
	/* we'll create at most two more regions */
	while (type->cnt + 2 > type->max)
		if (memblock_double_array(type) < 0)
			return -ENOMEM;
	return 0;
}

int __init_memblock memblock_free_reserved_regions(void)
{
	int ret;

	if (memblock.reserved.regions == memblock_reserved_init_regions)
		return 0;

	ret = memblock_prepare_for_isolation(&memblock.reserved);
	if (ret)
		return ret;

	ret = memblock_free(__pa(memblock.reserved.regions),
		sizeof(struct memblock_region) * memblock.reserved.max);
	WARN_ON(ret || memblock.reserved.regions has changed);
	return ret;
}

Thanks.

-- 
tejun
