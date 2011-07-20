Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab1GTInx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 04:43:53 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:36466 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab1GTInv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 04:43:51 -0400
X-Greylist: delayed 1051 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jul 2011 04:43:51 EDT
Date: Wed, 20 Jul 2011 10:26:40 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: k-ueda@ct.jp.nec.com
Cc: agk@redhat.com, linux-kernel@vger.kernel.org
Subject: request baset device mapper in Linux
Message-ID: <20110720082640.GZ7561@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.73.218
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 20 Jul 2011 10:26:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encouter serious problems with you commit
cec47e3d4a861e1d942b3a580d0bbef2700d2bb2 introducing request based device
mapper in Linux.

I got machine with 80 SATA disks connected to two LSI SAS 2.0 controller
(mpt2sas driver).

All disks are configured as multipath devices in failover mode:

defaults {
        udev_dir        /dev
        polling_interval 10
        selector        "round-robin 0"
        path_grouping_policy    failover
        path_checker    directio
        rr_min_io       100
        no_path_retry   queue
        user_friendly_names no
}

if I run the following command, ksoftirqd eats 100% CPU as soon as all
available memory is used for buffers.

for i in `seq 0 79`; do dd if=/dev/dm-$i of=/dev/null bs=1M count=10000 & done

top looks like this:

Mem:     48390M total,    45741M used,     2649M free,    43243M buffers
Swap:        0M total,        0M used,        0M free,     1496M cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                       
   12 root      20   0     0    0    0 R   96  0.0   0:38.78 ksoftirqd/4                                   
17263 root      20   0  9432 1752  616 R   14  0.0   0:03.19 dd                                            
17275 root      20   0  9432 1756  616 D   14  0.0   0:03.16 dd                                            
17271 root      20   0  9432 1756  616 D   10  0.0   0:02.60 dd                                            
17258 root      20   0  9432 1756  616 D    7  0.0   0:02.67 dd                                            
17260 root      20   0  9432 1756  616 D    7  0.0   0:02.47 dd                                            
17262 root      20   0  9432 1752  616 D    7  0.0   0:02.38 dd                                            
17264 root      20   0  9432 1756  616 D    7  0.0   0:02.42 dd                                            
17267 root      20   0  9432 1756  616 D    7  0.0   0:02.35 dd                                            
17268 root      20   0  9432 1756  616 D    7  0.0   0:02.45 dd                                            
17274 root      20   0  9432 1756  616 D    7  0.0   0:02.47 dd                                            
17277 root      20   0  9432 1756  616 D    7  0.0   0:02.53 dd                                            
17261 root      20   0  9432 1756  616 D    7  0.0   0:02.36 dd                                            
17265 root      20   0  9432 1756  616 R    7  0.0   0:02.47 dd                                            
17266 root      20   0  9432 1756  616 R    7  0.0   0:02.44 dd                                            
17269 root      20   0  9432 1756  616 D    7  0.0   0:02.62 dd                                            
17270 root      20   0  9432 1756  616 D    7  0.0   0:02.46 dd                                            
17272 root      20   0  9432 1756  616 D    7  0.0   0:02.36 dd                                            
17273 root      20   0  9432 1756  616 D    7  0.0   0:02.46 dd                                            
17276 root      20   0  9432 1752  616 D    7  0.0   0:02.36 dd                                            
17278 root      20   0  9432 1752  616 D    7  0.0   0:02.44 dd                                            
17259 root      20   0  9432 1752  616 D    6  0.0   0:02.37 dd 


It looks like device mapper produces long SG lists and  end_clone_bio() has
someting like quadratic complexity.

The problem can be workarounded using:
for i in /sys/block/dm-*; do echo 128 > $i/queue/max_sectors_kb; done

to short SG lists.

I use SLES 2.6.32.36-0.5-default kernel.

Using iostat -x, I can see there is about 25000 rrmq/s, while there is only
180 r/s, so it looks like each bio contains more then 100 requests which makes
serious troubles for ksoftirqd call backs.

Without the mentioned workeround, I got only 600MB/s sum of all dd readers.
With workernoud, I got about 2.8GB/s sum of all dd readers.

-- 
Luká¹ Hejtmánek
