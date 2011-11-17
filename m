Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1KQWhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:37:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:56473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1KQWhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077684"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 7/8] checksyscalls: Use arch/x86/syscalls/syscall_32.tbl as source
Date: Thu, 17 Nov 2011 14:37:25 -0800
Message-Id: <1321569446-20433-8-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Use the new arch/x86/syscalls/syscall_32.tbl file as source instead of
arch/x86/include/asm/unistd_32.h.

Cc: Michal Marek <mmarek@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/checksyscalls.sh |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 3ab316e..d24810f 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -198,11 +198,16 @@ EOF
 }
 
 syscall_list() {
-sed -n -e '/^\#define/ s/[^_]*__NR_\([^[:space:]]*\).*/\
-\#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
-\#warning syscall \1 not implemented\
-\#endif/p' $1
+    grep '^[0-9]' "$1" | sort -n | (
+	while read nr abi name entry ; do
+	    echo <<EOF
+#if !defined(__NR_${name}) && !defined(__IGNORE_${name})
+#warning syscall ${name} not implemented
+#endif
+EOF
+	done
+    )
 }
 
-(ignore_list && syscall_list $(dirname $0)/../arch/x86/include/asm/unistd_32.h) | \
+(ignore_list && syscall_list $(dirname $0)/../arch/x86/syscalls/syscall_32.tbl) | \
 $* -E -x c - > /dev/null
-- 
1.7.6.4

