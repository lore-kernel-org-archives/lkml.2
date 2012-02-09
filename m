Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab2BIDO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:14:57 -0500
Received: from mx2.netapp.com ([216.240.18.37]:61490 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab2BIDOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:14:55 -0500
X-IronPort-AV: E=Sophos;i="4.73,387,1325491200"; 
   d="scan'208";a="623837162"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: Tree for Feb 2 (trace/events/sunrpc.h)
Thread-Topic: linux-next: Tree for Feb 2 (trace/events/sunrpc.h)
Thread-Index: AQHM5tO9TFW7VWehPUStvETYNujz+5Y0amiA
Date: Thu, 9 Feb 2012 03:14:48 +0000
Message-ID: <1328757287.3234.76.camel@lade.trondhjem.org>
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
	 <4F2AD18D.9030904@xenotime.net>
	 <1328755030.2200.133.camel@gandalf.stny.rr.com>
In-Reply-To: <1328755030.2200.133.camel@gandalf.stny.rr.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D077FD8824811144B273378A92AEBD13@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Feb 2012 03:14:49.0112 (UTC) FILETIME=[FB58B180:01CCE6D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q193FK4f007547

On Wed, 2012-02-08 at 21:37 -0500, Steven Rostedt wrote:
> [ Added the person responsible for this ]
> 
> On Thu, 2012-02-02 at 10:10 -0800, Randy Dunlap wrote:
> > On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20120201:
> > 
> > 
> > 
> > include/trace/events/sunrpc.h:69:1: error: implicit declaration of function 'rpc_qname'
> > include/trace/events/sunrpc.h:69:1: warning: format '%s' expects type 'char *', but argument 9 has type 'int'
> 
> This has actually nothing to do with the tracepoint itself. The bug is
> with the rpc_qname().
> 
> The tracepoint references rpc_qname() and in
> include/linux/sunrpc/sched.h:
> 
> 
> #ifdef RPC_DEBUG
> static inline const char * rpc_qname(const struct rpc_wait_queue *q)
> {
> 	return ((q && q->name) ? q->name : "unknown");
> }
> #endif
> 
> Your config had RPC_DEBUG not set, thus the function was not defined.
> 
> 
> The below patch fixes the problem with the side effect that the trace
> data will contain "unknown" for all references to rcu_qname().
> 
> -- Steve
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> 
> diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
> index f7b2df5..c89ba95 100644
> --- a/include/linux/sunrpc/sched.h
> +++ b/include/linux/sunrpc/sched.h
> @@ -275,6 +275,11 @@ static inline const char * rpc_qname(const struct rpc_wait_queue *q)
>  {
>  	return ((q && q->name) ? q->name : "unknown");
>  }
> +#else
> +static inline const char * rpc_qname(const struct rpc_wait_queue *q)
> +{
> +	return "unknown";
> +}
>  #endif
>  
>  #endif /* _LINUX_SUNRPC_SCHED_H_ */

Hmm.... How about if we rather take that out of the RPC_DEBUG condition?
I'm assuming that if someone compiles in the tracepoint code, then they
want to be able to do a full trace independently of whether or not they
set CONFIG_SYSCTL.

8<---------------------------------------------------------------------
>From d051b60dcc3032b71cf8d9b96ac4bf24f12b6dcb Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 8 Feb 2012 22:01:15 -0500
Subject: [PATCH] SUNRPC: Ensure that we can trace waitqueues when
 !defined(CONFIG_SYSCTL)

The tracepoint code relies on the queue->name being defined in order to
be able to display the name of the waitqueue on which an RPC task is
sleeping.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 include/linux/sunrpc/debug.h |    3 +++
 include/linux/sunrpc/sched.h |   15 +++++++++++++--
 net/sunrpc/sched.c           |    4 +---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/debug.h b/include/linux/sunrpc/debug.h
index c2786f2..2a11eb2 100644
--- a/include/linux/sunrpc/debug.h
+++ b/include/linux/sunrpc/debug.h
@@ -34,6 +34,9 @@
 #ifdef CONFIG_SYSCTL
 #define  RPC_DEBUG
 #endif
+#ifdef CONFIG_TRACEPOINTS
+#define RPC_TRACEPOINTS
+#endif
 /* #define  RPC_PROFILE */
 
 /*
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index f7b2df5..22dfc24 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -195,7 +195,7 @@ struct rpc_wait_queue {
 	unsigned char		nr;			/* # tasks remaining for cookie */
 	unsigned short		qlen;			/* total # tasks waiting in queue */
 	struct rpc_timer	timer_list;
-#ifdef RPC_DEBUG
+#if defined(RPC_DEBUG) || defined(RPC_TRACEPOINTS)
 	const char *		name;
 #endif
 };
@@ -270,11 +270,22 @@ static inline int rpc_task_has_priority(struct rpc_task *task, unsigned char pri
 	return (task->tk_priority + RPC_PRIORITY_LOW == prio);
 }
 
-#ifdef RPC_DEBUG
+#if defined(RPC_DEBUG) || defined (RPC_TRACEPOINTS)
 static inline const char * rpc_qname(const struct rpc_wait_queue *q)
 {
 	return ((q && q->name) ? q->name : "unknown");
 }
+
+static inline void rpc_assign_waitqueue_name(struct rpc_wait_queue *q,
+		const char *name)
+{
+	q->name = name;
+}
+#else
+static inline void rpc_assign_waitqueue_name(struct rpc_wait_queue *q,
+		const char *name)
+{
+}
 #endif
 
 #endif /* _LINUX_SUNRPC_SCHED_H_ */
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index d79c63d..1c570a8 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -208,9 +208,7 @@ static void __rpc_init_priority_wait_queue(struct rpc_wait_queue *queue, const c
 	queue->qlen = 0;
 	setup_timer(&queue->timer_list.timer, __rpc_queue_timer_fn, (unsigned long)queue);
 	INIT_LIST_HEAD(&queue->timer_list.list);
-#ifdef RPC_DEBUG
-	queue->name = qname;
-#endif
+	rpc_assign_waitqueue_name(queue, qname);
 }
 
 void rpc_init_priority_wait_queue(struct rpc_wait_queue *queue, const char *qname)
-- 
1.7.7.6


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
