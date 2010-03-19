Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0CSPVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:21:55 -0400
Received: from kroah.org ([198.145.64.141]:45913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab0CSPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/12] kobject: documentation: Fix erroneous example in kobject doc.
Date: Fri, 19 Mar 2010 08:18:51 -0700
Message-Id: <1269011935-8886-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Replace uio_mem example for kobjects with uio_map, since the uio_mem
struct no longer contains a kobject.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |   57 ++++++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index bdb1381..668cb83 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -59,37 +59,56 @@ nice to have in other objects.  The C language does not allow for the
 direct expression of inheritance, so other techniques - such as structure
 embedding - must be used.
 
-So, for example, the UIO code has a structure that defines the memory
-region associated with a uio device:
+(As an aside, for those familiar with the kernel linked list implementation,
+this is analogous as to how "list_head" structs are rarely useful on
+their own, but are invariably found embedded in the larger objects of
+interest.)
 
-struct uio_mem {
+So, for example, the UIO code in drivers/uio/uio.c has a structure that
+defines the memory region associated with a uio device:
+
+    struct uio_map {
 	struct kobject kobj;
-	unsigned long addr;
-	unsigned long size;
-	int memtype;
-	void __iomem *internal_addr;
-};
+	struct uio_mem *mem;
+    };
 
-If you have a struct uio_mem structure, finding its embedded kobject is
+If you have a struct uio_map structure, finding its embedded kobject is
 just a matter of using the kobj member.  Code that works with kobjects will
 often have the opposite problem, however: given a struct kobject pointer,
 what is the pointer to the containing structure?  You must avoid tricks
 (such as assuming that the kobject is at the beginning of the structure)
 and, instead, use the container_of() macro, found in <linux/kernel.h>:
 
-	container_of(pointer, type, member)
+    container_of(pointer, type, member)
+
+where:
+
+  * "pointer" is the pointer to the embedded kobject,
+  * "type" is the type of the containing structure, and
+  * "member" is the name of the structure field to which "pointer" points.
+
+The return value from container_of() is a pointer to the corresponding
+container type. So, for example, a pointer "kp" to a struct kobject
+embedded *within* a struct uio_map could be converted to a pointer to the
+*containing* uio_map structure with:
+
+    struct uio_map *u_map = container_of(kp, struct uio_map, kobj);
+
+For convenience, programmers often define a simple macro for "back-casting"
+kobject pointers to the containing type.  Exactly this happens in the
+earlier drivers/uio/uio.c, as you can see here:
+
+    struct uio_map {
+        struct kobject kobj;
+        struct uio_mem *mem;
+    };
 
-where pointer is the pointer to the embedded kobject, type is the type of
-the containing structure, and member is the name of the structure field to
-which pointer points.  The return value from container_of() is a pointer to
-the given type. So, for example, a pointer "kp" to a struct kobject
-embedded within a struct uio_mem could be converted to a pointer to the
-containing uio_mem structure with:
+    #define to_map(map) container_of(map, struct uio_map, kobj)
 
-    struct uio_mem *u_mem = container_of(kp, struct uio_mem, kobj);
+where the macro argument "map" is a pointer to the struct kobject in
+question.  That macro is subsequently invoked with:
 
-Programmers often define a simple macro for "back-casting" kobject pointers
-to the containing type.
+    struct uio_map *map = to_map(kobj);
 
 
 Initialization of kobjects
-- 
1.7.0.2

