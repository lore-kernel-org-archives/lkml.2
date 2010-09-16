Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0IPWO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0IPWO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:56 -0400
Subject: Audit: add support to match lsm labels on user audit messages
From: Eric Paris <eparis@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, akpm@linux-foundation.org,
        mitr@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 18:14:11 -0400
Message-ID: <1284675251.2695.10.camel@dhcp231-112.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

Add support for matching by security label (e.g. SELinux context) of
the sender of an user-space audit record.

The audit filter code already allows user space to configure such
filters, but they were ignored during evaluation.  This patch implements
evaluation of these filters.

For example, after application of this patch, PAM authentication logs
caused by cron can be disabled using
	auditctl -a user,never -F subj_type=crond_t

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
---

This patch was actually sent to list back on Nov 9, 2009 but
accidentally got dropped on the floor.  I am resending the patch in
hopes that it will not get lost for the next merge window.

 kernel/auditfilter.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a706040..50307c1 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1259,6 +1259,18 @@ static int audit_filter_user_rules(struct netlink_skb_parms *cb,
 		case AUDIT_LOGINUID:
 			result = audit_comparator(cb->loginuid, f->op, f->val);
 			break;
+		case AUDIT_SUBJ_USER:
+		case AUDIT_SUBJ_ROLE:
+		case AUDIT_SUBJ_TYPE:
+		case AUDIT_SUBJ_SEN:
+		case AUDIT_SUBJ_CLR:
+			if (f->lsm_rule)
+				result = security_audit_rule_match(cb->sid,
+								   f->type,
+								   f->op,
+								   f->lsm_rule,
+								   NULL);
+			break;
 		}
 
 		if (!result)

