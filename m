Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2HPOM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:12:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41536 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HPOM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:12:57 -0400
Message-ID: <502CFFB6.3080006@oracle.com>
Date: Thu, 16 Aug 2012 22:12:06 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
Organization: Oracle
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: fix potential NULL pointer dereferences
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In general we can get the symbol name of a particular lock and print it out if something
went wrong regarding lock/unlock stuff.

However, I observed the following info(3.5.0-rc4) when running quotacheck(1) yesterday.
It has occurred only once, I can not reproduced it afterwards.

[15800.938071] quotacheck/11934 is trying to release lock (
[15800.940040] BUG: unable to handle kernel NULL pointer dereference at 0000007c
[15800.940040] IP: [<c10f9b2c>] print_lockdep_cache+0x15/0x86
[15800.940040] *pde = 00000000
[15800.940040] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC

Maybe something wrong at other areas, but I also noticed there is no defense for __get_key_name()
failure at both __print_lock_name() and print_lockdep_cache().

How about to trigger BUG_ON() to indicate it a bit more explicit once such situation is detected?

Thanks,
-Jeff


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 kernel/lockdep.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ea9ee45..dfbcd86 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -508,6 +508,7 @@ static void __print_lock_name(struct lock_class *class)
 	name = class->name;
 	if (!name) {
 		name = __get_key_name(class->key, str);
+		BUG_ON(!name);
 		printk("%s", name);
 	} else {
 		printk("%s", name);
@@ -538,6 +539,7 @@ static void print_lockdep_cache(struct lockdep_map *lock)
 	if (!name)
 		name = __get_key_name(lock->key->subkeys, str);
 
+	BUG_ON(!name);
 	printk("%s", name);
 }
 
-- 
1.7.9
