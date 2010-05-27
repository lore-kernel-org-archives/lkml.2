Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0E0DE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:04:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab0E0DEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:04:25 -0400
Message-ID: <4BFDE1CE.4030100@cn.fujitsu.com>
Date: Thu, 27 May 2010 11:06:54 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
References: <1274461422-18433-1-git-send-email-josef@redhat.com> <1274461422-18433-6-git-send-email-josef@redhat.com>
In-Reply-To: <1274461422-18433-6-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2010 01:03 AM, Josef Bacik wrote:
> In order for AIO to work, we need to implement aio_write.  This patch converts
> our btrfs_file_write to btrfs_aio_write.  I've tested this with xfstests and
> nothing broke, and the AIO stuff magically started working.  Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
>   

Hi, Josef,

I've tested your patch(May 22) with my tools, and one case triggered a bug
which made writev operation hang up, more information is followed.

- Steps to trigger it:
  # mount /dev/sda8 /home/btrfsdisk -o nodatacow
  # gcc direct-io.c -o direct-io
  # ./direct-io O_DIRECT writev /home/btrfsdisk/testrw 4M

then on another tty, after "dmesg"...

[snip]
device fsid f44b0879c75c0e99-1d4b28f2d5c503ae devid 1 transid 11177
/dev/sda8
btrfs: setting nodatacow
INFO: task direct-io:1399 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
direct-io     D 0000000000000003     0  1399   1341 0x00000000
 ffff880137c379c8 0000000000000082 ffff880137c379d8 ffffffff00000000
 ffff880137c37fd8 ffff880139730000 0000000000015440 ffff880137c37fd8
 0000000000015440 0000000000015440 0000000000015440 0000000000015440
Call Trace:
 [<ffffffffa0119d4a>] wait_extent_bit+0xe3/0x163 [btrfs]
 [<ffffffff8106651f>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa0119e47>] lock_extent_bits+0x7d/0xa8 [btrfs]
 [<ffffffffa0119e88>] lock_extent+0x16/0x18 [btrfs]
 [<ffffffffa01025ce>] btrfs_direct_IO+0x8e/0x1be [btrfs]
 [<ffffffff810c7301>] generic_file_direct_write+0xed/0x16d
 [<ffffffffa010bb91>] btrfs_file_aio_write+0x2af/0x8d2 [btrfs]
 [<ffffffff81100eae>] ? try_get_mem_cgroup_from_mm+0x39/0x49
 [<ffffffffa010b8e2>] ? btrfs_file_aio_write+0x0/0x8d2 [btrfs]
 [<ffffffff811063ed>] do_sync_readv_writev+0xc1/0x100
 [<ffffffff81106120>] ? might_fault+0x21/0x23
 [<ffffffff81106151>] ? copy_from_user+0x2f/0x31
 [<ffffffff811c90ab>] ? security_file_permission+0x16/0x18
 [<ffffffff81107145>] do_readv_writev+0xa7/0x127
 [<ffffffff81107208>] vfs_writev+0x43/0x4e
 [<ffffffff811072f8>] sys_writev+0x4a/0x93
 [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b


So, can you figure out if anything in your patch leads to the bug?
