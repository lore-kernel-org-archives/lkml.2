Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1CJCFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:05:44 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59748 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1CJCFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:05:43 -0500
X-Nat-Received: from [202.181.97.72]:55742 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1299722742.15746
Message-Id: <201103100205.p2A25f4b095209@www262.sakura.ne.jp>
Subject: Loop condition question. (GCC bug?)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Mar 2011 11:05:41 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 10032011 #5079608, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to figure out what happens to "for (i = 0; i < n i++)" loop when
"i is int" and "sizeof(i) == 4" and "n is unsigned long" and "sizeof(n) == 8"
and "n is larger than INT_MAX" (in order to determine whether such comparison
can cause "int i" to become negative value).

----- Start of source code -----
#include <linux/module.h>
#include <linux/sched.h>

static int __init test_init(void)
{
	int i;
	unsigned long n = 2147483649UL;
	for (i = 2147483646; i < n; i++) {
		printk(KERN_INFO "*** i=%d\n", i);
		if (signal_pending(current))
			break;
	}
	return -EINVAL;
}

module_init(test_init);
MODULE_LICENSE("GPL");
----- End of source code -----

# gcc --version
gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# uname -a
Linux localhost.localdomain 2.6.35.11-83.fc14.x86_64 #1 SMP Mon Feb 7 07:06:44 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

I got a strange behavior around the boundary.
Above program prints

*** i=2147483647
*** i=2147483647
*** i=2147483647
*** i=2147483647

line forever.

If the loop is "for (i = 2147483645; i < n; i++)" instead of
"for (i = 2147483646; i < n; i++)", it prints only

*** i=2147483645
*** i=2147483646
*** i=2147483647

lines.

If I use "volatile int i;" instead of "int i;", the
"for (i = 2147483646; i < n; i++)" loop prints only

*** i=2147483646
*** i=2147483647

lines.

Is this a compiler bug?

Also, is the "for (i = 0; i < n; i++)" loop guaranteed to stop at
i == 2147483647 if n is larger than 2147483648?
