Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1CVKSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:18:05 -0400
Received: from shutemov.name ([188.40.19.243]:59638 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1CVKSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:18:02 -0400
Date: Tue, 22 Mar 2011 12:18:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: menage@google.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] list.h: add debug version of list_empty
Message-ID: <20110322101801.GA1733@shutemov.name>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1300194523-19325-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110321165206.1deaf0ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321165206.1deaf0ab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:52:06PM -0700, Andrew Morton wrote:
> On Tue, 15 Mar 2011 15:08:42 +0200
> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> 
> > Heed the notice in list_del: "Note: list_empty() on entry does not
> > return true after this, the entry is in an undefined state.", and
> > check for precisely that condition.
> > 
> > There are currently a few instances in the code of this sequence:
> >     if(!list_empty(pnode))
> >         list_del(pnode);
> > which seems to be useless or dangerous if intended to protect from
> > repeated del's. And given that I've seen an oops pointing to a
> > dereference of poison in such a list_empty, I'm veering towards
> > dangerous. This patch would make such errors obvious.
> > 
> > Nothing is changed in the non-DEBUG_LIST build.
> > 
> > ...
> >
> > +
> > +/**
> > + * list_empty - tests whether a list is empty
> > + * @head: the list to test.
> > + */
> > +int list_empty(const struct list_head *head)
> > +{
> > +	if ((head->prev == LIST_POISON2) || (head->prev == LIST_POISON1))
> > +		WARN(1, "list_empty performed on a node "
> > +		     "at %p removed from a list.\n", head);
> > +	else
> > +		WARN((head->prev == head) != (head->next == head),
> > +		     "list_empty corruption. %p<-%p->%p is half-empty.\n",
> > +		     head->prev, head, head->next);
> > +
> > +	return head->next == head;
> > +}
> > +EXPORT_SYMBOL(list_empty);
> 
> The second warning here is triggering maybe a hundred times from all
> over the place just when booting the kernel.
> 
> Here's the first two:
> 
> 
> [   64.295941] WARNING: at lib/list_debug.c:89 list_empty+0x79/0x85()
> [   64.296129] list_empty corruption. ffff880255bcb788<-ffff880255bcb788->ffff88024c3a3c20 is half-empty.

It looks like a race between __list_del() and list_empty().

-- 
 Kirill A. Shutemov
