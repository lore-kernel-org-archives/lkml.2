Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465Ab1EABjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab1EABiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eDaAVN7kTDkLEetMLpElQi/BtJsG0qeV9O051GgbpyoJd+mo5we+3oIkoX5Ercj9u+
         GwOjmYUY8U9GRhlqJD/gYVTq5hpfgv9a4FjJ7MIv6wjxxltHiUD9tVkCcmU7ywczp6zX
         iSNIMKMcMcZ0LBnvylpETe4zC5430TG8pQZxY=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 61/69] sysctl: single subheader path: optimisation for paths used only once
Date: Sun,  1 May 2011 03:36:31 +0200
Message-Id: <1304213799-10257-62-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an optimisation for registering paths that you know will be
used to register a single table. Because such directories will be used
only once, sysctl will always create an entry for it when it sees it.

When sysctl registers a table, for each directory that may be used
while registering other tables we do a linear search to see if it's
already added, and, if not, add it ourselves.

For example: each netdevice will register a single table under
    	  /proc/sys/net/ipv4/conf/DEVNAME/.

The 'DEVNAME' component of the path is not used to register other
headers, and we can optimise adding that directory: we don't have to
check if it's already registered.

This will have a positive performance impact when registering many
such directories because we're doing a O(nr of sibling directories)
search. With @has_just_one_subheader=1 set we skip that search and add
the directory directly because we know no other sibling directory with
the same name was registered.

NOTE: in this example setting @has_just_one_subheader=1 for the 'conf'
ctl_path would be wrong because it's used when registering other
subheaders too (e.g. subheaders for other netdevices).

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/sysctl.h |   31 +++++++++++++++++++++++++++++++
 kernel/sysctl.c        |   12 +++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index cd9e789..0931165 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1072,6 +1072,37 @@ struct ctl_table_header {
 /* struct ctl_path describes where in the hierarchy a table is added */
 struct ctl_path {
 	const char *procname;
+
+
+	/* This is an optimisation for registering paths that you know
+	 * will be used to register a single table. Because such
+	 * directories will be used only once, sysctl will always
+	 * create an entry for it when it sees it.
+	 *
+	 * When sysctl registers a table, for each directory that may
+	 * be used while registering other tables we do a linear
+	 * search to see if it's already added, and, if not, add it
+	 * ourselves.
+	 *
+	 * For example: each netdevice will register a single table
+	 * under /proc/sys/net/ipv4/conf/DEVNAME/.
+	 *
+	 * The 'DEVNAME' component of the path is not used to register
+	 * other headers, and we can optimise adding that directory:
+	 * we don't have to check if it's already registered.
+	 *
+	 * This will have a positive performance impact when
+	 * registering many such directories because we're doing a
+	 * O(nr of sibling directories) search. With
+	 * @has_just_one_subheader=1 set we skip that search and add
+	 * the directory directly because we know no other sibling
+	 * directory with the same name was registered.
+	 *
+	 * NOTE: in this example setting @has_just_one_subheader=1 for
+	 * the 'conf' ctl_path would be wrong because it's used when
+	 * registering other subheaders too (e.g. subheaders for other
+	 * netdevices). */
+	int has_just_one_subheader;
 };
 
 extern struct ctl_table_header *__register_sysctl_paths(struct ctl_table_group *g,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3ff4384..6747259 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1896,11 +1896,13 @@ static struct ctl_table_header *sysctl_mkdirs(struct ctl_table_header *parent,
 	retry:
 		sysctl_write_lock_head(parent);
 
-		h = mkdir_existing_dir(parent, dirs[i]->dirname);
-		if (h != NULL) {
-			sysctl_write_unlock_head(parent);
-			parent = h;
-			continue;
+		if (!path[i].has_just_one_subheader) {
+			h = mkdir_existing_dir(parent, dirs[i]->dirname);
+			if (h != NULL) {
+				sysctl_write_unlock_head(parent);
+				parent = h;
+				continue;
+			}
 		}
 
 		if (likely(!create_first_netns_corresp)) {
-- 
1.7.5.134.g1c08b

