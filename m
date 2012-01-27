Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2A0FFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:05:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51904 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2A0Erv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:47:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 08/29] sysctl: Create local copies of directory names used in paths
Date: Thu, 26 Jan 2012 20:49:49 -0800
Message-Id: <1327639810-12760-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/QDKYsK0QwaNgy8EdHHKkIlhfhgF+Yr9M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating local copies of directory names is a good idea for
two reasons.
- The dynamic names used by callers must be copied into new
  strings by the callers today to ensure the strings do not
  change between register and unregister of the sysctl table.

- Sysctl directories have a potentially different lifetime
  than the time between register and unregister of any
  particular sysctl table.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 86d32a3..bcf60fb 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -943,10 +943,12 @@ struct ctl_table_header *__register_sysctl_paths(
 	struct ctl_table *new, **prevp;
 	unsigned int n, npath;
 	struct ctl_table_set *set;
+	size_t path_bytes = 0;
+	char *new_name;
 
 	/* Count the path components */
 	for (npath = 0; path[npath].procname; ++npath)
-		;
+		path_bytes += strlen(path[npath].procname) + 1;
 
 	/*
 	 * For each path component, allocate a 2-element ctl_table array.
@@ -956,24 +958,27 @@ struct ctl_table_header *__register_sysctl_paths(
 	 * We allocate everything in one go so that we don't have to
 	 * worry about freeing additional memory in unregister_sysctl_table.
 	 */
-	header = kzalloc(sizeof(struct ctl_table_header) +
+	header = kzalloc(sizeof(struct ctl_table_header) + path_bytes +
 			 (2 * npath * sizeof(struct ctl_table)), GFP_KERNEL);
 	if (!header)
 		return NULL;
 
 	new = (struct ctl_table *) (header + 1);
+	new_name = (char *)(new + (2 * npath));
 
 	/* Now connect the dots */
 	prevp = &header->ctl_table;
 	for (n = 0; n < npath; ++n, ++path) {
 		/* Copy the procname */
-		new->procname = path->procname;
+		strcpy(new_name, path->procname);
+		new->procname = new_name;
 		new->mode     = 0555;
 
 		*prevp = new;
 		prevp = &new->child;
 
 		new += 2;
+		new_name += strlen(new_name) + 1;
 	}
 	*prevp = table;
 	header->ctl_table_arg = table;
-- 
1.7.2.5

