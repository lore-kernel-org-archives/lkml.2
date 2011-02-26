Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1BZPLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:11:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34986 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1BZPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=VYDGZbYYH+9jAbfjEEsQu/HeQ5HGfrlrq79Sc0BYhBI9SF7srSXOrvizj3QCCyLAiz
         38sooONOaJSxmTvIb5gGIvwCtAj2ZQcXLfPPch53kCbsCnWwmbbnIIGhAU8rFsCopRqE
         gbuV93WzWXoqnaLZVYOxiWgSPUbRbBDDeHSYw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2] perf: Fix undefined PyVarObject_HEAD_INIT in python 2.5
Date: Sat, 26 Feb 2011 16:11:33 +0100
Message-Id: <1298733093-3928-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110226070208.GB28222@elte.hu>
References: <20110226070208.GB28222@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PyVarObject_HEAD_INIT is undefined in python 2.5, resulting
in a build crash:

	util/python.c:81: attention : déclaration implicite de la fonction « «PyVarObject_HEAD_INIT» »
	util/python.c:82: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:117: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:146: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:177: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:290: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:359: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:532: erreur: request for member «tp_name» in something not a structure or union
	util/python.c:761: erreur: request for member «tp_name» in something not a structure or union
	error: command 'gcc' failed with exit status 1
	make: *** [python/perf.so] Erreur 1

We can fix that by defining PyVarObject_HEAD_INIT as a wrapper on
PyObject_HEAD_INIT, thanks to a trick found on biopython:
https://github.com/biopython/biopython/commit/d4eaf57946c7b4c32eca8d18821edf32f83e300d

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 5317ef2..a9f2d7e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -8,6 +8,11 @@
 #include "cpumap.h"
 #include "thread_map.h"
 
+/* Define PyVarObject_HEAD_INIT for python 2.5 */
+#ifndef PyVarObject_HEAD_INIT
+# define PyVarObject_HEAD_INIT(type, size) PyObject_HEAD_INIT(type) size,
+#endif
+
 struct throttle_event {
 	struct perf_event_header header;
 	u64			 time;
-- 
1.7.3.2

