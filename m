Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab0EZIlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:41:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45431 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0EZIlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:41:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <monstr@monstr.eu>, linux-m32r@ml.linux-m32r.org,
       Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 2/2 v2] FLAT: tweak default stack alignment
Date: Wed, 26 May 2010 04:45:06 -0400
Message-Id: <1274863506-14168-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
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

But let's ignore that and simply ignore min alignment values of 0.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- split changes & document better

 fs/binfmt_flat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index b865622..4959a0a 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -68,7 +68,7 @@
  * Here we can be a bit looser than the data sections since this
  * needs to only meet arch ABI requirements.
  */
-#ifdef ARCH_SLAB_MINALIGN
+#if defined(ARCH_SLAB_MINALIGN) && ARCH_SLAB_MINALIGN != 0
 #define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
 #else
 #define FLAT_STACK_ALIGN	(sizeof(void *))
-- 
1.7.1

