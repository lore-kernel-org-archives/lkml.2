Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0GIB21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:28:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:48367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0GIB20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:28:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ubI+2ozHLqoZTuPi834pV4t4mm6aWitC9dolKRqitJCR0zcYl1Nz26DzhqQWPcZOm
	IS9sxI33fk0CVTtthuGUg==
Date: Thu, 8 Jul 2010 18:28:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH]shmem: reduce one time of locking in pagefault
In-Reply-To: <20100707013919.GA22097@sli10-desk.sh.intel.com>
Message-ID: <alpine.DEB.1.00.1007081814420.1132@tigran.mtv.corp.google.com>
References: <1278465346.11107.8.camel@sli10-desk.sh.intel.com> <20100706183254.cf67e29e.akpm@linux-foundation.org> <20100707013919.GA22097@sli10-desk.sh.intel.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, Shaohua Li wrote:
> On Wed, Jul 07, 2010 at 09:32:54AM +0800, Andrew Morton wrote:
> > 
> > The patch doesn't make shmem_getpage() any clearer :(

:)

> > 
> > shmem_inode_info.lock appears to be held too much.  Surely
> > lookup_swap_cache() didn't need it (for example).
> > 
> > What data does shmem_inode_info.lock actually protect?
> As far as my understanding, it protects shmem swp_entry, which is most used
> to support swap. It also protects some accounting. If no swap, the lock almost
> can be removed like tiny-shmem.

That's right: shmem_info_info.lock protects what's in shmem_inode_info,
plus what hangs off it (the shmem_swp blocks).

We want that lock across the lookup_swap_cache() to be sure that what we
find is still what we want (otherwise another thread might bring it out
of swap and that swap be reused for something else) - the page lock is
good once you have a page to lock, but until then....  I guess could be
done by dropping the lock then retaking and rechecking after, but that
would go right against the grain of this patch.

Hugh
