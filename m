Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0FFHH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 03:07:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34466 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0FFHHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 03:07:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <monstr@monstr.eu>, linux-m32r@ml.linux-m32r.org,
       Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3] FLAT: tweak default stack alignment
Date: Sun,  6 Jun 2010 03:12:17 -0400
Message-Id: <1275808337-17465-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274863506-14168-2-git-send-email-vapier@gentoo.org>
References: <1274863506-14168-2-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit 1f0ce8b3dd667dca7 which moved the ARCH_SLAB_MINALIGN
default into the global header inadvertently broke FLAT for a bunch of
systems.  Blackfin systems now fail on any FLAT exec with:
Unable to read code+data+bss, errno 14
When your /init is a FLAT binary, obviously this can be annoying ;).

This stems from the alignment usage in the FLAT loader.  The behavior
before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
defined, and this was only defined by arches when they wanted a larger
alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.

So let's merge the two alignment requirements so the floor is never 0.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- split changes & document better

v3
	- combine the diff align values via max_t

 fs/binfmt_flat.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index b6ab27c..811384b 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -68,11 +68,7 @@
  * Here we can be a bit looser than the data sections since this
  * needs to only meet arch ABI requirements.
  */
-#ifdef ARCH_SLAB_MINALIGN
-#define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
-#else
-#define FLAT_STACK_ALIGN	(sizeof(void *))
-#endif
+#define FLAT_STACK_ALIGN	max_t(unsigned long, sizeof(void *), ARCH_SLAB_MINALIGN)
 
 #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
 #define UNLOADED_LIB 0x7ff000ff		/* Placeholder for unused library */
-- 
1.7.1

