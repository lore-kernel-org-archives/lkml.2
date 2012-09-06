Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2IFVLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:11:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63250 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2IFVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:11:30 -0400
Date: Thu, 6 Sep 2012 22:11:25 +0100
From: James Hogan <james@albanarts.com>
To: Mike Frysinger <vapier@gentoo.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: add symbol prefix arg to kallsyms
Message-ID: <20120906211125.GB4785@balrog.le.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 ("kbuild: link of
vmlinux moved to a script") introduced in v3.5-rc1 broke kallsyms on
architectures which have symbol prefixes.

The --symbol-prefix argument used to be added to the KALLSYMS command
line from the architecture Makefile, however this isn't picked up by the
new scripts/link-vmlinux.sh. This resulted in symbols like
kallsyms_addresses being added which weren't correctly overriding the
weak symbols such as _kallsyms_addresses. These could then trigger
BUG_ONs in kallsyms code.

This is fixed by removing the KALLSYMS addition from the architecture
Makefile, and using CONFIG_SYMBOL_PREFIX in the link-vmlinux.sh script
to determine whether to add the --symbol-prefix argument.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/blackfin/Makefile  |    1 -
 scripts/link-vmlinux.sh |    7 ++++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index d3d7e64..66cf000 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -20,7 +20,6 @@ endif
 KBUILD_AFLAGS           += $(call cc-option,-mno-fdpic)
 KBUILD_CFLAGS_MODULE    += -mlong-calls
 LDFLAGS                 += -m elf32bfin
-KALLSYMS         += --symbol-prefix=_
 
 KBUILD_DEFCONFIG := BF537-STAMP_defconfig
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 4629038..df48dda 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -74,8 +74,13 @@ kallsyms()
 	info KSYM ${2}
 	local kallsymopt;
 
+	if [ -n "${CONFIG_SYMBOL_PREFIX}" ]; then
+		kallsymopt="${kallsymopt} \
+			    --symbol-prefix=${CONFIG_SYMBOL_PREFIX}"
+	fi
+
 	if [ -n "${CONFIG_KALLSYMS_ALL}" ]; then
-		kallsymopt=--all-symbols
+		kallsymopt="${kallsymopt} --all-symbols"
 	fi
 
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
-- 
1.7.7.6
