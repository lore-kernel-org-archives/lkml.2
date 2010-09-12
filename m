Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0ILL4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:56:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24406 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0ILL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:56:33 -0400
Message-ID: <4C8CBFC3.8060706@oracle.com>
Date: Sun, 12 Sep 2010 19:55:47 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/41] block/loop: queue ordered mode should be DRAIN_FLUSH
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-3-git-send-email-tj@kernel.org> <4C8C9175.5030404@oracle.com> <4C8CBC50.1070400@kernel.org>
In-Reply-To: <4C8CBC50.1070400@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/12/2010 07:41 PM, Tejun Heo wrote:
> Hello,
>
> On 09/12/2010 10:38 AM, Tao Ma wrote:
>> According to Documentation/block/barrier.txt,
>> QUEUE_ORDERED_DRAIN
>>          Requests are ordered by draining the request queue and cache
>>          flushing isn't needed.
>>
>>          Sequence: drain =>  barrier
>>
>> QUEUE_ORDERED_DRAIN_FLUSH
>>          Requests are ordered by draining the request queue and both
>>          pre-barrier and post-barrier cache flushings are needed.
>>
>>          Sequence: drain =>  preflush =>  barrier =>  postflush
>>
>> And for loop device, it call fsync in barrier request. See do_bio_filebacked in drivers/block/loop.c
>> bool barrier = !!(bio->bi_rw&  REQ_HARDBARRIER);
>>                  struct file *file = lo->lo_backing_file;
>>
>>                  if (barrier) {
>>                          if (unlikely(!file->f_op->fsync)) {
>>                                  ret = -EOPNOTSUPP;
>>                                  goto out;
>>                          }
>>
>>                          ret = vfs_fsync(file, 0);
>>                          if (unlikely(ret)) {
>>                                  ret = -EIO;
>>                                  goto out;
>>                          }
>>                  }
>>
>> So actually the sync is done in barrier and no extra flush is needed?
>> Or Do I misread the rules in barrier.txt?
>
> Hmmm... maybe the doc was a bit confusing.  Any device which has
> writeback cache should have FLUSH in the queue ordered configuration.
> The loop device used vfs_fsync() for cache flushing and didn't support
> ordered sequence.  As such, it should use draining for request
> ordering and suports FLUSH, so the mode to use is DRAIN_FLUSH.
oh, thanks for the explanation.

Regards,
Tao
