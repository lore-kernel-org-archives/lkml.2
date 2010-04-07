Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0DGIcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:32:32 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58246 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0DGIc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:32:26 -0400
Message-ID: <4BBC4318.1070702@dcl.info.waseda.ac.jp>
Date: Wed, 07 Apr 2010 17:32:24 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Floating point exception by perf record
References: <4BB84991.5080301@dcl.info.waseda.ac.jp> <20100405183127.GA3677@ghostprotocols.net>
In-Reply-To: <20100405183127.GA3677@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/10 03:31, Arnaldo Carvalho de Melo wrote:
 > Em Sun, Apr 04, 2010 at 05:10:57PM +0900, Hitoshi Mitake escreveu:
 >> I suffered a mysterious floating point exception when executing perf
 >> on current tip/master.
 >>
 >> For example,
 >>
 >> % sudo ./perf lock record ./perf bench sched messaging
 >> # Running sched/messaging benchmark...
 >> # 20 sender and receiver processes per group
 >> # 10 groups == 400 processes run
 >>
 >>       Total time: 1.375 [sec]
 >> [ perf record: Woken up 0 times to write data ]
 >> [ perf record: Captured and wrote 160.002 MB perf.data (~6990599 
samples) ]
 >> [1]    26348 floating point exception  sudo ./perf lock record ./perf
 >> bench sched messaging
 >>
 >> dmesg says that
 >>
 >> [10212.752490] perf[26348] trap divide error ip:7fade8564310
 >> sp:7fff46d926e8 error:0 in libnewt.so.0.52.2[7fade8556000+15000]
 >>
 >> Example is of perf lock, but this is not a special phenomenon of 
perf lock,
 >> other users of perf record, like perf sched, caused the same problem.
 >>
 >> I found that this might be caused by the line 283 of perf.c
 >>
 >> 	if (fclose(stdout)) #<- closing stdout!
 >> 		die("close failed on standard output: %s", strerror(errno));
 >>
 >> I don't know well about libnewt, do you know something like cause?
 >>
 >> The version of libnewt I'm using is 0.52.2 (default of Debian lenny)
 >
 > I just built a kernel where 'perf lock' can work, but I'm seeing a
 > different problem:
 >
 > [root@doppio ~]# perf lock trace | head -3
 >    Warning: Error: expected 'data' but read 'overwrite'
 >           swapper-0     [000]   619.086424: lock_acquire: 
0xffff8800029d4b28&q->lock
 >           swapper-0     [000]   619.086429: lock_acquire: 
0xffff8800029d08f8&ctx->lock
 >           swapper-0     [000]   619.086439: lock_acquire: 
0xffffffff81a38e58 clockevents_lock
 > [root@doppio ~]# perf lock report | head -3
 >    Warning: Error: expected 'data' but read 'overwrite'
 >                  ID                 Name   acquired  contended total 
wait (ns)   max wait (ns)   min wait (ns)
 >
 > 0xffff8800029d4b28&q->lock          0          0               0 
           0               0
 > [root@doppio ~]#
 >
 > My system details:
 >
 > [root@doppio ~]# uname -a
 > Linux doppio.ghostprotocols.net 2.6.34-rc3-tip+ #1 SMP Mon Apr 5 
13:49:42 BRT 2010 x86_64 x86_64 x86_64 GNU/Linux
 > [root@doppio ~]# rpm -q newt
 > newt-0.52.10-4.fc11.x86_64
 > [root@doppio ~]#
 >
 > No segfaults here :-\
 >
 > - Arnaldo
 >

I tested perf lock trace and got a similar error (but different).
% sudo ./perf lock trace
   Fatal: reading input file (size expected=3 received=0)
It seems that perf.data is broken :( I'll search the cause.

    Hitoshi
