Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0EJV05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:26:57 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:36700 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751754Ab0EJV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:26:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=l4t4VO26288wI3XHsGhAxhS0wFeov2aB2oBvZKjVWs4BitSmp9gd9XuR3XKx9PrXd2qynqBAoKuiUqOgm877MQhvYLD4shRFSlpVujoDDsSMwgozZ6CCHExqvw6pdU7O;
Date: Mon, 10 May 2010 14:26:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 1/2] timer: add on-stack deferrable timer interfaces
Message-ID: <20100510142620.33e0a8a1@virtuousgeek.org>
In-Reply-To: <20100510142521.5a705dea@virtuousgeek.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases (for instance with kernel threads) it may be desireable to
use on-stack deferrable timers to get their power saving benefits.  Add
interfaces to support this for the IPS driver.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 include/linux/timer.h |   15 +++++++++++++++
 kernel/timer.c        |   13 +++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index a2d1eb6..b9bc8e1 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -94,6 +94,13 @@ void init_timer_deferrable_key(struct timer_list *timer,
 		setup_timer_on_stack_key((timer), #timer, &__key,	\
 					 (fn), (data));			\
 	} while (0)
+#define setup_deferrable_timer_on_stack(timer, fn, data)		\
+	do {								\
+		static struct lock_class_key __key;			\
+		setup_deferrable_timer_on_stack_key((timer), #timer,	\
+						    &__key, (fn),	\
+						    (data));		\
+	} while (0)
 #else
 #define init_timer(timer)\
 	init_timer_key((timer), NULL, NULL)
@@ -105,6 +112,8 @@ void init_timer_deferrable_key(struct timer_list *timer,
 	setup_timer_key((timer), NULL, NULL, (fn), (data))
 #define setup_timer_on_stack(timer, fn, data)\
 	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
+#define setup_deferrable_timer_on_stack(timer, fn, data)\
+	setup_deferrable_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
 #endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
@@ -144,6 +153,12 @@ static inline void setup_timer_on_stack_key(struct timer_list *timer,
 	init_timer_on_stack_key(timer, name, key);
 }
 
+extern void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
+						const char *name,
+						struct lock_class_key *key,
+						void (*function)(unsigned long),
+						unsigned long data);
+
 /**
  * timer_pending - is a timer pending?
  * @timer: the timer in question
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..a7b964a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -557,6 +557,19 @@ static void __init_timer(struct timer_list *timer,
 	lockdep_init_map(&timer->lockdep_map, name, key, 0);
 }
 
+void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
+					 const char *name,
+					 struct lock_class_key *key,
+					 void (*function)(unsigned long),
+					 unsigned long data)
+{
+	timer->function = function;
+	timer->data = data;
+	init_timer_on_stack_key(timer, name, key);
+	timer_set_deferrable(timer);
+}
+EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
+
 /**
  * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
-- 
1.7.0.1

