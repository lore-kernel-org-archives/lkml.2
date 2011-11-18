Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1KRXLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:11:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab1KRXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:11:48 -0500
Date: Fri, 18 Nov 2011 15:11:22 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-e5e78d08f3ab3094783b8df08a5b6d1d1a56a58f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de, sim@hostway.ca
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, srostedt@redhat.com,
        tglx@linutronix.de, sim@hostway.ca
In-Reply-To: <20111025202049.GB25043@hostway.ca>
References: <20111025202049.GB25043@hostway.ca>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] lockdep: Show subclass in pretty print of lockdep output
Git-Commit-ID: e5e78d08f3ab3094783b8df08a5b6d1d1a56a58f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:11:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5e78d08f3ab3094783b8df08a5b6d1d1a56a58f
Gitweb:     http://git.kernel.org/tip/e5e78d08f3ab3094783b8df08a5b6d1d1a56a58f
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 2 Nov 2011 20:24:16 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Nov 2011 11:01:46 -0500

lockdep: Show subclass in pretty print of lockdep output

The pretty print of the lockdep debug splat uses just the lock name
to show how the locking scenario happens. But when it comes to
nesting locks, the output becomes confusing which takes away the point
of the pretty printing of the lock scenario.

Without displaying the subclass info, we get the following output:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(slock-AF_INET);
                                lock(slock-AF_INET);
                                lock(slock-AF_INET);
   lock(slock-AF_INET);

  *** DEADLOCK ***

The above looks more of a A->A locking bug than a A->B B->A.
By adding the subclass to the output, we can see what really happened:

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(slock-AF_INET);
                                lock(slock-AF_INET/1);
                                lock(slock-AF_INET);
   lock(slock-AF_INET/1);

  *** DEADLOCK ***

This bug was discovered while tracking down a real bug caught by lockdep.

Link: http://lkml.kernel.org/r/20111025202049.GB25043@hostway.ca

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 91d67ce..6bd915d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -490,36 +490,32 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 	usage[i] = '\0';
 }
 
-static int __print_lock_name(struct lock_class *class)
+static void __print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN];
 	const char *name;
 
 	name = class->name;
-	if (!name)
-		name = __get_key_name(class->key, str);
-
-	return printk("%s", name);
-}
-
-static void print_lock_name(struct lock_class *class)
-{
-	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
-	const char *name;
-
-	get_usage_chars(class, usage);
-
-	name = class->name;
 	if (!name) {
 		name = __get_key_name(class->key, str);
-		printk(" (%s", name);
+		printk("%s", name);
 	} else {
-		printk(" (%s", name);
+		printk("%s", name);
 		if (class->name_version > 1)
 			printk("#%d", class->name_version);
 		if (class->subclass)
 			printk("/%d", class->subclass);
 	}
+}
+
+static void print_lock_name(struct lock_class *class)
+{
+	char usage[LOCK_USAGE_CHARS];
+
+	get_usage_chars(class, usage);
+
+	printk(" (");
+	__print_lock_name(class);
 	printk("){%s}", usage);
 }
 
