Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1BVSmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:42:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:62067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1BVSmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:42:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FXO3UzLvdeRKgw7jhTihjEzn1K1FmzZqt9D72wb0KQX94OYQ687tZvoxhxVWF2jwuF
         yvOEiwqubGTgWZ6FhNMg==
MIME-Version: 1.0
In-Reply-To: <1298394776-9957-5-git-send-email-arighi@develer.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
	<1298394776-9957-5-git-send-email-arighi@develer.com>
Date: Tue, 22 Feb 2011 10:42:41 -0800
Message-ID: <AANLkTinD2ZH3hw_iqVpvMjMRbUkXMBgttjd2NevvYq9x@mail.gmail.com>
Subject: Re: [PATCH 4/5] blk-throttle: track buffered and anonymous pages
From: Chad Talbott <ctalbott@google.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 9:12 AM, Andrea Righi <arighi@develer.com> wrote:
> Add the tracking of buffered (writeback) and anonymous pages.
...
> ---
>  block/blk-throttle.c   |   87 +++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/blkdev.h |   26 ++++++++++++++-
>  2 files changed, 111 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 9ad3d1e..a50ee04 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
...
> +int blk_throtl_set_anonpage_owner(struct page *page, struct mm_struct *mm)
> +int blk_throtl_set_filepage_owner(struct page *page, struct mm_struct *mm)
> +int blk_throtl_copy_page_owner(struct page *npage, struct page *opage)

It would be nice if these were named blk_cgroup_*.  This is arguably
more correct as the id comes from the blkio subsystem, and isn't
specific to blk-throttle.  This will be more important very shortly,
as CFQ will be using this same cgroup id for async IO tracking soon.

is_kernel_io() is a good idea, it avoids a bug that we've run into
with CFQ async IO tracking.  Why isn't PF_KTHREAD sufficient to cover
all kernel threads, including kswapd and those marked PF_MEMALLOC?

Thanks,
Chad
