Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1BVTMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:12:53 -0500
Received: from trinity.develer.com ([83.149.158.210]:33197 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1BVTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:12:51 -0500
Date: Tue, 22 Feb 2011 20:12:47 +0100
From: Andrea Righi <arighi@develer.com>
To: Chad Talbott <ctalbott@google.com>
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
Subject: Re: [PATCH 4/5] blk-throttle: track buffered and anonymous pages
Message-ID: <20110222191247.GA1657@linux.develer.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
 <1298394776-9957-5-git-send-email-arighi@develer.com>
 <AANLkTinD2ZH3hw_iqVpvMjMRbUkXMBgttjd2NevvYq9x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinD2ZH3hw_iqVpvMjMRbUkXMBgttjd2NevvYq9x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:42:41AM -0800, Chad Talbott wrote:
> On Tue, Feb 22, 2011 at 9:12 AM, Andrea Righi <arighi@develer.com> wrote:
> > Add the tracking of buffered (writeback) and anonymous pages.
> ...
> > ---
> >  block/blk-throttle.c   |   87 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/blkdev.h |   26 ++++++++++++++-
> >  2 files changed, 111 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> > index 9ad3d1e..a50ee04 100644
> > --- a/block/blk-throttle.c
> > +++ b/block/blk-throttle.c
> ...
> > +int blk_throtl_set_anonpage_owner(struct page *page, struct mm_struct *mm)
> > +int blk_throtl_set_filepage_owner(struct page *page, struct mm_struct *mm)
> > +int blk_throtl_copy_page_owner(struct page *npage, struct page *opage)
> 
> It would be nice if these were named blk_cgroup_*.  This is arguably
> more correct as the id comes from the blkio subsystem, and isn't
> specific to blk-throttle.  This will be more important very shortly,
> as CFQ will be using this same cgroup id for async IO tracking soon.

Sounds reasonable. Will do in the next version.

> 
> is_kernel_io() is a good idea, it avoids a bug that we've run into
> with CFQ async IO tracking.  Why isn't PF_KTHREAD sufficient to cover
> all kernel threads, including kswapd and those marked PF_MEMALLOC?

With PF_MEMALLOC we're sure we don't add the page tracking overhead also
to non-kernel threads when memory gets low.

PF_KSWAPD is not probably needed, AFAICS it is only used by kswapd, that
is created by kthread_create() and so it has the PF_KTHREAD flag set.

Let's see if someone can give more deatils about that. In the while I'll
investigate and try to do some tests only with PF_KTHREAD.

Thanks,
-Andrea
