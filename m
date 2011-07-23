Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1GWCKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 22:10:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1GWCKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 22:10:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	references:mime-version:content-type:content-disposition:in-reply-to:
	user-agent:x-system-of-record;
	b=hA7Co8OzQMOqTLB83FZh2udc++rVivcu1BTWDG9DIK5E0kmZwop1cVnkUXbcCUsSY
	eftiKTJsY+7i78uYL5x3A==
Date: Sat, 23 Jul 2011 04:10:43 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, acme@redhat.com, mingo@elte.hu
Subject: [PATCH]: perf: fix error handling of unknown events
Message-ID: <20110723021043.GA20178@quad>
References: <20110607161936.GA8163@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607161936.GA8163@quad>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There was a problem with the parse_events() code not
printing the correct event name when an event was unknown
and starting with an 'r'. The source of the problem was
the way raw notation was parsed.

Without the patch:
	$ perf stat -e retired_foo
	invalid event modifier: 'tired_foo'

With the patch:
	$ perf stat -e retired_foo
	invalid or unsupported event: 'retired_foo'

This also covers the case where the name of the event was
not printed at all when perf was linked with libpfm4.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4ea7e19..8c1cb10 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -697,7 +697,11 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		const char *end = str + n + 1;
+		if (*end != '\0' && *end != ',' && *end != ':')
+			return EVT_FAILED;
+
+		*strp = end;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
 		return EVT_HANDLED;
