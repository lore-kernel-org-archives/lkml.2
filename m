Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1HCXdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:33:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab1HCXbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:31:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.453586565@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Johansen <john.johansen@canonical.com>
Subject: [093/102] AppArmor: Fix masking of capabilities in complain mode
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 25e75dff519bcce2cb35023105e7df51d7b9e691 upstream.

AppArmor is masking the capabilities returned by capget against the
capabilities mask in the profile.  This is wrong, in complain mode the
profile has effectively all capabilities, as the profile restrictions are
not being enforced, merely tested against to determine if an access is
known by the profile.

This can result in the wrong behavior of security conscience applications
like sshd which examine their capability set, and change their behavior
accordingly.  In this case because of the masked capability set being
returned sshd fails due to DAC checks, even when the profile is in complain
mode.

Kernels affected: 2.6.36 - 3.0.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/apparmor/lsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -127,7 +127,7 @@ static int apparmor_capget(struct task_s
 	*inheritable = cred->cap_inheritable;
 	*permitted = cred->cap_permitted;
 
-	if (!unconfined(profile)) {
+	if (!unconfined(profile) && !COMPLAIN_MODE(profile)) {
 		*effective = cap_intersect(*effective, profile->caps.allow);
 		*permitted = cap_intersect(*permitted, profile->caps.allow);
 	}


