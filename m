Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2DCBmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:42:44 -0400
Received: from mta115.f1.k8.com.br ([187.73.32.187]:60156 "EHLO
	mta115.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2DCBmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:42:43 -0400
Message-ID: <1333417354.2412.7.camel@Thor>
Subject: [PATCH 1/1] rculist: Made list_first_entry_rcu usable
From: Michel Machado <michel@digirati.com.br>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2012 21:42:34 -0400
Organization: Digirati Internet
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro list_first_entry_rcu assumed that the passed list is not empty
as its counterpart list_first_entry does. However, one can test that a
list is not empty with list_empty before calling list_first_entry,
whereas neither exists list_empty_rcu, nor is advisable to add it as the
example below shows.

Assuming that list_empty_rcu is available, one could write the following
snippet:

if (!list_empty_rcu(mylist)) {
	struct foo *bar = list_first_entry_rcu(mylist, struct foo,
		list_member);
	do_something(bar);
}

The problem with this snippet is the following racing condition: the
list may not be empty when list_empty_rcu checks it, but it may be when
list_first_entry_rcu rereads the ->next pointer.

This patch cannot break any upstream code because list_first_entry_rcu
is not being used anywhere in the kernel (tested with grep(1)), and
external code that uses it is probably broken already.

Signed-off-by: Michel Machado <michel@digirati.com.br>
CC: Dipankar Sarma <dipankar@in.ibm.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
Please CC my e-mail address while replying this message because I don't
subscribe this mailing list due to its high volume; thanks.

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index d079290..866d3ec 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -233,13 +233,16 @@ static inline void list_splice_init_rcu(struct
list_head *list,
  * @type:       the type of the struct this is embedded in.
  * @member:     the name of the list_struct within the struct.
  *
- * Note, that list is expected to be not empty.
+ * Note that if the list is empty, it returns NULL.
  *
  * This primitive may safely run concurrently with the _rcu
list-mutation
  * primitives such as list_add_rcu() as long as it's guarded by
rcu_read_lock().
  */
 #define list_first_entry_rcu(ptr, type, member) \
-	list_entry_rcu((ptr)->next, type, member)
+	({struct list_head *__ptr = ptr; \
+	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
+	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL;
\
+	})
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type


