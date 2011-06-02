Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1FBVxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:53:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43200 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1FBVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:53:13 -0400
X-Greylist: delayed 3385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jun 2011 17:53:13 EDT
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/9] perf python: Use exception to propagate errors
Date: Thu,  2 Jun 2011 17:56:29 -0300
Message-Id: <1307048196-16387-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307048196-16387-1-git-send-email-acme@infradead.org>
References: <1307048196-16387-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were using pr_debug to tell the user about not being able to parse a sample
where we should really use the python way of reporting errors: exceptions.

Fixes this problem:

[root@emilia ~]# python
>>> import perf
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: eprintf
>>>
[root@emilia ~]

As we want to keep the objects linked in the python binding (and in the future
in a shared library) minimal.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-m9dba9kaluas0kq8r58z191c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 69436b3..2dd1698 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -694,14 +694,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		err = perf_event__parse_sample(event, first->attr.sample_type,
 					       perf_sample_size(first->attr.sample_type),
 					       sample_id_all, &pevent->sample);
-		if (err) {
-			pr_err("Can't parse sample, err = %d\n", err);
-			goto end;
-		}
-
+		if (err)
+			return PyErr_Format(PyExc_OSError,
+					    "perf: can't parse sample, err=%d", err);
 		return pyevent;
 	}
-end:
+
 	Py_INCREF(Py_None);
 	return Py_None;
 }
-- 
1.6.2.5

