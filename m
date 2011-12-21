Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1LUDKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:10:46 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56974 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703Ab1LUDKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:10:43 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 80.237.6.56
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19n78oc1/M6ZNMVHK/fWGaDQOHJagE6khY=
Message-ID: <1324437036.4677.5.camel@hakkenden.homenet>
Subject: Kswapd in 3.2.0-rc5 is a CPU hog
From: "Nikolay S." <nowhere@hakkenden.ath.cx>
To: linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 07:10:36 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using 3.2-rc5 on a machine, which atm does almost nothing except
file system operations and network i/o (i.e. file server). And there is
a problem with kswapd.

I'm playing with dd:
dd if=/some/big/file of=/dev/null bs=8M

I.e. I'm filling page cache.

So when the machine is just rebooted, kswapd during this operation is
almost idle, just 5-8 percent according to top.

After ~5 days of uptime (5 days,  2:10), the same operation demands ~70%
for kswapd:

  PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
  420 root      R   70  0.0  22:09.60    0 kswapd0
17717 nowhere   D   27  0.2   0:01.81  10m dd

In fact, kswapd cpu usage on this operation steadily increases over
time.

Also read performance degrades over time. After reboot:
dd if=/some/big/file of=/dev/null bs=8M
1019+1 records in
1019+1 records out
8553494018 bytes (8.6 GB) copied, 16.211 s, 528 MB/s

After ~5 days uptime:
dd if=/some/big/file of=/dev/null bs=8M
1019+1 records in
1019+1 records out
8553494018 bytes (8.6 GB) copied, 29.0507 s, 294 MB/s

Whereas raw disk sequential read performance stays the same:
dd if=/some/big/file of=/dev/null bs=8M iflag=direct
1019+1 records in
1019+1 records out
8553494018 bytes (8.6 GB) copied, 14.7286 s, 581 MB/s

Also after dropping caches, situation somehow improves, but not to the
state of freshly restarted system:
  PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
  420 root      S   39  0.0  23:31.17    0 kswapd0
19829 nowhere   D   24  0.2   0:02.72 7764 dd

perf shows:

    31.24%  kswapd0  [kernel.kallsyms]  [k] _raw_spin_lock
    26.19%  kswapd0  [kernel.kallsyms]  [k] shrink_slab
    16.28%  kswapd0  [kernel.kallsyms]  [k] prune_super
     6.55%  kswapd0  [kernel.kallsyms]  [k] grab_super_passive
     5.35%  kswapd0  [kernel.kallsyms]  [k] down_read_trylock
     4.03%  kswapd0  [kernel.kallsyms]  [k] up_read
     2.31%  kswapd0  [kernel.kallsyms]  [k] put_super
     1.81%  kswapd0  [kernel.kallsyms]  [k] drop_super
     0.99%  kswapd0  [kernel.kallsyms]  [k] __put_super
     0.25%  kswapd0  [kernel.kallsyms]  [k] __isolate_lru_page
     0.23%  kswapd0  [kernel.kallsyms]  [k] free_pcppages_bulk
     0.19%  kswapd0  [r8169]            [k] rtl8169_interrupt
     0.15%  kswapd0  [kernel.kallsyms]  [k] twa_interrupt

P.S.: The message above was written couple of days ago. Now I'm at 10
days uptime, and this is the result as of today
  PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
  420 root      R   93  0.0 110:48.48    0 kswapd0
30085 nowhere   D   42  0.2   0:04.36  10m dd

PPS: Please CC me.

