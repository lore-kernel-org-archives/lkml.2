Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2LMWjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:39:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55490 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2LMWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:39:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        <linux-security-module@vger.kernel.org>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com>
Date: Thu, 13 Dec 2012 14:39:20 -0800
In-Reply-To: <87mwxhtxve.fsf@xmission.com> (Eric W. Biederman's message of
	"Thu, 13 Dec 2012 14:01:41 -0800")
Message-ID: <87zk1hshk7.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/sEZOupTsAWYiGZnImcn2+ftMKSwDaJnE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0832]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andy Lutomirski pointed out that the current behavior of allowing the
owner of a user namespace to have all caps when that owner is not in a
parent user namespace is wrong.

This is a bug introduced by the kuid conversion which made it possible
for the owner of a user namespace to live in a child user namespace.  I
goofed and totally missed this implication.

Serge and can you please take a look and see if my corrected cap_capable
reads correctly to you.

Andy or anyone else that wants to give me a second eyeball and double
check me on this I would appreciate it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---

diff --git a/security/commoncap.c b/security/commoncap.c
index 6dbae46..4639f44 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -70,37 +70,44 @@ int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
  *
  * NOTE WELL: cap_has_capability() cannot be used like the kernel's capable()
  * and has_capability() functions.  That is, it has the reverse semantics:
  * cap_has_capability() returns 0 when a task has a capability, but the
  * kernel's capable() and has_capability() returns 1 for this case.
  */
 int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
 		int cap, int audit)
 {
 	for (;;) {
-		/* The owner of the user namespace has all caps. */
-		if (targ_ns != &init_user_ns && uid_eq(targ_ns->owner, cred->euid))
-			return 0;
+		struct user_namespace *parent_ns;
 
 		/* Do we have the necessary capabilities? */
 		if (targ_ns == cred->user_ns)
 			return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
 
 		/* Have we tried all of the parent namespaces? */
 		if (targ_ns == &init_user_ns)
 			return -EPERM;
 
+		parent_ns = targ_ns->parent;
+
+		/* 
+		 * The owner of the user namespace in the parent user
+		 * namespace has all caps.
+		 */
+		if ((parent_ns == cred->user_ns) && uid_eq(targ_ns->owner, cred->euid))
+			return 0;
+
 		/*
-		 *If you have a capability in a parent user ns, then you have
+		 * If you have a capability in a parent user ns, then you have
 		 * it over all children user namespaces as well.
 		 */
-		targ_ns = targ_ns->parent;
+		targ_ns = parent_ns;
 	}
 
 	/* We never get here */
 }
 
 /**
  * cap_settime - Determine whether the current process may set the system clock
  * @ts: The time to set
  * @tz: The timezone to set
  *
