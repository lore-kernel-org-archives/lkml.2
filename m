Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab2HJK3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:29:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35163 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2HJK3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:29:08 -0400
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 15:59:07 +0530
Message-ID: <CAM3X=jOq+1uNZtwPh0am00jq0nsHu+bdVUPvpsyb+qr=5opTjA@mail.gmail.com>
Subject: Issues with ioremap
From: kps mailme <kps.mailme@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have a ARM926 based development board. I am trying to remap 23 MB of
IO memory using ioremap and access with the code snippet below, mm
throws an exception most of the times -
#define MRAM_SIZE 23068672

    while(1)
    {
        offset = test_random() % MRAM_SIZE;
        virt_addr = mmem + offset;
        page = virt_to_page (virt_addr);
        get_page(page);
        /* do something */
        put_page(page);
    }
Exception in linux-kernel ver - 3.1-
[  116.390625] [<bf0120a4>] (test_init+0xa4/0x114 [test]) from
[<c0008770>] (do_one_initcall+0x94/0x16c)
[  116.390625] [<c0008770>] (do_one_initcall+0x94/0x16c) from
[<c0043f50>] (sys_init_module+0xd8c/0xfdc)
[  116.390625] [<c0043f50>] (sys_init_module+0xd8c/0xfdc) from
[<c0009280>] (ret_fast_syscall+0x0/0x2c)
[  116.390625] Code: e7933280 e3130902 0a000008 e594301c (e5932010)

0xa4 is in test_init (include/linux/mm.h:386).
381            /*
382             * This is safe only because
383             * __split_huge_page_refcount can't run under
384             * get_page().
385             */
386            VM_BUG_ON(atomic_read(&page->first_page->_count) < 0);
387            atomic_inc(&page->first_page->_count);
388        }
389    }


Exception in linux-kernel ver - 3.4.3 -
[  108.640625] [<c0063ce4>] (__get_page_tail+0x20/0xb0) from
[<bf012084>] (test_init+0x84/0x100 [test])
[  108.640625] [<bf012084>] (test_init+0x84/0x100 [test]) from
[<c0008770>] (do_one_initcall+0x94/0x16c)
[  108.640625] [<c0008770>] (do_one_initcall+0x94/0x16c) from
[<c0045330>] (sys_init_module+0x70/0x18c)
[  108.640625] [<c0045330>] (sys_init_module+0x70/0x18c) from
[<c0009320>] (ret_fast_syscall+0x0/0x2c)
[  108.640625] Code: 0a000023 e590001c e1530000 0a000020 (e5902010)

Is there a limitation on the size of memory that can be mapped using
ioremap? Looks like, first_page is not configured correctly for memory
mapped using ioremap.
This is a shared memory used by a network device to read and write ip
packets. Can someone please confirm? Any pointers on how to debug and
fix this issue are much appreciated.

Thank you!
Regards, Pratik

[Note: I tried using iotable but situation does not improve.]
