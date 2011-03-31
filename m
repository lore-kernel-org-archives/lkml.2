Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1CaHFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:05:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57476 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab1CaHFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:05:02 -0400
Date: Thu, 31 Mar 2011 07:04:16 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add more documentation about the -f/--fields parameters
Message-ID: <tip-176fcc5c5f0131504a55e1e1d35389c49a9177c2@git.kernel.org>
Git-Commit-ID: 176fcc5c5f0131504a55e1e1d35389c49a9177c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 07:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  176fcc5c5f0131504a55e1e1d35389c49a9177c2
Gitweb:     http://git.kernel.org/tip/176fcc5c5f0131504a55e1e1d35389c49a9177c2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 30 Mar 2011 15:30:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Mar 2011 15:30:43 -0300

perf script: Add more documentation about the -f/--fields parameters

Using the commit log for 2c9e45f.

Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |   52 ++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 66f040b..86c87e2 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -113,13 +113,61 @@ OPTIONS
         Do various checks like samples ordering and lost events.
 
 -f::
---fields
+--fields::
         Comma separated list of fields to print. Options are:
         comm, tid, pid, time, cpu, event, trace, sym. Field
-        list must be prepended with the type, trace, sw or hw,
+        list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
 
+		perf script -f <fields>
+
+	is equivalent to:
+
+		perf script -f trace:<fields> -f sw:<fields> -f hw:<fields>
+    
+	i.e., the specified fields apply to all event types if the type string
+	is not given.
+    
+	The arguments are processed in the order received. A later usage can
+	reset a prior request. e.g.:
+    
+		-f trace: -f comm,tid,time,sym
+    
+	The first -f suppresses trace events (field list is ""), but then the
+	second invocation sets the fields to comm,tid,time,sym. In this case a
+	warning is given to the user:
+    
+		"Overriding previous field request for all events."
+    
+	Alternativey, consider the order:
+    
+		-f comm,tid,time,sym -f trace:
+    
+	The first -f sets the fields for all events and the second -f
+	suppresses trace events. The user is given a warning message about
+	the override, and the result of the above is that only S/W and H/W
+	events are displayed with the given fields.
+    
+	For the 'wildcard' option if a user selected field is invalid for an
+	event type, a message is displayed to the user that the option is
+	ignored for that type. For example:
+    
+		$ perf script -f comm,tid,trace
+		'trace' not valid for hardware events. Ignoring.
+		'trace' not valid for software events. Ignoring.
+    
+	Alternatively, if the type is given an invalid field is specified it
+	is an error. For example:
+    
+        perf script -v -f sw:comm,tid,trace
+        'trace' not valid for software events.
+    
+	At this point usage is displayed, and perf-script exits.
+    
+	Finally, a user may not set fields to none for all event types.
+	i.e., -f "" is not allowed.
+
 -k::
 --vmlinux=<file>::
         vmlinux pathname
