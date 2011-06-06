Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab1FFPKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:10:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32595 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab1FFPKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AIJHV1SwT861xeGkEBSzxOJeKlfI4gcc74F7ThI5eAZ2sKvMGDwMQRBtV8WQEyU/rX
         lTpCvG9OXSZfoyhzWMIA==
Date: Mon, 6 Jun 2011 17:10:24 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, acme@redhat.com
Subject: [PATCH] perf: fix missing event name init for default event
Message-ID: <20110606151024.GA9464@quad>
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

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b021ea9..1584af6 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -87,6 +87,13 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	if (evsel == NULL)
 		return -ENOMEM;
 
+	/* use strdup() because free(evsel) assumes name is allocated */
+	evsel->name = strdup("cycles");
+	if (!evsel->name) {
+		free(evsel);
+		return -ENOMEM;
+	}
+
 	perf_evlist__add(evlist, evsel);
 	return 0;
 }
