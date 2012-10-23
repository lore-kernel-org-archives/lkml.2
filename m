Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab2JWXgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:36:48 -0400
Received: from shutemov.name ([176.9.204.213]:59979 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933579Ab2JWXgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:36:47 -0400
Date: Wed, 24 Oct 2012 02:38:01 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-ID: <20121023233801.GA21591@shutemov.name>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
 <20121018164502.b32791e7.akpm@linux-foundation.org>
 <20121018235941.GA32397@shutemov.name>
 <20121023063532.GA15870@shutemov.name>
 <20121022234349.27f33f62.akpm@linux-foundation.org>
 <20121023070018.GA18381@otc-wbsnb-06>
 <20121023155915.7d5ef9d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023155915.7d5ef9d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:59:15PM -0700, Andrew Morton wrote:
> On Tue, 23 Oct 2012 10:00:18 +0300
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > > Well, how hard is it to trigger the bad behavior?  One can easily
> > > create a situation in which that page's refcount frequently switches
> > > from 0 to 1 and back again.  And one can easily create a situation in
> > > which the shrinkers are being called frequently.  Run both at the same
> > > time and what happens?
> > 
> > If the goal is to trigger bad behavior then:
> > 
> > 1. read from an area where a huge page can be mapped to get huge zero page
> >    mapped. hzp is allocated here. refcounter == 2.
> > 2. write to the same page. refcounter == 1.
> > 3. echo 3 > /proc/sys/vm/drop_caches. refcounter == 0 -> free the hzp.
> > 4. goto 1.
> > 
> > But it's unrealistic. /proc/sys/vm/drop_caches is only root-accessible.
> 
> Yes, drop_caches is uninteresting.
> 
> > We can trigger shrinker only under memory pressure. But in this, most
> > likely we will get -ENOMEM on hzp allocation and will go to fallback path
> > (4k zero page).
> 
> I disagree.  If, for example, there is a large amount of clean
> pagecache being generated then the shrinkers will be called frequently
> and memory reclaim will be running at a 100% success rate.  The
> hugepage allocation will be successful in such a situation?

Yes.

Shrinker callbacks are called from shrink_slab() which happens after page
cache reclaim, so on next reclaim round page cache will reclaim first and
we will avoid frequent alloc-free pattern.

One more thing we can do: increase shrinker->seeks to something like
DEFAULT_SEEKS * 4. In this case shrink_slab() will call our callback after
callbacks with DEFAULT_SEEKS.

-- 
 Kirill A. Shutemov
