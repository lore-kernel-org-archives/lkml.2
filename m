Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2A0Eya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:54:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51978 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2A0Etg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:49:36 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 17/29] sysctl: Factor out insert_header and erase_header
Date: Thu, 26 Jan 2012 20:51:53 -0800
Message-Id: <1327639925-12920-17-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zjyU8U5Y1dEldUlqLO7/bjno37l/uCxA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 4979925..7e96a26 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -57,6 +57,17 @@ static void init_header(struct ctl_table_header *head,
 	head->parent = NULL;
 }
 
+static void erase_header(struct ctl_table_header *head)
+{
+	list_del_init(&head->ctl_entry);
+}
+
+static void insert_header(struct ctl_table_header *header)
+{
+	header->parent->count++;
+	list_add_tail(&header->ctl_entry, &header->set->list);
+}
+
 /* called under sysctl_lock */
 static int use_table(struct ctl_table_header *p)
 {
@@ -96,7 +107,7 @@ static void start_unregistering(struct ctl_table_header *p)
 	 * do not remove from the list until nobody holds it; walking the
 	 * list in do_sysctl() relies on that.
 	 */
-	list_del_init(&p->ctl_entry);
+	erase_header(p);
 }
 
 static void sysctl_head_get(struct ctl_table_header *head)
@@ -974,8 +985,7 @@ struct ctl_table_header *__register_sysctl_table(
 	}
 	if (sysctl_check_dups(namespaces, header, path, table))
 		goto fail_locked;
-	header->parent->count++;
-	list_add_tail(&header->ctl_entry, &header->set->list);
+	insert_header(header);
 	spin_unlock(&sysctl_lock);
 
 	return header;
-- 
1.7.2.5

