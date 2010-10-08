Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0JHKd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:33:57 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:56616 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755453Ab0JHKd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:33:56 -0400
Date: Fri, 8 Oct 2010 21:33:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] kernel: add bl_list
Message-ID: <20101008103352.GD4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-2-git-send-email-david@fromorbit.com>
 <87hbgx5c7z.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbgx5c7z.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:18:40AM +0200, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > +static inline void __hlist_bl_del(struct hlist_bl_node *n)
> > +{
> > +	struct hlist_bl_node *next = n->next;
> > +	struct hlist_bl_node **pprev = n->pprev;
> > +
> > +	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
> > +
> > +	/* pprev may be `first`, so be careful not to lose the lock bit */
> > +	*pprev = (struct hlist_bl_node *)
> > +			((unsigned long)next |
> > +			 ((unsigned long)*pprev & LIST_BL_LOCKMASK));
> > +	if (next)
> > +		next->pprev = pprev;
> > +}
> 
> Should this set n->pprev to NULL so that unhashed returns true
> afterwards?

No, I think the callers set that appropriately.

> > +
> > +static inline void hlist_bl_del(struct hlist_bl_node *n)
> > +{
> > +	__hlist_bl_del(n);
> > +	n->next = BL_LIST_POISON1;
> > +	n->pprev = BL_LIST_POISON2;
> > +}
> 
> Ok so unhashed only works once. Seems unsymmetric.

Exactly the same behaviour as hlist_del(). If you want
hlist_bl_unhashed() to work, you need to call hlist_bl_del_init().

/me makes a note to check all the inode hash code uses hlist_bl_del_init()
as there are unhashed checks in many places.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
