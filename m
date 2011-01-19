Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1ASDJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:09:43 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:36667 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752053Ab1ASDJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:09:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:X-Identified-User;
	b=qEH+XUPgF6M7ylEuITRGvtSjDnXUhPRG4JzlII/fY0zR1byq9UMyhsGWOBU5nHGAlyqSwplOU4xKOjVgicwgyYEjmPXeFV0B4uB0bAFTJ7OiesTZWIFfzowCXkcfpnBM;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH v2] blktrace: Don't output messages if NOTIFY isn't set.
Date: Wed, 19 Jan 2011 11:09:50 +0800
Message-Id: <1295406590-7320-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <x491v4a5hzq.fsf@segfault.boston.devel.redhat.com>
References: <x491v4a5hzq.fsf@segfault.boston.devel.redhat.com>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On 01/18/2011 11:50 PM, Jeff Moyer wrote:
> Tao Ma<tm@tao.ma>  writes:
>
>> +	/*
>> +	 * If the user does specify some action masks, don't send any note
>> +	 * message to the trace so that it won't pollute what the user really
>> +	 * want to see.
>> +	 */
>> +	if (bt->act_mask != (u16) -1)
>> +		return;
>> +
>
> I think you want to check for the BLK_TC_NOTIFY bit.
I was thinking of this, but actually there is no way for the user to set this flag.
At least from blktrace(8), -a doesn't have any flags like NOTIFY. So if the user
set any flag, NOTIFY will be cleared. So it does work. Thanks.

Here is the updated patch.

>From 8693c19f165b09f60d5c26aed369d79a79e144ba Mon Sep 17 00:00:00 2001
From: Tao Ma <boyu.mt@taobao.com>
Date: Wed, 19 Jan 2011 10:51:44 +0800
Subject: [PATCH v2] blktrace: Don't output messages if NOTIFY isn't set.

Now if we enable blktrace, cfq has too many messages output to the
trace buffer. It is fine if we don't specify any action mask.
But if I do like this:
blktrace /dev/sdb -a issue -a complete -o - | blkparse -i -
I only want to see 'D' and 'C', while with the following command
dd if=/mnt/ocfs2/test of=/dev/null bs=4k count=1 iflag=direct

I will get(with a 2.6.37 vanilla kernel):
  8,16   0        0     0.000000000     0  m   N cfq3805 alloced
  8,16   0        0     0.000004126     0  m   N cfq3805 insert_request
  8,16   0        0     0.000004884     0  m   N cfq3805 add_to_rr
  8,16   0        0     0.000008417     0  m   N cfq workload slice:300
  8,16   0        0     0.000009557     0  m   N cfq3805 set_active wl_prio:0 wl_type:2
  8,16   0        0     0.000010640     0  m   N cfq3805 fifo=          (null)
  8,16   0        0     0.000011193     0  m   N cfq3805 dispatch_insert
  8,16   0        0     0.000012221     0  m   N cfq3805 dispatched a request
  8,16   0        0     0.000012802     0  m   N cfq3805 activate rq, drv=1
  8,16   0        1     0.000013181  3805  D   R 114759 + 8 [dd]
  8,16   0        2     0.000164244     0  C   R 114759 + 8 [0]
  8,16   0        0     0.000167997     0  m   N cfq3805 complete rqnoidle 0
  8,16   0        0     0.000168782     0  m   N cfq3805 set_slice=100
  8,16   0        0     0.000169874     0  m   N cfq3805 arm_idle: 8 group_idle: 0
  8,16   0        0     0.000170189     0  m   N cfq schedule dispatch
  8,16   0        0     0.000397938     0  m   N cfq3805 slice expired t=0
  8,16   0        0     0.000399763     0  m   N cfq3805 sl_used=1 disp=1 charge=1 iops=0 sect=8
  8,16   0        0     0.000400227     0  m   N cfq3805 del_from_rr
  8,16   0        0     0.000400882     0  m   N cfq3805 put_queue

See, there are 19 lines while I only need 2. I don't think it is
appropriate for a user.

So this patch will disable any messages if the BLK_TC_NOTIFY isn't set.
Now the output for the same command will look like:
  8,16   0        1     0.000000000  4908  D   R 114759 + 8 [dd]
  8,16   0        2     0.000146827     0  C   R 114759 + 8 [0]

Yes, it is what I want to see.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 kernel/trace/blktrace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 153562d..d95721f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -138,6 +138,13 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		     !blk_tracer_enabled))
 		return;
 
+	/*
+	 * If the BLK_TC_NOTIFY action mask isn't set, don't send any note
+	 * message to the trace.
+	 */
+	if (!(bt->act_mask & BLK_TC_NOTIFY))
+		return;
+
 	local_irq_save(flags);
 	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
 	va_start(args, fmt);
-- 
1.6.3.GIT

