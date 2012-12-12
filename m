Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2LLOxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:53:52 -0500
Received: from relay.parallels.com ([195.214.232.42]:36024 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab2LLOxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:53:51 -0500
Message-ID: <50C89A78.4010309@parallels.com>
Date: Wed, 12 Dec 2012 18:53:44 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Maxim Patlasov <mpatlasov@parallels.com>
CC: "miklos@szeredi.hu" <miklos@szeredi.hu>,
        Kirill Korotaev <dev@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: [PATCH v2 00/14] fuse: An attempt to implement a write-back cache
 policy
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

11/16/2012 09:04 PM, Maxim Patlasov пишет:
> Hi,
>
> This is the second iteration of Pavel Emelyanov's patch-set implementing
> write-back policy for FUSE page cache. Initial patch-set description was
> the following:
>
> One of the problems with the existing FUSE implementation is that it uses the
> write-through cache policy which results in performance problems on certain
> workloads. E.g. when copying a big file into a FUSE file the cp pushes every
> 128k to the userspace synchronously. This becomes a problem when the userspace
> back-end uses networking for storing the data.
>
> A good solution of this is switching the FUSE page cache into a write-back policy.
> With this file data are pushed to the userspace with big chunks (depending on the
> dirty memory limits, but this is much more than 128k) which lets the FUSE daemons
> handle the size updates in a more efficient manner.
>
> The writeback feature is per-connection and is explicitly configurable at the
> init stage (is it worth making it CAP_SOMETHING protected?) When the writeback is
> turned ON:
>
> * still copy writeback pages to temporary buffer when sending a writeback request
>    and finish the page writeback immediately
>
> * make kernel maintain the inode's i_size to avoid frequent i_size synchronization
>    with the user space
>
> * take NR_WRITEBACK_TEMP into account when makeing balance_dirty_pages decision.
>    This protects us from having too many dirty pages on FUSE
>
> The provided patchset survives the fsx test. Performance measurements are not yet
> all finished, but the mentioned copying of a huge file becomes noticeably faster
> even on machines with few RAM and doesn't make the system stuck (the dirty pages
> balancer does its work OK). Applies on top of v3.5-rc4.
>
> We are currently exploring this with our own distributed storage implementation
> which is heavily oriented on storing big blobs of data with extremely rare meta-data
> updates (virtual machines' and containers' disk images). With the existing cache
> policy a typical usage scenario -- copying a big VM disk into a cloud -- takes way
> too much time to proceed, much longer than if it was simply scp-ed over the same
> network. The write-back policy (as I mentioned) noticeably improves this scenario.
> Kirill (in Cc) can share more details about the performance and the storage concepts
> details if required.
>
> Changed in v2:
>   - numerous bugfixes:
>     - fuse_write_begin and fuse_writepages_fill and fuse_writepage_locked must wait
>       on page writeback because page writeback can extend beyond the lifetime of
>       the page-cache page
>     - fuse_send_writepages can end_page_writeback on original page only after adding
>       request to fi->writepages list; otherwise another writeback may happen inside
>       the gap between end_page_writeback and adding to the list
>     - fuse_direct_io must wait on page writeback; otherwise data corruption is possible
>       due to reordering requests
>     - fuse_flush must flush dirty memory and wait for all writeback on given inode
>       before sending FUSE_FLUSH to userspace; otherwise FUSE_FLUSH is not reliable
>     - fuse_file_fallocate must hold i_mutex around FUSE_FALLOCATE and i_size update;
>       otherwise a race with a writer extending i_size is possible
>     - fix handling errors in fuse_writepages and fuse_send_writepages
>   - handle i_mtime intelligently if writeback cache is on (see patch #7 (update i_mtime
>     on buffered writes) for details.
>   - put enabling writeback cache under fusermount control; (see mount option
>     'allow_wbcache' introduced by patch #13 (turn writeback cache on))
>   - rebased on v3.7-rc5

Any feedback on this version (v2) would be appreciated.

Thanks,
Maxim

>
> Thanks,
> Maxim
>
> ---
>
> Maxim Patlasov (14):
>        fuse: Linking file to inode helper
>        fuse: Getting file for writeback helper
>        fuse: Prepare to handle short reads
>        fuse: Prepare to handle multiple pages in writeback
>        fuse: Connection bit for enabling writeback
>        fuse: Trust kernel i_size only
>        fuse: Update i_mtime on buffered writes
>        fuse: Flush files on wb close
>        fuse: Implement writepages and write_begin/write_end callbacks
>        fuse: fuse_writepage_locked() should wait on writeback
>        fuse: fuse_flush() should wait on writeback
>        fuse: Fix O_DIRECT operations vs cached writeback misorder
>        fuse: Turn writeback cache on
>        mm: Account for WRITEBACK_TEMP in balance_dirty_pages
>
>
>   fs/fuse/dir.c             |   51 ++++
>   fs/fuse/file.c            |  523 +++++++++++++++++++++++++++++++++++++++++----
>   fs/fuse/fuse_i.h          |   20 ++
>   fs/fuse/inode.c           |   98 ++++++++
>   include/uapi/linux/fuse.h |    1
>   mm/page-writeback.c       |    3
>   6 files changed, 638 insertions(+), 58 deletions(-)
>

