Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2A0FDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:03:17 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56456 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2A0Erw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 10/29] sysctl: Add ctl_table chains into cstring paths
Date: Thu, 26 Jan 2012 20:49:51 -0800
Message-Id: <1327639810-12760-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+8i4bMNMTRrhjyc1LSxG8lPTANv4MFTqk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For any component of table passed to __register_sysctl_paths
that actually serves as a path, add that to the cstring path
that is passed to __register_sysctl_table.

The result is that for most calls to __register_sysctl_paths
we only pass a table to __register_sysctl_table that contains
no child directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5704ff0..9b91dee 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1076,6 +1076,7 @@ struct ctl_table_header *__register_sysctl_paths(
 	struct nsproxy *namespaces,
 	const struct ctl_path *path, struct ctl_table *table)
 {
+	struct ctl_table *ctl_table_arg = table;
 	struct ctl_table_header *header = NULL;
 	const struct ctl_path *component;
 	char *new_path, *pos;
@@ -1090,7 +1091,15 @@ struct ctl_table_header *__register_sysctl_paths(
 		if (!pos)
 			goto out;
 	}
+	while (table->procname && table->child && !table[1].procname) {
+		pos = append_path(new_path, pos, table->procname);
+		if (!pos)
+			goto out;
+		table = table->child;
+	}
 	header = __register_sysctl_table(root, namespaces, new_path, table);
+	if (header)
+		header->ctl_table_arg = ctl_table_arg;
 out:
 	kfree(new_path);
 	return header;
-- 
1.7.2.5

