Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2BVOnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:43:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2BVOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:13 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=R7jQZscdm2AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=5VWwTsiBk38U1gz7N9oA:9 a=IxbW029ruVz8BF8nX2AA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=oQ0e_yyQPKg8Dt4kR1sA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144210.435191457@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/9] ftrace, perf: Add add/del tracepoint perf registration actions
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-perf-Add-add-del-tracepoint-perf-registration.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding TRACE_REG_PERF_ADD and TRACE_REG_PERF_DEL to handle
perf event schedule in/out actions.

The add action is invoked for when the perf event is scheduled in,
while the del action is invoked when the event is scheduled out.

Link: http://lkml.kernel.org/r/1329317514-8131-4-git-send-email-jolsa@redha=
t.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    |    2 ++
 kernel/trace/trace_event_perf.c |    4 +++-
 kernel/trace/trace_events.c     |    2 ++
 kernel/trace/trace_kprobe.c     |    2 ++
 kernel/trace/trace_syscalls.c   |    4 ++++
 5 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 195e360..2bf677c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -148,6 +148,8 @@ enum trace_reg {
 	TRACE_REG_PERF_UNREGISTER,
 	TRACE_REG_PERF_OPEN,
 	TRACE_REG_PERF_CLOSE,
+	TRACE_REG_PERF_ADD,
+	TRACE_REG_PERF_DEL,
 };
=20
 struct ftrace_event_call;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_per=
f.c
index 0cfcc37..d72af0b 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -211,12 +211,14 @@ int perf_trace_add(struct perf_event *p_event, int fl=
ags)
 	list =3D this_cpu_ptr(pcpu_list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
=20
-	return 0;
+	return tp_event->class->reg(tp_event, TRACE_REG_PERF_ADD, p_event);
 }
=20
 void perf_trace_del(struct perf_event *p_event, int flags)
 {
+	struct ftrace_event_call *tp_event =3D p_event->tp_event;
 	hlist_del_rcu(&p_event->hlist_entry);
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_DEL, p_event);
 }
=20
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5138fea..079a93a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -173,6 +173,8 @@ int ftrace_event_reg(struct ftrace_event_call *call,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5667f89..580a05e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1912,6 +1912,8 @@ int kprobe_register(struct ftrace_event_call *event,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index e23515f..96fc733 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -666,6 +666,8 @@ static int syscall_enter_register(struct ftrace_event_c=
all *event,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
@@ -690,6 +692,8 @@ static int syscall_exit_register(struct ftrace_event_ca=
ll *event,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7CAAoJEIy3vGnGbaoAxvAP/irRWGRlON7K/7L/GGAwuK6D
74LBMaaZTwPtVPE0DNgdM6/4ng7xq8up6ap+DOw9ZwujrXKN4gJmQO0NeAb4Azx8
EDfaimUPZyG21MWbCNXDNJ9fpwm1KUN0vrtM33aDslkkdqrsMa+ClP5npMAlppLx
plT1IWgGX3Hn22oYUYIBtE2a4I7ij4crT3YmF/53sF7wLF//8ig1LoD9sooNoCXs
P3VNYzfTcEVdMVTularuRLtP/FCsHb3NciHukPUWrkjPwnFv/8LvcVLNCgKDA+R+
e6C4AkYzUCuPKjDLF6K4cNVBaz8wVpsetljFzyW3bjj2lrHDETwHOrGz8dhxV4p1
WwnkIYlrT+WWcQmKinkJr/DjKVZWOrQEAqoPDTOG3JUenEq7tCUmq7D8s/MOYnLh
XGQB2KZjrp8SqePyvjIkho2lNVgz/v0XP4fzilS19WDVWYQ/DaJlFqaKF0niFDLd
H6FPLgR2CNXHklwg6KMBN+IntbKVkmwxt3zkmBMgUKrJN0nbM6B6BwhMceNpsYLt
wS7FmyhInRChVKzm48qoWHWFwktk0N02kwQHqD/3x+X0h2b5zFMisFCqNd459MTy
/q5G2Dq5CUTbLXvC5+NkRKcYZqP53yATvDP/YVOLfckF15j895ZdZbw88ACc7ciJ
txg4N1UJlPg5/3lmGrvx
=ZnGm
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
