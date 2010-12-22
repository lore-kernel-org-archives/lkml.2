Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0LVBJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:09:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:39854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0LVBJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RfvLwbfjdWHxVzZAKnoF0d9nMi09uYQ98Yh29eMNFbJqQSR9Kde2qAHrEhjLA+TZ+t
         TJFtxAHrWiMQeA1tYVKA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 0/5] Proper kernel irq time reporting -v2
Date: Tue, 21 Dec 2010 17:08:59 -0800
Message-Id: <1292980144-28796-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Part 2 of
"Proper kernel irq time accounting -v4"
http://lkml.indiana.edu/hypermail//linux/kernel/1010.0/01175.html

and applies over 2.6.37-rc7.

Part 1 solves the way irqs are accounted in scheduler and tasks. This
patchset solves how irq times are reported in /proc/stat and also not
to include irq time in task->stime, etc.

Example:
Running a cpu intensive loop and network intensive nc on a 4 CPU system
and looking at 'top' output.

With vanilla kernel:
Cpu0  :  0.0% us,  0.3% sy,  0.0% ni, 99.3% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu1  : 100.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  1.3% us, 27.2% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 71.4% si
Cpu3  :  1.6% us,  1.3% sy,  0.0% ni, 96.7% id,  0.0% wa,  0.0% hi,  0.3% si

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7555 root      20   0  1760  528  436 R  100  0.0   0:15.79 nc
 7563 root      20   0  3632  268  204 R  100  0.0   0:13.13 loop

Notes:
* Both tasks show 100% CPU, even when one of them is stuck on a CPU thats
  processing 70% softirq.
* no hardirq time.


With "Part 1" patches:
Cpu0  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  : 100.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  2.0% us, 30.6% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 67.4% si
Cpu3  :  0.7% us,  0.7% sy,  0.3% ni, 98.3% id,  0.0% wa,  0.0% hi,  0.0% si

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6289 root      20   0  3632  268  204 R  100  0.0   2:18.67 loop
 5737 root      20   0  1760  528  436 R   33  0.0   0:26.72 nc

Notes:
* Tasks show 100% CPU and 33% CPU that correspond to their non-irq exec time.
* no hardirq time.


With "Part 1 + Part 2" patches:
Cpu0  :  1.3% us,  1.0% sy,  0.3% ni, 97.0% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu1  : 99.3% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.7% hi,  0.0% si
Cpu2  :  1.3% us, 31.5% sy,  0.0% ni,  0.0% id,  0.0% wa,  8.3% hi, 58.9% si
Cpu3  :  1.0% us,  2.0% sy,  0.3% ni, 95.0% id,  0.0% wa,  0.7% hi,  1.0% si

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
20929 root      20   0  3632  268  204 R   99  0.0   3:48.25 loop
20796 root      20   0  1760  528  436 R   33  0.0   2:38.65 nc

Notes:
* Both task exec time and hard irq time reported correctly.
* hi and si time are based on fine granularity info and not on samples.
* getrusage would give proper utime/stime split not including irq times
  in that ratio.
* Other places that report user/sys time like, cgroup cpuacct.stat will
  now include only non-irq exectime.


Changes since v1:
( v1 - http://kerneltrap.com/mailarchive/linux-kernel/2010/10/25/4637170 )
* Rebase over other related code changes since v1

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
