Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab1HQIUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 04:20:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:23239 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1HQIUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 04:20:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,238,1312182000"; 
   d="scan'208";a="39327192"
Subject: perf: problem of 32bit mmap call graph recording
From: Lin Ming <ming.m.lin@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, "Huang, Ying" <ying.huang@intel.com>,
        "He, Fan F" <fan.f.he@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 16:20:03 +0800
Message-ID: <1313569203.4115.149.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

On 32 bit machine, we have problem to get the usersapce call graph of
mmap syscall.

You can reproduce it with below command on 32bit machine.

sudo perf record -f -g -e raw_syscalls:sys_enter --filter "id==192" ls

sudo perf report |less

# Events: 26 
#
# Overhead  Command      Shared Object  Symbol
# ........  .......  .................  ......
#
   100.00%       ls  [kernel.kallsyms]  [k] syscall_trace_enter
                 |
                 --- syscall_trace_enter
                     syscall_trace_entry
                    |          
                    |--88.46%-- __mmap  <--- only __mmap, no more userspace call stacks
                    |          
                     --11.54%-- 0xffffe424


Kernel relies on userspace bp register to get call graph information.
But for mmap syscall, the bp register is used to pass in the sixth
parameter(offset).

void *mmap(void *addr, size_t length, int prot, int flags,
                  int fd, off_t offset);

Anyway to fix this issue on 32bit machine?

Thanks,
Lin Ming

