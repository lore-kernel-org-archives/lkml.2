Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1EQPcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:32:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1EQPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Do4wZj2iIWC+uh0wKxUB/DJrDsvzfeXJ3Nhlu37ZDusM3aArazdcMrMp3IsVUENysP
         OZ5srHyRhhYstmb/z0zw==
Date: Tue, 17 May 2011 17:32:07 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf: make annotate more readable
Message-ID: <20110517153207.GA9834@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds two new options to perf annotate:
	- -R, --no-asm-raw : do not display raw instruction encodings
	- -S, --no-source  : do not interleave source code with assembly code

We believe those options make the output of annotate more readable.
Systematically displaying source can make it hard to follow code and
especially optimized code.

Raw encodings are not useful in most cases.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 6f5a498..cf59fdd 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -66,6 +66,15 @@ OPTIONS
 	used. This interfaces starts by centering on the line with more
 	samples, TAB/UNTAB cycles through the lines with more samples.
 
+-R::
+--no-asm-raw::
+	Do not show raw instruction encoding of assembly instructions. They
+	are displayed by default
+
+-S
+--no-source::
+	Do not interleave source code with assembly code.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e18eb7e..976f5d8 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -254,6 +254,10 @@ static const struct option options[] = {
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the displayed pathnames"),
+		OPT_BOOLEAN('S', "no-source", &symbol_conf.annotate_no_src,
+		    "do not interleave source code with assembly code"),
+		OPT_BOOLEAN('R', "no-asm-raw", &symbol_conf.asm_no_raw,
+		    "do not display raw encoding of assembly instructions"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 532e4a6..5ccb32b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -324,9 +324,12 @@ fallback:
 
 	snprintf(command, sizeof(command),
 		 "objdump --start-address=0x%016" PRIx64
-		 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
+		 " --stop-address=0x%016" PRIx64
+		 " -d %s %s -C %s|grep -v %s|expand",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
+		 symbol_conf.asm_no_raw ? "--no-show-raw" : "",
+		 symbol_conf.annotate_no_src ? "" : "-S",
 		 symfs_filename, filename);
 
 	pr_debug("Executing: %s\n", command);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index c1736e5..bd75365 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -75,7 +75,9 @@ struct symbol_conf {
 			use_callchain,
 			exclude_other,
 			show_cpu_utilization,
-			initialized;
+			initialized,
+			asm_no_raw,
+			annotate_no_src;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
