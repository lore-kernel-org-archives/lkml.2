Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163313Ab1FAI3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:29:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:45353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163295Ab1FAI3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:29:44 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:31 2011
Message-Id: <20110601081230.981816107@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:15 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees@ubuntu.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [165/165] AppArmor: fix oops in apparmor_setprocattr
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1159
Lines: 34

From: Kees Cook <kees.cook@canonical.com>

commit a5b2c5b2ad5853591a6cac6134cd0f599a720865 upstream.

When invalid parameters are passed to apparmor_setprocattr a NULL deref
oops occurs when it tries to record an audit message. This is because
it is passing NULL for the profile parameter for aa_audit. But aa_audit
now requires that the profile passed is not NULL.

Fix this by passing the current profile on the task that is trying to
setprocattr.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/apparmor/lsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -593,7 +593,8 @@ static int apparmor_setprocattr(struct t
 			sa.aad.op = OP_SETPROCATTR;
 			sa.aad.info = name;
 			sa.aad.error = -EINVAL;
-			return aa_audit(AUDIT_APPARMOR_DENIED, NULL, GFP_KERNEL,
+			return aa_audit(AUDIT_APPARMOR_DENIED,
+					__aa_current_profile(), GFP_KERNEL,
 					&sa, NULL);
 		}
 	} else if (strcmp(name, "exec") == 0) {


