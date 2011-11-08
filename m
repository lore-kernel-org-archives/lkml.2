Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1KHBao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:30:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1KHBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:38 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=OAyoMmvJi0EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=l4oKXxidolLKefUkS98A:9 a=eFr-wm5IPnsx5wqWWwsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=JueQIJ928L3v5IsrKo4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013037.560493198@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 03/10] tracing: Add boiler plate for subsystem filter
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-boiler-plate-for-subsystem-filter.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The system filter can be used to set multiple event filters that
exist within the system. But currently it displays the last filter
written that does not necessarily correspond to the filters within
the system. The system filter itself is not used to filter any events.
The system filter is just a means to set filters of the events within
it.

Because this causes an ambiguous state when the system filter reads
a filter string but the events within the system have different strings
it is best to just show a boiler plate:

 ### global filter ###
 # Use this to set filters for multiple events.
 # Only events with the given fields will be affected.
 # If no events are modified, an error message will be displayed here.

If an error occurs while writing to the system filter, the system
filter will replace the boiler plate with the error message as it
currently does.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 86040d9..fdc6d22 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -27,6 +27,12 @@
 #include "trace.h"
 #include "trace_output.h"
=20
+#define DEFAULT_SYS_FILTER_MESSAGE					\
+	"### global filter ###\n"					\
+	"# Use this to set filters for multiple events.\n"		\
+	"# Only events with the given fields will be affected.\n"	\
+	"# If no events are modified, an error message will be displayed here"
+
 enum filter_op_ids
 {
 	OP_OR,
@@ -646,7 +652,7 @@ void print_subsystem_event_filter(struct event_subsyste=
m *system,
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
-		trace_seq_printf(s, "none\n");
+		trace_seq_printf(s, DEFAULT_SYS_FILTER_MESSAGE "\n");
 	mutex_unlock(&event_mutex);
 }
=20
@@ -1838,7 +1844,10 @@ int apply_subsystem_event_filter(struct event_subsys=
tem *system,
 	if (!filter)
 		goto out;
=20
-	replace_filter_string(filter, filter_string);
+	/* System filters just show a default message */
+	kfree(filter->filter_string);
+	filter->filter_string =3D NULL;
+
 	/*
 	 * No event actually uses the system filter
 	 * we can free it without synchronize_sched().
@@ -1848,14 +1857,12 @@ int apply_subsystem_event_filter(struct event_subsy=
stem *system,
=20
 	parse_init(ps, filter_ops, filter_string);
 	err =3D filter_parse(ps);
-	if (err) {
-		append_filter_err(ps, system->filter);
-		goto out;
-	}
+	if (err)
+		goto err_filter;
=20
 	err =3D replace_system_preds(system, ps, filter_string);
 	if (err)
-		append_filter_err(ps, system->filter);
+		goto err_filter;
=20
 out:
 	filter_opstack_clear(ps);
@@ -1865,6 +1872,11 @@ out_unlock:
 	mutex_unlock(&event_mutex);
=20
 	return err;
+
+err_filter:
+	replace_filter_string(filter, filter_string);
+	append_filter_err(ps, system->filter);
+	goto out;
 }
=20
 #ifdef CONFIG_PERF_EVENTS
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY9AAoJEIy3vGnGbaoAsbsQAN2ayC5qzRAHe11uJPwRafXH
a2mRbAEqbaWQmTiCP5Vpm/jd3EHzow+kAHBsnqFumisOtXhKzgbe1CGefkyTJWdH
CRH2NKtaGxdHTQ6AdRURk+FN0l3P6AVabw5mje3iq6TUD1SRxVrIsPqK50u6aRV7
V1QeYCzmHgBi4aPWwT7A/M1pz8JfZWkuEENwl8F6VGXMS5wJmZW+vm/k68Qu0DZ4
WWHrDcgYaxIqFzodkDgQPGTvsw7sDR3Y0mggZK6ySp6ggsOYQWLvN+mBcxsGGRxL
4UENyq7WRLqe+tbe5UHm+OQkOdBpApTemdhVt1j1EMKr1z33RTx9BMdy144f8P+B
IKKNwvLVDzqf1oBmQWyjh+5xPyN+3riJTqCHskI1i15gOGc7hlR7yc8ghBl8JL0v
H/bBAM/q9jv0SEnNw5ZDm37LJgHdwhi/mzmil79YxTRu3Va7GkdcHB66ijmnJkS8
S3J0icM41TKOa0/ogJ2q2U8W/Hoi4wkNdWgU/sXl1hmjGg0UzXd+/AyB+N8U+qdx
F8FlbfmIATWPEc6hSCJGmFq7XyUX/LFxJAONOuVhOi/HrCJ8jDzExEtcW+L2Oiw7
XSKc+cj4aYEaXVjxU1LHjH/HCJLe7egts8Ry/9q4iRxiZgXqNYhnHltgA1cJtV0k
FAPxGEBnd57MWq5LMSQ6
=qxfJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
