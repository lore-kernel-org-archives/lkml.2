Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0KWSHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:07:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0KWSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=orssd7cbc1VO7MsdEnF4Rq2yPDKpJDyaEfA6wO+9ptgc095pqqO6X4OcIn50rYbwME
         okxlFQtfRAHJfVOgMFJQ==
Message-ID: <4cec02cc.8491d80a.273a.1217@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 23 Nov 2010 19:06:05 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf: add support for per-event sampling period or frequency in perf record (v2)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows specifying a per event sampling period or frequency.
Up until now, the same sampling period or frequency was applied to all
the events specified on the command line of perf record. A sampling 
period depends on the event, thus it is necessary to specify it per event.

The per-event sampling period or frequency is specified as part of the
event string, similar to the priv level mask. There are two new modifiers:
period, freq. They both take an integer value:

$ perf record -e cycles:u:period=100000,instructions:k:freq=1500 -a -- sleep 5

An event can have either period= or freq= but not both.

The -F and -c options are used whenever an event does not have an
explicit period or frequency:

$ perf record -e cycles:period=100000,instructions -F 1000 -a -- sleep 5

Here instructions will be sampled at 1000Hz and cycles with the fixed
period 100,000.

There is no requirement as to the ordering of those new modifiers.

This second version drops the comma-separated list of periods or
frequencies in favor of new event modifiers.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a91f9f9..86fc6f7 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -39,6 +39,14 @@ OPTIONS
           be passed as follows: '\mem:addr[:[r][w][x]]'.
           If you want to profile read-write accesses in 0x1000, just set
           'mem:0x1000:rw'.
+
+	- a sampling period can be appended to the event using the :period=XX
+	  notation where XX is expressed in the unit of the measured event.
+	  This is mutually exclusive with the :freq mode.
+
+	- a sampling rate can be appended to the event using the :freq=XX
+	  notation where XX is in Hertz. This is mutually exclusive with the
+	  :period mode.
 -a::
         System-wide collection.
 
@@ -62,7 +70,8 @@ OPTIONS
 
 -c::
 --count=::
-	Event period to sample.
+	Default event sampling period. It is used whenever an event is
+	specified without the :period or :freq modifier.
 
 -o::
 --output=::
@@ -73,7 +82,8 @@ OPTIONS
 	Child tasks do not inherit counters.
 -F::
 --freq=::
-	Profile at this frequency.
+	Default event sampling frequency. It is used whenever an event is
+	specified without the :freq or :period modifier.
 
 -m::
 --mmap-pages=::
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 970a7f2..d009ddf 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -696,6 +696,16 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		memcpy(attrs, default_attrs, sizeof(default_attrs));
 		nr_counters = ARRAY_SIZE(default_attrs);
 	}
+	/*
+	 * validate event attr as set by parse_event_symbols()
+	 */
+	for (i = 0; i < nr_counters; i++) {
+		if (attrs[i].sample_period) {
+			die("cannot set a sampling period or frequency with"
+			    " perf stat\n");
+			return -EINVAL;
+		}
+	}
 
 	if (system_wide)
 		nr_cpus = read_cpu_map(cpu_list);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 898aa94..cbf95eb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -692,43 +692,126 @@ parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 }
 
 static enum event_result
+parse_event_period(const char *q, u64 *period)
+{
+	char *endptr = NULL;
+
+	if (!q || *q != '=')
+		return EVT_FAILED;
+
+	*period = strtoull(q+1, &endptr, 0);
+	if (*period == 0 || *period == ULLONG_MAX
+	    || (*endptr && *endptr != ':' && *endptr != ','))
+		return EVT_FAILED;
+
+	return EVT_HANDLED;
+}
+
+static enum event_result
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
-	const char *str = *strp;
+	const char *str = *strp, *o, *p, *q, *end;
+	u64 period = 0;
+	size_t l;
 	int exclude = 0;
-	int eu = 0, ek = 0, eh = 0, precise = 0;
+	int eu = 0, ek = 0, eh = 0;
+	int freq = 0, precise = 0;
 
 	if (*str++ != ':')
-		return 0;
+		return EVT_HANDLED;
+
 	while (*str) {
-		if (*str == 'u') {
+
+		l = strlen(str);
+		end = str + l;
+
+		if (*str == ',')
+			break;
+
+		o = strchr(str, ',');
+		p = strchr(str, ':');
+		q = strchr(str, '=');
+		/*
+		 * cannot do 3-way min because
+		 * of NULL, so do this explicitly
+		 */
+		if (o && p > o)
+			p = NULL;
+
+		if (o && q > o)
+			q = NULL;
+
+		if (p && q > p)
+			q = NULL;
+
+		/*
+		 * only look at the string before
+		 * either '=' or ':' or ','
+		 */
+		if (q)
+			l = q - str;
+		else if (p)
+			l = p - str;
+		else if (o)
+			l = o - str;
+
+		/*
+		 * use strncmp() because str is read-only
+		 *
+		 * must compare lengths to ensure we do not
+		 * match partial strings
+		 *
+		 */
+		if (l == 1 && !strncmp(str, "u", l)) {
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
 			eu = 0;
-		} else if (*str == 'k') {
+		} else if (l == 1 && !strncmp(str, "k", l)) {
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
 			ek = 0;
-		} else if (*str == 'h') {
+		} else if (l == 1 && !strncmp(str, "h", l)) {
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
 			eh = 0;
-		} else if (*str == 'p') {
-			precise++;
+		} else if (l == 1 && !strncmp(str, "p", l)) {
+			precise = 1;
+		} else if (l == 2 && !strncmp(str, "pp", l)) {
+			precise = 2;
+		} else if (l == 2 && (!strncmp(str, "uk", l)
+				      || !strncmp(str, "ku", l))) {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
+			eu = ek = 0;
+		} else if (l == 6 && !strncmp(str, "period", l)) {
+			/* already specificed as period or freq */
+			if (period)
+				return EVT_FAILED;
+			if (parse_event_period(q, &period) != EVT_HANDLED)
+				return EVT_FAILED;
+		} else if (l == 4 && !strncmp(str, "freq", l)) {
+			if (period)
+				return EVT_FAILED;
+			if (parse_event_period(q, &period) != EVT_HANDLED)
+				return EVT_FAILED;
+			freq = 1;
 		} else
 			break;
 
-		++str;
+		str = p ? (p + 1) : (o ? o : end);
 	}
+
 	if (str >= *strp + 2) {
 		*strp = str;
 		attr->exclude_user   = eu;
 		attr->exclude_kernel = ek;
 		attr->exclude_hv     = eh;
 		attr->precise_ip     = precise;
-		return 1;
+		attr->freq	     = freq;
+		attr->sample_period  = period;
+		return EVT_HANDLED;
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
 /*
@@ -772,9 +855,7 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr, int verbose)
 	return EVT_FAILED;
 
 modifier:
-	parse_event_modifier(str, attr);
-
-	return ret;
+	return parse_event_modifier(str, attr);
 }
 
 static int store_event_type(const char *orgname)
