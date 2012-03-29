Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab2C2SYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:24:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39788 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab2C2SYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120329155542.GA31285@redhat.com>
References: <20120329155542.GA31285@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 11:23:57 -0700
X-Google-Sender-Auth: LljK7cC38JaEhV7IFTk3VrzjK70
Message-ID: <CA+55aFySh2VJ3+Hdu8oFR3oBERS0uh=3ezBsbkWQNfsLHSDyqw@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 8:55 AM, Dave Jones <davej@redhat.com> wrote:
> In v3.3-8839-gb5174fa I see some behaviour on my laptop
> that I haven't noticed on other machines.
> It boots up, I can log in, and start up a terminal, firefox, banshee
> and use the system, and all is good. Then if I lock the screen,
> walk away for a while and come back to it, the loadavg has sky-rocketed,
> and every process is hung. Trying to run any commands that perform disk io
> hang immediately.
>
> There's a (truncated) sysrq-t output at http://codemonkey.org.uk/junk/process-trace.txt
>
> Top showed kworker was going nuts. Trying to run perf resulted in a black screen.

Ok, so the filesystem and the disk do seem to be very active. That
could be normal, but I assume this trace was done at a time when you
*expected* the system to be idle.

Your process trace has quite a few processes waiting for disk or filesystem:

3x firefox (these are waiting for the sys_mmap below):
  schedule+0x29/0x70
  rwsem_down_failed_common+0xb5/0x150
  rwsem_down_read_failed+0x15/0x17
  call_rwsem_down_read_failed+0x14/0x30
  do_page_fault+0x1b6/0x5d0
  page_fault+0x25/0x30

firefox (this one is waiting for the page fault below to finish):
  schedule+0x29/0x70
  rwsem_down_failed_common+0xb5/0x150
  rwsem_down_write_failed+0x13/0x20
  call_rwsem_down_write_failed+0x13/0x20
  sys_mmap_pgoff+0x125/0x210
  sys_mmap+0x22/0x30
  system_call_fastpath+0x16/0x1b

firefox (waiting for the jbd2 journal):
  schedule+0x29/0x70
  start_this_handle+0x2dd/0x6d0
  jbd2__journal_start+0x12a/0x1a0
  jbd2_journal_start+0x13/0x20
  ext4_journal_start_sb+0x7e/0x2d0
  ext4_dirty_inode+0x26/0x60
  __mark_inode_dirty+0x3c/0x240
  file_update_time+0xd7/0x140
  do_wp_page+0x3ec/0x720
  handle_pte_fault+0x27d/0xa10
  handle_mm_fault+0x1e8/0x2f0
  do_page_fault+0x16b/0x5d0
  page_fault+0x25/0x30

npviewer.bin (waiting for inode->i_mutex - apparently the same file as
'banshee'):
  __mutex_lock_common+0x1b5/0x4c0
  mutex_lock_nested+0x44/0x50
  generic_file_aio_write+0x58/0xe0
  ext4_file_write+0xca/0x270
  do_sync_write+0xd2/0x110
  vfs_write+0xb6/0x180
  sys_write+0x4d/0x90
  sysenter_dispatch+0x7/0x26

banshee (waiting on actual IO):
  schedule+0x29/0x70
  io_schedule+0x8f/0xd0
  sleep_on_page+0xe/0x20
  __wait_on_bit+0x5f/0x90
  wait_on_page_bit+0x78/0x80
  grab_cache_page_write_begin+0xae/0xf0
  ext4_da_write_begin+0xa0/0x2e0
  generic_file_buffered_write+0x107/0x2c0
  __generic_file_aio_write+0x22c/0x440
  generic_file_aio_write+0x74/0xe0
  ext4_file_write+0xca/0x270
  do_sync_write+0xd2/0x110
  vfs_write+0xb6/0x180
  sys_write+0x4d/0x90
  system_call_fastpath+0x16/0x1b

xscreensaver-co D (waiting for the ext4 journal):
  schedule+0x29/0x70
  start_this_handle+0x2dd/0x6d0
  jbd2__journal_start+0x12a/0x1a0
  jbd2_journal_start+0x13/0x20
  ext4_journal_start_sb+0x7e/0x2d0
  ext4_dirty_inode+0x26/0x60
  __mark_inode_dirty+0x3c/0x240
  file_update_time+0xd7/0x140
  __generic_file_aio_write+0x1f8/0x440
  generic_file_aio_write+0x74/0xe0
  ext4_file_write+0xca/0x270
  do_sync_write+0xd2/0x110
  vfs_write+0xb6/0x180
  sys_write+0x4d/0x90
  system_call_fastpath+0x16/0x1b

kworker/1:0 D (waiting for scsi_test_unit_ready):
  schedule+0x29/0x70
  schedule_timeout+0x385/0x4f0
  wait_for_common+0x112/0x160
  wait_for_completion+0x1d/0x20
  blk_execute_rq+0x1b8/0x200
  scsi_execute+0xee/0x180
  scsi_execute_req+0xbd/0x130
  scsi_test_unit_ready+0x9d/0x140
  sd_check_events+0x12e/0x1c0
  disk_events_workfn+0x62/0x120
  process_one_work+0x1d3/0x740
  worker_thread+0x15f/0x350
  kthread+0xb7/0xc0
  kernel_thread_helper+0x4/0x10

so it ostensibly looks like a disk driver thing, but at the same time
what I find very surprising is that these are all waiting for
*writes*.

And quite frankly, that's quite unusual. Writes are often async, so
when the disk goes south it usually shows up as people waiting for the
*reads*. Sure, eventually the flushing gets to be synchronous and you
*also* get writers blocked, but from my experience it tends to be the
readers that block first.

Now, it's a truncated list of processes, and looking at the lock data
at the end there are some missing processes that are clearly also
stuck:

  1 lock held by xfconfd/1512:
  #0:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<ffffffff811d42bb>]
do_last+0x38b/0x900

but even that looks like a *writer* because anything blocked within
that do_last() function would likely be blocked on "vfs_create()":
it's somebody opening a non-existing file with O_CREAT.

Now, lack of readers *may* be because you have everything cached, so
maybe I'm just barking up the wrong tree, but my gut feel is that this
mig hbe writeback-related rather than necessarily related to disk IO
itself.

That's doubly true since I see processes waiting for the journal lock,
but I don't actually see anything waiting for journal IO completion.
Did something not release the journal lock. Even banshee - that *is*
waiting for actual IO - seems to wait for page_writeback, which is not
done by the *disk* driver, but by the filesystem (end_page_writeback).
So that would be consistent with the ext4 changes having broken that.

Was there a previous post-3.3 git kernel that worked?

                      Linus
