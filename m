Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2HVKIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:08:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab2HVKIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:08:32 -0400
Date: Wed, 22 Aug 2012 12:08:26 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: Re: [PATCH RESEND] udf: extent cache implementation for
 manipulating block map
Message-ID: <20120822100826.GB20640@quack.suse.cz>
References: <1345283903-7960-1-git-send-email-linkinjeon@gmail.com>
 <20120821090810.GC7537@quack.suse.cz>
 <CAKYAXd_odZxzXqn91Q517BuRRFHP3O4pkVgN8uK6QTeFEqaEdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_odZxzXqn91Q517BuRRFHP3O4pkVgN8uK6QTeFEqaEdg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-08-12 19:02:26, Namjae Jeon wrote:
> 2012/8/21, Jan Kara <jack@suse.cz>:
> Hi. Jan.
> Okay, We are trying to do it from your comment.
> 1. Change udf_ext_cache structure to following which would also include *bh.
> struct udf_ext_cache {
> 
> /* Position of the cached extent */
> struct extent_position epos;
> 
> /* Logical block where cached extent starts */
> sector_t block;
> };
  OK.

> 2. Remove call to brelse(epos.bh) from all the callers of inode_bmap()
> and move it to udf_evict_inode()
  It might be easier to keep brelse() where it is and add get_bh() to
udf_add_extent_cache() and brelse() to udf_clear_extent_cache(). It is then
easier to audit we don't leak bh references...

> 3. As now we are not caching elen, etype and eloc, we have to change
> the cache_hit logic in inode_bmap.
> The call to function udf_next_aext is now necessary from inode_bmap.
  Yes.

> 4. Remove call to udf_clear_extent_cache() from udf_get_block as with
> new scheme, it is not required.
  You still need this when you write before the cached location (e.g. when
the file has holes, and you write into them, extents will shift).


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
