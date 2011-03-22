Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1CVKQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:16:40 -0400
Received: from smtp.nokia.com ([147.243.1.48]:64863 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1CVKQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:16:37 -0400
Date: Tue, 22 Mar 2011 12:11:21 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] list.h: add debug version of list_empty
Message-ID: <20110322101121.GB30552@esdhcp04044.research.nokia.com>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com> <1300194523-19325-2-git-send-email-ext-phil.2.carmody@nokia.com> <20110321165206.1deaf0ab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321165206.1deaf0ab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/11 16:52 -0700, ext Andrew Morton wrote:
> On Tue, 15 Mar 2011 15:08:42 +0200
> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> > +int list_empty(const struct list_head *head)
> > +{
> > +	if ((head->prev == LIST_POISON2) || (head->prev == LIST_POISON1))
> > +		WARN(1, "list_empty performed on a node "
> > +		     "at %p removed from a list.\n", head);
> > +	else
> > +		WARN((head->prev == head) != (head->next == head),
> > +		     "list_empty corruption. %p<-%p->%p is half-empty.\n",
> > +		     head->prev, head, head->next);
 
> The second warning here is triggering maybe a hundred times from all
> over the place just when booting the kernel.
> 
> Here's the first two:
> 
> [   64.295941] WARNING: at lib/list_debug.c:89 list_empty+0x79/0x85()
> [   64.296129] list_empty corruption. ffff880255bcb788<-ffff880255bcb788->ffff88024c3a3c20 is half-empty.


OK, so the patch is working as expected. Perhaps my expectations were wrong.

Looking at list.h I was sure that lists should always be either circular or
poisoned both ends. The above is a rho-shape, this == prev.

Traditional list_empty() returns false on such a node, so it should be
possible to list_del() it. But then next->prev will be set to this->prev 
which is this. So this will never be deleted from the list. That situation
rings warning bells in my head. Which I guess is what the patch was trying
to concretise.

I presume the above are x86_64, I'll see if I can get access to such a 
machine in the next few days, or reproduce it on one of the architectures
I do have here.

Phil


