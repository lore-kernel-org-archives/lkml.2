Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1FGQTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:19:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:59016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab1FGQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ITtsj/PZVefe9VmI6YmOoqjVDnduSLPatg3ppz+vN/1nDYeMYCafAHP/sT7E/sfz1d
         ZEKV4coYMgocuwl1ulkQ==
Date: Tue, 7 Jun 2011 18:19:36 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, acme@redhat.com
Subject: [PATCH] perf: fix missing event name init for default event (v2)
Message-ID: <20110607161936.GA8163@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When no event is given to perf record, perf top, a default
event is initialized (cycles). However, perf_evlist__add_default()
was not setting the symbolic name for the event. Perf top
worked simply because it was reconstructing the name from the event
code. But it should not have to do this. This patch initializes the
evsel->name field properly.

This second version improves the code flow on the non error path.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b021ea9..9a98c28 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -85,10 +85,19 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	struct perf_evsel *evsel = perf_evsel__new(&attr, 0);
 
 	if (evsel == NULL)
-		return -ENOMEM;
+		goto error;
+
+	/* use strdup() because free(evsel) assumes name is allocated */
+	evsel->name = strdup("cycles");
+	if (!evsel->name)
+		goto error_free;
 
 	perf_evlist__add(evlist, evsel);
 	return 0;
+error_free:
+	free(evsel);
+error:
+	return -ENOMEM;
 }
 
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
