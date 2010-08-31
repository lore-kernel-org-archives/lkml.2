Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0HaNDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:03:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab0HaNDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:03:17 -0400
Date: Tue, 31 Aug 2010 09:02:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Message-ID: <20100831130242.GB17505@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
 <20100830132836.GB5283@redhat.com>
 <4C7BB932.1070405@kernel.org>
 <4C7BC942.7070703@kernel.org>
 <20100830190835.GA8458@redhat.com>
 <20100830212819.GA12522@redhat.com>
 <4C7CD9A7.4030901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7CD9A7.4030901@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31 2010 at  6:29am -0400,
Tejun Heo <tj@kernel.org> wrote:

> On 08/30/2010 11:28 PM, Mike Snitzer wrote:
> > Hmm, but unfortunately I was too quick to say the patch fixed the hang.
> > 
> > It is much more rare, but I can still get a hang.  I just got the
> > following running vgcreate against an DM mpath (rq-based) device:
> 
> Can you please try this one instead?

Still hit the hang on the 5th iteration of my test:
while true ; do ./test_dm_discard_mpath.sh && sleep 1 ; done

Would you like me to (re)send my test script offlist?

INFO: task vgcreate:2617 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
vgcreate      D ffff88007bf7ba00  4688  2617   2479 0x00000080
 ffff88007bf7b998 0000000000000046 ffff880000000000 ffff88007bf7bfd8
 ffff88005542a430 ffff88007bf7bfd8 00000000001d3880 ffff88005542a800
 ffff88005542a7f8 00000000001d3880 00000000001d3880 ffff88007bf7bfd8
Call Trace:
 [<ffffffff81389338>] io_schedule+0x73/0xb5
 [<ffffffff811c7304>] get_request_wait+0xef/0x17d
 [<ffffffff810642be>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff811c7890>] __make_request+0x333/0x467
 [<ffffffff810251e5>] ? pvclock_clocksource_read+0x50/0xb9
 [<ffffffff811c5e91>] generic_make_request+0x342/0x3bf
 [<ffffffff81074714>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81069df2>] ? local_clock+0x41/0x5a
 [<ffffffff811c5fe9>] submit_bio+0xdb/0xf8
 [<ffffffff810754a4>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811381a6>] dio_bio_submit+0x7b/0x9c
 [<ffffffff81138dbe>] __blockdev_direct_IO+0x7f3/0x97d
 [<ffffffff810251e5>] ? pvclock_clocksource_read+0x50/0xb9
 [<ffffffff81136d7a>] blkdev_direct_IO+0x57/0x59
 [<ffffffff81135f58>] ? blkdev_get_blocks+0x0/0x90
 [<ffffffff810ce301>] generic_file_aio_read+0xed/0x5b4
 [<ffffffff81077932>] ? lock_release_non_nested+0xd5/0x23b
 [<ffffffff810e40f8>] ? might_fault+0x5c/0xac
 [<ffffffff810251e5>] ? pvclock_clocksource_read+0x50/0xb9
 [<ffffffff8110e131>] do_sync_read+0xcb/0x108
 [<ffffffff81074688>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff81389ac9>] ? __mutex_unlock_slowpath+0x120/0x132
 [<ffffffff8119d805>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff8119d86c>] ? security_file_permission+0x2e/0x33
 [<ffffffff8110e7a3>] vfs_read+0xab/0x107
 [<ffffffff81075473>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff8110e8c2>] sys_read+0x4d/0x74
 [<ffffffff81002c32>] system_call_fastpath+0x16/0x1b
no locks held by vgcreate/2617.
