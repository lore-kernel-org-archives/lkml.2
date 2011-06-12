Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1FLOtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 10:49:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1FLOs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 10:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=YWz5gfThRTZOXumlOVYP1ijD9G+HmeA6xqIXpHzt14UkeZw6lamFSZmaoDSqWloyt8
         xO4elac/U+Te3XcMduTwkW5pCQNj+rGCk8Rrf/1PRq13AUU0vg+2ba4fPYn4X5bvEk0x
         Oy/PcU3HLo3Nm0IIQHb7geNLLdLMuGNbjQrZs=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
        linux-doc@vger.kernel.org
Subject: [RFC v2 04/04] procfs: document mount options
Date: Sun, 12 Jun 2011 18:47:42 +0400
Message-Id: <1307890063-6399-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe procfs mount options in documentation.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Documentation/filesystems/proc.txt |   51 ++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 23cae65..4fd35c4 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -41,6 +41,8 @@ Table of Contents
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
 
+  4	Configuring procfs
+  4.1	Mount options
 
 ------------------------------------------------------------------------------
 Preface
@@ -1535,3 +1537,52 @@ a task to set its own or one of its thread siblings comm value. The comm value
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+
+------------------------------------------------------------------------------
+Configuring procfs
+------------------------------------------------------------------------------
+
+4.1	Mount options
+---------------------
+
+The following mount options are supported:
+
+	hidepid=	Set /proc/<pid>/ access mode.
+	hidenet		Hide /proc/<pid>/net/ from nonauthorized users.
+	nohidenet	Don't hide /proc/<pid>/net/ from nonauthorized users.
+	gid=		Set the group authorized to learn processes and
+			networking information.
+
+hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
+(default).
+
+hidepid=1 means users may not access any /proc/<pid>/ directories, but their
+own.  Sensitive files like cmdline, io, sched*, status, wchan are now protected
+against other users.  This makes impossible to learn whether any user runs
+specific program (given the program doesn't reveal itself by its behaviour).
+As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
+poorly written programs passing sensitive information via program arguments are
+now protected against local eavesdroppers.
+
+hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be fully invisible to other
+users.  It doesn't mean that it hides a fact whether a process with a specific
+pid value exists (it can be learned by other means, e.g. by sending signals),
+but it hides process' uid and gid, which may be learned by stat()'ing
+/proc/<pid>/ otherwise.  It greatly complicates intruder's task of gathering info
+about running processes, whether some daemon runs with elevated privileges,
+whether other user runs some sensitive program, whether other users run any
+program at all, etc.
+
+hidenet means /proc/<pid>/net/ will be accessible to processes with
+CAP_NET_ADMIN capability or to members of a special group.  It means
+nonauthorized users may not learn any networking connections information.  If
+network namespaces support is enabled (CONFIG_NET_NS=y) then common users would
+obtain net directory, but all files would indicate no networking activity at
+all.  If network namespaces are disabled, net directory is unaccessible to
+common users.
+
+gid= means group authorized to learn processes information prohibited by
+hidepid= and networking information prohibited by hidenet.  If you use some
+daemon like identd which have to learn information about net/processes
+information, just add identd to this group.
