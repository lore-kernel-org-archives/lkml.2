Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab1CYG2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab1CYG2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:28:50 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Subject: [PATCH] ipcns: fix use after free in free_ipc_ns
Date: Fri, 25 Mar 2011 14:28:24 +0800
Message-Id: <1301034504-8133-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b515498 add a user namespace owner of ipc ns, but it also
introduced a use after free in free_ipc_ns.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
---
 ipc/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 3c3e522..8054c8e 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -104,7 +104,6 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
-	kfree(ns);
 	atomic_dec(&nr_ipc_ns);
 
 	/*
@@ -113,6 +112,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	 */
 	ipcns_notify(IPCNS_REMOVED);
 	put_user_ns(ns->user_ns);
+	kfree(ns);
 }
 
 /*
-- 
1.7.1

