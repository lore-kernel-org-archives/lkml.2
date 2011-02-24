Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1BXGLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:11:14 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36263 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1BXGLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:11:13 -0500
Date: Thu, 24 Feb 2011 11:38:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <arighi@develer.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        containers@lists.linux-foundation.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, Hirokazu Takahashi <taka@valinux.co.jp>,
        linux-mm@kvack.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/5] blk-throttle: writeback and swap IO control
Message-ID: <20110224060853.GN3379@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1298394776-9957-1-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <arighi@develer.com> [2011-02-22 18:12:51]:

> Currently the blkio.throttle controller only support synchronous IO requests.
> This means that we always look at the current task to identify the "owner" of
> each IO request.
> 
> However dirty pages in the page cache can be wrote to disk asynchronously by
> the per-bdi flusher kernel threads or by any other thread in the system,
> according to the writeback policy.
> 
> For this reason the real writes to the underlying block devices may
> occur in a different IO context respect to the task that originally
> generated the dirty pages involved in the IO operation. This makes the
> tracking and throttling of writeback IO more complicate respect to the
> synchronous IO from the blkio controller's perspective.
> 
> The same concept is also valid for anonymous pages involed in IO operations
> (swap).
> 
> This patch allow to track the cgroup that originally dirtied each page in page
> cache and each anonymous page and pass these informations to the blk-throttle
> controller. These informations can be used to provide a better service level
> differentiation of buffered writes swap IO between different cgroups.
> 
> Testcase
> ========
> - create a cgroup with 1MiB/s write limit:
>   # mount -t cgroup -o blkio none /mnt/cgroup
>   # mkdir /mnt/cgroup/foo
>   # echo 8:0 $((1024 * 1024)) > /mnt/cgroup/foo/blkio.throttle.write_bps_device
> 
> - move a task into the cgroup and run a dd to generate some writeback IO
> 
> Results:
>   - 2.6.38-rc6 vanilla:
>   $ cat /proc/$$/cgroup
>   1:blkio:/foo
>   $ dd if=/dev/zero of=zero bs=1M count=1024 &
>   $ dstat -df
>   --dsk/sda--
>    read  writ
>      0    19M
>      0    19M
>      0     0
>      0     0
>      0    19M
>   ...
> 
>   - 2.6.38-rc6 + blk-throttle writeback IO control:
>   $ cat /proc/$$/cgroup
>   1:blkio:/foo
>   $ dd if=/dev/zero of=zero bs=1M count=1024 &
>   $ dstat -df
>   --dsk/sda--
>    read  writ
>      0  1024
>      0  1024
>      0  1024
>      0  1024
>      0  1024
>   ...
> 

Thanks for looking into this, further review follows.

-- 
	Three Cheers,
	Balbir
