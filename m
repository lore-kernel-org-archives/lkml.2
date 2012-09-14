Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2INV1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:27:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55852 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2INV1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:27:22 -0400
Date: Fri, 14 Sep 2012 23:27:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120914212717.GA29307@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding everybody to CC and leaving the below for reference.)

Guys,

as Nikolay says below, we have a regression in 3.6 with pgbench's
benchmark in postgresql.

I was able to reproduce it on another box here and did a bisection run.
It pointed to the commit below.

And yes, reverting that commit fixes the issue here.

@Nikolay: can you try reverting it from 3.6-rc5 and check whether the
regression dissapears at your end?

Thanks.

commit 970e178985cadbca660feb02f4d2ee3a09f7fdda
Author: Mike Galbraith <efault@gmx.de>
Date:   Tue Jun 12 05:18:32 2012 +0200

    sched: Improve scalability via 'CPU buddies', which withstand random perturbations
    
    Traversing an entire package is not only expensive, it also leads to tasks
    bouncing all over a partially idle and possible quite large package.  Fix
    that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
    to motivate that one other CPU, if it's busy, tough, it may then try its
    SMT sibling, but that's all this optimization is allowed to cost.
    
    Sibling cache buddies are cross-wired to prevent bouncing.
    
    4 socket 40 core + SMT Westmere box, single 30 sec tbench runs, higher is better:
    
     clients     1       2       4        8       16       32       64      128
     ..........................................................................
     pre        30      41     118      645     3769     6214    12233    14312
     post      299     603    1211     2418     4697     6847    11606    14557
    
    A nice increase in performance.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Link: http://lkml.kernel.org/r/1339471112.7352.32.camel@marge.simpson.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>


On Fri, Sep 14, 2012 at 10:47:44AM +0300, Nikolay Ulyanitsky wrote:
> Hi
> I compiled the 3.6-rc5 kernel with the same config from 3.5.3 and got
> the 15-20% performance drop of PostgreSQL 9.2 on AMD chipsets (880G,
> 990X).
> 
> CentOS 6.3 x86_64
> PostgreSQL 9.2
> cpufreq scaling_governor - performance
> 
> # /etc/init.d/postgresql initdb
> # echo "fsync = off" >> /var/lib/pgsql/data/postgresql.conf
> # /etc/init.d/postgresql start
> # su - postgres
> $ psql
> # create database pgbench;
> # \q
> 
> # pgbench -i pgbench && pgbench -c 10 -t 10000 pgbench
> tps = 4670.635648 (including connections establishing)
> tps = 4673.630345 (excluding connections establishing)[/code]
> 
> On kernel 3.5.3:
> tps = ~5800
> 
> 1) Host 1 - 15-20% performance drop
> AMD Phenom(tm) II X6 1090T Processor
> MB: AMD 880G
> RAM: 16 Gb DDR3
> SSD: PLEXTOR PX-256M3 256Gb
> 
> 2) Host 2 - 15-20% performance drop
> AMD Phenom(tm) II X6 1055T Processor
> MB: AMD 990X
> RAM: 32 Gb DDR3
> SSD: Corsair Performance Pro 128Gb
> 
> 3) Host 3 - no problems - same performance
> Intel E6300
> MB: Intel® P43 / ICH10
> RAM: 4 Gb DDR3
> HDD: SATA 7200 rpm
> 
> Kernel config - http://pastebin.com/cFpg5JSJ
> 
> Any ideas?
> 
> Thx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
