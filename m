Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab2KBQDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:03:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55116 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661Ab2KBQDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:03:20 -0400
Message-ID: <5093EEC2.7000109@gmail.com>
Date: Sat, 03 Nov 2012 00:03:14 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: cl@linux-foundation.org, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Shan Wei <shanwei88@gmail.com>
Subject: [PATCH 0/9 v2] use efficient this_cpu_* helper
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_ptr is faster than per_cpu_ptr(p, smp_processor_id()) 
and can reduce  memory accesses.
The latter helper needs to find the offset for current cpu,
and needs more assembler instructions which objdump shows in following. 

per_cpu_ptr(p, smp_processor_id())：
  1e:   65 8b 04 25 00 00 00 00         mov    %gs:0x0,%eax
  26:   48 98                           cltq
  28:   31 f6                           xor    %esi,%esi
  2a:   48 c7 c7 00 00 00 00            mov    $0x0,%rdi
  31:   48 8b 04 c5 00 00 00 00         mov    0x0(,%rax,8),%rax
  39:   c7 44 10 04 14 00 00 00         movl   $0x14,0x4(%rax,%rdx,1)

this_cpu_ptr(p)
  1e:   65 48 03 14 25 00 00 00 00      add    %gs:0x0,%rdx
  27:   31 f6                           xor    %esi,%esi
  29:   c7 42 04 14 00 00 00            movl   $0x14,0x4(%rdx)
  30:   48 c7 c7 00 00 00 00            mov    $0x0,%rdi

Changelog V2:
1. Use this_cpu_read directly instead of ref to field of per-cpu variable.
2. Patch5 about ftrace is dropped from this series.
3. Add new patch9 to replace get_cpu;per_cpu_ptr;put_cpu with this_cpu_add opt.
4. For preemption disable case, use __this_cpu_read instead.
  
$ git diff --stat b77bc2069d1e437d5a1a71bb5cfcf4556ee40015 
 drivers/clocksource/arm_generic.c |    2 +-
 kernel/padata.c                   |    5 ++---
 kernel/rcutree.c                  |    2 +-
 kernel/trace/blktrace.c           |    2 +-
 kernel/trace/trace.c              |    4 +---
 net/batman-adv/main.h             |    4 +---
 net/core/flow.c                   |    4 +---
 net/openvswitch/datapath.c        |    4 ++--
 net/openvswitch/vport.c           |    5 ++---
 net/rds/ib_recv.c                 |    2 +-
 net/xfrm/xfrm_ipcomp.c            |    7 +++----
 11 files changed, 16 insertions(+), 25 deletions(-)
