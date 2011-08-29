Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1H2Apy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 20:45:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1H2Apu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 20:45:50 -0400
Message-ID: <4E5AE138.20408@gmail.com>
Date: Mon, 29 Aug 2011 02:45:44 +0200
From: Nebojsa Trpkovic <trx.lists@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110822 Thunderbird/6.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: cleancache can lead to serious performance degradation
References: <4E4C395E.20000@gmail.com 20110825041212.GA5014@dumpdata.com> <3aef71a8-d390-4a91-bfef-561c89edc040@default>
In-Reply-To: <3aef71a8-d390-4a91-bfef-561c89edc040@default>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you everybody for reviewing my report.

On 08/25/11 18:56, Dan Magenheimer wrote:
> Are your measurements on a real workload or a benchmark?  Can
> you describe your configuration more (e.g. number of spindles
> -- or SSDs?).  Is any swapping occurring?

I've noticed performance degradation during the real workload. I did not 
run any special benchmarks to prove this problem. All my conclusions are 
based on everyday usage case scenarios.

I use multi-purpose (read: all-purpose) server with Intel Core 2 Duo 
E6550, 8GB DDR2, 4 1Gbps NICs and 16 1.5TB 5.4k rpm hard drives in LAN 
with ~50 workstations and WAN with couple of hundreds clients.
Usually, 50 to 60% of RAM is used by "applications". Most of the rest is 
used for cache. Swap allocation is usually less then 100MB (divided to 
three spindles). Swapping is rare (I monitor both swap usage in MB and 
swap reads/writes along with many other parameters).
Drives are partitioned and some of partitions are stand-alone, some are 
in software RAID1 and some are in software RAID5, all depending of the 
partition purpose. Spindles are slow, but RAID5 gives us possibility to 
reach throughputs high enough to get affected with cleancache/zcache.
Just an insight in _synthetic_ RAID5 performance during the light/night 
server load (not an isolated test with all other services shot down):
/dev/md2:
  Timing buffered disk reads: 1044 MB in  3.00 seconds = 347.73 MB/sec
/dev/md3:
  Timing buffered disk reads: 1078 MB in  3.02 seconds = 356.94 MB/sec
/dev/md4:
  Timing buffered disk reads: 1170 MB in  3.00 seconds = 389.86 MB/sec

Scenarios affected by cleancache/zcache usage include:
- hashing of directconnect (DC++) shares on RAID5 arrays full of big 
files like ISO images (~120MB/s without cleancache/zcache as microdc2 
uses just one thread to hash)
- copying big files to my workstation using gigabit LAN with destination 
to a SSD (without cleancache/zcache up to ~105MB/s via NFS and ~117MB/s 
via FTP)
- copying big files between RAID5 arrays that do not have any common spindle
(without cleancache/zcache performance varies heavily based on current 
server workload: 150 - 250MB/s)

In all these scenarios, using cleancache/zcache caps throughput to 
60-70MB/s.

> First, I don't recommend that zcache+cleancache be used without
> frontswap, because the additional memory pressure from saving
> compressed clean pagecache pages may sometimes result in swapping
> (and frontswap will absorb much of the performance loss).  I know
> frontswap isn't officially merged yet, but that's an artifact of
> the process for submitting a complex patchset (transcendent memory)
> that crosses multiple subsystems.  (See https://lwn.net/Articles/454795/
> if you're not familiar with the whole transcendent memory picture.)

I'll do my best to get familiar with the whole transcendent memory story 
and give it a try to frontswap as soon as I can. Unfortunately, I'm 
afraid that I'll have to postpone that at least for couple of weeks.

>>> - if there's no available CPU time, just store (or throw away) to
>>> avoid IO waits;
>
> Any ideas on how to code this test (for "no available CPU time")?

I cannot help with this question as I have no practical experience in 
code development, especially OS related, but maybe some approach similar 
to other kernel systems could by used. For an example, cpufreq makes 
decisions for CPU clock changes based on current CPU usage by sampling 
recent load/usage statistics. Obviously, I have no idea if something 
similar could be used with zcache, but this was my best shot. :)

> If you have any more comments or questions, please cc me directly
> as I'm not able to keep up with all the lkml traffic, especially
> when traveling... when you posted this I was at Linuxcon 2011
> talking about transcendent memory!  See:
> http://events.linuxfoundation.org/events/linuxcon/magenheimer

Please, CC me directly on any further messages regarding this problem, too.

Last but not least, thank you for developing such a great feature for 
Linux kernel!

Best Regards,
Nebojsa Trpkovic


