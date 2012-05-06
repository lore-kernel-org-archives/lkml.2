Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2EFNeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:34:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64290 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2EFNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:34:14 -0400
MIME-Version: 1.0
Date: Sun, 6 May 2012 21:34:13 +0800
Message-ID: <CAD+1EGOzJGSNU4ZYhjWA9ktxAGjKONUxVRhGnR+g2JnuHFrmFg@mail.gmail.com>
Subject: [RFC]Read kernel stack contents with trace-cmd
From: harryxiyou <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe this is not the right place for asking a trace-cmd matter. If true,
please ignore this mail. Thanks.
I wanna to read stack contents with our trace-cmd. But i can only get
something about function information like following. I can not get kernel
stack infos with trace-cmd. How should i run trace-cmd for kernel stack
ones. Cloud anyone give me some suggestions?

My Environments:
# uname -r
2.6.32-21-generic
# lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 10.04.4 LTS
Release:        10.04
Codename:       lucid
gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1)

Following are my test code and logs after running trace-cmd.

/*
 * linux_os/sys_call.c
 *
 * Harry Wei (C) 2012 5 6
 */
#include <syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>

int main(int argc, char **argv) {
       long ID1 = 0L;
       long ID2 = 0L;

       ID1 = syscall(SYS_getpid);
       printf("syscall(SYS_getpid) = %ld\n", ID1);
       ID2 = getpid();
       printf("getpid() = %ld\n", ID2);
       return 0;
}

$ gcc sys_call.c

# ./trace-cmd record -e all ../../workshop1/homeworkxy/linux_os/a.out
/sys/kernel/debug/tracing/events/*/filter
syscall(SYS_getpid) = 3497
getpid() = 3497
Kernel buffer statistics:
 Note: "entries" are the entries left in the kernel ring buffer and are not
       recorded in the trace data. They should all be zero.

CPU: 0
entries: 0
overrun: 0
commit overrun: 0

CPU: 1
entries: 0
overrun: 0
commit overrun: 0

CPU0 data recorded at offset=0x1fc000
   53248 bytes in size
CPU1 data recorded at offset=0x209000
   12288 bytes in size

# ./trace-cmd report
# ./trace-cmd report > 1
trace-cmd: No such file or directory
 unknown op '{'
 failed to read event print fmt for hrtimer_start
 unknown op '{'
 failed to read event print fmt for hrtimer_expire_entry
 function jbd2_dev_to_name not defined
 failed to read event print fmt for jbd2_submit_inode_data
 function jbd2_dev_to_name not defined
 ...
version = 6
cpus=2
          a.out-3497  [001]   417.636333: sys_exit:             NR 4 = 1
          a.out-3497  [001]   417.636345: sys_enter:            NR 11
(bf911946, bf910a44, bf910a4c, bf910a44, c47ff4, bf910874)
          a.out-3497  [001]   417.636346: kmem_cache_alloc:
call_site=c021113a ptr=0xd2d61000 bytes_req=4096 bytes_alloc=4096
gfp_flags=GFP_KERNEL
          a.out-3497  [001]   417.636347: kmem_cache_alloc:
call_site=c020e906 ptr=0xe3f6e800 bytes_req=256 bytes_alloc=256
gfp_flags=GFP_KERNEL|GFP_ZERO
          a.out-3497  [001]   417.636347: kmalloc:
call_site=c020e8f8 ptr=0xe3f6e800 bytes_req=196 bytes_alloc=256
gfp_flags=GFP_KERNEL|GFP_ZERO
          a.out-3497  [001]   417.636348: kmem_cache_alloc:
call_site=c016df13 ptr=0xf4124900 bytes_req=32 bytes_alloc=32
gfp_flags=GFP_KERNEL
          a.out-3497  [001]   417.636348: kmalloc:
call_site=c016def0 ptr=0xf4124900 bytes_req=28 bytes_alloc=32
gfp_flags=GFP_KERNEL
          a.out-3497  [001]   417.636349: kmem_cache_alloc:
call_site=c016db9c ptr=0xd2c6f780 bytes_req=128 bytes_alloc=128
gfp_flags=GFP_KERNEL
...
# cat 1 | tail -10
         <idle>-0     [001]   417.652875: hrtimer_start:
[FAILED TO PARSE] timer=0xc1e03d80 function=0xc0176db0
expires=2759989000000 softexpires=2759989000000
         <idle>-0     [001]   417.652877: sched_stat_wait:      task:
trace-cmd:3494 wait: 22002 [ns]
         <idle>-0     [001]   417.652878: sched_switch:         task
swapper:0 [120] (R) ==> trace-cmd:3494 [120]
      trace-cmd-3494  [001]   417.652880: mm_page_free_direct:
page=0xc174d980 pfn=3245660544 order=0
      trace-cmd-3494  [001]   417.652880: mm_page_free_direct:
page=0xc174d980 pfn=3245660544 order=0
      trace-cmd-3494  [001]   417.652881: kmem_cache_free:
call_site=c014a6c7 ptr=0xf6b84fc0
      trace-cmd-3494  [001]   417.652889: kmem_cache_free:
call_site=c0149bf4 ptr=0xf6b1da40
      trace-cmd-3494  [001]   417.652890: kmem_cache_free:
call_site=c0149ce2 ptr=0xe3fba900
      trace-cmd-3494  [001]   417.652891: sys_exit:             NR 7 = 3497
      trace-cmd-3494  [001]   417.652896: sys_enter:            NR 4
(3, 806fb9a, 1, 0, 0, bf910898)

-- 
Thanks
Harry Wei
