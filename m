Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0ILLlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:41:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab0ILLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:41:09 -0400
Message-ID: <4C8CBC50.1070400@kernel.org>
Date: Sun, 12 Sep 2010 13:41:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/41] block/loop: queue ordered mode should be DRAIN_FLUSH
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-3-git-send-email-tj@kernel.org> <4C8C9175.5030404@oracle.com>
In-Reply-To: <4C8C9175.5030404@oracle.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Sep 2010 11:41:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/12/2010 10:38 AM, Tao Ma wrote:
> According to Documentation/block/barrier.txt,
> QUEUE_ORDERED_DRAIN
>         Requests are ordered by draining the request queue and cache
>         flushing isn't needed.
> 
>         Sequence: drain => barrier
> 
> QUEUE_ORDERED_DRAIN_FLUSH
>         Requests are ordered by draining the request queue and both
>         pre-barrier and post-barrier cache flushings are needed.
> 
>         Sequence: drain => preflush => barrier => postflush
> 
> And for loop device, it call fsync in barrier request. See do_bio_filebacked in drivers/block/loop.c
> bool barrier = !!(bio->bi_rw & REQ_HARDBARRIER);
>                 struct file *file = lo->lo_backing_file;
> 
>                 if (barrier) {
>                         if (unlikely(!file->f_op->fsync)) {
>                                 ret = -EOPNOTSUPP;
>                                 goto out;
>                         }
> 
>                         ret = vfs_fsync(file, 0);
>                         if (unlikely(ret)) {
>                                 ret = -EIO;
>                                 goto out;
>                         }
>                 }
> 
> So actually the sync is done in barrier and no extra flush is needed?
> Or Do I misread the rules in barrier.txt?

Hmmm... maybe the doc was a bit confusing.  Any device which has
writeback cache should have FLUSH in the queue ordered configuration.
The loop device used vfs_fsync() for cache flushing and didn't support
ordered sequence.  As such, it should use draining for request
ordering and suports FLUSH, so the mode to use is DRAIN_FLUSH.

Thanks.

-- 
tejun
