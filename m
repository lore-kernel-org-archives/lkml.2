Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1LUMja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:39:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1LUMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:13 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=A9AKlfWQAwsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=J40Elaxdzwn_IxBdQ3sA:9 a=ZOhHvLSm1oTW8RjefgsA:7 a=QEXdDO2ut3YA:10 a=PhqLORVAZFQA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=x-KPXDeS7YgTIhSPBn4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123812.093382193@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] tracing: Factorize filter creation
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0016-tracing-Factorize-filter-creation.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Tejun Heo <tj@kernel.org>

There are four places where new filter for a given filter string is
created, which involves several different steps.  This patch factors
those steps into create_[system_]filter() functions which in turn make
use of create_filter_{start|finish}() for common parts.

The only functional change is that if replace_filter_string() is
requested and fails, creation fails without any side effect instead of
being ignored.

Note that system filter is now installed after the processing is
complete which makes freeing before and then restoring filter string
on error unncessary.

-v2: Rebased to resolve conflict with 49aa29513e and updated both
     create_filter() functions to always set *filterp instead of
     requiring the caller to clear it to %NULL on entry.

Link: http://lkml.kernel.org/r/1323988305-1469-2-git-send-email-tj@kernel.o=
rg

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |  283 ++++++++++++++++++--------------=
----
 1 files changed, 142 insertions(+), 141 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index f04cc31..24aee71 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1738,11 +1738,121 @@ static int replace_system_preds(struct event_subsy=
stem *system,
 	return -ENOMEM;
 }
=20
+static int create_filter_start(char *filter_str, bool set_str,
+			       struct filter_parse_state **psp,
+			       struct event_filter **filterp)
+{
+	struct event_filter *filter;
+	struct filter_parse_state *ps =3D NULL;
+	int err =3D 0;
+
+	WARN_ON_ONCE(*psp || *filterp);
+
+	/* allocate everything, and if any fails, free all and fail */
+	filter =3D __alloc_filter();
+	if (filter && set_str)
+		err =3D replace_filter_string(filter, filter_str);
+
+	ps =3D kzalloc(sizeof(*ps), GFP_KERNEL);
+
+	if (!filter || !ps || err) {
+		kfree(ps);
+		__free_filter(filter);
+		return -ENOMEM;
+	}
+
+	/* we're committed to creating a new filter */
+	*filterp =3D filter;
+	*psp =3D ps;
+
+	parse_init(ps, filter_ops, filter_str);
+	err =3D filter_parse(ps);
+	if (err && set_str)
+		append_filter_err(ps, filter);
+	return err;
+}
+
+static void create_filter_finish(struct filter_parse_state *ps)
+{
+	if (ps) {
+		filter_opstack_clear(ps);
+		postfix_clear(ps);
+		kfree(ps);
+	}
+}
+
+/**
+ * create_filter - create a filter for a ftrace_event_call
+ * @call: ftrace_event_call to create a filter for
+ * @filter_str: filter string
+ * @set_str: remember @filter_str and enable detailed error in filter
+ * @filterp: out param for created filter (always updated on return)
+ *
+ * Creates a filter for @call with @filter_str.  If @set_str is %true,
+ * @filter_str is copied and recorded in the new filter.
+ *
+ * On success, returns 0 and *@filterp points to the new filter.  On
+ * failure, returns -errno and *@filterp may point to %NULL or to a new
+ * filter.  In the latter case, the returned filter contains error
+ * information if @set_str is %true and the caller is responsible for
+ * freeing it.
+ */
+static int create_filter(struct ftrace_event_call *call,
+			 char *filter_str, bool set_str,
+			 struct event_filter **filterp)
+{
+	struct event_filter *filter =3D NULL;
+	struct filter_parse_state *ps =3D NULL;
+	int err;
+
+	err =3D create_filter_start(filter_str, set_str, &ps, &filter);
+	if (!err) {
+		err =3D replace_preds(call, filter, ps, filter_str, false);
+		if (err && set_str)
+			append_filter_err(ps, filter);
+	}
+	create_filter_finish(ps);
+
+	*filterp =3D filter;
+	return err;
+}
+
+/**
+ * create_system_filter - create a filter for an event_subsystem
+ * @system: event_subsystem to create a filter for
+ * @filter_str: filter string
+ * @filterp: out param for created filter (always updated on return)
+ *
+ * Identical to create_filter() except that it creates a subsystem filter
+ * and always remembers @filter_str.
+ */
+static int create_system_filter(struct event_subsystem *system,
+				char *filter_str, struct event_filter **filterp)
+{
+	struct event_filter *filter =3D NULL;
+	struct filter_parse_state *ps =3D NULL;
+	int err;
+
+	err =3D create_filter_start(filter_str, true, &ps, &filter);
+	if (!err) {
+		err =3D replace_system_preds(system, ps, filter_str);
+		if (!err) {
+			/* System filters just show a default message */
+			kfree(filter->filter_string);
+			filter->filter_string =3D NULL;
+		} else {
+			append_filter_err(ps, filter);
+		}
+	}
+	create_filter_finish(ps);
+
+	*filterp =3D filter;
+	return err;
+}
+
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
-	struct filter_parse_state *ps;
 	struct event_filter *filter;
-	struct event_filter *tmp;
 	int err =3D 0;
=20
 	mutex_lock(&event_mutex);
@@ -1759,49 +1869,30 @@ int apply_event_filter(struct ftrace_event_call *ca=
ll, char *filter_string)
 		goto out_unlock;
 	}
=20
-	err =3D -ENOMEM;
-	ps =3D kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto out_unlock;
-
-	filter =3D __alloc_filter();
-	if (!filter) {
-		kfree(ps);
-		goto out_unlock;
-	}
-
-	replace_filter_string(filter, filter_string);
-
-	parse_init(ps, filter_ops, filter_string);
-	err =3D filter_parse(ps);
-	if (err) {
-		append_filter_err(ps, filter);
-		goto out;
-	}
+	err =3D create_filter(call, filter_string, true, &filter);
=20
-	err =3D replace_preds(call, filter, ps, filter_string, false);
-	if (err) {
-		filter_disable(call);
-		append_filter_err(ps, filter);
-	} else
-		call->flags |=3D TRACE_EVENT_FL_FILTERED;
-out:
 	/*
 	 * Always swap the call filter with the new filter
 	 * even if there was an error. If there was an error
 	 * in the filter, we disable the filter and show the error
 	 * string
 	 */
-	tmp =3D call->filter;
-	rcu_assign_pointer(call->filter, filter);
-	if (tmp) {
-		/* Make sure the call is done with the filter */
-		synchronize_sched();
-		__free_filter(tmp);
+	if (filter) {
+		struct event_filter *tmp =3D call->filter;
+
+		if (!err)
+			call->flags |=3D TRACE_EVENT_FL_FILTERED;
+		else
+			filter_disable(call);
+
+		rcu_assign_pointer(call->filter, filter);
+
+		if (tmp) {
+			/* Make sure the call is done with the filter */
+			synchronize_sched();
+			__free_filter(tmp);
+		}
 	}
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
 out_unlock:
 	mutex_unlock(&event_mutex);
=20
@@ -1811,7 +1902,6 @@ out_unlock:
 int apply_subsystem_event_filter(struct event_subsystem *system,
 				 char *filter_string)
 {
-	struct filter_parse_state *ps;
 	struct event_filter *filter;
 	int err =3D 0;
=20
@@ -1835,48 +1925,19 @@ int apply_subsystem_event_filter(struct event_subsy=
stem *system,
 		goto out_unlock;
 	}
=20
-	err =3D -ENOMEM;
-	ps =3D kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto out_unlock;
-
-	filter =3D __alloc_filter();
-	if (!filter)
-		goto out;
-
-	/* System filters just show a default message */
-	kfree(filter->filter_string);
-	filter->filter_string =3D NULL;
-
-	/*
-	 * No event actually uses the system filter
-	 * we can free it without synchronize_sched().
-	 */
-	__free_filter(system->filter);
-	system->filter =3D filter;
-
-	parse_init(ps, filter_ops, filter_string);
-	err =3D filter_parse(ps);
-	if (err)
-		goto err_filter;
-
-	err =3D replace_system_preds(system, ps, filter_string);
-	if (err)
-		goto err_filter;
-
-out:
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
+	err =3D create_system_filter(system, filter_string, &filter);
+	if (filter) {
+		/*
+		 * No event actually uses the system filter
+		 * we can free it without synchronize_sched().
+		 */
+		__free_filter(system->filter);
+		system->filter =3D filter;
+	}
 out_unlock:
 	mutex_unlock(&event_mutex);
=20
 	return err;
-
-err_filter:
-	replace_filter_string(filter, filter_string);
-	append_filter_err(ps, system->filter);
-	goto out;
 }
=20
 #ifdef CONFIG_PERF_EVENTS
@@ -1894,7 +1955,6 @@ int ftrace_profile_set_filter(struct perf_event *even=
t, int event_id,
 {
 	int err;
 	struct event_filter *filter;
-	struct filter_parse_state *ps;
 	struct ftrace_event_call *call;
=20
 	mutex_lock(&event_mutex);
@@ -1909,33 +1969,10 @@ int ftrace_profile_set_filter(struct perf_event *ev=
ent, int event_id,
 	if (event->filter)
 		goto out_unlock;
=20
-	filter =3D __alloc_filter();
-	if (!filter) {
-		err =3D PTR_ERR(filter);
-		goto out_unlock;
-	}
-
-	err =3D -ENOMEM;
-	ps =3D kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto free_filter;
-
-	parse_init(ps, filter_ops, filter_str);
-	err =3D filter_parse(ps);
-	if (err)
-		goto free_ps;
-
-	err =3D replace_preds(call, filter, ps, filter_str, false);
+	err =3D create_filter(call, filter_str, false, &filter);
 	if (!err)
 		event->filter =3D filter;
-
-free_ps:
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
-
-free_filter:
-	if (err)
+	else
 		__free_filter(filter);
=20
 out_unlock:
@@ -1954,43 +1991,6 @@ out_unlock:
 #define CREATE_TRACE_POINTS
 #include "trace_events_filter_test.h"
=20
-static int test_get_filter(char *filter_str, struct ftrace_event_call *cal=
l,
-			   struct event_filter **pfilter)
-{
-	struct event_filter *filter;
-	struct filter_parse_state *ps;
-	int err =3D -ENOMEM;
-
-	filter =3D __alloc_filter();
-	if (!filter)
-		goto out;
-
-	ps =3D kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto free_filter;
-
-	parse_init(ps, filter_ops, filter_str);
-	err =3D filter_parse(ps);
-	if (err)
-		goto free_ps;
-
-	err =3D replace_preds(call, filter, ps, filter_str, false);
-	if (!err)
-		*pfilter =3D filter;
-
- free_ps:
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
-
- free_filter:
-	if (err)
-		__free_filter(filter);
-
- out:
-	return err;
-}
-
 #define DATA_REC(m, va, vb, vc, vd, ve, vf, vg, vh, nvisit) \
 { \
 	.filter =3D FILTER, \
@@ -2109,12 +2109,13 @@ static __init int ftrace_test_event_filter(void)
 		struct test_filter_data_t *d =3D &test_filter_data[i];
 		int err;
=20
-		err =3D test_get_filter(d->filter, &event_ftrace_test_filter,
-				      &filter);
+		err =3D create_filter(&event_ftrace_test_filter, d->filter,
+				    false, &filter);
 		if (err) {
 			printk(KERN_INFO
 			       "Failed to get filter for '%s', err %d\n",
 			       d->filter, err);
+			__free_filter(filter);
 			break;
 		}
=20
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dM0AAoJEIy3vGnGbaoATR0QAIwBz32t6wsGVLVrw/f/3Lzd
WjhRPGj/PurbHAS8bHNKe7u5sHaxE6fLKYvNjEjXnZr2n+32G13UbE2b/49ZG/7u
Pp+Ht+eN2t5hFz3F30bxvLL9fyKfE2IDfwDgetJmMPTVidN1xpk9XfcAZVwgF1kh
AlJ4KrgKBbZwZhmU4A5sN8LEKxD7BiZFWEN0wkLS1ujPVoQz7bLphgmSGBC1LSW5
tmj0Je3TGNfgknr15axQBa0dQbHygb9PkKb/EuFgi/e5eI+TTS2l/wzDk15GEdmw
Tz8K1TQ5RH70vn5bntkVzi9lrl18H5vdo1pWiwKchsIbfj1AGE0MP0EgB60l96/k
PMx2j994U99DGGdbCrgEk2kIIceSy4srbxDGRAKgoFgYJq/Jr9ioVYyIMCbfRjGx
Vq0CBpFFoAcokwskkC+1HPlBbjAx/UVPdExlac8trzyy11/umiCMFUZ/fBFhEQyY
Ch+OGRdlWwKSkMwVNitTWWyqGucTaGuH7Q1ijIx8fcMymrUzEJa3Ae/cyOW1GR5I
b9Ovjc/B/L5NI4rOTHhQEfyx/+9mHlDbExpWmW25/D5sZC9rUHxXdE4DdZouRVOL
1cTsL4WdODVQrFRj9mX0H8K/8TbLg6dSduiOBW8Z66/P7GAGzhdcFt+aUPRt4EF+
2nvyP2kmN1Cmn7OLwy6M
=yrka
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
