Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab0IXQfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:31 -0400
Received: from kroah.org ([198.145.64.141]:37234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015Ab0IXQf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.391912830@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>,
        Tavis Ormandy <taviso@cmpxchg8b.com>, dann frazier <dannf@debian.org>
Subject: [38/68] KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/keyctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
 


