Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453Ab2I1Xt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:49:59 -0400
Received: from nm31-vm5.bullet.mail.bf1.yahoo.com ([72.30.239.13]:20228 "HELO
	nm31-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965014Ab2I1XtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:49:17 -0400
X-Yahoo-Newman-Id: 592870.40552.bm@smtp101.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6tbDamAVM1lt9OX4ZjfnxVU9OHw6HuhCLdLiDr7oEg1gx4L
 BI3K1AoZ1cY0xH1f.fH3AGDEFbjWTdVh1.wZ19G4daN90miwIYM0JRP7XX8I
 LoSpydtyoyrt.XzDYRAdxRJQaIU0M9KVG7nlCA69a8NPih4dlV_YhKtuuBkg
 PLXyUYkgh8KMdxz8kQtWdV3Gl3B0yem8ZkvFY9lNejgzl4NsXcNfQxZZ4d4s
 iCKNATlKO9ma3NObi3rM0jSC4qbNv.TR1_5v8_q4cHyJYdXVVF8zRBxKrdzp
 bdLQqW5W5bxmhYKbZWsaV1AyOK_dS1gFe8mx9.2LCaLbaVAQkA8P9VjpLW.s
 s9b6PxzxOaFmECLf1VyoWgpRK1g0P646Yi95mRaxiCuGfMicrOTPGRTKIMgk
 ZKZMTT1q1GoWoz7lSnnShCGlwgl9j.MONOfLjj166vDJ7iEOhhMNNCVfHynn
 I5rK_astTBaMQUWjgPMe14jpjSKs3KQ2G3QoTfU.nJOYqEwfM50RMxw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-doc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v6 10/10] selftest: report generation script for test results
Date: Fri, 28 Sep 2012 18:48:46 -0500
Message-Id: <1348876126-28792-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A script that uses sqlite to load test results and generates a report
showing differences in performance per compiler used.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/gen_report.sh |  129 ++++++++++++++++++++
 1 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100755 tools/testing/selftests/grbtree/user/gen_report.sh

diff --git a/tools/testing/selftests/grbtree/user/gen_report.sh b/tools/testing/selftests/grbtree/user/gen_report.sh
new file mode 100755
index 0000000..a0ab88a
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/gen_report.sh
@@ -0,0 +1,129 @@
+#!/bin/bash
+
+dbfile=results.$$.db
+datafile=runtest.out
+
+die() {
+	echo "ERROR${@:+": "}$@" 1>&2
+	exit -1
+}
+
+find_sqlite() {
+	for suffix in "" 4 3; do
+		which sqlite${suffix} 2> /dev/null && return 0
+	done
+	return 1
+}
+
+sqlite=$(find_sqlite) || die "failed to find sqlite"
+
+${sqlite} "${dbfile}" << asdf
+/* .echo on */
+.headers on
+create table if not exists grbtest_result (
+	compiler	varchar(255),
+	key_type	varchar(255),
+	payload		int,
+	userland	tinyint,
+	use_generic	tinyint,
+	use_leftmost	tinyint,
+	use_rightmost	tinyint,
+	use_count	tinyint,
+	unique_keys	tinyint,
+	insert_replaces	tinyint,
+	debug		tinyint,
+	debug_validate	tinyint,
+	arch		varchar(255),
+	arch_flags	varchar(255),
+	processor	varchar(255),
+	cc		varchar(255),
+	cflags		varchar(255),
+	test		tinyint,
+	in_seed		bigint,
+	seed		bigint,
+	key_mask	int,
+	object_count	int,
+	pool_count	int,
+	reps		bigint,
+	node_size	int,
+	object_size	int,
+	pool_size	int,
+	insertions	bigint,
+	insertion_time	bigint,
+	evictions	bigint,
+	deletions	bigint,
+	deletion_time	bigint
+);
+.separator |
+.import ${datafile} grbtest_result
+/* .mode column */
+select distinct
+	key_type,
+	payload,
+	userland,
+	use_leftmost,
+	use_rightmost,
+	use_count,
+	unique_keys,
+	insert_replaces,
+	debug,
+	debug_validate,
+	arch,
+	arch_flags,
+	processor,
+	cc,
+	test,
+	in_seed,
+	seed,
+	key_mask,
+	object_count,
+	pool_count,
+	reps,
+	node_size,
+	object_size,
+	pool_size,
+	insertions,
+	evictions,
+	deletions
+from grbtest_result;
+
+select distinct
+	a.compiler as 'Compiler',
+	a.key_type,
+	a.payload,
+	a.userland,
+	(case when a.use_leftmost then	  'L' else '.' end) ||
+	(case when a.use_rightmost then	  'R' else '.' end) ||
+	(case when a.use_count then	  'C' else '.' end) ||
+	(case when a.unique_keys then	  'U' else '.' end) ||
+	(case when a.insert_replaces then 'I' else '.' end) ||
+	(case when a.debug then		  'D' else '.' end) ||
+	(case when a.debug_validate then  'V' else '.' end)
+	as config,
+	a.insertion_time as 'Generic Insert Time',
+	b.insertion_time as 'Hand-Coded Insert Time',
+	1.0 * a.insertion_time / b.insertion_time - 1.0 as 'Insert Diff',
+	a.deletion_time as 'Generic Delete Time',
+	b.deletion_time as 'Hand-Coded Delete Time',
+	1.0 * a.deletion_time / b.deletion_time - 1.0 as 'Delete Diff'
+from
+	grbtest_result as a inner join grbtest_result as b on (
+		a.compiler		= b.compiler
+		AND a.key_type		= b.key_type
+		AND a.payload		= b.payload
+		AND a.userland		= b.userland
+		AND a.use_leftmost	= b.use_leftmost
+		AND a.use_rightmost	= b.use_rightmost
+		AND a.use_count		= b.use_count
+		AND a.unique_keys	= b.unique_keys
+		AND a.insert_replaces	= b.insert_replaces
+		AND a.debug		= b.debug
+		AND a.debug_validate	= b.debug_validate
+	)
+where
+	a.use_generic == 1
+	and b.use_generic = 0;
+asdf
+
+rm "${dbfile}"
+
-- 
1.7.3.4

