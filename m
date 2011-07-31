Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1GaUUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:20:35 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:56438 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab1GaUU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:20:28 -0400
X-ASG-Debug-ID: 1312143627-03d6a510aa2128d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E35B908.6090507@fusionio.com>
Date: Sun, 31 Jul 2011 22:20:24 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: loop: fix deadlock when sysfs and LOOP_CLR_FD race against each
  other
References: <1312053553.1187.17.camel@mop>
X-ASG-Orig-Subj: Re: loop: fix deadlock when sysfs and LOOP_CLR_FD race against each
  other
In-Reply-To: <1312053553.1187.17.camel@mop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312143627
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70528
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-30 21:19, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: loop: fix deadlock when sysfs and LOOP_CLR_FD race against each other
> 
> LOOP_CLR_FD takes lo->lo_ctl_mutex and tries to remove the loop sysfs
> files. Sysfs calls show() and waits for lo->lo_ctl_mutex. LOOP_CLR_FD
> waits for show() to finish to remove the sysfs file.
> 
>   cat /sys/class/block/loop0/loop/backing_file
>     mutex_lock_nested+0x176/0x350
>     ? loop_attr_do_show_backing_file+0x2f/0xd0 [loop]
>     ? loop_attr_do_show_backing_file+0x2f/0xd0 [loop]
>     loop_attr_do_show_backing_file+0x2f/0xd0 [loop]
>     dev_attr_show+0x1b/0x60
>     ? sysfs_read_file+0x86/0x1a0
>     ? __get_free_pages+0x12/0x50
>     sysfs_read_file+0xaf/0x1a0
> 
>   ioctl(LOOP_CLR_FD):
>     wait_for_common+0x12c/0x180
>     ? try_to_wake_up+0x2a0/0x2a0
>     wait_for_completion+0x18/0x20
>     sysfs_deactivate+0x178/0x180
>     ? sysfs_addrm_finish+0x43/0x70
>     ? sysfs_addrm_start+0x1d/0x20
>     sysfs_addrm_finish+0x43/0x70
>     sysfs_hash_and_remove+0x85/0xa0
>     sysfs_remove_group+0x59/0x100
>     loop_clr_fd+0x1dc/0x3f0 [loop]
>     lo_ioctl+0x223/0x7a0 [loop]
> 
> Instead of taking the lo_ctl_mutex from sysfs code, take the inner
> lo->lo_lock, to protect the access to the backing_file data.
> 
> Thanks to Tejun for help debugging and finding a solution.

Looks good, looks like something that should have a stable tag as well?

-- 
Jens Axboe

