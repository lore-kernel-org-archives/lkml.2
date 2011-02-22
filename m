Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1BVWAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:00:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1BVWAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:00:46 -0500
Date: Tue, 22 Feb 2011 16:57:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
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
Message-ID: <20110222215720.GK28269@redhat.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
 <1298394776-9957-4-git-send-email-arighi@develer.com>
 <20110222130145.37cb151e@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222130145.37cb151e@bike.lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 01:01:45PM -0700, Jonathan Corbet wrote:
> On Tue, 22 Feb 2011 18:12:54 +0100
> Andrea Righi <arighi@develer.com> wrote:
> 
> > The page_cgroup infrastructure, currently available only for the memory
> > cgroup controller, can be used to store the owner of each page and
> > opportunely track the writeback IO. This information is encoded in
> > the upper 16-bits of the page_cgroup->flags.
> > 
> > A owner can be identified using a generic ID number and the following
> > interfaces are provided to store a retrieve this information:
> > 
> >   unsigned long page_cgroup_get_owner(struct page *page);
> >   int page_cgroup_set_owner(struct page *page, unsigned long id);
> >   int page_cgroup_copy_owner(struct page *npage, struct page *opage);
> 
> My immediate observation is that you're not really tracking the "owner"
> here - you're tracking an opaque 16-bit token known only to the block
> controller in a field which - if changed by anybody other than the block
> controller - will lead to mayhem in the block controller.  I think it
> might be clearer - and safer - to say "blkcg" or some such instead of
> "owner" here.
> 
> I'm tempted to say it might be better to just add a pointer to your
> throtl_grp structure into struct page_cgroup.

throtl_grp might not even be present when page is being dirtied. When this
IO is actually submitted to device, we migth end up creating new
throtl_grp. I guess other concern here would be increasing the size of
page_cgroup structure.

I guess you meant storing a pointer to blkio_cgroup, along the lines of
storing a pointer to mem_cgroup. That also means extra 8 bytes and only
one subsystem can use it at a time. So using upper bits of pc->flags
is probably better.

> Or maybe replace the
> mem_cgroup pointer with a single pointer to struct css_set.  Both of
> those ideas, though, probably just add unwanted extra overhead now to gain
> generality which may or may not be wanted in the future.

This sounds interesting. IIUC, then this single pointer will allow all
the subsystems to use this single pointer to retireve respective cgroups
without actually co-mounting them. 

I am not sure how much work is involved in making it happen. Also not sure
about the overhead involved in traversing one extra pointer. Also apart
from blkio controller, have we practically felt the need of any other
controller this info. (network controller?). Few days back we were
experimenting with trying to control block IO bandwidth over NFS with 
the help of network controller but it did not really work well with
host of issues and one them being losing the context information.

If storing css_set pointer is lot of work, may be for the time being
we can go for this hardcoding that these bits are exclusively used
by blkio controller and once some other controller wants to share it,
then look for ways of how to do sharing.

Thanks
Vivek
