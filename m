Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2FKX5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:57:18 -0400
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:60582 "EHLO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2FKX5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:57:15 -0400
X-Greylist: delayed 4933 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2012 19:57:15 EDT
From: Paton Lewis <palewis@adobe.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Paton Lewis <palewis@adobe.com>, Paul Holland <pholland@adobe.com>
Date: Mon, 11 Jun 2012 15:34:49 -0700
Subject: [PATCH] epoll: Improved support for multi-threaded clients
Thread-Topic: [PATCH] epoll: Improved support for multi-threaded clients
Thread-Index: AQHNSCGJAZiQWGl8oE6Qxgw2CSfFbw==
Message-ID: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is not currently possible to reliably delete epoll items when using the
same epoll set from multiple threads. After calling epoll_ctl with
EPOLL_CTL_DEL, another thread might still be executing code related to an
event for that epoll item (in response to epoll_wait). Therefore the deleting
thread does not know when it is safe to delete resources pertaining to the
associated epoll item because another thread might be using those resources.

The deleting thread could wait an arbitrary amount of time after calling
epoll_ctl with EPOLL_CTL_DEL and before deleting the item, but this is
inefficient and could result in the destruction of resources before another
thread is done handling an event returned by epoll_wait.

This patch introduces the new epoll_ctl command EPOLL_CTL_DISABLE, which
disables the associated epoll item and returns -EBUSY if the epoll item is not
currently in the epoll ready queue. This allows multiple threads to use a
mutex to determine when it is safe to delete an epoll item and its associated
resources. This allows epoll items to be deleted and closed efficiently and
without error.

This patch has been tested against the following checklist:
http://kernelnewbies.org/UpstreamMerge/SubmitChecklist

The following psuedocode attempts to illustrate the problem as well as the
solution provided by this patch.


Pseudocode for the deleting thread:


void delete_epoll_item( int index )
{
	bool handling_io = false;
	pthread_mutex_lock( items[ index ].stop_mutex );
	items[ index ].stop_work = true;
#ifdef EPOLL_CTL_DISABLE
	if( epoll_ctl( epoll_fd, EPOLL_CTL_DISABLE, items[ index ].fd, NULL ) == 0 )
	{
		if( epoll_ctl( epoll_fd, EPOLL_CTL_DEL, items[ index ].fd, NULL ) < 0 )
			handle_error();
	}
	else if ( errno == EBUSY )
		handling_io = true;
	else
		handle_error();
#else
	if( epoll_ctl( epoll_fd, EPOLL_CTL_DEL, items[ index ].fd, NULL ) < 0 )
		handle_error();
	else
		/* Wait in case another thread is currently doing I/O on this item.
		   Note that we have no idea if this will be long enough or not: */
		sleep( 10 );
#endif
	if( !handling_io )
		delete_item( items[ index ] );
	pthread_mutex_unlock( items[ index ].stop_mutex );
}


Pseudocode for the processing thread:


	while( epoll_wait( epoll_fd, &event, 1, -1 ) == 1 )
	{
		item = item_from_event( event );
		/* Without EPOLL_CTL_DISABLE, the following call can fail because
		   'item' has been deleted: */
		pthread_mutex_lock( item.stop_mutex );
		if( item.stop_work )
		{
			pthread_mutex_unlock( item.stop_mutex );
			/* Without EPOLL_CTL_DISABLE, the following call can fail because
		   	   'item' has already been deleted: */
			delete_item( item );
		}
		else
		{
			perform_io( item );
			event.events = EPOLLONESHOT | EPOLLET | EPOLLIN | EPOLLOUT;
			if( epoll_ctl( epoll_fd, EPOLL_CTL_ADD, item.fd, &event ) < 0 )
				handle_error();
			pthread_mutex_unlock( item.stop_mutex );
		}
	}


Signed-off-by: Paton J. Lewis <palewis@adobe.com>
---
 fs/eventpoll.c            |   35 ++++++++++++++++++++++++++++++++---
 include/linux/eventpoll.h |    1 +
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 739b098..ef924e5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -339,7 +339,7 @@ static inline struct epitem *ep_item_from_epqueue(poll_table *p)
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
-	return op != EPOLL_CTL_DEL;
+	return op == EPOLL_CTL_ADD || op == EPOLL_CTL_MOD;
 }
 
 /* Initialize the poll safe wake up structure */
@@ -664,6 +664,31 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	return 0;
 }
 
+/*
+ * Disables a "struct epitem" in the eventpoll set. Returns -EBUSY
+ * if the item was not in the ready list and its event may therefore
+ * be currently getting handled by another thread.
+ * Must be called with "mtx" held.
+ */
+static int ep_disable(struct eventpoll *ep, struct epitem *epi)
+{
+	int result = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ep->lock, flags);
+	if (ep_is_linked(&epi->rdllink))
+		list_del_init(&epi->rdllink);
+	else
+		result = -EBUSY;
+
+	/* Ensure ep_poll_callback will not add epi back onto ready list: */
+	epi->event.events &= EP_PRIVATE_BITS;
+
+	spin_unlock_irqrestore(&ep->lock, flags);
+
+	return result;
+}
+
 static void ep_free(struct eventpoll *ep)
 {
 	struct rb_node *rbp;
@@ -996,8 +1021,6 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
 	rb_insert_color(&epi->rbn, &ep->rbr);
 }
 
-
-
 #define PATH_ARR_SIZE 5
 /*
  * These are the number paths of length 1 to 5, that we are allowing to emanate
@@ -1701,6 +1724,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		} else
 			error = -ENOENT;
 		break;
+	case EPOLL_CTL_DISABLE:
+		if (epi)
+			error = ep_disable(ep, epi);
+		else
+			error = -ENOENT;
+		break;
 	}
 	mutex_unlock(&ep->mtx);
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 657ab55..e91f7e3 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -25,6 +25,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
+#define EPOLL_CTL_DISABLE 4
 
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
-- 
1.7.5.4


Signed-off-by: Paton J. Lewis <palewis@adobe.com>
---
 fs/eventpoll.c            |   35 ++++++++++++++++++++++++++++++++---
 include/linux/eventpoll.h |    1 +
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 739b098..ef924e5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -339,7 +339,7 @@ static inline struct epitem *ep_item_from_epqueue(poll_table *p)
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
-	return op != EPOLL_CTL_DEL;
+	return op == EPOLL_CTL_ADD || op == EPOLL_CTL_MOD;
 }
 
 /* Initialize the poll safe wake up structure */
@@ -664,6 +664,31 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	return 0;
 }
 
+/*
+ * Disables a "struct epitem" in the eventpoll set. Returns -EBUSY
+ * if the item was not in the ready list and its event may therefore
+ * be currently getting handled by another thread.
+ * Must be called with "mtx" held.
+ */
+static int ep_disable(struct eventpoll *ep, struct epitem *epi)
+{
+	int result = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ep->lock, flags);
+	if (ep_is_linked(&epi->rdllink))
+		list_del_init(&epi->rdllink);
+	else
+		result = -EBUSY;
+
+	/* Ensure ep_poll_callback will not add epi back onto ready list: */
+	epi->event.events &= EP_PRIVATE_BITS;
+
+	spin_unlock_irqrestore(&ep->lock, flags);
+
+	return result;
+}
+
 static void ep_free(struct eventpoll *ep)
 {
 	struct rb_node *rbp;
@@ -996,8 +1021,6 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
 	rb_insert_color(&epi->rbn, &ep->rbr);
 }
 
-
-
 #define PATH_ARR_SIZE 5
 /*
  * These are the number paths of length 1 to 5, that we are allowing to emanate
@@ -1701,6 +1724,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		} else
 			error = -ENOENT;
 		break;
+	case EPOLL_CTL_DISABLE:
+		if (epi)
+			error = ep_disable(ep, epi);
+		else
+			error = -ENOENT;
+		break;
 	}
 	mutex_unlock(&ep->mtx);
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 657ab55..e91f7e3 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -25,6 +25,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
+#define EPOLL_CTL_DISABLE 4
 
 /* Set the One Shot behaviour for the target file descriptor */
 #define EPOLLONESHOT (1 << 30)
-- 
1.7.5.4

