Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2IYXcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:32:39 -0400
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:29087 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755678Ab2IYXcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:32:36 -0400
X-Yahoo-Newman-Id: 971939.18879.bm@omp1017.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0TPs9gIVM1kBkYPrKAerfCRazRYT5hOoyRZ.81FfJGZEhh3
 Htl5JybnujKqs4gNTxbEiLaJWVAf8BPC5NrNJhP0sPXf823zIEo6.jF81ANf
 fb3ONM3ILRXmrwZCxrwWa735UbgZG8_GFbbcYIsDnM9.AOUYWsDYgoMJwrAq
 5TQ7VC0uqcPlCsAOVvNbaftV9YGodlkLpH9OH.7pNmZAcHR52fAKGjL_94mF
 G6Kk7_hyMmzyHq2_sNr_OTsTFGpb9QE2Nje0CgPthrYg31nE8pwl2aHo98uD
 C_YhHStag2LB74lc_MDaWBSsWYOdEz4.V9G8tZ0AJxnw6bRd6hcR3ODv2fX8
 g0FJstq5RLa1CicS4geKwK4LCGVaqr9jd5yGGgtlFqdXN0ZIiYcjNrEMCRe3
 CeOMYGglU10G2SINtD5Ah_dx1n41cey7E0TRpqgQikGMkys_eWxHu88HRlxc
 ZE7VD3bGb0cJmU_8swVoFdTf6Xd5AurutdSYBV5c.QUVadKI1qdch
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 24/25] selftest: report generation script for test results
Date: Tue, 25 Sep 2012 18:32:27 -0500
Message-Id: <1348615947-10755-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A script that uses sqlite to load test results and generates a report
showing differences in performance per compiler used.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/gen_report.sh |  118 ++++++++++++++++++++
 1 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100755 tools/testing/selftests/grbtree/user/gen_report.sh

diff --git a/tools/testing/selftests/grbtree/user/gen_report.sh b/tools/testing/selftests/grbtree/user/gen_report.sh
new file mode 100755
index 0000000..d6a1d3d
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/gen_report.sh
@@ -0,0 +1,118 @@
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
+	userland	tinyint,
+	use_generic	tinyint,
+	use_leftmost	tinyint,
+	use_rightmost	tinyint,
+	use_count	tinyint,
+	unique_keys	tinyint,
+	insert_replaces	tinyint,
+	use_augmented	tinyint,
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
+	userland,
+	use_leftmost,
+	use_rightmost,
+	use_count,
+	unique_keys,
+	insert_replaces,
+	use_augmented,
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
+	(case when a.userland then	  'U' else 'K' end) ||
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
+		a.compiler = b.compiler
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

