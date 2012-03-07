Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2CGPJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:09:17 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:24824
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab2CGPJQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:09:16 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz936eKzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0ISR7-01-5B4-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Subject: [PATCH 2/2] Refine mutex and rcu method in module.c, kernel<3.2.9>
Thread-Topic: [PATCH 2/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Index: AQHM/HKZ7/XXKKaGDUauY7gMkxJ9YA==
Date: Wed, 7 Mar 2012 14:57:21 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0430328AF@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Add protection code for module_bug_list readers
2. Add a new module_bug_mutex as the mutex of the module_bug_list writers

--- bug.ori.c   2012-03-07 20:42:56.454850872 +0800
+++ bug.c       2012-03-07 20:58:48.562825887 +0800
@@ -42,6 +42,7 @@
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/sched.h>
+#include <linux/rcupdate.h>
 
 extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
 
@@ -56,19 +57,24 @@
 
 #ifdef CONFIG_MODULES
 static LIST_HEAD(module_bug_list);
+static DEFINE_MUTEX(module_bug_mutex);
 
 static const struct bug_entry *module_find_bug(unsigned long bugaddr)
 {
        struct module *mod;
 
-       list_for_each_entry(mod, &module_bug_list, bug_list) {
+       rcu_read_lock();
+       list_for_each_entry_rcu(mod, &module_bug_list, bug_list) {
                const struct bug_entry *bug = mod->bug_table;
                unsigned i;
 
                for (i = 0; i < mod->num_bugs; ++i, ++bug)
-                       if (bugaddr == bug_addr(bug))
+                       if (bugaddr == bug_addr(bug)){
+                               rcu_read_unlock();
                                return bug;
+                        }
        }
+       rcu_read_unlock();
        return NULL;
 }
 
@@ -96,7 +102,9 @@
         * traversals, but since we only traverse on BUG()s, a spinlock
         * could potentially lead to deadlock and thus be counter-productive.
         */
-       list_add(&mod->bug_list, &module_bug_list);
+       mutex_lock(&module_bug_mutex);
+       list_add_rcu(&mod->bug_list, &module_bug_list);
+       mutex_unlock(&module_bug_mutex);
 }
 
 void module_bug_cleanup(struct module *mod)

