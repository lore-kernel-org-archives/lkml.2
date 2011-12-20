Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1LTV6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:58:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1LTV6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:58:19 -0500
Date: Tue, 20 Dec 2011 13:58:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH 1/4] memcg: simplify page cache charging.
Message-Id: <20111220135817.5ba7ab05.akpm@linux-foundation.org>
In-Reply-To: <20111219090122.66024659.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
	<20111214164922.05fb4afe.kamezawa.hiroyu@jp.fujitsu.com>
	<20111216142814.dbb77209.akpm@linux-foundation.org>
	<20111219090122.66024659.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 09:01:22 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 16 Dec 2011 14:28:14 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 14 Dec 2011 16:49:22 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > Because of commit ef6a3c6311, FUSE uses replace_page_cache() instead
> > > of add_to_page_cache(). Then, mem_cgroup_cache_charge() is not
> > > called against FUSE's pages from splice.
> > 
> > Speaking of ef6a3c6311 ("mm: add replace_page_cache_page() function"),
> > may I pathetically remind people that it's rather inefficient?
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/1109.1/00375.html
> > 
> 
> IIRC, people says inefficient because it uses memcg codes for page-migration
> for fixing up accounting. Now, We added replace-page-cache for memcg in
> memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
> 
> So, I think the problem originally mentioned is fixed.
> 

No, the inefficiency in replace_page_cache_page() is still there.  Two
identical walks down the radix tree, a pointless decrement then
increment of mapping->nrpages, two writes to page->mapping, an often
pointless decrement then increment of NR_FILE_PAGES, and probably other things.


