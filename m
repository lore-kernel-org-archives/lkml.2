Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab1F1P65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:58:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36491 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab1F1P43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:56:29 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: [PATCH 2/2] AppArmor: Fix masking of capabilities in complain mode
Date: Tue, 28 Jun 2011 16:56:05 +0100
Message-Id: <1309276565-20776-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309276565-20776-1-git-send-email-john.johansen@canonical.com>
References: <1309276565-20776-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AppArmor is masking the capabilities returned by capget against the
capabilities mask in the profile.  This is wrong, in complain mode the
profile has effectively all capabilities, as the profile restrictions are
not being enforced, merely tested against to determine is an access is
known by the profile.

This can result in the wrong behavior of security conscience applications
like sshd which examine their capability set, and change their behavior
accordingly.  In this case because of the masked capability set being
returned sshd fails due to DAC checks, even when the profile is complain
mode.

Kernels affected: 2.6.36 - 3.0

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lsm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 3d2fd14..3783202 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -127,7 +127,7 @@ static int apparmor_capget(struct task_struct *target, kernel_cap_t *effective,
 	*inheritable = cred->cap_inheritable;
 	*permitted = cred->cap_permitted;
 
-	if (!unconfined(profile)) {
+	if (!unconfined(profile) && !COMPLAIN_MODE(profile)) {
 		*effective = cap_intersect(*effective, profile->caps.allow);
 		*permitted = cap_intersect(*permitted, profile->caps.allow);
 	}
-- 
1.7.4.1

