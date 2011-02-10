Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1BJVhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:37:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1BJVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:37:24 -0500
Subject: Re: perf on 2.6.38-rc4 wedges my box
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 22:38:25 +0100
Message-ID: <1297373905.5226.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 12:38 -0500, Jeff Moyer wrote:
> Hi,
> 
> I'm trying out willy's ata_ram driver[1], and in so doing have managed to
> wedge my box while using perf record on an aio-stress run:
> 
> [root@metallica ~]# modprobe ata_ram capacity=2097152 preallocate=1
> [root@metallica ~]# ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
> adding stage write
> starting with write
> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
> max io_submit 16, buffer alignment set to 4KB
> threads 1 files 1 contexts 1 context offset 2MB verification off
> adding file /dev/sds thread 0
> write on /dev/sds (621.30 MB/s) 1024.00 MB in 1.65s
> thread 0 write totals (621.27 MB/s) 1024.00 MB in 1.65s
> [root@metallica ~]# perf record -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16
> /dev/sds
> adding stage write
> starting with write
> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
> max io_submit 16, buffer alignment set to 4KB
> threads 1 files 1 contexts 1 context offset 2MB verification off
> adding file /dev/sds thread 0
> 
> and there it sits.  On the console, I see:
> 
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> NOHZ: local_softirq_pending 100
> 
> The number of messages varies, but this is the most I've seen (it
> doesn't keep repeating).  At this point, the machine does not respond to
> pings.  As I don't have physical access at the moment, I can't try
> alt-sysrq, but might be able to do that tomorrow.  It's probably worth
> noting that I've witnessed similar behavior with real devices, so it's
> not just the ata_ram driver.
> 
> Any ideas on how to track this down?

So I took linus' tree of about half an hour ago, added
git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git ata-ram
(fixed up some Kconfig/Makefile rejects), google'd aio-stress
(http://fsbench.filesystems.org/bench/aio-stress.c) and set out to
reproduce the above..

Sadly it all seems to work here, its spending ~15% in
_raw_spin_lock_irq, which when I use -g looks to break down like:

-     14.13%  aio-stress  [kernel.kallsyms]  [k] _raw_spin_lock_irq 
   - _raw_spin_lock_irq                                             
      + 44.14% __make_request                                       
      + 20.91% __aio_get_req                                        
      + 10.15% aio_run_iocb                                         
      + 7.37% do_io_submit                                          
      + 6.55% scsi_request_fn                                       
      + 5.48% generic_unplug_device                                 
      + 3.58% aio_put_req                                           
      + 0.92% generic_make_request                                  
      + 0.91% __generic_unplug_device



