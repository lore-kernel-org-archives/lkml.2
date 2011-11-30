Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab1K3QYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:24:46 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:46448 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab1K3QYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:24:40 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Masami.hiramatsu.pt@hitachi.com'" <Masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Nov 2011 11:24:27 -0500
Subject: RE: [PATCH 2/2] tracing: send_sigqueue() needs
 trace_signal_generate()	too
Thread-Topic: [PATCH 2/2] tracing: send_sigqueue() needs
 trace_signal_generate()	too
Thread-Index: AcypWYE451KamP9oRhyloN6fa5c2twGIpzcA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57D411B7@USINDEVS01.corp.hds.com>
References: <20111121191920.GA24883@redhat.com>
 <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com>
 <1321912356.20742.24.camel@frodo> <20111122205239.GA20971@redhat.com>
 <20111122205314.GC20971@redhat.com>
In-Reply-To: <20111122205314.GC20971@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=8 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1111300142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Oleg Nesterov
>Sent: Tuesday, November 22, 2011 3:53 PM
>To: Steven Rostedt
>Cc: Frederic Weisbecker; Ingo Molnar; Jiri Olsa; Masami Hiramatsu; Seiji Aguchi; linux-kernel@vger.kernel.org
>Subject: [PATCH 2/2] tracing: send_sigqueue() needs trace_signal_generate() too
>
>Add trace_signal_generate() into send_sigqueue().
>
>send_sigqueue() is very similar to __send_signal(), just it uses
>the preallocated info. It should do the same wrt tracing.
>

Looks good.
Reviewed-by: Seiji Aguchi <seiji.aguchi@hds.com>

>Reported-by: Seiji Aguchi <saguchi@redhat.com>
>Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>---
> kernel/signal.c |    6 +++++-
> 1 files changed, 5 insertions(+), 1 deletions(-)
>
>diff --git a/kernel/signal.c b/kernel/signal.c
>index 5f130f6..7366f68 100644
>--- a/kernel/signal.c
>+++ b/kernel/signal.c
>@@ -1559,7 +1559,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
> 	int sig = q->info.si_signo;
> 	struct sigpending *pending;
> 	unsigned long flags;
>-	int ret;
>+	int ret, result;
>
> 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>
>@@ -1568,6 +1568,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
> 		goto ret;
>
> 	ret = 1; /* the signal is ignored */
>+	result = TRACE_SIGNAL_IGNORED;
> 	if (!prepare_signal(sig, t, 0))
> 		goto out;
>
>@@ -1579,6 +1580,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
> 		 */
> 		BUG_ON(q->info.si_code != SI_TIMER);
> 		q->info.si_overrun++;
>+		result = TRACE_SIGNAL_ALREADY_PENDING;
> 		goto out;
> 	}
> 	q->info.si_overrun = 0;
>@@ -1588,7 +1590,9 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
> 	list_add_tail(&q->list, &pending->list);
> 	sigaddset(&pending->signal, sig);
> 	complete_signal(sig, t, group);
>+	result = TRACE_SIGNAL_DELIVERED;
> out:
>+	trace_signal_generate(sig, &q->info, t, group, result);
> 	unlock_task_sighand(t, &flags);
> ret:
> 	return ret;
>--
>1.5.5.1
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
