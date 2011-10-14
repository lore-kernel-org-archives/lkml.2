Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1JNNgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:36:51 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14810 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab1JNNgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:36:49 -0400
From: "Seger, Mark" <mark.seger@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 14:36:30 +0100
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKbiscVAUw/9GxScap4b/e2riaOQABhc/w
Message-ID: <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9EDaxjE018969

> > The HP developed collectl utility depends heavily on abstractions in
> /proc and /sys provided by the kernel for kernel statistics capture.
> > During testing on newer NUMA platforms with large numbers of CPUâ€™S HP
> has observed a significant increase in the time taken to parse this
> data with the newer 2.6.32.x and higher kernels.

While this does indeed effect collectl and renders its effectiveness at 0.1 or lower monitoring intervals it effects ANY utility that reads /proc/stat, and the more frequent the access the heavier the load.  Remember, the increase in load is by a factor of over 50 times, so those who like to run top or vmstat or even iostat will also see a much heavier hand too.  If people ran sar at a lower monitoring frequency it too would suffer.

I've also observed reading /proc/meminfo also consumes a lot more CPU, but not as bad as /proc/stat.

> Strange, here is what I have on my 2x4x2 machine.

Forgive a dumb question, but what does 2X4X2 mean?  ;(

I've observed things are fine on 2 socket systems and are truly horrible on the few 8 socket machines I tested this on which also had higher core counts, so there were always on the order of 48+ cpus involved.  I haven't done any testing on 4 socket machines and I don't even want to think about what could happen on 16 or 32 or however many socket machines are built in the future.

> Could you try following actions please ?
> 
> # perf record ./prog
> Opened, read and closed 8640 times and read total of 29595948 bytes
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.057 MB perf.data (~2482 samples) ]
> 
> # perf report --stdio
> # Events: 1K cycles
> #
> # Overhead  Command      Shared Object                        Symbol
> # ........  .......  .................  ............................
> #
>     22.82%     prog  [kernel.kallsyms]  [k] format_decode
>     21.15%     prog  [kernel.kallsyms]  [k] vsnprintf
>     13.46%     prog  [kernel.kallsyms]  [k] number.isra.4
>     11.33%     prog  [kernel.kallsyms]  [k] memcpy
>      8.87%     prog  [kernel.kallsyms]  [k] kstat_irqs
>      3.80%     prog  [kernel.kallsyms]  [k] radix_tree_lookup_element
>      3.69%     prog  [kernel.kallsyms]  [k] seq_printf
>      3.63%     prog  [kernel.kallsyms]  [k] find_next_bit
>      2.81%     prog  [kernel.kallsyms]  [k] show_stat
>      1.18%     prog  [kernel.kallsyms]  [k] put_dec_trunc
>      0.96%     prog  [kernel.kallsyms]  [k] radix_tree_lookup
>      0.96%     prog  [kernel.kallsyms]  [k] irq_to_desc
>      0.66%     prog  [kernel.kallsyms]  [k] getname_flags
>      0.37%     prog  [kernel.kallsyms]  [k]
> selinux_inode_alloc_security
>      0.22%     prog  [kernel.kallsyms]  [k] jiffies_64_to_clock_t
>      0.22%     prog  [kernel.kallsyms]  [k] copy_user_generic_string
>      0.22%     prog  [kernel.kallsyms]  [k] __call_rcu
>      0.15%     prog  [kernel.kallsyms]  [k] add_preempt_count
>      0.15%     prog  [kernel.kallsyms]  [k] put_dec_full
>      0.15%     prog  [kernel.kallsyms]  [k] nr_context_switches
>      0.15%     prog  [kernel.kallsyms]  [k] kfree

For me the easiest reproducer, which admittedly doesn't show any deeper analysis, is to just run "cat /proc/stat>/dev/null" in a loop and time it.

-mark
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
