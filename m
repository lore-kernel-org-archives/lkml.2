Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1BVUBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:01:50 -0500
Received: from tex.lwn.net ([70.33.254.29]:35344 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1BVUBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:01:48 -0500
Date: Tue, 22 Feb 2011 13:01:45 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Andrea Righi <arighi@develer.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] page_cgroup: make page tracking available for blkio
Message-ID: <20110222130145.37cb151e@bike.lwn.net>
In-Reply-To: <1298394776-9957-4-git-send-email-arighi@develer.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
	<1298394776-9957-4-git-send-email-arighi@develer.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 18:12:54 +0100
Andrea Righi <arighi@develer.com> wrote:

> The page_cgroup infrastructure, currently available only for the memory
> cgroup controller, can be used to store the owner of each page and
> opportunely track the writeback IO. This information is encoded in
> the upper 16-bits of the page_cgroup->flags.
> 
> A owner can be identified using a generic ID number and the following
> interfaces are provided to store a retrieve this information:
> 
>   unsigned long page_cgroup_get_owner(struct page *page);
>   int page_cgroup_set_owner(struct page *page, unsigned long id);
>   int page_cgroup_copy_owner(struct page *npage, struct page *opage);

My immediate observation is that you're not really tracking the "owner"
here - you're tracking an opaque 16-bit token known only to the block
controller in a field which - if changed by anybody other than the block
controller - will lead to mayhem in the block controller.  I think it
might be clearer - and safer - to say "blkcg" or some such instead of
"owner" here.

I'm tempted to say it might be better to just add a pointer to your
throtl_grp structure into struct page_cgroup.  Or maybe replace the
mem_cgroup pointer with a single pointer to struct css_set.  Both of
those ideas, though, probably just add unwanted extra overhead now to gain
generality which may or may not be wanted in the future.

jon
