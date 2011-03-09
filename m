Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1CIF3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:29:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1CIF3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:29:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 14:22:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Justin TerAvest <teravest@google.com>
Cc: m-ikeda@ds.jp.nec.com, jaxboe@fusionio.com, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org, ryov@valinux.co.jp, taka@valinux.co.jp,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
Message-Id: <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299619256-12661-1-git-send-email-teravest@google.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Mar 2011 13:20:50 -0800
Justin TerAvest <teravest@google.com> wrote:

> This patchset adds tracking to the page_cgroup structure for which cgroup has
> dirtied a page, and uses that information to provide isolation between
> cgroups performing writeback.
> 
> I know that there is some discussion to remove request descriptor limits
> entirely, but I included a patch to introduce per-cgroup limits to enable
> this functionality. Without it, we didn't see much isolation improvement.
> 
> I think most of this material has been discussed on lkml previously, this is
> just another attempt to make a patchset that handles buffered writes for CFQ.
> 
> There was a lot of previous discussion at:
>   http://thread.gmane.org/gmane.linux.kernel/1007922
> 
> Thanks to Andrea Righi, Kamezawa Hiroyuki, Munehiro Ikeda, Nauman Rafique,
> and Vivek Goyal for work on previous versions of these patches.
> 

2 points from me.

1. If you know there is a thread, please join even if it's a bit little thread.
2. In these days, I got many comments as 'page_cgroup is toooo big', so
   I don't feel fun when I see a patch which increases size of page_cgroup.

I don't like to increase size of page_cgroup but I think you can record 
information without increasing size of page_cgroup.

A) As Andrea did, encode it to pc->flags.
   But I'm afraid that there is a racy case because memory cgroup uses some
   test_and_set() bits.
B) I wonder why the information cannot be recorded in page->private.
   When page has buffers, you can record the information to buffer struct.
   About swapio (if you take care of), you can record information to bio.

Anyway, thank you for the work. And please join the discussion and explain
"Without it, we didn't see much isolation improvement." with real data.

Regards,
-Kame



> 
>  Documentation/block/biodoc.txt |   10 +
>  block/blk-cgroup.c             |  204 +++++++++++++++++++++-
>  block/blk-cgroup.h             |    9 +-
>  block/blk-core.c               |  216 +++++++++++++++--------
>  block/blk-settings.c           |    2 +-
>  block/blk-sysfs.c              |   60 ++++---
>  block/cfq-iosched.c            |  390 +++++++++++++++++++++++++++++++---------
>  block/cfq.h                    |    6 +-
>  block/elevator.c               |   11 +-
>  fs/buffer.c                    |    2 +
>  fs/direct-io.c                 |    2 +
>  include/linux/blk_types.h      |    2 +
>  include/linux/blkdev.h         |   81 ++++++++-
>  include/linux/blkio-track.h    |   89 +++++++++
>  include/linux/elevator.h       |   14 ++-
>  include/linux/iocontext.h      |    1 +
>  include/linux/memcontrol.h     |    6 +
>  include/linux/mmzone.h         |    4 +-
>  include/linux/page_cgroup.h    |   12 +-
>  init/Kconfig                   |   16 ++
>  mm/Makefile                    |    3 +-
>  mm/bounce.c                    |    2 +
>  mm/filemap.c                   |    2 +
>  mm/memcontrol.c                |    6 +
>  mm/memory.c                    |    6 +
>  mm/page-writeback.c            |   14 ++-
>  mm/page_cgroup.c               |   29 ++-
>  mm/swap_state.c                |    2 +
>  28 files changed, 985 insertions(+), 216 deletions(-)
> 
> [PATCH 1/6] Add IO cgroup tracking for buffered writes.
> [PATCH 2/6] Make async queues per cgroup.
> [PATCH 3/6] Modify CFQ to use IO tracking information.
> [PATCH 4/6] With per-cgroup async, don't special case queues.
> [PATCH 5/6] Add stat for per cgroup writeout done by flusher.
> [PATCH 6/6] Per cgroup request descriptor counts
> 

