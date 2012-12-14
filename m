Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2LNWEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:04:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:32868 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab2LNWEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:04:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
References: <87txroxpgq.fsf@xmission.com>
Date: Fri, 14 Dec 2012 14:04:31 -0800
In-Reply-To: <87txroxpgq.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 14 Dec 2012 14:01:57 -0800")
Message-ID: <87bodwxpcg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ZLMnBMChSDV4apVQ6NqMN1zmHwkNXSCU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0409]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 3/4] userns: Add a more complete capability subset test to commit_creds
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When unsharing a user namespace we reduce our credentials to just what
can be done in that user namespace.  This is a subset of the credentials
we previously had.  Teach commit_creds to recognize this is a subset
of the credentials we have had before and don't clear the dumpability flag.

This allows an unprivileged  program to do:
unshare(CLONE_NEWUSER);
fd = open("/proc/self/uid_map", O_RDWR);

Where previously opening the uid_map writable would fail because
the the task had been made non-dumpable.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/cred.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 48cea3d..993a7ea41 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -455,6 +455,30 @@ error_put:
 	return ret;
 }
 
+static bool cred_cap_issubset(const struct cred *set, const struct cred *subset)
+{
+	const struct user_namespace *set_ns = set->user_ns;
+	const struct user_namespace *subset_ns = subset->user_ns;
+
+	/* If the two credentials are in the same user namespace see if
+	 * the capabilities of subset are a subset of set.
+	 */
+	if (set_ns == subset_ns)
+		return cap_issubset(subset->cap_permitted, set->cap_permitted);
+
+	/* The credentials are in a different user namespaces
+	 * therefore one is a subset of the other only if a set is an
+	 * ancestor of subset.
+	 */
+	while (subset_ns != &init_user_ns) {
+		if (set_ns == subset_ns->parent)
+			return true;
+		subset_ns = subset_ns->parent;
+	}
+
+	return false;
+}
+
 /**
  * commit_creds - Install new credentials upon the current task
  * @new: The credentials to be assigned
@@ -493,7 +517,7 @@ int commit_creds(struct cred *new)
 	    !gid_eq(old->egid, new->egid) ||
 	    !uid_eq(old->fsuid, new->fsuid) ||
 	    !gid_eq(old->fsgid, new->fsgid) ||
-	    !cap_issubset(new->cap_permitted, old->cap_permitted)) {
+	    !cred_cap_issubset(old, new)) {
 		if (task->mm)
 			set_dumpable(task->mm, suid_dumpable);
 		task->pdeath_signal = 0;
-- 
1.7.5.4

