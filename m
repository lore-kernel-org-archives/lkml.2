Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2KSPND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:13:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60767 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2KSPM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:12:59 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:27 -0800
Message-Id: <1353337961-12962-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18tHgMStca7B041QO86/A/4QxHSCxTKr8o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.5 XMWhlSbjSex Whole Obfuscated Subjects
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0009]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 02/16] userns: Allow unprivileged users to create user namespaces.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Now that we have been through every permission check in the kernel
having uid == 0 and gid == 0 in your local user namespace no
longer adds any special privileges.  Even having a full set
of caps in your local user namespace is safe because capabilies
are relative to your local user namespace, and do not confer
unexpected privileges.

Over the long term this should allow much more of the kernels
functionality to be safely used by non-root users.  Functionality
like unsharing the mount namespace that is only unsafe because
it can fool applications whose privileges are raised when they
are executed.  Since those applications have no privileges in
a user namespaces it becomes safe to spoof and confuse those
applications all you want.

Those capabilities will still need to be enabled carefully because
we may still need things like rlimits on the number of unprivileged
mounts but that is to avoid DOS attacks not to avoid fooling root
owned processes.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/fork.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 811ffba..8c29abb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1569,14 +1569,6 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
 			return -EINVAL;
 	}
-	if (clone_flags & CLONE_NEWUSER) {
-		/* hopefully this check will go away when userns support is
-		 * complete
-		 */
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SETUID) ||
-				!capable(CAP_SETGID))
-			return -EPERM;
-	}
 
 	/*
 	 * Determine whether and which event to report to ptracer.  When
-- 
1.7.5.4

