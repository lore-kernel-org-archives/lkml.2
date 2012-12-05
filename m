Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2LEQJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:24 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2LEQJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Balbir Singh <bsingharora@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [PATCH v2 03/44] Add CONFIG_HAVE_64BIT_ALIGNED_STRUCT for taskstats
Date: Wed, 5 Dec 2012 16:08:21 +0000
Message-ID: <1354723742-6195-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit architectures with no efficient unaligned access, taskstats
has to add some padding to a reply to prevent unaligned access warnings.
However this also needs to apply to 32 bit architectures with 64 bit
struct alignment such as metag (which has 64 bit memory accesses).

This is solved by adding a new Kconfig symbol
CONFIG_HAVE_64BIT_ALIGNED_STRUCT which defaults to CONFIG_64BIT, and can
be explicitly selected by CONFIG_METAG. Taskstats then uses this symbol
instead of CONFIG_64BIT to determine whether to add the padding.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Will Drewry <wad@chromium.org>
Cc: James Morris <james.l.morris@oracle.com>
---
 arch/Kconfig       |   16 ++++++++++++++++
 kernel/taskstats.c |    3 ++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 366ec06..dc7ffb1 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -93,6 +93,22 @@ config UPROBES
 
 	  If in doubt, say "N".
 
+config HAVE_64BIT_ALIGNED_STRUCT
+	bool
+	default 64BIT
+	help
+	  Some architectures have 64bit struct alignment (64 bit
+	  architectures and some 32 bit architectures which can do
+	  64 bit accesses).
+
+	  This symbol should be selected by an architecture if it has
+	  a 64 bit struct alignment requirement even though it isn't
+	  a 64 bit architecture (64 bit architectures have this on by
+	  default).
+
+	  See Documentation/unaligned-memory-access.txt for more
+	  information on the topic of unaligned memory accesses.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 145bb4d..afaa4c2 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -364,7 +364,8 @@ static int parse(struct nlattr *na, struct cpumask *mask)
 	return ret;
 }
 
-#if defined(CONFIG_64BIT) && !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#if defined(CONFIG_HAVE_64BIT_ALIGNED_STRUCT) && \
+	!defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define TASKSTATS_NEEDS_PADDING 1
 #endif
 
-- 
1.7.7.6


