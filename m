Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab1EXOqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:46:06 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:56166 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362Ab1EXOqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:46:05 -0400
X-ASG-Debug-ID: 1306248363-01de28096b60b90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDBC4A7.1040104@fusionio.com>
Date: Tue, 24 May 2011 16:45:59 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH 2/2] loop: handle on-demand devices correctly
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com> <1306247761-2246-2-git-send-email-namhyung@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 2/2] loop: handle on-demand devices correctly
In-Reply-To: <1306247761-2246-2-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306248363
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-24 16:36, Namhyung Kim wrote:
> When finding or allocating a loop device, loop_probe() did not take
> partition numbers into account so that it can result to a different
> device. Consider following example:
> 
> $ sudo modprobe loop max_part=15
> $ ls -l /dev/loop*
> brw-rw---- 1 root disk 7,   0 2011-05-24 22:16 /dev/loop0
> brw-rw---- 1 root disk 7,  16 2011-05-24 22:16 /dev/loop1
> brw-rw---- 1 root disk 7,  32 2011-05-24 22:16 /dev/loop2
> brw-rw---- 1 root disk 7,  48 2011-05-24 22:16 /dev/loop3
> brw-rw---- 1 root disk 7,  64 2011-05-24 22:16 /dev/loop4
> brw-rw---- 1 root disk 7,  80 2011-05-24 22:16 /dev/loop5
> brw-rw---- 1 root disk 7,  96 2011-05-24 22:16 /dev/loop6
> brw-rw---- 1 root disk 7, 112 2011-05-24 22:16 /dev/loop7
> $ sudo mknod /dev/loop8 b 7 128
> $ sudo losetup /dev/loop8 ~/temp/disk-with-3-parts.img
> $ sudo losetup -a
> /dev/loop128: [0805]:278201 (/home/namhyung/temp/disk-with-3-parts.img)
> $ ls -l /dev/loop*
> brw-rw---- 1 root disk 7,    0 2011-05-24 22:16 /dev/loop0
> brw-rw---- 1 root disk 7,   16 2011-05-24 22:16 /dev/loop1
> brw-rw---- 1 root disk 7, 2048 2011-05-24 22:18 /dev/loop128
> brw-rw---- 1 root disk 7, 2049 2011-05-24 22:18 /dev/loop128p1
> brw-rw---- 1 root disk 7, 2050 2011-05-24 22:18 /dev/loop128p2
> brw-rw---- 1 root disk 7, 2051 2011-05-24 22:18 /dev/loop128p3
> brw-rw---- 1 root disk 7,   32 2011-05-24 22:16 /dev/loop2
> brw-rw---- 1 root disk 7,   48 2011-05-24 22:16 /dev/loop3
> brw-rw---- 1 root disk 7,   64 2011-05-24 22:16 /dev/loop4
> brw-rw---- 1 root disk 7,   80 2011-05-24 22:16 /dev/loop5
> brw-rw---- 1 root disk 7,   96 2011-05-24 22:16 /dev/loop6
> brw-rw---- 1 root disk 7,  112 2011-05-24 22:16 /dev/loop7
> brw-r--r-- 1 root root 7,  128 2011-05-24 22:17 /dev/loop8
> 
> After this patch, /dev/loop8 - instead of /dev/loop128 - was
> accessed correctly.
> 
> In addition, 'range' passed to blk_register_region() should
> include all range of dev_t that LOOP_MAJOR can address. It does
> not need to be limited by partition numbers unless 'max_loop'
> param was specified.

Thanks, applied. Seems we should mark this for stable.

-- 
Jens Axboe

