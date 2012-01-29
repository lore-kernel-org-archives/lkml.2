Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab2A2KDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 05:03:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56974 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2A2KDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 05:03:05 -0500
Message-ID: <1327831380.14602.6.camel@edumazet-laptop>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Date: Sun, 29 Jan 2012 11:03:00 +0100
In-Reply-To: <20120129055917.GB8513@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	 <20120128125108.GA9661@localhost> <1327757611.7199.6.camel@edumazet-laptop>
	 <20120129055917.GB8513@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 29 janvier 2012 à 13:59 +0800, Wu Fengguang a écrit :

> What's the block size? If it's < 4k, performance might be hurt.
> 
>         blockdev --getbsz /dev/sda
> 

# blockdev --getbsz /dev/sda
4096



> > FYI, I started a bisection.
> 
> Thank you! If the bisection would take much human time, it should be
> easier to collect some blktrace data on reading /dev/sda for analyzes.
> 

Very strange, my bissection ended on following commit :

commit 805f6b5e1cbfedfb9b3d354013e7f4b13a79270f
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Fri Mar 11 20:11:59 2011 +0100

    blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.



This makes no sense.

hdparm uses 2MB block reads, so read_ahead (128KB) is too small for best
perf

# cat /sys/class/block/sda/queue/read_ahead_kb
128

# dd if=/dev/sda of=/dev/null bs=128k 
^C
63744+0 enregistrements lus
63743+0 enregistrements écrits
8354922496 octets (8,4 GB) copiés, 39,975 s, 209 MB/s

# hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads: 510 MB in  3.00 seconds = 169.75 MB/sec

# uname -a
Linux edumazet-laptop 3.0.0-15-generic #26-Ubuntu SMP Fri Jan 20
17:23:00 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux



