Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab1C3WqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:46:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:51389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab1C3WqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:46:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf script: If type not given fields apply to all event types
Date: Wed, 30 Mar 2011 19:46:10 -0300
Message-Id: <1301525171-5094-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301525171-5094-1-git-send-email-acme@infradead.org>
References: <1301525171-5094-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <daahern@cisco.com>

Allow:
  perf script -f <fields>

to be equivalent to:
  perf script -f trace:<fields> -f sw:<fields> -f hw:<fields>

i.e., the specified fields apply to all event types if the type string
is not given.

The field (-f) arguments are processed in the order received. A later
usage can reset a prior request. e.g.,

  -f trace: -f comm,tid,time,sym

The first -f suppresses trace events (field list is ""), but then the second
invocation sets the fields to comm,tid,time,sym. In this case a warning is
given to the user:

  "Overriding previous field request for all events."

Alternativey, consider the order:

  -f comm,tid,time,sym -f trace:

The first -f sets the fields for all events and the second -f suppresses trace
events. The user is given a warning message about the override, and the result
of the above is that only S/W and H/W events are displayed with the given
fields.

For the 'wildcard' option if a user selected field is invalid for an event
type, a message is displayed to the user that the option is ignored for that
type. For example:

  perf script -f comm,tid,trace 2>&1 | less
  'trace' not valid for hardware events. Ignoring.
  'trace' not valid for software events. Ignoring.

Alternatively, if the type is given an invalid field is specified it is an
error. For example:

    perf script -v -f sw:comm,tid,trace 2>&1 | less
    'trace' not valid for software events.

At this point usage is displayed, and perf-script exits.

Finally, a user may not set fields to none for all event types.
i.e., -f "" is not allowed.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
LPU-Reference: <1300377801-27246-1-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |  171 ++++++++++++++++++++++++++++++------------
 1 files changed, 122 insertions(+), 49 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ac574ea..6cf811a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -49,23 +49,52 @@ struct output_option {
 };
 
 /* default set to maintain compatibility with current format */
-static u64 output_fields[PERF_TYPE_MAX] = {
-	[PERF_TYPE_HARDWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
-
-	[PERF_TYPE_SOFTWARE] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-			       PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-			       PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
-
-	[PERF_TYPE_TRACEPOINT] = PERF_OUTPUT_COMM | PERF_OUTPUT_TID | \
-				 PERF_OUTPUT_CPU | PERF_OUTPUT_TIME | \
-				 PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+static struct {
+	bool user_set;
+	u64 fields;
+	u64 invalid_fields;
+} output[PERF_TYPE_MAX] = {
+
+	[PERF_TYPE_HARDWARE] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
+
+	[PERF_TYPE_SOFTWARE] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+
+		.invalid_fields = PERF_OUTPUT_TRACE,
+	},
+
+	[PERF_TYPE_TRACEPOINT] = {
+		.user_set = false,
+
+		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
+				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
+				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+	},
 };
 
-static bool output_set_by_user;
+static bool output_set_by_user(void)
+{
+	int j;
+	for (j = 0; j < PERF_TYPE_MAX; ++j) {
+		if (output[j].user_set)
+			return true;
+	}
+	return false;
+}
 
-#define PRINT_FIELD(x)  (output_fields[attr->type] & PERF_OUTPUT_##x)
+#define PRINT_FIELD(x)  (output[attr->type].fields & PERF_OUTPUT_##x)
 
 static int perf_session__check_attr(struct perf_session *session,
 				    struct perf_event_attr *attr)
@@ -168,7 +197,7 @@ static void process_event(union perf_event *event __unused,
 {
 	struct perf_event_attr *attr = &evsel->attr;
 
-	if (output_fields[attr->type] == 0)
+	if (output[attr->type].fields == 0)
 		return;
 
 	if (perf_session__check_attr(session, attr) < 0)
@@ -451,6 +480,7 @@ static int parse_output_fields(const struct option *opt __used,
 {
 	char *tok;
 	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);
+	int j;
 	int rc = 0;
 	char *str = strdup(arg);
 	int type = -1;
@@ -458,52 +488,95 @@ static int parse_output_fields(const struct option *opt __used,
 	if (!str)
 		return -ENOMEM;
 
-	tok = strtok(str, ":");
-	if (!tok) {
-		fprintf(stderr,
-			"Invalid field string - not prepended with type.");
-		return -EINVAL;
-	}
-
-	/* first word should state which event type user
-	 * is specifying the fields
+	/* first word can state for which event type the user is specifying
+	 * the fields. If no type exists, the specified fields apply to all
+	 * event types found in the file minus the invalid fields for a type.
 	 */
-	if (!strcmp(tok, "hw"))
-		type = PERF_TYPE_HARDWARE;
-	else if (!strcmp(tok, "sw"))
-		type = PERF_TYPE_SOFTWARE;
-	else if (!strcmp(tok, "trace"))
-		type = PERF_TYPE_TRACEPOINT;
-	else {
-		fprintf(stderr, "Invalid event type in field string.");
-		return -EINVAL;
+	tok = strchr(str, ':');
+	if (tok) {
+		*tok = '\0';
+		tok++;
+		if (!strcmp(str, "hw"))
+			type = PERF_TYPE_HARDWARE;
+		else if (!strcmp(str, "sw"))
+			type = PERF_TYPE_SOFTWARE;
+		else if (!strcmp(str, "trace"))
+			type = PERF_TYPE_TRACEPOINT;
+		else {
+			fprintf(stderr, "Invalid event type in field string.\n");
+			return -EINVAL;
+		}
+
+		if (output[type].user_set)
+			pr_warning("Overriding previous field request for %s events.\n",
+				   event_type(type));
+
+		output[type].fields = 0;
+		output[type].user_set = true;
+
+	} else {
+		tok = str;
+		if (strlen(str) == 0) {
+			fprintf(stderr,
+				"Cannot set fields to 'none' for all event types.\n");
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (output_set_by_user())
+			pr_warning("Overriding previous field request for all events.\n");
+
+		for (j = 0; j < PERF_TYPE_MAX; ++j) {
+			output[j].fields = 0;
+			output[j].user_set = true;
+		}
 	}
 
-	output_fields[type] = 0;
-	while (1) {
-		tok = strtok(NULL, ",");
-		if (!tok)
-			break;
+	tok = strtok(tok, ",");
+	while (tok) {
 		for (i = 0; i < imax; ++i) {
-			if (strcmp(tok, all_output_options[i].str) == 0) {
-				output_fields[type] |= all_output_options[i].field;
+			if (strcmp(tok, all_output_options[i].str) == 0)
 				break;
-			}
 		}
 		if (i == imax) {
-			fprintf(stderr, "Invalid field requested.");
+			fprintf(stderr, "Invalid field requested.\n");
 			rc = -EINVAL;
-			break;
+			goto out;
 		}
-	}
 
-	if (output_fields[type] == 0) {
-		pr_debug("No fields requested for %s type. "
-			 "Events will not be displayed\n", event_type(type));
+		if (type == -1) {
+			/* add user option to all events types for
+			 * which it is valid
+			 */
+			for (j = 0; j < PERF_TYPE_MAX; ++j) {
+				if (output[j].invalid_fields & all_output_options[i].field) {
+					pr_warning("\'%s\' not valid for %s events. Ignoring.\n",
+						   all_output_options[i].str, event_type(j));
+				} else
+					output[j].fields |= all_output_options[i].field;
+			}
+		} else {
+			if (output[type].invalid_fields & all_output_options[i].field) {
+				fprintf(stderr, "\'%s\' not valid for %s events.\n",
+					 all_output_options[i].str, event_type(type));
+
+				rc = -EINVAL;
+				goto out;
+			}
+			output[type].fields |= all_output_options[i].field;
+		}
+
+		tok = strtok(NULL, ",");
 	}
 
-	output_set_by_user = true;
+	if (type >= 0) {
+		if (output[type].fields == 0) {
+			pr_debug("No fields requested for %s type. "
+				 "Events will not be displayed.\n", event_type(type));
+		}
+	}
 
+out:
 	free(str);
 	return rc;
 }
@@ -1020,7 +1093,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		struct stat perf_stat;
 		int input;
 
-		if (output_set_by_user) {
+		if (output_set_by_user()) {
 			fprintf(stderr,
 				"custom fields not supported for generated scripts");
 			return -1;
-- 
1.6.2.5

