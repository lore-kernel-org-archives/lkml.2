Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2GIEOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:14:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:6167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab2GIEOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174871159"
Date: Mon, 9 Jul 2012 12:14:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Message-ID: <20120709041437.GA10180@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881562-5900-1-git-send-email-handai.szj@taobao.com>
 <20120708145309.GC18272@localhost>
 <4FFA51AB.30203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFA51AB.30203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:36:11AM +0800, Sha Zhengju wrote:
> On 07/08/2012 10:53 PM, Fengguang Wu wrote:
> >>@@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
> >>  {
> >>  	struct address_space *mapping = page_mapping(page);
> >>  	int ret;
> >>+	bool locked;
> >>+	unsigned long flags;
> >>
> >>+	mem_cgroup_begin_update_page_stat(page,&locked,&flags);
> >>  	if (mapping) {
> >>  		struct backing_dev_info *bdi = mapping->backing_dev_info;
> >>  		unsigned long flags;
> >>@@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
> >>  	}
> >>  	if (!ret)
> >>  		account_page_writeback(page);
> >>+
> >>+	mem_cgroup_end_update_page_stat(page,&locked,&flags);
> >>  	return ret;
> >>
> >>  }
> >Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
> >
> 
> It's in account_page_writeback().
> 
>  void account_page_writeback(struct page *page)
>  {
> +	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
>  	inc_zone_page_state(page, NR_WRITEBACK);
>  }

I didn't find that chunk, perhaps it's lost due to rebase..

> There isn't a unified interface to dec/inc writeback accounting, so
> I just follow that.
> Maybe we can rework account_page_writeback() to also account
> dec in?

The current seperate inc/dec paths are fine. It sounds like
over-engineering if going any further.

I'm a bit worried about some 3rd party kernel module to call
account_page_writeback() without mem_cgroup_begin/end_update_page_stat().
Will that lead to serious locking issues, or merely inaccurate
accounting?

Thanks,
Fengguang
