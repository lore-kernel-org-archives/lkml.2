Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1KHBal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:30:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1KHBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:38 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=lNjySy1V4GQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=_MoRDtdJ9Uc92lmFQBQA:9 a=1gRinDbRM5SDX5fBscYA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=_c7ACBCFbtNB2VrR85wA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013037.128419411@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 02/10] tracing: Restore system filter behavior
References: <20111108012939.372220547@goodmis.org>
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
index 816d3d0..86040d9 100644
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
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY9AAoJEIy3vGnGbaoAIPEQAJ8gshoOqOjZ4ywStaTA5dNW
PxBS5kpM0UdyZPqXM7ohVAK448zPj9DCC21qrq6A+seRJZQJKaGWAATsdblkF9PN
WMBdaJ6lup/FibGfdHAkbNml9nfEVs0lhKgKfqh3Cr9GYLDF2yB3p1T7F1g8Fs49
aBr5ZNZCZkWL5zXlJcX3xcHTvJzjD6xFpzCUP8vg2DjBWbNE5tXTDhzowaPZnEF3
/CTVoHn7I37STcywKSNUZ8/CYXVDxVioS6AC4rXD1X0aDeikPG+DvYUFKAXd5TLv
aX0qcV++OFhDns+/p5WKITvcAYfDUMlY17wOoX/6dpxecVqafQQLsM74wQ+5xxh7
Tfuny0WtQdNVstrBq72Zo2APoZsGbJgp41XsuKOcdHr5bdjpxhdJIz52n5Ox1atX
rVs37dBtXCWgsilQ9H1syGFv4u8BrNmYbNiLdKOvAI1ZNLpAlCLofaN3RqAD8Zac
r7FutSDAq2snSs5ns1vluEE6hHn0dS8g8fpgGZGp95gR+IOMYKIo9zq8/U/B0ngK
buL0w9yvisxX3ppC89E5eTIq5HAUXcZNPliTAg+oHz+1zXuS7vaYfOX4pR+Lkl1S
VBdk/Ax0Mp40E9NQHdXrXH7wXQFmEhwwOzhFFE1wdT6ruxL5ZKpjmX3FqRh4+aYc
CvcNzoGO/euJ0S4xKY2y
=LJgk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
