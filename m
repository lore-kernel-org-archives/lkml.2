Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0IDCFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:05:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:43912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0IDCFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:05:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,316,1280732400"; 
   d="scan'208";a="603671908"
Date: Sat, 4 Sep 2010 10:04:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] compaction: fix COMPACTPAGEFAILED counting
Message-ID: <20100904020452.GA7788@localhost>
References: <1283438087-11842-1-git-send-email-minchan.kim@gmail.com>
 <20100903170227.b2f18ba4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903170227.b2f18ba4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 08:02:27AM +0800, Andrew Morton wrote:
> On Thu,  2 Sep 2010 23:34:47 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > Now update_nr_listpages doesn't have a role. That's because
> > lists passed is always empty just after calling migrate_pages.
> > The migrate_pages cleans up page list which have failed to migrate
> > before returning by aaa994b3.
> > 
> >  [PATCH] page migration: handle freeing of pages in migrate_pages()
> > 
> >  Do not leave pages on the lists passed to migrate_pages().  Seems that we will
> >  not need any postprocessing of pages.  This will simplify the handling of
> >  pages by the callers of migrate_pages().
> > 
> > At that time, we thought we don't need any postprocessing of pages.
> > But the situation is changed. The compaction need to know the number of
> > failed to migrate for COMPACTPAGEFAILED stat
> > 
> > This patch makes new rule for caller of migrate_pages to call putback_lru_pages.
> > So caller need to clean up the lists so it has a chance to postprocess the pages.
> > [suggested by Christoph Lameter]
> 
> I'm having trouble predicting what the user-visible effects of this bug
> might be.  Just an inaccuracy in the COMPACTPAGEFAILED vm event?

Right, it's an accounting fix. Before patch COMPACTPAGEFAILED will
remain 0 regardless of how many migration failures.

The patch does slightly add dependency for migrate_pages() to return
error code properly. Before patch, migrate_pages() calls
putback_lru_pages() regardless of the error code. After patch, the
migrate_pages() callers will check its return value before calling
putback_lru_pages().

In current code, the two conditions do seem to match:

"some pages remained in the *from list" == "migrate_pages() returns an error code".

Thanks,
Fengguang
