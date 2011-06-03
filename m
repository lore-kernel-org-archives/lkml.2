Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1FCNgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:36:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:57776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1FCNgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:36:24 -0400
Date: Fri, 3 Jun 2011 13:36:13 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-m9dba9kaluas0kq8r58z191c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Use exception to propagate errors
Git-Commit-ID: 5c6970af2f4be4e04b06fe78214f6809777a8354
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:36:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c6970af2f4be4e04b06fe78214f6809777a8354
Gitweb:     http://git.kernel.org/tip/5c6970af2f4be4e04b06fe78214f6809777a8354
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 2 Jun 2011 10:55:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Jun 2011 10:55:10 -0300

perf python: Use exception to propagate errors

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
