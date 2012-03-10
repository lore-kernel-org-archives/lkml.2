Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2CJP0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 10:26:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39878 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2CJP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 10:26:01 -0500
Message-ID: <1331393157.2453.15.camel@edumazet-laptop>
Subject: Re: [PATCH 1/2] module: use rcu to protect module list read
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 10 Mar 2012 07:25:57 -0800
In-Reply-To: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 10 mars 2012 à 22:20 +0800, Cong Wang a écrit :
> Now the read of module list is protected by preempt disable + *_rcu
> list operations, this is odd, as RCU read lock should be able to
> protect it directly. This patch makes the read of module list
> protected by RCU read lock and the write still protected by
> module_mutex.
> 

Problem is that your patch does more than that.

In set_all_modules_text_rw() and set_all_modules_text_ro() you removed
the mutex in favor of rcu_read_lock()

Also, module code uses synchronize_sched(), not synchronize_rcu()

Take a look at Documentation/RCU/whatisRCU.txt and see that
preempt_disable() / preempt_enable() are documented as a right protect
code, in line 333.

You added races in /proc/modules as well.

So I would say your patch is not needed at all : module code already
uses RCU.

What particular problem do you have with current code ?

I would probably do the opposite patch, since its clear that at least in
two points we use the wrong macro :

diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..cacb36e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1714,7 +1714,7 @@ void set_all_modules_text_rw(void)
 	struct module *mod;
 
 	mutex_lock(&module_mutex);
-	list_for_each_entry_rcu(mod, &modules, list) {
+	list_for_each_entry(mod, &modules, list) {
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
 						mod->module_core + mod->core_text_size,
@@ -1735,7 +1735,7 @@ void set_all_modules_text_ro(void)
 	struct module *mod;
 
 	mutex_lock(&module_mutex);
-	list_for_each_entry_rcu(mod, &modules, list) {
+	list_for_each_entry(mod, &modules, list) {
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
 						mod->module_core + mod->core_text_size,


