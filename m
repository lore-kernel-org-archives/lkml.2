Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1BVWVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:44 -0500
Received: from kroah.org ([198.145.64.141]:46709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1BVWVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221839.961065505@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wright <chrisw@sous-sol.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <jmorris@namei.org>
Subject: [29/70] security: add cred argument to security_capable()
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 6037b715d6fab139742c3df8851db4c823081561 upstream.

Expand security_capable() to include cred, so that it can be usable in a
wider range of call sites.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/security.h |    6 +++---
 kernel/capability.c      |    2 +-
 security/security.c      |    5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1664,7 +1664,7 @@ int security_capset(struct cred *new, co
 		    const kernel_cap_t *effective,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted);
-int security_capable(int cap);
+int security_capable(const struct cred *cred, int cap);
 int security_real_capable(struct task_struct *tsk, int cap);
 int security_real_capable_noaudit(struct task_struct *tsk, int cap);
 int security_sysctl(struct ctl_table *table, int op);
@@ -1857,9 +1857,9 @@ static inline int security_capset(struct
 	return cap_capset(new, old, effective, inheritable, permitted);
 }
 
-static inline int security_capable(int cap)
+static inline int security_capable(const struct cred *cred, int cap)
 {
-	return cap_capable(current, current_cred(), cap, SECURITY_CAP_AUDIT);
+	return cap_capable(current, cred, cap, SECURITY_CAP_AUDIT);
 }
 
 static inline int security_real_capable(struct task_struct *tsk, int cap)
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -306,7 +306,7 @@ int capable(int cap)
 		BUG();
 	}
 
-	if (security_capable(cap) == 0) {
+	if (security_capable(current_cred(), cap) == 0) {
 		current->flags |= PF_SUPERPRIV;
 		return 1;
 	}
--- a/security/security.c
+++ b/security/security.c
@@ -154,10 +154,9 @@ int security_capset(struct cred *new, co
 				    effective, inheritable, permitted);
 }
 
-int security_capable(int cap)
+int security_capable(const struct cred *cred, int cap)
 {
-	return security_ops->capable(current, current_cred(), cap,
-				     SECURITY_CAP_AUDIT);
+	return security_ops->capable(current, cred, cap, SECURITY_CAP_AUDIT);
 }
 
 int security_real_capable(struct task_struct *tsk, int cap)


