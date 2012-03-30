Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471Ab2C3C1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 22:27:37 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:26979
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759895Ab2C3C1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 22:27:31 -0400
X-SpamScore: -6
X-BigFish: VPS-6(z21eNzzz1202hzz8275bhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F7519EA.300@am.sony.com>
Date: Thu, 29 Mar 2012 19:26:50 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>, <frank.rowand@am.sony.com>
Subject: [PATCH RT] mutex_init regression from 2.6.29.6-rt24
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix regression of mutex_init() between 2.6.29.6-rt24 and 3.2.12-rt22
(regression exists in all 3.x versions).

In 2.6.29.6-rt24, with CONFIG_PREEMPT_RT, mutex_init() is a define that
resolves to the function __mutex_init(), which is EXPORT_SYMBOL.
__mutex_init() further calls __rt_mutex_init(), which is EXPORT_SYMBOL_GPL.

In 3.2.12-rt22, with CONFIG_PREEMPT_RT_FULL, mutex_init() is a define that
resolves to the function __rt_mutex_init(), which is EXPORT_SYMBOL_GPL.

Recreate an intermediary function (___rt_mutex_init()), which is
EXPORT_SYMBOL(), to make mutex_init() once again available to non-GPL modules.

Making this change without the 2.6.29.6-rt24 context would not be reasonable.
But the author of the EXPORT_SYMBOL_GPL, __rt_mutex_init(), is also the
author of the 2.6.29.6-rt24 patches that created the EXPORT_SYMBOL function
__mutex_init().  The patches are rt-mutex-core.patch which creates
_mutex_init(), and rt-mutex-core-mutex-fixes.patch, which renames
_mutex_init() to __mutex_init().  The author and signed-off-by for these
patches is Ingo Molnar.

The full expansions from mutex_init() to __mutex_init() is:

# 2.6.29.6-rt24
# include/linux/mutex.h:
# define mutex_init(mutex) __mutex_init((mutex), #mutex, &__key);
   # kernel/rt.c:
   void __mutex_init(...) {
      __rt_mutex_init()
         # kernel/rtmutex.c:
         void __rt_mutex_init(...) {
         EXPORT_SYMBOL_GPL(__rt_mutex_init)

# 3.0.12-rt29
# include/linux/mutex_rt.h:
# define mutex_init(mutex) rt_mutex_init(&(mutex)->lock);
   # include/linux/rtmutex.h:
   # define rt_mutex_init(mutex) __rt_mutex_init(mutex, #mutex);
      # kernel/rtmutex.c:
      void __rt_mutex_init() {
      EXPORT_SYMBOL_GPL(__rt_mutex_init)

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 include/linux/rtmutex.h |    5 	3 +	2 -	0 !
 kernel/rt.c             |    6 	6 +	0 -	0 !
 2 files changed, 9 insertions(+), 2 deletions(-)

Index: b/include/linux/rtmutex.h
===================================================================
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -61,7 +61,7 @@ struct hrtimer_sleeper;
 # define rt_mutex_init(mutex)					\
 	do {							\
 		raw_spin_lock_init(&(mutex)->wait_lock);	\
-		__rt_mutex_init(mutex, #mutex);			\
+		___rt_mutex_init(mutex, #mutex);			\
 	} while (0)
 
  extern void rt_mutex_debug_task_free(struct task_struct *tsk);
@@ -71,7 +71,7 @@ struct hrtimer_sleeper;
 # define rt_mutex_init(mutex)					\
 	do {							\
 		raw_spin_lock_init(&(mutex)->wait_lock);	\
-		__rt_mutex_init(mutex, #mutex);			\
+		___rt_mutex_init(mutex, #mutex);			\
 	} while (0)
 
 # define rt_mutex_debug_task_free(t)			do { } while (0)
@@ -105,6 +105,7 @@ static inline int rt_mutex_is_locked(str
 	return lock->owner != NULL;
 }
 
+extern void ___rt_mutex_init(struct rt_mutex *lock, const char *name);
 extern void __rt_mutex_init(struct rt_mutex *lock, const char *name);
 extern void rt_mutex_destroy(struct rt_mutex *lock);
 
Index: b/kernel/rt.c
===================================================================
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -72,6 +72,12 @@
 /*
  * struct mutex functions
  */
+void ___rt_mutex_init(struct rt_mutex *lock, const char *name)
+{
+	__rt_mutex_init(lock, name);
+}
+EXPORT_SYMBOL(___rt_mutex_init);
+
 void __mutex_do_init(struct mutex *mutex, const char *name,
 		     struct lock_class_key *key)
 {

