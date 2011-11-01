Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab1KAXxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:53:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:40354 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab1KAXxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:53:39 -0400
Date: Wed, 2 Nov 2011 10:53:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem update
Message-ID: <alpine.LRH.2.00.1111021049080.12545@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this fix for Tomoyo.


The following changes since commit b4beb4bf9934d151bf4581a54ae028927374cb2a:
  Linus Torvalds (1):
        Merge branch 'for-linus/i2c-3.2' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  git://git.selinuxproject.org/~jmorris/linux-security for-linus

Tetsuo Handa (1):
      TOMOYO: Fix interactive judgment functionality.

 security/tomoyo/common.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index d41900d..610b535 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -963,6 +963,9 @@ static bool tomoyo_manager(void)
 	return found;
 }
 
+static struct tomoyo_domain_info *tomoyo_find_domain_by_qid
+(unsigned int serial);
+
 /**
  * tomoyo_select_domain - Parse select command.
  *
@@ -996,6 +999,8 @@ static bool tomoyo_select_domain(struct tomoyo_io_buffer *head,
 	} else if (!strncmp(data, "domain=", 7)) {
 		if (tomoyo_domain_def(data + 7))
 			domain = tomoyo_find_domain(data + 7);
+	} else if (sscanf(data, "Q=%u", &pid) == 1) {
+		domain = tomoyo_find_domain_by_qid(pid);
 	} else
 		return false;
 	head->w.domain = domain;
@@ -1891,6 +1896,7 @@ static DECLARE_WAIT_QUEUE_HEAD(tomoyo_answer_wait);
 /* Structure for query. */
 struct tomoyo_query {
 	struct list_head list;
+	struct tomoyo_domain_info *domain;
 	char *query;
 	size_t query_len;
 	unsigned int serial;
@@ -2041,6 +2047,7 @@ int tomoyo_supervisor(struct tomoyo_request_info *r, const char *fmt, ...)
 		goto out;
 	}
 	len = tomoyo_round2(entry.query_len);
+	entry.domain = r->domain;
 	spin_lock(&tomoyo_query_list_lock);
 	if (tomoyo_memory_quota[TOMOYO_MEMORY_QUERY] &&
 	    tomoyo_memory_used[TOMOYO_MEMORY_QUERY] + len
@@ -2088,6 +2095,29 @@ out:
 }
 
 /**
+ * tomoyo_find_domain_by_qid - Get domain by query id.
+ *
+ * @serial: Query ID assigned by tomoyo_supervisor().
+ *
+ * Returns pointer to "struct tomoyo_domain_info" if found, NULL otherwise.
+ */
+static struct tomoyo_domain_info *tomoyo_find_domain_by_qid
+(unsigned int serial)
+{
+	struct tomoyo_query *ptr;
+	struct tomoyo_domain_info *domain = NULL;
+	spin_lock(&tomoyo_query_list_lock);
+	list_for_each_entry(ptr, &tomoyo_query_list, list) {
+		if (ptr->serial != serial || ptr->answer)
+			continue;
+		domain = ptr->domain;
+		break;
+	}
+	spin_unlock(&tomoyo_query_list_lock);
+	return domain;
+}
+
+/**
  * tomoyo_poll_query - poll() for /sys/kernel/security/tomoyo/query.
  *
  * @file: Pointer to "struct file".

