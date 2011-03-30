Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1C3Pre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:47:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39365 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab1C3Prd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cc34FDc/r9OBxCvnYffIqjIU331s7UkDB5n6iwaa00Dzv8TTqmGpehK81OLi9KgQ9I
         NojN6qhcoJ3lGJn5S5vuc3BIoR0NlI2spbtBnueVqgQlP7WgmehkxNo79YdCZoyl6vlo
         AH+BFimfDluJFDwTaQ5eRxk+ufU0t/9p/qIAY=
Message-ID: <4D93508D.30701@gmail.com>
Date: Wed, 30 Mar 2011 08:47:25 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG] NULL pointer dereference in dev_get_drvdata
References: <1301448497.14261.319.camel@gandalf.stny.rr.com>
In-Reply-To: <1301448497.14261.319.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 06:28 PM, Steven Rostedt wrote:
> While running ktest.pl with randconfig tests on latest Linus (before
> 2.6.38-rc9 was released), several tests triggered a bug similar to this:
>
> Starting udev: udevd-work[880]: '/usr/bin/vmmouse_detect' unexpected exit with status 0x000b
> udevd-work[881]: '/usr/bin/vmmouse_detect' unexpected exit with status 0x000b
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> IP: [<ffffffff818a6e9e>] dev_get_drvdata+0xe/0x39
> PGD 74dc7067 PUD 741ef067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/net/teql0/address
> CPU 1
> Modules linked in: ide_pci_generic iTCO_wdt iTCO_vendor_support ide_core
>
> Pid: 994, comm: v4l_id Not tainted 2.6.38-test-09043-gc585015 #1                  /DG965MQ
> RIP: 0010:[<ffffffff818a6e9e>]  [<ffffffff818a6e9e>] dev_get_drvdata+0xe/0x39
> RSP: 0018:ffff8800743dbb68  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff8800743dbba0 RCX: 0000000000000000
> RDX: ffffffff8408b740 RSI: 0000000000000000 RDI: 0000000000000010
> RBP: ffff8800743dbb68 R08: ffff8800743dbb98 R09: 00000000000023e7
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88007784f888 R14: ffff880076f82140 R15: 0000000000000000
> FS:  00007f4059724700(0000) GS:ffff88007e280000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000018 CR3: 00000000742bb000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process v4l_id (pid: 994, threadinfo ffff8800743da000, task ffff880074dac420)
> Stack:
>   ffff8800743dbb88 ffffffff818e4129 ffff880074dac420 ffffffff8408b740
>   ffff8800743dbbc8 ffffffff818e1865 2222222222222222 2222222222222222
>   ffff88007784f000 0000000000000000 ffff88007784f888 ffff880076f82140
> Call Trace:
>   [<ffffffff818e4129>] st_kim_ref+0x2c/0x42
>   [<ffffffff818e1865>] st_register+0x29/0x444
>   [<ffffffff81dc6415>] fmc_prepare+0x75/0x382
>   [<ffffffff81dc9109>] fm_v4l2_fops_open+0x5a/0xce
>   [<ffffffff81d40bab>] v4l2_open+0x180/0x212
>   [<ffffffff811c6fc5>] chrdev_open+0x1c5/0x204
>   [<ffffffff811c6e00>] ? cdev_put+0x45/0x45
>   [<ffffffff811bf61e>] __dentry_open+0x2a1/0x467
>   [<ffffffff811c0bd8>] nameidata_to_filp+0x75/0x83
>   [<ffffffff811d2c5f>] do_last+0x716/0x902
>   [<ffffffff811d02e7>] ? path_init+0x1fd/0x46f
>   [<ffffffff811d3d07>] path_openat+0x102/0x4cd
>   [<ffffffff811d413d>] do_filp_open+0x6b/0xb5
>   [<ffffffff822671ab>] ? _raw_spin_unlock+0x40/0x4c
>   [<ffffffff811e387e>] ? alloc_fd+0x165/0x17e
>   [<ffffffff811c0c7f>] do_sys_open+0x99/0x16a
>   [<ffffffff811c0d77>] sys_open+0x27/0x30
>   [<ffffffff82270a82>] system_call_fastpath+0x16/0x1b
> Code: 90 55 48 89 e5 0f 1f 44 00 00 48 ff 05 ac 70 5d 02 f0 ff 07 48 ff 05 aa 70 5d 02 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 85 ff 74 20
>   8b 47 08 48 ff 05 97 70 5d 02 48 85 c0 74 10 48 8b 80 b8 00
> RIP  [<ffffffff818a6e9e>] dev_get_drvdata+0xe/0x39
>   RSP<ffff8800743dbb68>
> CR2: 0000000000000018
>
> As not all configs triggered this, but when a config did trigger it, it
> was consistent. I ran the "config-bisect" of ktest.pl to find the dirty
> culprit, and it came up with:
>
> ***************************************
> Found bad config: CONFIG_RADIO_WL128X
> ***************************************
>
> When I removed the config, sure enough, the bug goes away. I added it
> back in and the bug re-appeared.
>
> The .config can be downloaded here:
> http://rostedt.homelinux.com/private/mxtest-boot-randconfig-fail-20110228232103/config
>
> and the full dmesg here:
> http://rostedt.homelinux.com/private/mxtest-boot-randconfig-fail-20110228232103/dmesg
>
> -- Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


strange thing with this, is one instance my screen went black, then 
something similar showed up on screen but then the screen kind of went 
back to normal(was able to move the mouse, but most of everything was 
frozen), another instance was shutting down the system pics are here:

http://www.flickr.com/photos/44066293@N08/5573957179/
http://www.flickr.com/photos/44066293@N08/5574543648/
(not the best camara used)

this does not fire off all the time, but it does.
(I will keep my eye out with this one).

Justin P. Mattock





