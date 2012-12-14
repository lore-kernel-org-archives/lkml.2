Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2LNDUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 22:20:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36643 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2LNDUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 22:20:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
	<CALCETrXLLcUu8Rajjx7+3N_6j5E0T0CR1h=hD+gcc5_r4Umyqw@mail.gmail.com>
	<876245jrbc.fsf@xmission.com>
	<CALCETrXRYOh2tkwB+U9ZjA5BNZwscWsq1WGzjP3wUiOXQUXOQg@mail.gmail.com>
Date: Thu, 13 Dec 2012 19:20:13 -0800
In-Reply-To: <CALCETrXRYOh2tkwB+U9ZjA5BNZwscWsq1WGzjP3wUiOXQUXOQg@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 13 Dec 2012 18:36:02 -0800")
Message-ID: <87sj79iaky.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Ixkp8ujWu64smaYXUQx0AFXWk+pLWKYI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andy Lutomirski pointed out that the current behavior of allowing the
owner of a user namespace to have all caps when that owner is not in a
parent user namespace is wrong.  Add a test to ensure the owner of a user
namespace is in the parent of the user namespace to fix this bug.

Thankfully this bug did not apply to the initial user namespace, keeping
the mischief that can be caused by this bug quite small.

This is bug was introduced in v3.5 by commit 783291e6900
"Simplify the user_namespace by making userns->creator a kuid."

The bug made it possible for the owner of a user namespace to be
present in a child user namespace.  Since the owner of a user nameapce
is granted all capabilities it became possible for users in a
grandchild user namespace to have all privilges over their parent user
namspace.

Reorder the checks in cap_capable.  This should make the common case
faster and make it clear that nothing magic happens in the initial
user namespace.  The reordering is safe because cred->user_ns
can only be in targ_ns or targ_ns->parent but not both.

Add a comment a the top of the loop to make the logic of
the code clear.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 security/commoncap.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 6dbae46..ded41a0 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -76,11 +76,12 @@ int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
 		int cap, int audit)
 {
-	for (;;) {
-		/* The owner of the user namespace has all caps. */
-		if (targ_ns != &init_user_ns && uid_eq(targ_ns->owner, cred->euid))
-			return 0;
 
+	/* See if cred has the capability in the target user namespace
+	 * by examining the target user namespace and all of the target
+	 * user namespace's parents.
+	 */
+	for (;;) {
 		/* Do we have the necessary capabilities? */
 		if (targ_ns == cred->user_ns)
 			return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
@@ -89,8 +90,16 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
 		if (targ_ns == &init_user_ns)
 			return -EPERM;
 
+		/* 
+		 * The owner of the user namespace in the parent of the
+		 * user namespace has all caps.
+		 */
+		if ((targ_ns->parent == cred->user_ns) &&
+		     uid_eq(targ_ns->owner, cred->euid))
+			return 0;
+
 		/*
-		 *If you have a capability in a parent user ns, then you have
+		 * If you have a capability in a parent user ns, then you have
 		 * it over all children user namespaces as well.
 		 */
 		targ_ns = targ_ns->parent;
-- 
1.7.5.4

