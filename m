Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2GKJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:24:58 -0400
Received: from teranetworks.de ([188.40.78.98]:54055 "EHLO teranetworks.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2GKJY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:24:56 -0400
Date: Wed, 11 Jul 2012 11:24:53 +0200
From: Andreas Herz <andi@geekosphere.org>
To: linux-kernel@vger.kernel.org
Subject: inconsistency in kernel/time.c with jiffies
Message-ID: <20120711092453.GW9358@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote this testcase module to prove a bug in kernel/time.c.
The problem i found is in the msecs_to_jiffies() function. In my
testcase the bug occurs with kernel 3.2 on a 32-Bit system.
The problem is this first part of the function:

> if ((int)m < 0)
>   return MAX_JIFFY_OFFSET;

When the function has const unsigned int as parameter so it's fine to
call it with a unsigned int value, for example 2147483647 for 32-Bit as
the maximum value the return value is 2147483647 on a system with
HZ=1000. But when the value is increased by 1 to 2147483648 the return
value is 1073741822 (MAX_JIFFY_OFFSET). This means, a even higher value
results in a smaller return value.

But time.c also says:

* - 'too large' values [that would result in larger than
* MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.

If you read this it would mean that even 2147483647 should result in
1073741822 (MAX_JIFFY_OFFSET) as it's larger then MAX_JIFFY_OFFSET.

So there are several suggestions i would discuss:

1. Change MAX_JIFFY_OFFSET ((ULONG_MAX >> 1)-1 as i guess unsigned makes
more sense, because jiffies are never < 0
2. Change the if((int)m < 0) to return MAX_JIFFY_OFFSET even with values
that are valid but higher then MAX_JIFFY_OFFSET
> if (((int)m < 0) || (m > MAX_JIFFY_OFFSET))
3. Change the parameter to signed int.

This issue came up when i worked with ipset and higher values resulted
in smaller timeouts.

Any feedback is appreciated.

Here the testcase source code:

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/jiffies.h>
#include <linux/time.h>

static int jiffiestestcase_init(void)
{
        printk(KERN_ALERT "Last working msecs_to_jiffies value with 2147483647 %ld\n", msecs_to_jiffies(2147483647));
        printk(KERN_ALERT "First wrong msecs_to_jiffies value with 2147483648 %ld\n", msecs_to_jiffies(2147483648));
        printk(KERN_ALERT "int casts %d and %d\n", (int)2147483647, (int)2147483648);
        printk(KERN_ALERT "MAX JIFFIES: %ld\n", MAX_JIFFY_OFFSET);
        return 0;
}

static void jiffiestestcase_exit(void)
{
        printk(KERN_ALERT "ending jiffiestestcase!\n");
}

module_init(jiffiestestcase_init);
module_exit(jiffiestestcase_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Andreas Herz <andi@geekosphere.org>");
MODULE_DESCRIPTION("Jiffies Testcase Module");

-- 
Andreas Herz
