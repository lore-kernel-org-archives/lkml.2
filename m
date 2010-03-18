Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0CRJHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:07:43 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:60035 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0CRJHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ANPq42fizZU+2X2qGt/5YwOB77kOODlG2W6MmaXhkv4XMqH3YKJd5PoN+1Rwe+aus8
         4OWdiuyvCv+k6gXuhbRcwZoUsJZkM5rEGkscB5rBYAj+TiSpRvWeJY/o9q1+KpWYSiRv
         rFDYbqlUMve/K8lkXE2ZoDt0ebVbTdkzp04ik=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 03/12] notifier: change notifier_from_errno(0) to return NOTIFY_OK
Date: Thu, 18 Mar 2010 18:05:15 +0900
Message-Id: <1268903124-10237-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes notifier_from_errno(0) to be NOTIFY_OK instead of
NOTIFY_STOP_MASK | NOTIFY_OK.

Currently, the notifiers which return encapsulated errno value have to
do something like this:

	err = do_something(); // returns -errno
	if (err)
		return notifier_from_errno(err);
	else
		return NOTIFY_OK;

This change makes the above code simple:

	err = do_something(); // returns -errno

	return return notifier_from_errno(err);

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/notifier.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index fee6c2f..9e4831d 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -164,7 +164,10 @@ extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 /* Encapsulate (negative) errno value (in particular, NOTIFY_BAD <=> EPERM). */
 static inline int notifier_from_errno(int err)
 {
-	return NOTIFY_STOP_MASK | (NOTIFY_OK - err);
+	if (err)
+		return NOTIFY_STOP_MASK | (NOTIFY_OK - err);
+
+	return NOTIFY_OK;
 }
 
 /* Restore (negative) errno value from notify return value. */
-- 
1.6.0.6

