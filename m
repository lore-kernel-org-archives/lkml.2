Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab0EUQ6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:58:37 -0400
Received: from kroah.org ([198.145.64.141]:39148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab0EUQyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/38] sysfs-namespaces: add a high-level Documentation file
Date: Fri, 21 May 2010 09:53:56 -0700
Message-Id: <1274460848-11377-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

The first three paragraphs are almost verbatim taken from Eric's
commit message on the patch introducing network ns tags.  The next
two paragraphs I wrote to be a brief high level overview.  The last
section is taken from the commit message on "Implement sysfs tagged
directory support", but updated.  Hopefully correctly.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs-tagging.txt |   42 +++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/sysfs-tagging.txt

diff --git a/Documentation/filesystems/sysfs-tagging.txt b/Documentation/filesystems/sysfs-tagging.txt
new file mode 100644
index 0000000..caaaf12
--- /dev/null
+++ b/Documentation/filesystems/sysfs-tagging.txt
@@ -0,0 +1,42 @@
+Sysfs tagging
+-------------
+
+(Taken almost verbatim from Eric Biederman's netns tagging patch
+commit msg)
+
+The problem.  Network devices show up in sysfs and with the network
+namespace active multiple devices with the same name can show up in
+the same directory, ouch!
+
+To avoid that problem and allow existing applications in network
+namespaces to see the same interface that is currently presented in
+sysfs, sysfs now has tagging directory support.
+
+By using the network namespace pointers as tags to separate out the
+the sysfs directory entries we ensure that we don't have conflicts
+in the directories and applications only see a limited set of
+the network devices.
+
+Each sysfs directory entry may be tagged with zero or one
+namespaces.  A sysfs_dirent is augmented with a void *s_ns.  If a
+directory entry is tagged, then sysfs_dirent->s_flags will have a
+flag between KOBJ_NS_TYPE_NONE and KOBJ_NS_TYPES, and s_ns will
+point to the namespace to which it belongs.
+
+Each sysfs superblock's sysfs_super_info contains an array void
+*ns[KOBJ_NS_TYPES].  When a a task in a tagging namespace
+kobj_nstype first mounts sysfs, a new superblock is created.  It
+will be differentiated from other sysfs mounts by having its
+s_fs_info->ns[kobj_nstype] set to the new namespace.  Note that
+through bind mounting and mounts propagation, a task can easily view
+the contents of other namespaces' sysfs mounts.  Therefore, when a
+namespace exits, it will call kobj_ns_exit() to invalidate any
+sysfs_dirent->s_ns pointers pointing to it.
+
+Users of this interface:
+- define a type in the kobj_ns_type enumeration.
+- call kobj_ns_type_register() with its kobj_ns_type_operations which has
+  - current_ns() which returns current's namespace
+  - netlink_ns() which returns a socket's namespace
+  - initial_ns() which returns the initial namesapce
+- call kobj_ns_exit() when an individual tag is no longer valid
-- 
1.7.0.3

