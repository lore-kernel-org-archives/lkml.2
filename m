Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0EDFaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 01:30:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60678 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0EDFaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 01:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XV4jic6ExRPWNsKOb1F2eVNrSnmTwAef3PlYEDg+XpKUqHa8849B4Lgdn1l/a9i5xI
         eFcObox3rjeKfEN5OTpOOx8ohUdOos3DKNp6mXVTaORo9+5PlmS+tgRKJw2Ex8C8DcVi
         cg1g02aJ7fFI1lWGCdQ9p+UwPD5rWrlKi1I2c=
MIME-Version: 1.0
Date: Mon, 3 May 2010 22:30:01 -0700
Message-ID: <p2n9a158e2e1005032230u2cb21e6do40ae0b58e746b75f@mail.gmail.com>
Subject: race condition between udevd and modprobe (mtrr_add)
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, while booting an initrd image built off of BusyBox on a thousand
nodes, we hit a race on a couple of nodes. They hang during the boot
process with the stack traces listed below. The really simple init
script in the initrd does a 'udevd --daemon' and then modprobe of a
device. The device needs to assign an mtrr to the pci resource, and
instead the whole node hangs. Putting a 'sleep 1' in between these two
calls prevents any hangs.

mtrr_add_page and the buddy allocator code don't appear to share any
semaphores, and there isn't an obvious way in which this can hang.
Possibly the smp_call_function IPI isn't being handled by the other
cores... That's the best guess. Can anyone help sort this mess out?

Also, is there a better way to test that udevd is fully up? A 'sleep
1' is not the preferred solution here.

Thanks for your time,

-Kyle Hubert

>> ps
              ADDR    UID    PID   PPID  STATE     FLAGS CPU  NAME
===============================================================================
...
0xffff88061d26c720      0   1036      1      0  0x400140   -  udevd
0xffff88021e05c480      0   1037      1      0  0x400100   -  modprobe
0xffff88081d072440      0   1116   1036      0  0x400040   -  udevd
===============================================================================
135 active task structs found
>> bt 0xffff88021e05c480
================================================================
STACK TRACE FOR TASK: 0xffff88021e05c480(modprobe)

 0 <schedule?> [0x0]
 1 mtrr_add_page+494 [0xffffffff80219d9e]
 2 <unknown?>+<ERROR> [0xffffffffa0009a08]
================================================================
>> bt 0xffff88061d25f420
================================================================
STACK TRACE FOR TASK: 0xffff88061d25f420(udevd)

 0 <schedule?> [0x0]
 1 __alloc_pages_internal+241 [0xffffffff80292731]
 2 rmqueue_bulk+89 [0xffffffff80291b19]
 3 get_page_from_freelist+1430 [0xffffffff802922e6]
 4 __alloc_pages_internal+241 [0xffffffff80292731]
 5 alloc_pages_current+168 [0xffffffff802b0898]
 6 pte_alloc_one+49 [0xffffffff80229271]
 7 __pte_alloc+67 [0xffffffff8029e7d3]
 8 copy_page_range+1269 [0xffffffff802a11c5]
 9 alloc_pid+744 [0xffffffff80250a18]
10 copy_process+3057 [0xffffffff8023bcf1]
11 do_fork+118 [0xffffffff8023c4d6]
12 sys_clone+35 [0xffffffff80209c23]
13 ptregscall_common+103 [0xffffffff8020bda7]
================================================================
>> bt 0xffff88081de869e0
================================================================
STACK TRACE FOR TASK: 0xffff88081de869e0(udevd)

 0 <schedule?> [0x0]
 1 set_user_nice+324 [0xffffffff80234734]
 2 set_one_prio+113 [0xffffffff8024ea61]
 3 sys_setpriority+129 [0xffffffff8024eb41]
 4 system_call_fastpath+22 [0xffffffff8020ba3b]
================================================================
