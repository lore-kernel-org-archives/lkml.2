Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab2I1Xt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:49:26 -0400
Received: from nm9.bullet.mail.bf1.yahoo.com ([98.139.212.168]:45910 "HELO
	nm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964952Ab2I1XtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:49:15 -0400
X-Yahoo-Newman-Id: 779226.40552.bm@smtp101.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZtK5v_IVM1ni9NZI0YY1Mpqw702WFapIWqwka2OPeR_5WB.
 Tdt6iYsvYBr5elHEdmKc.8Qs3glEQ8hfAWB2jkO5LS971F31yXk6eXTFVeu0
 SYHsQvdlVrNSVsu1Fo6qExq4c7JVQuxLFQhhWYGzq42YiTdFLlSxIINd0Oh.
 tIFl3MiRJ1Ei2Eu3iRZeiLFDK9WIdN7se7kqNmF9RZraXP8SogIJPlQeRyqL
 roFLuRf9km4sOYdWQRqsKOBRPyR0trIxdMD9RVPhmdC67xTenr0IF9FisKcs
 ZGXtQ2Jh.2_G_VdFrK8xMcSAgGlFo1NZ2CCpVg1P4qZpN5t1Xm20N2GJBHgv
 xUeedvENuTkVILynhJ6SWERypBintEsSG.G5jtZe76eYozZUlxds7sTPna7J
 5yhCJelyxZZ1.dpm8C1qoi3NEMdcN9PhBBLtTjHnb.pIFM.OGRmD4e6zElK0
 lmE188N1R.o.iNt_qJHJ9s7TPYY9bhCtdH6gTe_rjXl3agxHxrxKic9MrTI9
 m7L4dr9Z1uwSVEFwOv28.QBBpYA--
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
Subject: [PATCH v6 9/10] selftest: Add basic compiler iterator test script
Date: Fri, 28 Sep 2012 18:48:45 -0500
Message-Id: <1348876126-28792-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Gentoo-specific script (to be run by root) to iterate through all
installed compilers, execte runtest.sh script and collect the output
data.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/runtests.sh |   52 ++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)
 create mode 100755 tools/testing/selftests/grbtree/user/runtests.sh

diff --git a/tools/testing/selftests/grbtree/user/runtests.sh b/tools/testing/selftests/grbtree/user/runtests.sh
new file mode 100755
index 0000000..d60ec99
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/runtests.sh
@@ -0,0 +1,52 @@
+#!/bin/bash
+
+# This script is designed for use on Gentoo systems, using gcc-config to
+# change the compiler and must be run as root. I'm lazy, so alter to fit your
+# system.
+
+#key_type_range=$(echo {u,s}{8,16,32,64})
+key_type_range="u32 u64"
+unique_style_range="0 1 2"
+add_ons_range="0 1 2"
+
+user=daniel
+outfile=runtests.$$.out
+
+die() {
+	echo "ERROR${@:+": "}$@" 1>&2
+	exit -1
+}
+
+
+rm -f runtest.log runtest.out
+
+if [[ -e ${outfile} ]]; then
+	echo "File ${outfile} exists, please move it out of the way."
+	exit
+fi
+
+for ((gcc_inst_num = 10; gcc_inst_num > 1; --gcc_inst_num)); do
+	gcc-config $gcc_inst_num || exit
+	. /etc/profile
+
+	for key_type in ${key_type_range}; do
+	for unique_style in ${unique_style_range}; do
+	for add_ons in ${add_ons_range}; do
+
+	nice -n -3 sudo -Hu ${user}			\
+		key_type=${key_type}			\
+		payload=0				\
+		use_leftmost=$((add_ons > 0))		\
+		use_rightmost=$((add_ons == 2))		\
+		use_count=$((add_ons == 2))		\
+		unique_keys=$((unique_style > 0))	\
+		insert_replaces=$((unique_style == 2))	\
+		reps=0x20000				\
+		./runtest.sh >> ${outfile} || die
+
+	done
+	done
+	done
+done
+gcc-config 10
+. /etc/profile
-- 
1.7.3.4

