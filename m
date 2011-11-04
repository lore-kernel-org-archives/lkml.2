Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1KDWYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:24:15 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45273 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1KDWYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:24:09 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, serge@hallyn.com, dhowells@redhat.com,
        eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 4/6] Add Documentation/namespaces/user_namespace.txt (v3)
Date: Fri,  4 Nov 2011 22:24:40 +0000
Message-Id: <1320445482-8459-5-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320445482-8459-1-git-send-email-serge@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge@hallyn.com>

Provide a description of user namespaces

Changelog:
   jul 26: incorporate feedback from David Howells.
   jul 29: incorporate feedback from Randy Dunlap.
   sep 15: remove information which is not yet certain.
   Oct 26: add changes suggested by David on Oct 19

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/namespaces/user_namespace.txt |   54 +++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/namespaces/user_namespace.txt

diff --git a/Documentation/namespaces/user_namespace.txt b/Documentation/namespaces/user_namespace.txt
new file mode 100644
index 0000000..805f0ef
--- /dev/null
+++ b/Documentation/namespaces/user_namespace.txt
@@ -0,0 +1,54 @@
+Description
+===========
+
+Traditionally, each task is owned by a user ID (UID) and belongs to one or more
+groups (GID).  Both are simple numeric IDs, though userspace usually translates
+them to names.  The user namespace allows tasks to have different views of the
+UIDs and GIDs associated with tasks and other resources.  (See 'UID mapping'
+below for more.)
+
+The user namespace is a simple hierarchical one.  The system starts with all
+tasks belonging to the initial user namespace.  A task creates a new user
+namespace by passing the CLONE_NEWUSER flag to clone(2).  This requires the
+creating task to have the CAP_SETUID, CAP_SETGID, and CAP_CHOWN capabilities,
+but it does not need to be running as root.  The clone(2) call will result in a
+new task which to itself appears to be running as UID and GID 0, but to its
+creator seems to have the creator's credentials.
+
+To this new task, any resource belonging to the initial user namespace will
+appear to belong to user and group 'nobody', which are UID and GID -1.
+Permission to open such files will be granted according to world access
+permissions.  UID comparisons and group membership checks will fail, and
+privilege will be denied.
+
+When a task belonging to (for example) UID 500 in the initial user namespace
+creates a new user namespace, even though the new task will see itself as
+belonging to UID 0, any task in the initial user namespace will see it as
+belonging to UID 500.  Therefore, UID 500 in the initial user namespace will be
+able to kill the new task.
+
+UID mapping for the VFS is not yet implemented, though prototypes exist.
+
+Relationship between the User namespace and other namespaces
+============================================================
+
+Other namespaces, such as UTS and network, are owned by a user namespace.  When
+such a namespace is created, it is assigned to the user namespace of the task
+by which it was created.  Therefore attempts to exercise privilege over a
+resource can be properly validated by checking for privilege targeted to the
+user namespace which owns the resource.  For instance, a check for the special
+privilege to change a network interface address could be done by checking for
+CAP_NET_ADMIN against the user namespace which created the network namespace
+owning the network interface.
+
+( XXX TODO: add a list of capabilities corresponding to different namespaces)
+
+As an example, if a new task is cloned with a private user namespace but
+not a private network namespace, then the task's network namespace is owned
+by the parent user namespace.  The new task has no special privilege over the
+parent user namespace, so it will not be able to create or configure the
+network devices therein.  If instead the task were cloned with both private
+user and network namespaces, then the private network namespace is owned
+by the private user namespace, and so root in the new user namespace
+will have privilege over resources owned by the network namespace.  It will
+be able to create and configure network devices.
-- 
1.7.0.4

