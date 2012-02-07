Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab2BGSLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:11:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2BGSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:11:53 -0500
Message-ID: <4F316964.2050900@gmail.com>
Date: Tue, 07 Feb 2012 11:11:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: perf: allow command to attach local data to thread/evsel structs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an API I have been using for some 'local' commands that process
perf events. It allows the commands to attach data to events and threads
and avoid local caching and lookups.


diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 326b8e4..866de40 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -66,6 +66,12 @@ struct perf_evsel {
        void        *data;
    } handler;
    bool            supported;
+
+   /*
+    * can be used by commands that process samples
+    * for storing local, event-based data
+    */
+   void *private;
 };

 struct cpu_map;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 70c2c13..9f62859 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -16,6 +16,12 @@ struct thread {
    bool            comm_set;
    char            *comm;
    int         comm_len;
+
+    /*
+    * can be used by commands that process samples
+    * for storing local, thread-based data
+    */
+   void *private;
 };

 struct machine;

One wrinkle is that for the thread-based one the thread__delete(),
thread__fork() and thread__set_comm() functions would free the
allocations if set -- or a handler is needed to free private structs to
handle layered mallocs.

Any objections to pushing this kind of open-ended API into perf?

David
