Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2KSPNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:13:12 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60883 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2KSPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:13:07 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:29 -0800
Message-Id: <1353337961-12962-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19DQgQHPbLL3pfYSCTzzFtUbHtBqSjgDyw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 04/16] userns: Allow setting a userns mapping to your current uid.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 456a6b9..49096d5 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -709,6 +709,21 @@ ssize_t proc_projid_map_write(struct file *file, const char __user *buf, size_t
 static bool new_idmap_permitted(struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
+	/* Allow mapping to your own filesystem ids */
+	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
+		u32 id = new_map->extent[0].lower_first;
+		if (cap_setid == CAP_SETUID) {
+			kuid_t uid = make_kuid(ns->parent, id);
+			if (uid_eq(uid, current_fsuid()))
+				return true;
+		}
+		else if (cap_setid == CAP_SETGID) {
+			kgid_t gid = make_kgid(ns->parent, id);
+			if (gid_eq(gid, current_fsgid()))
+				return true;
+		}
+	}
+
 	/* Allow anyone to set a mapping that doesn't require privilege */
 	if (!cap_valid(cap_setid))
 		return true;
-- 
1.7.5.4

