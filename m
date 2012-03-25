Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2CYNhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 09:37:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60435 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753512Ab2CYNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 09:37:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/4rqhJKxH42s73agbFETO/Mw0eJwI7y/CuefmEAG
	hq1yIG1z9kCJt5
Message-ID: <1332682650.9154.111.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
From: Mike Galbraith <efault@gmx.de>
To: Valdis.Kletnieks@vt.edu
Cc: Gene Heskett <gene.heskett@gmail.com>, Con Kolivas <kernel@kolivas.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 25 Mar 2012 15:37:30 +0200
In-Reply-To: <57375.1332641134@turing-police.cc.vt.edu>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
	 <201203240553.32526.gene.heskett@gmail.com>
	 <57375.1332641134@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 22:05 -0400, Valdis.Kletnieks@vt.edu wrote: 
> On Sat, 24 Mar 2012 05:53:32 -0400, Gene Heskett said:
> 
> > I for one am happy to see this, Con.  I have been running an earlier patch
> > as pclos applies it to 2.6.38.8, and I must say the desktop interactivity
> > is very much improved over the non-bfs version.
> 
> I'va always wondered what people are using to measure interactivity. Do we have
> some hard numbers from scheduler traces, or is it a "feels faster"?  And if
> it's a subjective thing, how are people avoiding confirmation bias (where you
> decide it feels faster because it's the new kernel and *should* feel faster)?
> Anybody doing blinded boots, where a random kernel old/new is booted and the
> user grades the performance without knowing which one was actually running?
> 
> And yes, this can be a real issue - anybody who's been a aysadmin for
> a while will have at least one story of scheduling an upgrade, scratching it
> at the last minute, and then having users complain about how the upgrade
> ruined performance and introduced bugs...

Yeah.  In all the interactivity testing I've ever done, it's really hard
to not see what you expect and/or hope to see.  For normal desktop use,
I don't see any real difference with BFS vs CFS unless I load test of
course, and that can go either way, depending on the load.

Example:

3.3.0-bfs vs 3.3.0-cfs - identical config

Q6600 desktop box doing a measured interactivity test.

time mplayer BigBuckBunny-DivXPlusHD.mkv, with massive_intr 8 as competition

no bg load real    9m56.627s              1.000
CFS        real    9m59.199s              1.004
BFS        real    12m8.166s              1.220

As you can see, neither scheduler can run that perfectly on my box, as
the load needs a tad more than its fair share.  However, the Interactive
Experience was far better in CFS in this case due to it being more fair.
In BFS, the interactive tasks (mplayer/Xorg) could not get their fair
share, causing interactivity to measurably suffer.

It could just as well flip in favor of the unfair scheduler with the
right load mix.  Is this a big desktop deal?  No.  Neither scheduler
totally sucks, both have weaknesses and strengths (contrary to hype).

CFS vs BFS fairness:

CFS
  PID USER      PR  NI  VIRT  RES  SHR S   %CPU %MEM    TIME+  P COMMAND                                                                                                                                                                    
18598 root      20   0  8216  104    0 R     25  0.0   0:30.64 3 massive_intr                                                                                                                                                               
18597 root      20   0  8216  104    0 R     25  0.0   0:30.63 3 massive_intr                                                                                                                                                               
18600 root      20   0  3956  344  272 R     25  0.0   0:30.62 3 cpuhog                                                                                                                                                                     
18599 root      20   0  8216  104    0 R     25  0.0   0:30.63 3 massive_intr

BFS
  PID USER      PR  NI  VIRT  RES  SHR S   %CPU %MEM    TIME+  P COMMAND                                                                                                                                                                    
 7447 root       3   0  8216  104    0 R     27  0.0   0:31.20 3 massive_intr                                                                                                                                                               
 7448 root       5   0  8216  104    0 R     27  0.0   0:30.78 3 massive_intr                                                                                                                                                               
 7449 root       4   0  8216  104    0 R     26  0.0   0:30.65 3 massive_intr                                                                                                                                                               
 7446 root       7   0  3956  344  272 R     21  0.0   0:24.71 3 cpuhog

BFS is roughly fair, but demonstrably not as fair as CFS.  Is that a
strength or a weakness?  A: It depends.

What about low latency?  A couple latency bound loads:

tbench 8
Q6600 desktop box
CFS Throughput 1159.6 MB/sec 8 procs      1.000
BFS Throughput 701.2 MB/sec 8 procs        .604 (L2 misses hurt like hell)

E5620 (x3550 M3)
CFS Throughput 1505.09 MB/sec 8 procs     1.000
BFS Throughput 1269.87 MB/sec 8 procs      .843 (less pain, can't miss L3 at least)

Nobody likes vmark, but it sends a pretty clear message too.

marge:/vmark2.5.0.9 # ./volanomark.sh && grep troughput *.log

CFS
test-1.log:Average throughput = 148507 messages per second
test-2.log:Average throughput = 150017 messages per second
test-3.log:Average throughput = 147072 messages per second

BFS
test-1.log:Average throughput = 74042 messages per second
test-2.log:Average throughput = 73520 messages per second
test-3.log:Average throughput = 73134 messages per second

(Imagine this localhost throughput is your desktop applications
jabbering back and forth)

Right, BFS generally does have a tighter worst case, mostly because of
CFSs more accurate distribution.  OTOH, BFS pays a heavy price for being
single queue with zero load balancing overhead.  It has advantages, but
affinity problems result (not to mention scalability).

Lets see what lmbench has to say.

                 L M B E N C H  3 . 0   S U M M A R Y
                 ------------------------------------
		 (Alpha software, do not distribute)

Basic system parameters
------------------------------------------------------------------------------
Host                 OS Description              Mhz  tlb  cache  mem   scal
                                                     pages line   par   load
                                                           bytes  
--------- ------------- ----------------------- ---- ----- ----- ------ ----
marge         3.3.0-bfs        x86_64-linux-gnu 2401         128           1
marge         3.3.0-bfs        x86_64-linux-gnu 2401         128           1
marge         3.3.0-bfs        x86_64-linux-gnu 2401         128           1
marge         3.3.0-cfs        x86_64-linux-gnu 2401         128           1
marge         3.3.0-cfs        x86_64-linux-gnu 2401         128           1
marge         3.3.0-cfs        x86_64-linux-gnu 2401         128           1

Processor, Processes - times in microseconds - smaller is better
------------------------------------------------------------------------------
Host                 OS  Mhz null null      open slct sig  sig  fork exec sh  
                             call  I/O stat clos TCP  inst hndl proc proc proc
--------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
marge         3.3.0-bfs 2401 0.12 0.16 1.32 1.93 2.99 0.23 1.22 191. 463. 1989
marge         3.3.0-bfs 2401 0.11 0.16 1.31 1.93 2.98 0.23 1.22 193. 463. 1991
marge         3.3.0-bfs 2401 0.11 0.17 1.31 1.93 3.02 0.23 1.23 192. 463. 1987
marge         3.3.0-cfs 2401 0.12 0.16 1.32 1.91 3.03 0.23 1.23 187. 458. 2237
marge         3.3.0-cfs 2401 0.11 0.16 1.29 1.89 3.04 0.23 1.23 185. 459. 2235
marge         3.3.0-cfs 2401 0.11 0.16 1.30 1.89 3.00 0.23 1.22 191. 455. 2227

Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
marge         3.3.0-bfs 1.4900 2.3600 1.9000 2.6500 2.8000 2.71000 2.16000
marge         3.3.0-bfs 1.4600 2.8800 2.9100 2.7300 2.0800 2.75000 3.50000
marge         3.3.0-bfs 1.4400 2.6500 2.3000 2.6400 2.2700 2.69000 3.82000
marge         3.3.0-cfs 1.6900 1.6800 1.6900 2.3700 1.9100 2.37000 1.94000
marge         3.3.0-cfs 1.6500 1.7100 1.6800 2.3600 1.8400 2.37000 1.89000
marge         3.3.0-cfs 1.6800 1.7900 1.6900 2.4100 1.8800 2.38000 2.06000

*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
marge         3.3.0-bfs 1.490 4.393 14.5  12.1  22.3  22.7  28.7  24.
marge         3.3.0-bfs 1.460 4.369 15.0  12.1  22.0  22.2  29.0  25.
marge         3.3.0-bfs 1.440 4.370 15.2  12.1  22.1  22.8  28.9  25.
marge         3.3.0-cfs 1.690 4.780 5.90  10.1  13.4  12.9  16.7  20.
marge         3.3.0-cfs 1.650 4.790 5.68  10.2  13.4  12.9  16.7  20.
marge         3.3.0-cfs 1.680 4.819 5.53  10.1  13.3  12.8  16.7  20.

File & VM system latencies in microseconds - smaller is better
-------------------------------------------------------------------------------
Host                 OS   0K File      10K File     Mmap    Prot   Page   100fd
                        Create Delete Create Delete Latency Fault  Fault  selct
--------- ------------- ------ ------ ------ ------ ------- ----- ------- -----
marge         3.3.0-bfs                               775.0 0.447 0.96890 1.443
marge         3.3.0-bfs                               776.0 0.464 0.97250 1.441
marge         3.3.0-bfs                               783.0 0.461 0.97380 1.432
marge         3.3.0-cfs                               788.0 0.475 0.95950 1.441
marge         3.3.0-cfs                               774.0 0.473 0.96820 1.442
marge         3.3.0-cfs                               778.0 0.458 0.96040 1.432

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
marge         3.3.0-bfs 2275 2102 1310 2959.7 5199.2 1881.3 1848.7 4912 2347.
marge         3.3.0-bfs 2242 2105 1321 2964.8 5199.6 1895.9 1849.4 4896 2345.
marge         3.3.0-bfs 2269 2115 1302 2961.5 5197.2 1903.1 1851.2 4882 2337.
marge         3.3.0-cfs 2452 4956 2885 3000.8 5121.2 1929.8 1829.7 4843 2032.
marge         3.3.0-cfs 2443 4965 2807 3010.7 5204.9 1900.6 1851.2 4900 2350.
marge         3.3.0-cfs 2449 4987 2834 2959.5 5194.0 1900.7 1829.2 4832 2305.
make[1]: Leaving directory `/usr/local/tmp/lmbench3/results.smp'

