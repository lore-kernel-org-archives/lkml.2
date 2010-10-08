Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab0JHSyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:54:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0JHSyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:54:11 -0400
Date: Fri, 8 Oct 2010 14:54:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008185409.GA29251@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-12-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct inode_hash_bucket {
> +	struct hlist_bl_head head;
> +};
> +
> +static inline void spin_lock_bucket(struct inode_hash_bucket *b)
> +{
> +	bit_spin_lock(0, (unsigned long *)b);
> +}
> +
> +static inline void spin_unlock_bucket(struct inode_hash_bucket *b)
> +{
> +	__bit_spin_unlock(0, (unsigned long *)b);
> +}

I've looked at the dcache version of this again, and I really hate
duplicating these helpers in the dcache code aswell.  IMHO they
should simple operate directly on the hlist_bl_head, as that's
what it was designed for.  I also don't really see any point in
wrapping the hlist_bl_head as inode_hash_bucket.  If the bucket naming
is important we could rename the hlist_bl stuff to bl_hash, and the
hlist_bl_head could become bl_hash_bucket.

