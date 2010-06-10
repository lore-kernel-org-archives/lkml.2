Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab0FJO4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:56:41 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:55797 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab0FJO4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:56:40 -0400
Message-ID: <4C10FD1C.7080200@tu-dresden.de>
Date: Thu, 10 Jun 2010 16:56:28 +0200
From: =?ISO-8859-15?Q?Ronny_Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: sched:sched_migrate_task event tracing returns incorrect events
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to know a little bit more about the execution of my program. 
Especially I'm interested in cpu migrations of my process. Therefore I 
use the Linux performance counter infrastructure, set appropriate 
perf_event attributes and setup the sched:sched_migrate_task event with 
a system call:
...
attr.type = PERF_TYPE_TRACEPOINT;
attr.size = sizeof( struct perf_event_attr );
attr.config = event_id; // id of sched:sched_migrate_task event
attr.sample_type = PERF_SAMPLE_TIME|PERF_SAMPLE_CPU|PERF_SAMPLE_RAW;
attr.freq = 0;
attr.sample_freq = 1;
fd = syscall( __NR_perf_counter_open, &attr, getpid(), -1, -1, 0 );
...
Finally to read the events I map the kernel event buffer via mmap and 
process every event in this buffer. However I run into two problems:

(1) I need root privileges to open the counter successfully. Without 
root privileges syscall returns -1. I think that is not OK because users 
should be allowed to create per task counters.

(2) The buffer contains events that aren't caused by my process (i.e. 
the COMM field does not contain the name of my process and the PID field 
is not equal to the pid of my process).

Some information about my system:
Processor: Core 2 Duo E6750
Kernel information: Linux version 2.6.34-100610-1530 (gcc version 4.4.3 
(Ubuntu 4.4.3-4ubuntu5) ) #1 SMP

This behaviour could also be observed in tests with
- Linux version 2.6.33.3 (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #1 SMP
- Linux version 2.6.32-22-generic (buildd@yellow) (gcc version 4.4.3 
(Ubuntu 4.4.3-4ubuntu5) ) #36-Ubuntu SMP (Ubuntu 10.04)


Bye, Ronny Tschueter

