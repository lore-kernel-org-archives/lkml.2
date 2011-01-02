Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1ABHYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:36085 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1ABHYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, David Howells <dhowells@redhat.com>,
        dann frazier <dannf@debian.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 142/260] KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring
Date: Sun,  2 Jan 2011 02:17:18 -0500
Message-Id: <1293952756-15010-143-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:45.0681 (UTC) FILETIME=[D9FFBA10:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 3d96406c7da1ed5811ea52a3b0905f4f0e295376 upstream.

Fix a bug in keyctl_session_to_parent() whereby it tries to check the ownership
of the parent process's session keyring whether or not the parent has a session
keyring [CVE-2010-2960].

This results in the following oops:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
  IP: [<ffffffff811ae4dd>] keyctl_session_to_parent+0x251/0x443
  ...
  Call Trace:
   [<ffffffff811ae2f3>] ? keyctl_session_to_parent+0x67/0x443
   [<ffffffff8109d286>] ? __do_fault+0x24b/0x3d0
   [<ffffffff811af98c>] sys_keyctl+0xb4/0xb8
   [<ffffffff81001eab>] system_call_fastpath+0x16/0x1b

if the parent process has no session keyring.

If the system is using pam_keyinit then it mostly protected against this as all
processes derived from a login will have inherited the session keyring created
by pam_keyinit during the log in procedure.

To test this, pam_keyinit calls need to be commented out in /etc/pam.d/.

Reported-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 security/keys/keyctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d29e022..c25603a 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1292,7 +1292,8 @@ long keyctl_session_to_parent(void)
 		goto not_permitted;
 
 	/* the keyrings must have the same UID */
-	if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
+	if ((pcred->tgcred->session_keyring &&
+	     pcred->tgcred->session_keyring->uid != mycred->euid) ||
 	    mycred->tgcred->session_keyring->uid != mycred->euid)
 		goto not_permitted;
 
-- 
1.7.3.3

