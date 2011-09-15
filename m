Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab1IONgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:36:40 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:57451 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IONgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:36:38 -0400
Date: Thu, 15 Sep 2011 15:36:36 +0200
From: David Madore <david+ml@madore.org>
To: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>
Subject: processes (e.g. "ps auxw") frozen in uninterruptible wait while
 reshaping RAID array
Message-ID: <20110915133636.GA7289@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I don't know whether this is worth reporting or whether this belongs
to the "well, what did you expect?" category.

I recently did a heavy RAID reshape operation on a 3.1.0-rc6 kernel,
converting lots of arrays from RAID5-over-3-disks to
RAID6-over-4-disks (with a backup file located on a fifth, external,
disk).  The reshape itself worked correctly, but while it took place,
a number of processes remained frozen in uninterruptible wait state.
And when I say "frozen", I mean that no progress whatsoever took place
during the reshape (except possibly when moving from one array to the
next), it wasn't just slow on I/O.  Nor where the frozen processes in
any way related to the array being reshaped (e.g., "ps auxw" would
reproducibly freeze, even though it seemingly does not access any data
on an array being reshaped), so I guess someone's indefinitely holding
a lock on a kernel data structure.

I can offer little more detail, since everything returned to normal
when (dozens of hours later) the reshape was finished.  And for
obvious reasons, I can't try to reproduce the problem.  However, I can
say the following, if it's of any use:

* the frozen processes all had /proc/$PID/wchan to "schedule",

* an example of a strace of "ps auxw" freezing looks like this:

stat("/proc/627", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
open("/proc/627/stat", O_RDONLY)        = 7
read(7, "627 (zsh) D 624 624 603 0 -1 419"..., 1023) = 208
close(7)                                = 0
open("/proc/627/status", O_RDONLY)      = 7
read(7, "Name:\tzsh\nState:\tD (disk sleep)\n"..., 1023) = 735
close(7)                                = 0
open("/proc/627/cmdline", O_RDONLY)     = 7
read(7, <freezes indefinitely at this point>

(i.e., it freezes while reading /proc/$PID/cmdline for some other
process, which is also frozen),

* the /proc/$PID/stat file for a typical frozen process looks like
  this:

Name:	zsh
State:	D (disk sleep)
Tgid:	627
Pid:	627
PPid:	624
TracerPid:	0
Uid:	500	500	500	500
Gid:	500	500	500	500
FDSize:	64
Groups:	20 24 25 29 44 61 100 122 126 131 500 
VmPeak:	    3068 kB
VmSize:	    2952 kB
VmLck:	       0 kB
VmHWM:	     396 kB
VmRSS:	     396 kB
VmData:	     244 kB
VmStk:	     136 kB
VmExe:	     584 kB
VmLib:	    1912 kB
VmPTE:	      20 kB
VmSwap:	       0 kB
Threads:	1
SigQ:	17/63895
SigPnd:	0000000000000100
ShdPnd:	0000000000000001
SigBlk:	0000000000000000
SigIgn:	0000000000000000
SigCgt:	0000000000000000
CapInh:	0000000000000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	ffffffffffffffff
Cpus_allowed:	f
Cpus_allowed_list:	0-3
voluntary_ctxt_switches:	11
nonvoluntary_ctxt_switches:	1

* it appears that the frozen tasks where not, or not regularly,
  reported by CONFIG_DETECT_HUNG_TASK (despite my having this set to
  'y'); I did have some hung tasks reported earlier on in the reshape,
  but they were probably just regularly waiting for I/O.

My full config is on <URL:
http://www.madore.org/~david/.tmp/config-3.1.0-rc6-vega
 >.

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
