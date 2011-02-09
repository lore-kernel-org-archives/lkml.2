Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1BIRie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:38:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab1BIRic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:38:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf on 2.6.38-rc4 wedges my box
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 09 Feb 2011 12:38:10 -0500
Message-ID: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying out willy's ata_ram driver[1], and in so doing have managed to
wedge my box while using perf record on an aio-stress run:

[root@metallica ~]# modprobe ata_ram capacity=2097152 preallocate=1
[root@metallica ~]# ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
adding stage write
starting with write
file size 1024MB, record size 4KB, depth 32, ios per iteration 8
max io_submit 16, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
adding file /dev/sds thread 0
write on /dev/sds (621.30 MB/s) 1024.00 MB in 1.65s
thread 0 write totals (621.27 MB/s) 1024.00 MB in 1.65s
[root@metallica ~]# perf record -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16
/dev/sds
adding stage write
starting with write
file size 1024MB, record size 4KB, depth 32, ios per iteration 8
max io_submit 16, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
adding file /dev/sds thread 0

and there it sits.  On the console, I see:

NOHZ: local_softirq_pending 100
NOHZ: local_softirq_pending 100
NOHZ: local_softirq_pending 100
NOHZ: local_softirq_pending 100
NOHZ: local_softirq_pending 100

The number of messages varies, but this is the most I've seen (it
doesn't keep repeating).  At this point, the machine does not respond to
pings.  As I don't have physical access at the moment, I can't try
alt-sysrq, but might be able to do that tomorrow.  It's probably worth
noting that I've witnessed similar behavior with real devices, so it's
not just the ata_ram driver.

Any ideas on how to track this down?

Thanks!

Jeff

[1] http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=refs/heads/ata-ram
