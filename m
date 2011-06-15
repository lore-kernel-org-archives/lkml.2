Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1FOUdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:33:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41655 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1FOUdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:33:38 -0400
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1308163398.17300.147.camel@schen9-DESK>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>
	 <20110615161827.GA11769@tassilo.jf.intel.com>
	 <1308156337.2171.23.camel@laptop>  <1308163398.17300.147.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Jun 2011 22:32:17 +0200
Message-ID: <1308169937.15315.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 11:43 -0700, Tim Chen wrote:

> Wonder if you can provide the profile on your run so I can compare with
> what I got on 4 sockets? 

Sure, so this is on an Westmere-EP (2 sockets, 6 cores/socket, 2
threads/core), what I did was:

perf record -r2 -gf make bench
perf report > foo.txt
bzip2 -9 foo.txt

Both files are about 0.5M, the tip one has the sirq-rcu patch and linus'
patch applied (could do one without if wanted).

http://programming.kicks-ass.net/sekrit/tip.txt.bz2
http://programming.kicks-ass.net/sekrit/39.txt.bz2

However, looking at them, the weird thing is, they're both dominated by
(taken from 39.txt):

     7.44%        exim  [kernel.kallsyms]              [k] format_decode
                  |
                  --- format_decode
                     |          
                     |--93.07%-- vsnprintf
                     |          |          
                     |          |--98.83%-- seq_printf
                     |          |          show_stat
                     |          |          seq_read
                     |          |          proc_reg_read
                     |          |          vfs_read
                     |          |          sys_read
                     |          |          system_call
                     |          |          __GI___libc_read
                     |          |          |          
                     |          |          |--99.47%-- (nil)
                     |          |           --0.53%-- [...]
                     |          |          
                     |           --1.17%-- snprintf
                     |                     proc_flush_task
                     |                     release_task
                     |                     wait_consider_task
                     |                     do_wait
                     |                     sys_wait4
                     |                     system_call
                     |                     |          
                     |                     |--93.15%-- __libc_wait
                     |                     |          
                     |                      --6.85%-- __waitpid
                     |          
                     |--6.84%-- seq_printf
                     |          show_stat
                     |          seq_read
                     |          proc_reg_read
                     |          vfs_read
                     |          sys_read
                     |          system_call
                     |          __GI___libc_read
                     |          |          
                     |          |--99.56%-- (nil)
                     |           --0.44%-- [...]
                      --0.10%-- [...]


I've no idea why its doing that, I've had massive trouble getting this
MOSBENCH crap working in the first place since its all in python, but
what I basically done was rip out everything !exim in config.py and put
cores = [24]. In hosts.py I too ripped out everything !exim, cleared out
the clients list and made 'tom' my localhost (removing that perflock
thing).

After that things more or less ran, I saw exim, and its giving me those
msgs/sec/core numbers like:

# perf record -r2 -gfo 39.perf.data make bench
python config.py
Starting results in: results/20110615-221914
*** Starting configuration 1/1 (benchmark-exim) ***
Starting Host.host-westmere...
sending westmere: /./
del.ing westmere: out/log/EximLoad.trial-2.host-westmere
del.ing westmere: out/log/EximLoad.trial-1.host-westmere
del.ing westmere: out/log/EximLoad.trial-0.host-westmere
del.ing westmere: out/log/
del.ing westmere: out/EximDaemon.host-westmere.configure
del.ing westmere: out/
sending westmere: /home/root/
sending westmere: /home/root/test/mosbench/
Starting Host.host-westmere... done
Starting HostInfo.host-westmere...
Starting HostInfo.host-westmere... done
Starting FileSystem.host-westmere.fstype-tmpfs-separate...
Starting FileSystem.host-westmere.fstype-tmpfs-separate... done
Starting SetCPUs.host-westmere...
FATAL: Module oprofile not found.
FATAL: Module oprofile not found.
Kernel doesn't support oprofile
CPUs 0-23 are online
CPUs 0-23 are online
Starting SetCPUs.host-westmere... done
Starting EximDaemon.host-westmere...
Starting EximDaemon.host-westmere... done
Waiting on EximLoad.trial-0.host-westmere...
[EximLoad.trial-0.host-westmere] => 86983 messages (15.0032 secs, 241.568 messages/sec/core)
Waiting on EximLoad.trial-0.host-westmere... done
Waiting on EximLoad.trial-1.host-westmere...
[EximLoad.trial-1.host-westmere] => 86770 messages (15.004 secs, 240.964 messages/sec/core)
Waiting on EximLoad.trial-1.host-westmere... done
Waiting on EximLoad.trial-2.host-westmere...
[EximLoad.trial-2.host-westmere] => 86987 messages (15.0035 secs, 241.574 messages/sec/core)
Waiting on EximLoad.trial-2.host-westmere... done
Stopping EximDaemon.host-westmere...
Stopping EximDaemon.host-westmere... done
Stopping HostInfo.host-westmere...
Stopping HostInfo.host-westmere... done
Stopping Host.host-westmere...
copying westmere: ./
copying westmere: EximDaemon.host-westmere.configure
copying westmere: log/
copying westmere: log/EximLoad.trial-0.host-westmere
copying westmere: log/EximLoad.trial-1.host-westmere
copying westmere: log/EximLoad.trial-2.host-westmere
Stopping Host.host-westmere... done
Stopping ResultPath...
Results in: results/20110615-221914/benchmark-exim
Stopping ResultPath... done
All results in: results/20110615-221914
[ perf record: Woken up 3774 times to write data ]
[ perf record: Captured and wrote 979.494 MB 39.perf.data (~42794760 samples) ]
CPUs 0-23 are online

