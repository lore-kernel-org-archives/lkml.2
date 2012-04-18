Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2DRC1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:27:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2DRC1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:27:09 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=_2gBi4Ny9w4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=20KFwNOVAAAA:8 a=ayC55rCoAAAA:8 a=YnrGApNhv-q1ErT23nQA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Tue, 17 Apr 2012 22:27:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418022705.GA23877@home.goodmis.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 06:36:00PM -0700, Linus Torvalds wrote:
> On Tue, Apr 17, 2012 at 1:32 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > Ok, this builds. I'll run with this for a while, and see what falls out.
> 
> So assuming that works and doesn't have some silly thinko in it, I
> think it is a worthwhile addition to the whole stack debugging thing.
> Right now, the message about "process xyz used most stack, x bytes
> free" really is pretty useless. If it were to actually show "hey, this
> was the deepest actual stack chain", that sounds quite interesting.
> 
> Of course, if the stack is largely used by some leaf function that
> just has a big stack frame, that won't show up in the stack trace, but
> that's presumably not the worst worry. And hopefully the caller of
> that would still be pretty deep and show up without having been
> overwritten.

Note we have something that checks the stack, even on leaf functions.

Enable CONFIG_STACK_TRACER

and then enable it with the following:

# echo 1 > /proc/sys/kernel/stack_tracer_enabled
# cat /sys/kernel/debug/tracing/stack_trace
        Depth    Size   Location    (40 entries)
        -----    ----   --------
  0)     3056     208   select_task_rq_fair+0x30b/0x8b2
  1)     2848      96   try_to_wake_up+0xc7/0x30e
  2)     2752      16   default_wake_function+0x12/0x14
  3)     2736      32   autoremove_wake_function+0x16/0x39
  4)     2704      80   __wake_up_common+0x4e/0x84
  5)     2624      64   __wake_up+0x39/0x4d
  6)     2560      64   insert_work+0x8e/0x9b
  7)     2496      48   __queue_work+0x2f/0x41
  8)     2448      16   queue_work_on+0x48/0x4f
  9)     2432      16   queue_work+0x1f/0x21
 10)     2416      16   queue_delayed_work+0x13/0x28
 11)     2400      32   ata_pio_queue_task+0x35/0x39
 12)     2368      32   ata_sff_qc_issue+0x1e9/0x222
 13)     2336      96   ata_qc_issue+0x25e/0x29c
 14)     2240      80   __ata_scsi_queuecmd+0x193/0x1ef
 15)     2160      80   ata_scsi_queuecmd+0x59/0x93
 16)     2080      48   scsi_dispatch_cmd+0x1b1/0x233
 17)     2032      96   scsi_request_fn+0x385/0x4d8
 18)     1936      32   __generic_unplug_device+0x32/0x36
 19)     1904      48   blk_execute_rq_nowait+0x77/0x9e
 20)     1856     176   blk_execute_rq+0xa6/0xde
 21)     1680      80   scsi_execute+0xf6/0x148
 22)     1600     128   scsi_execute_req+0xa9/0xdb
 23)     1472      96   sr_test_unit_ready+0x65/0xcb
 24)     1376     160   sr_media_change+0x9f/0x2cd
 25)     1216      48   media_changed+0x54/0x8c
 26)     1168      16   cdrom_media_changed+0x31/0x37
 27)     1152      16   sr_block_media_changed+0x19/0x1b
 28)     1136      32   check_disk_change+0x29/0x5b
 29)     1104     208   cdrom_open+0x3d7/0x4b2
 30)      896      64   sr_block_open+0x90/0xad
 31)      832      96   __blkdev_get+0xd3/0x358
 32)      736      16   blkdev_get+0x10/0x12
 33)      720      48   blkdev_open+0x76/0xac
 34)      672      96   __dentry_open+0x199/0x2d2
 35)      576      32   nameidata_to_filp+0x42/0x53
 36)      544     320   do_filp_open+0x4f1/0x9d6
 37)      224      80   do_sys_open+0x63/0x10f
 38)      144      16   sys_open+0x20/0x22
 39)      128     128   system_call_fastpath+0x16/0x1b


You can also use trace-cmd to handle this:

# trace-cmd stack --start
# trace-cmd stack
        Depth    Size   Location    (24 entries)
        -----    ----   --------
  0)     2480      48   lock_timer_base+0x2c/0x52
  1)     2432      96   __mod_timer+0x3e/0x15e
  2)     2336      16   mod_timer_pending+0x15/0x17
  3)     2320      64   __nf_ct_refresh_acct+0x60/0xd9
  4)     2256     272   tcp_packet+0xe17/0x10e7
  5)     1984     224   nf_conntrack_in+0x687/0x86e
  6)     1760      16   ipv4_conntrack_local+0x40/0x49
  7)     1744      80   nf_iterate+0x46/0x89
  8)     1664     112   nf_hook_slow+0x6a/0xcb
  9)     1552      32   nf_hook_thresh.clone.0+0x41/0x4a
 10)     1520      16   __ip_local_out+0x7e/0x80
 11)     1504      32   ip_local_out+0x16/0x29
 12)     1472     176   ip_queue_xmit+0x30e/0x37f
 13)     1296     128   tcp_transmit_skb+0x64d/0x68b
 14)     1168     144   tcp_write_xmit+0x80d/0x8fc
 15)     1024      32   __tcp_push_pending_frames+0x2f/0x5d
 16)      992      16   tcp_push+0x88/0x8a
 17)      976     176   tcp_sendmsg+0x77b/0x876
 18)      800      64   __sock_sendmsg+0x61/0x6c
 19)      736     176   sock_aio_write+0xc0/0xd4
 20)      560     304   do_sync_write+0xe8/0x125
 21)      256      64   vfs_write+0xc1/0x10b
 22)      192      64   sys_write+0x4a/0x6e
 23)      128     128   system_call_fastpath+0x16/0x1b
# trace-cmd stack --stop

This also shows you the size of stack each function took up.

-- Steve

