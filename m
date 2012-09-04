Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2IDJai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:30:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55121 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2IDJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:30:37 -0400
MIME-Version: 1.0
From: Manavendra Nath Manav <mnm.kernel@gmail.com>
Date: Tue, 4 Sep 2012 15:00:16 +0530
Message-ID: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
Subject: Why exported const value modified by another driver not updated in
 original driver
To: kernelnewbies@kernelnewbies.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have declared a static const int variable in one driver and exported
that variable symbol. In another driver i am modifying that variable.
The other driver prints the modified value but the original driver
retains the original value. When both virtual and physical addresses
of the variable as seen by both drivers are same, how is this even
possible. Is it a kernel bug?

[root@localhost bug]# uname -a
Linux localhost.localdomain 3.5.3 #3 SMP Mon Sep 3 21:52:12 IST 2012
i686 i686 i386 GNU/Linux

================================
[root@localhost bug]# cat driver.c
#include <linux/module.h>

static const int value = 123;

int init_module()
{
	printk("Base driver (init): value                     = %d\n", value);
	printk("Base driver (init): virtual address of value  = %p\n", (void *)&value);
	printk("Base driver (init): physical address of value = %p\n", (void
*)__pa(&value));
	return 0;
}

void cleanup_module()
{
	printk("Base driver (exit): value                     = %d\n", value);
	printk("Base driver (exit): virtual address of value  = %p\n", (void *)&value);
	printk("Base driver (exit): physical address of value = %p\n", (void
*)__pa(&value));
}
EXPORT_SYMBOL(value);

==============================================
[root@localhost bug]# cat hacker.c
#include <linux/module.h>

extern int value;

int init_module()
{
	value = 987;
	printk("Hacker driver (init): value                     = %d\n", value);
	printk("Hacker Base driver (init): virtual address of value  = %p\n",
(void *)&value);
	printk("Hacker Base driver (init): physical address of value = %p\n",
(void *)__pa(&value));
	return 0;
}

void cleanup_module()
{
	printk("Hacker driver (exit): value                     = %d\n", value);
	printk("Hacker driver (exit): virtual address of value  = %p\n",
(void *)&value);
	printk("Hacker driver (exit): physical address of value = %p\n",
(void *)__pa(&value));
	return;
}

=========================================
[root@localhost bug]# insmod driver.ko
Base driver (init): value                     = 123
Base driver (init): virtual address of value  = f89d61c8
Base driver (init): physical address of value = 389d61c8

[root@localhost bug]# insmod hacker.ko
Hacker driver (init): value                     = 987
Hacker Base driver (init): virtual address of value  = f89d61c8
Hacker Base driver (init): physical address of value = 389d61c8

[root@localhost bug]# rmmod hacker.ko
Hacker driver (exit): value                     = 987
Hacker driver (exit): virtual address of value  = f89d61c8
Hacker driver (exit): physical address of value = 389d61c8

[root@localhost bug]# rmmod driver.ko
Base driver (exit): value                     = 123
Base driver (exit): virtual address of value  = f89d61c8
Base driver (exit): physical address of value = 389d61c8

[root@localhost bug]# cat /proc/kallsyms | grep value
f89f91c8 R value	[driver]
f89f9088 r __ksymtab_value	[driver]
f89f91cc r __kstrtab_value	[driver]

Interestingly, when i change the declaration of variable to "volatile"
in driver.c as "static const volatile int" then the driver.ko prints
modified value "987" during rmmod and the original value "123" is
lost. What is the difference between this and previous declaration?
Please forgive if you find this question silly?
--
Manavendra Nath Manav
