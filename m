Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2LDTwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:52:45 -0500
Received: from mail.tpi.com ([70.99.223.143]:2718 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab2LDTwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:52:44 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.7-rc8] lib/Makefile: Fix oid_registry build dependency
Date: Tue,  4 Dec 2012 12:52:28 -0700
Message-Id: <1354650748-11032-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is $(obj)/oid_registry.o that is dependent on $(obj)/oid_registry_data.c.
The object file cannot be built until $(obj)/oid_registry_data.c has been
generated.

A periodic and hard to reproduce parallel build failure is due to
this incorrect lib/Makefile dependency. The compile error is completely
disingenuous.

  GEN     lib/oid_registry_data.c
Compiling 49 OIDs
  CC      lib/oid_registry.o
gcc: error: lib/oid_registry.c: No such file or directory
gcc: fatal error: no input files
compilation terminated.
make[3]: *** [lib/oid_registry.o] Error 4

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

I've only ever been able to reproduce this build failure on an Ubuntu PPA, 
and then only infrequently. Restarting the build generally succeeds.
I beleive the root of the issue to be an incorrect dependency, though
I'm not sure why it doesn't fail more often. Its never failed when run by hand,
even on large N-way systems. Commit a77ad6ea0b0bb1f9d1f52ed494bd72a5fdde208e
which introduced this change came in with 3.7-rc1, so this patch is not
applicable for stable.

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 821a162..a08b791 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -163,7 +163,7 @@ $(obj)/crc32table.h: $(obj)/gen_crc32table
 #
 obj-$(CONFIG_OID_REGISTRY) += oid_registry.o
 
-$(obj)/oid_registry.c: $(obj)/oid_registry_data.c
+$(obj)/oid_registry.o: $(obj)/oid_registry_data.c
 
 $(obj)/oid_registry_data.c: $(srctree)/include/linux/oid_registry.h \
 			    $(src)/build_OID_registry
-- 
1.7.9.5

