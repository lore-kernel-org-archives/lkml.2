Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2IYXii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:38:38 -0400
Received: from nm10-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.194]:24245 "HELO
	nm10-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754052Ab2IYXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:38:22 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:38:21 EDT
X-Yahoo-Newman-Id: 34413.2029.bm@omp1010.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: axXk1bsVM1m6bgn.9gzXw6Y1YOq.WH4biw0oqymgGJ721eV
 TjMqc85JcTuFiZ.d.sKTBC3JBeS4yjO3l3Q5MTTKeVBptkETQOlLmHwhFaMM
 Gv.VlO.wLMGdDap3_50xUW7nn9JkOYIjenp9KcgWh9NbZnUnXRihjn.XuyX.
 rMeD1rMuMYHprpc5OrsUlaB3wep96EZV1LF0RRZduriOjvsvp7JIHB13bPuN
 Fx1lTsZI1h7Y23kMSQ2axlt4IOW61IzUDBYtxqQ1nGAqKnNfzNCZz_0q0Kt0
 AnXt9S9TZpe_ndRo5DgPMlBD5gN7XYcR4QZtuK.vUn1_dLCSSVxHRbFuBNOT
 pq3UmmiGPaXNAWav2fU60SFa.s2asr3xjPTwVKlfOTC5iUEPALpXTPg6646g
 qDYMIaMMPisjrQ6i8_uk.qVPmOP6W3WQnxzydXNyNu3RdmOCHPRSENm0L0lC
 WktYPUjypDXKHyHOyY9iQmrDjxneFpIM6k8V0CW0vqWCy
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
Subject: [PATCH v5 22/25] selftest: Add script to compile & run userspace test program
Date: Tue, 25 Sep 2012 18:32:13 -0500
Message-Id: <1348615933-10689-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a basic script is designed to automate the testing process (for
a single compiler) and generate delimited text output suitable for later
processing. All test parameters can be supplied via the environment, or
defaults will be used for them. The following variables affect the
script and if not supplied, will have the these default values:

CC="gcc"
KERNELDIR="../../../../.."
CFLAGS="-O2 -pipe -march=k8"
key_type="u64"
use_leftmost=0
use_rightmost=0
use_count=0
unique_keys=0
insert_replaces=0
augmented=0
test_num=0

Other variables are hard-coded and will have be tweaked to need.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/runtest.sh |  108 +++++++++++++++++++++++
 1 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100755 tools/testing/selftests/grbtree/user/runtest.sh

diff --git a/tools/testing/selftests/grbtree/user/runtest.sh b/tools/testing/selftests/grbtree/user/runtest.sh
new file mode 100755
index 0000000..f371fea
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/runtest.sh
@@ -0,0 +1,108 @@
+#!/bin/bash
+
+# runtest.sh - script to compile and run userspace tests of gerneric red-black
+#              tree implementation for a single compiler.
+#
+# Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version 2
+# of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+# Variables affecting code generation
+CC="${CC:-gcc}"
+KERNELDIR="${KERNELDIR:-../../../../..}"
+CFLAGS="${CFLAGS:-"-O2 -pipe -march=k8"}"
+# CONFIG parameters:
+key_type=${key_type:-u64}
+use_leftmost=${use_leftmost:-0}
+use_rightmost=${use_rightmost:-0}
+use_count=${use_count:-0}
+unique_keys=${unique_keys:-0}
+insert_replaces=${insert_replaces:-0}
+augmented=${augmented:-0}
+# For test_num, see grbtest -h
+test_num=${test_num:-0}
+
+# Variables passed to grbtest program
+reps=0x20000
+count=0x800
+keymask=0xfff
+
+# Output files
+logfile=runtest.log
+datafile=runtest.out
+
+build_desc[0]="hand-coded"
+build_desc[1]="generic"
+
+die() {
+	echo "ERROR${@:+": "}$@" 1>&2
+	exit -1
+}
+
+. /etc/profile || die
+
+do_cpp() {
+	echo "$1" > /tmp/gnucver.$$.c || die
+	${CC} -E /tmp/gnucver.$$.c | grep -v '^#' | tr -d ' '
+	rm /tmp/gnucver.$$.c
+}
+
+gccverstr=$(do_cpp "__GNUC__.__GNUC_MINOR__.__GNUC_PATCHLEVEL__") || die
+
+execute_tests() {
+	for build_type in 1 0; do
+		CONFIG=$(echo						\
+			-DGRBTEST_KEY_TYPE=${key_type}			\
+			-DGRBTEST_BUILD_GENERIC=${build_type}		\
+			-DGRBTEST_USE_LEFTMOST=${use_leftmost}		\
+			-DGRBTEST_USE_RIGHTMOST=${use_rightmost}	\
+			-DGRBTEST_USE_COUNT=${use_count}		\
+			-DGRBTEST_UNIQUE_KEYS=${unique_keys}		\
+			-DGRBTEST_INSERT_REPLACES=${insert_replaces}	\
+			-DGRBTEST_USE_AUGMENTED=${augmented}		\
+		)
+
+		echo "********************************************************"
+		echo "Starting build at $(date '+%Y-%m-%d %H:%M:%S')..."
+		echo "  build_type = ${build_desc[${build_type}]}"
+		echo "  compiler   = ${gccverstr}"
+		echo "  CFLAGS     = ${CFLAGS}"
+		echo "  KERNELDIR  = ${KERNELDIR}"
+		echo
+
+		#set -x
+		CC="${CC}"			\
+		CFLAGS="${CFLAGS}"		\
+		CONFIG="${CONFIG}"		\
+		KERNELDIR="${KERNELDIR}"	\
+		make clean all || die
+		set +x
+
+		echo
+		echo "Executing test..."
+		echo
+		./grbtest --seed 1		\
+			  --reps ${reps}	\
+			  --count ${count}	\
+			  --keymask ${keymask}	\
+			  --delim "|"		\
+			  --quote ""		\
+			  --test ${test_num} | tee -a "${datafile}"
+		echo
+		echo
+	done
+}
+
+execute_tests | tee -a ${logfile}
-- 
1.7.3.4

