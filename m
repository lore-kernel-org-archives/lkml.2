Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1EWMj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:39:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1EWMjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qhBKmSdemHBkmYqjUeIHpaCr823o9lfYqTwMgxMyIZz3xVji9NWEQpzKeoWQznuwLD
         lxY/SoOBJ60hY1/xYmxA==
Date: Mon, 23 May 2011 14:39:17 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: [PATCH] perf: fix exit value of perf list
Message-ID: <20110523123917.GA31060@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes an issue with the exit value of perf list:

$ perf list; echo $?
129

perf list returns an error exit code even though there is
no error.

There was a stray exit(129) in print_events(). This patch
removes this exit().

$ perf list; echo $?
0

$ perf list hw sw
  cpu-cycles OR cycles                               [Hardware event]
  stalled-cycles-frontend OR idle-cycles-frontend    [Hardware event]
  stalled-cycles-backend OR idle-cycles-backend      [Hardware event]
  instructions                                       [Hardware event]
  cache-references                                   [Hardware event]
  cache-misses                                       [Hardware event]
  branch-instructions OR branches                    [Hardware event]
  branch-misses                                      [Hardware event]
  bus-cycles                                         [Hardware event]

  cpu-clock                                          [Software event]
  task-clock                                         [Software event]
  page-faults OR faults                              [Software event]
  minor-faults                                       [Software event]
  major-faults                                       [Software event]
  context-switches OR cs                             [Software event]
  cpu-migrations OR migrations                       [Software event]
  alignment-faults                                   [Software event]
  emulation-faults                                   [Software event]
$ echo $?
0

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..fe89885 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1088,6 +1088,4 @@ void print_events(const char *event_glob)
 	printf("\n");
 
 	print_tracepoint_events(NULL, NULL);
-
-	exit(129);
 }
