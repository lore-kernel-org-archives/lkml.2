Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337Ab2I1XtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:49:23 -0400
Received: from nm13.bullet.mail.bf1.yahoo.com ([98.139.212.172]:47784 "HELO
	nm13.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964947Ab2I1XtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:49:14 -0400
X-Yahoo-Newman-Id: 20516.40552.bm@smtp101.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GWbovwAVM1lZ8TFKuuG3Cc47MUxI5yjSYL8i9.B9FeulTfs
 4W0VGM.NtDxJHu3HyET7GgOTKx3xJl.NFXSW47B.krUbRTUDE_R_0ejqtmgN
 4UaWbUFU8cvfz2nM5W0nfp8RuZPu5jjYLyNc0UQxUASDzYw6H4wcIvq3vsyi
 F7G5kR59uqCMpLANKPkf0ndhbs8BwsAUunHPvEtSrGEaoHXjr5iDwMXZRWXq
 r2V.PpiWcBGvxH2PJGY.YgTVj5kVnsjPxOyfYZl9299d81ZABxNiPlZ3ZEPM
 x9b4RJ26YUg7Z5V2lLQ3fX5dZZSkqdZhdiF9UpIPyKDQRmzo0ZJr1x3eWqoM
 CXqYj6l63a1eAflOiMl9aGOj.UEYike06gIFcfSVfE3gY4F9CntsfTIm1Urq
 S1Hc8oTQR57tSxBE7DoEMYf5GfIfJv5A8l02As9tlyJ1ALx2QJxePuGu5K1C
 coM9JGk2IaJymrXRmhbI5LdUYK5Hpkh3G.yXwtznChgbjzA--
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
Subject: [PATCH v6 8/10] selftest: Add script to compile & run userspace test program
Date: Fri, 28 Sep 2012 18:48:44 -0500
Message-Id: <1348876126-28792-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a basic script is designed to automate the testing process (for
a single compiler) and generate delimited text output suitable for later
processing. All test parameters can be supplied via the environment, or
defaults will be used for them. The following variables affect the
script and if not supplied, will have the these default values:

CC		"gcc"
KERNELDIR	"../../../../.."
CFLAGS		"-O2 -pipe -march=k8"
key_type	"u64"
payload		0
use_leftmost	0
use_rightmost	0
use_count	0
unique_keys	0
insert_replaces	0
test_num	0

reps		0x20000
count		0x800
keymask		0xfff

logfile		runtest.log
datafile	runtest.out

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/runtest.sh |  122 +++++++++++++++++++++++
 1 files changed, 122 insertions(+), 0 deletions(-)
 create mode 100755 tools/testing/selftests/grbtree/user/runtest.sh

diff --git a/tools/testing/selftests/grbtree/user/runtest.sh b/tools/testing/selftests/grbtree/user/runtest.sh
new file mode 100755
index 0000000..b481ad3
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/runtest.sh
@@ -0,0 +1,122 @@
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
+die() {
+	echo "ERROR${@:+": "}$@" 1>&2
+	exit -1
+}
+
+set_var_default() {
+	(($# == 2)) || die "set_var_default takes two parameters, got $#: $@"
+
+	var="$1"
+	default_val="$2"
+	cur_val=$(eval echo "\$${var}")
+
+	if [[ -z "${cur_val}" ]]; then
+		eval ${var}=\"${default_val}\"
+	fi
+}
+
+# Variables affecting code generation
+set_var_default CC		gcc
+set_var_default KERNELDIR	"../../../../.."
+set_var_default CFLAGS		"-O2 -pipe -march=k8"
+# CONFIG parameters:
+set_var_default key_type	u64
+set_var_default payload		0
+set_var_default use_leftmost	0
+set_var_default use_rightmost	0
+set_var_default use_count	0
+set_var_default unique_keys	0
+set_var_default insert_replaces	0
+# For test_num, see grbtest -h
+set_var_default test_num	0
+
+# Variables passed to grbtest program
+set_var_default reps		0x20000
+set_var_default count		0x800
+set_var_default keymask		0xfff
+
+# Output files
+set_var_default logfile		runtest.log
+set_var_default datafile	runtest.out
+
+
+build_desc[0]="hand-coded"
+build_desc[1]="generic"
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
+	for build_generic in 1 0; do
+		CONFIG=$(echo						\
+			-DGRBTEST_KEY_TYPE=${key_type}			\
+			-DGRBTEST_PAYLOAD=${payload}			\
+			-DGRBTEST_BUILD_GENERIC=${build_generic}	\
+			-DGRBTEST_USE_LEFTMOST=${use_leftmost}		\
+			-DGRBTEST_USE_RIGHTMOST=${use_rightmost}	\
+			-DGRBTEST_USE_COUNT=${use_count}		\
+			-DGRBTEST_UNIQUE_KEYS=${unique_keys}		\
+			-DGRBTEST_INSERT_REPLACES=${insert_replaces}
+		)
+
+		echo "********************************************************"
+		echo "Starting build at $(date '+%Y-%m-%d %H:%M:%S')..."
+		echo "  build_type = ${build_desc[${build_generic}]}"
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
+cp common.o prof/common-${build_desc[${build_generic}]}.o
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

