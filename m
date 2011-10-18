Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1JRV4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:56:14 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40282 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754118Ab1JRVys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:54:48 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 6/9] Add Documentation/namespaces/user_namespace.txt (v3)
Date: Tue, 18 Oct 2011 21:54:55 +0000
Message-Id: <1318974898-21431-7-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318974898-21431-1-git-send-email-serge@hallyn.com>
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serge@hallyn.com>

Provide a description of user namespaces

Changelog:
   jul 26: incorporate feedback from David Howells.
   jul 29: incorporate feedback from Randy Dunlap.
   sep 15: remove information which is not yet certain.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/namespaces/user_namespace.txt |   51 +++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/namespaces/user_namespace.txt

diff --git a/Documentation/namespaces/user_namespace.txt b/Documentation/namespaces/user_namespace.txt
new file mode 100644
index 0000000..0ca6564
--- /dev/null
+++ b/Documentation/namespaces/user_namespace.txt
@@ -0,0 +1,51 @@
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
+permissions.  UID comparisons and group membership checks will return false,
+and privilege will be denied.
+
+When a task belonging to (for example) userid 500 in the initial user namespace
+creates a new user namespace, even though the new task will see itself as
+belonging to UID 0, any task in the initial user namespace will see it as
+belonging to UID 500.  Therefore, UID 500 in the initial user namespace will be
+able to kill the new task.
+
+Userid mapping for the VFS is not yet implemented, though prototypes exist.
+
+Relationship between the User namespace and other namespaces
+============================================================
+
+Other namespaces, such as UTS and network, are owned by a user namespace.  When
+such a namespace is created, it is assigned to the user namespace of the task
+by which it was created.  Therefore, attempts to exercise privilege to
+resources in, for instance, a particular network namespace, can be properly
+validated by checking whether the caller has the needed privilege (i.e.
+CAP_NET_ADMIN) targeted to the user namespace which owns the network namespace.
+This is done using the ns_capable() function.
+
+As an example, if a new task is cloned with a private user namespace but
+no private network namespace, then the task's network namespace is owned
+by the parent user namespace.  The new task has no privilege to the
+parent user namespace, so it will not be able to create or configure
+network devices.  If, instead, the task were cloned with both private
+user and network namespaces, then the private network namespace is owned
+by the private user namespace, and so root in the new user namespace
+will have privilege targeted to the network namespace.  It will be able
+to create and configure network devices.
-- 
1.7.5.4

