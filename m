Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1J3UfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 16:35:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47052 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1J3UfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 16:35:10 -0400
Date: Sun, 30 Oct 2011 13:35:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
 (Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111030203503.GB7696@google.com>
References: <20110903221456.GA2877@elie>
 <20110904024244.GB3083@htj.dyndns.org>
 <87y5y37o7h.fsf@servo.factory.finestructure.net>
 <20110906174524.GN18425@mtj.dyndns.org>
 <20110907085037.GX10237@login.drsnuggles.stderr.nl>
 <20110911040826.GP29319@htj.dyndns.org>
 <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
 <20111026182650.GL14392@login.drsnuggles.stderr.nl>
 <20111026222510.GK24261@google.com>
 <20111028134743.GU14392@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028134743.GU14392@login.drsnuggles.stderr.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 28, 2011 at 03:47:43PM +0200, Matthijs Kooijman wrote:
> I'm not sure if the FRAME_POINTER option actually works, though, since I
> couldn't find any obvious differences in the format of the stack traces?

The lines w/o leading "?" are from stack frames discovered by
following frame pointer.  The ones w/ "?" are from dumb stack
scanning.  w/o FP, it wouldn't be possible to tell between the actual
ones from the spurious ones.

So, the following kworker is what the scsi_id is waiting for in
flush_work().

 kworker/2:1     D ffff880206054830     0 10775      2 0x00000000
  ffff880206067aa0 0000000000000046 ffff880206067a50 ffffffff8105476d
  ffff88022ed58140 ffff880206067fd8 ffff880206067fd8 0000000000012f40
  ffff880206054830 ffff88022ed58140 ffff880200000002 0000000000000286
 Call Trace:
  [<ffffffff8134c996>] schedule+0x55/0x57
  [<ffffffff8134cc9f>] schedule_timeout+0xa2/0xd9
  [<ffffffff8134c832>] wait_for_common+0x9e/0x115
  [<ffffffff8134c925>] wait_for_completion_timeout+0xe/0x10
  [<ffffffff8119c502>] blk_execute_rq+0xb7/0xf9
  [<ffffffffa0043044>] scsi_execute+0xf5/0x14d [scsi_mod]
  [<ffffffffa004311e>] scsi_execute_req+0x82/0xb4 [scsi_mod]
  [<ffffffffa00bb2d9>] sr_check_events+0x92/0x21e [sr_mod]
  [<ffffffffa009d04b>] cdrom_check_events+0x14/0x29 [cdrom]
  [<ffffffffa00bb696>] sr_block_check_events+0x14/0x16 [sr_mod]
  [<ffffffff8119ea7b>] disk_events_workfn+0x3b/0xd7
  [<ffffffff8105dcc9>] process_one_work+0x165/0x27a
  [<ffffffff8105ed4f>] worker_thread+0xce/0x152
  [<ffffffff81061f6c>] kthread+0x7f/0x87
  [<ffffffff81355034>] kernel_thread_helper+0x4/0x10

The kworker submitted request but it got lost during queue destruction
and blk_execute_rq() hangs.  There have been a number of recent
changes in block devel tree to address this issue.  Can you please
test the following branch?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ref

Thanks.

-- 
tejun
