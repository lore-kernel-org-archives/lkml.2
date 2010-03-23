Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0CWPoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:44:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40949 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0CWPoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:content-type:content-transfer-encoding:subject:date:message-id
         :to:mime-version:x-mailer;
        b=rkc3Y9+Arv+5LYkfEF8qVJtVTLGGvSjniJatlejfagwsPk9iUENlmyC6c1PCo07nxX
         aU94LdKS6wBZacliF3usCuGMMouyoblzrDI7RmSauIu58Hw4EHy094+J0f1PN5ZSy7ae
         OFif9dvfMAokvH0FV+tHpwp3JQYxQyM3Mxdho=
From: Anton Starikov <ant.starikov@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: possible huge regress
Date: Tue, 23 Mar 2010 16:43:52 +0100
Message-Id: <2A0D883F-2301-401B-BC35-D954AB7050D8@gmail.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have benchmarked some multithreaded code here on 16-core/4-way opteron 8356 host on number of kernels (see below) and found strange results.
Up to 8 threads we didn't see any noticeable differences in performance, but starting from 9 threads performance diverges substantially. I provide here results for 14 threads

2.6.18-164.11.1.el5 (centos)

user time: ~60 sec
sys time: ~12 sec

2.6.32.9-70.fc12.x86_64 (fedora-12)

user time: ~60 sec
sys time: ~75 sec

2.6.33-0.46.rc8.git1.fc13.x86_64 (fedora-12 + rawhide kernel)

user time: ~60 sec
sys time: ~300 sec

In all three cases real time corresponds to given numbers.

Binary used for all three cases is exactly the same (compiled on centos).
Setups for all three cases so identical as possible (last two - the sanme fedore-12 booted with different kernels).
I submit to LKLM because I feel that this is some general kernel issue rather than RH-flavored kernel issue.

What can be reason of this regress in performance? Is it possible to tune something to recover performance on 2.6.18 kernel? 

I perf'ed on 2.6.32.9-70.fc12.x86_64 kernel

report (top part only):

43.64% dve22lts-mc [kernel] [k] _spin_lock_irqsave 
32.93% dve22lts-mc ./dve22lts-mc [.] DBSLLlookup_ret 
5.37% dve22lts-mc ./dve22lts-mc [.] SuperFastHash 
3.76% dve22lts-mc /lib64/libc-2.11.1.so [.] __GI_memcpy 
2.60% dve22lts-mc [kernel] [k] clear_page_c 
1.60% dve22lts-mc ./dve22lts-mc [.] index_next_dfs

stat: 
129875.554435 task-clock-msecs # 10.210 CPUs 
1883 context-switches # 0.000 M/sec 
17 CPU-migrations # 0.000 M/sec 
2695310 page-faults # 0.021 M/sec 
298370338040 cycles # 2297.356 M/sec 
130581778178 instructions # 0.438 IPC 
42517143751 cache-references # 327.368 M/sec 
101906904 cache-misses # 0.785 M/sec 

callgraph:

53.09%      dve22lts-mc  [kernel]                                         [k]
 _spin_lock_irqsave
                |          
                |--49.90%-- __down_read_trylock
                |          down_read_trylock
                |          do_page_fault
                |          page_fault
                |          |          
                |          |--99.99%-- __GI_memcpy
                |          |          |          
                |          |          |--84.28%-- (nil)
                |          |          |          
                |          |          |--9.78%-- 0x100000000
                |          |          |          
                |          |           --5.94%-- 0x1
                |           --0.01%-- 
[...]

                |          
                |--49.39%-- __up_read
                |          up_read
                |          |          
                |          |--100.00%-- do_page_fault
                |          |          page_fault
                |          |          |          
                |          |          |--99.99%-- __GI_memcpy
                |          |          |          |          
                |          |          |          |--84.18%-- (nil)
                |          |          |          |          
                |          |          |          |--10.13%-- 0x100000000
                |          |          |          |          
                |          |          |           --5.69%-- 0x1
                |          |           --0.01%-- 
[...]

                |           --0.00%-- 
[...]

                 --0.72%-- 
[...]


Anton.