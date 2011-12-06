Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab1LFBmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:42:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:42:22 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=V6xMXOXh2XwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=_MoRDtdJ9Uc92lmFQBQA:9 a=1gRinDbRM5SDX5fBscYA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=_7rvjRG9PHBnDG1zAlMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206014219.278211062@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 20:41:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/6] tracing: Restore system filter behavior
References: <20111206014110.079874115@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Restore-system-filter-behavior.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Li Zefan <lizf@cn.fujitsu.com>

Though not all events have field 'prev_pid', it was allowed to do this:

  # echo 'prev_pid =3D=3D 100' > events/sched/filter

but commit 75b8e98263fdb0bfbdeba60d4db463259f1fe8a2 (tracing/filter: Swap
entire filter of events) broke it without any reason.

Link: http://lkml.kernel.org/r/4EAF46CF.8040408@cn.fujitsu.com

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    2 ++
 kernel/trace/trace_events_filter.c |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 96efa67..c3da42d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -172,6 +172,7 @@ enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
+	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 };
=20
 enum {
@@ -179,6 +180,7 @@ enum {
 	TRACE_EVENT_FL_FILTERED		=3D (1 << TRACE_EVENT_FL_FILTERED_BIT),
 	TRACE_EVENT_FL_RECORDED_CMD	=3D (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 	TRACE_EVENT_FL_CAP_ANY		=3D (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
+	TRACE_EVENT_FL_NO_SET_FILTER	=3D (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 };
=20
 struct ftrace_event_call {
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index d6e7926..95dc31e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1649,7 +1649,9 @@ static int replace_system_preds(struct event_subsyste=
m *system,
 		 */
 		err =3D replace_preds(call, NULL, ps, filter_string, true);
 		if (err)
-			goto fail;
+			call->flags |=3D TRACE_EVENT_FL_NO_SET_FILTER;
+		else
+			call->flags &=3D ~TRACE_EVENT_FL_NO_SET_FILTER;
 	}
=20
 	list_for_each_entry(call, &ftrace_events, list) {
@@ -1658,6 +1660,9 @@ static int replace_system_preds(struct event_subsyste=
m *system,
 		if (strcmp(call->class->system, system->name) !=3D 0)
 			continue;
=20
+		if (call->flags & TRACE_EVENT_FL_NO_SET_FILTER)
+			continue;
+
 		filter_item =3D kzalloc(sizeof(*filter_item), GFP_KERNEL);
 		if (!filter_item)
 			goto fail_mem;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3XL7AAoJEIy3vGnGbaoAco4QAO6Oj59AVUe+xfvyWfXSHB/B
Y0NulEml/updE+fr3Yb0iAh6n6KP7aLsd/m5yw2GZUF5wXSg2woKMwJ0uYtdkOhl
2AnDRphqCsMpRWvuk5LOZHnnXZogHwXAacyE+dXsXG09abjjR9r7di4Pl4ZHwMyV
wo86z+Xck7UXYh3DXhSTbUOCAxqb2a32qoLx6ylflQqRDEAdvawhjQzquhTs6g20
1ONslkcIOEJjEkWgWR4mny49sY83ndMG/PnPL+vgrArfqU9wBSW24fRYPeamuIWd
Dj6B1li54Sq8PS9+kdETAXOwWg5ojPfvIN7+hEHWtibS1j1Pop09unElKzYd5Ezw
Nhw7geS55YO0agKBVB3rPPOWko2hifvLslz7i6sEab2XY0SUBdeWxLWDhRHnFNzj
y+PepxDCYpMHgw4d5sIY7/Fg7jJCC+idg6nbimV0+j2Z+E1JQR8UFW1rfrlRpcBN
Fyalg4H5WOFYX/ChgTUVxlc52nB6iamR9uJnH0OtZnVRf5sPFnUs3cB4fDpsIIc0
dXG8RcOb2zkRqPgx3YCY/zSdbtcLG2Y2BlOjnJtNfiJEazfl8BkJBkTX+XR+zSiu
WcXZ9x17LEekUF57lUSZehXNHtABUpnh8kfMapOOSCviOIZ9NwXKjQTCjC16/7w/
W2vs8JEGplV8kVqqFFvN
=JEs+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
