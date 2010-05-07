Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab0EGMqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:46:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0EGMqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:46:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: cpumask: fix compat getaffinity
Date: Fri, 7 May 2010 14:45:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: stable@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005071445.50147.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1883nVEKsMEWCD9Ac/XSAYt9c7YTuDT8qPtf83
 fynTy4A/ev+ICpv8p6aFndkaFrbSO13mPxV5xiii4f7swxhMfw
 07fDhOKfTLBuf6iXXMfhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a45185d2d "cpumask: convert kernel/compat.c" broke
libnuma, which abuses sched_getaffinity to find out NR_CPUS
in order to parse /sys/devices/system/node/node*/cpumap.

On NUMA systems with less than 32 possibly CPUs, the
current compat_sys_sched_getaffinity now returns '4'
instead of the actual NR_CPUS/8, which makes libnuma
bail out when parsing the cpumap.

This restores the original return value for now.
If we ever get around to changing cpumask_size
to return only possibly CPUs, we will also need to
make the format of the cpumap file.

We should probably also make libnuma able to deal with
the modified kernel interface, so it can operate on
all kernels.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Ken Werner <ken.werner@web.de>
Cc: stable@kernel.org
Cc: Andi Kleen <andi@firstfloor.org>

--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -497,7 +497,7 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 	unsigned long *k;
 	unsigned int min_length = cpumask_size();
 
-	if (nr_cpu_ids <= BITS_PER_COMPAT_LONG)
+	if (NR_CPUS <= BITS_PER_COMPAT_LONG)
 		min_length = sizeof(compat_ulong_t);
 
 	if (len < min_length)
