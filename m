Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1HCXdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:33:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab1HCXbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:31:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.336284856@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Johansen <john.johansen@canonical.com>
Subject: [092/102] AppArmor: Fix reference to rcu protected pointer outside of rcu_read_lock
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 04fdc099f9c80c7775dbac388fc97e156d4d47e7 upstream.

The pointer returned from tracehook_tracer_task() is only valid inside
the rcu_read_lock.  However the tracer pointer obtained is being passed
to aa_may_ptrace outside of the rcu_read_lock critical section.

Mover the aa_may_ptrace test into the rcu_read_lock critical section, to
fix this.

Kernels affected: 2.6.36 - 3.0

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/apparmor/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -73,7 +73,6 @@ static int may_change_ptraced_domain(str
 		cred = get_task_cred(tracer);
 		tracerp = aa_cred_profile(cred);
 	}
-	rcu_read_unlock();
 
 	/* not ptraced */
 	if (!tracer || unconfined(tracerp))
@@ -82,6 +81,7 @@ static int may_change_ptraced_domain(str
 	error = aa_may_ptrace(tracer, tracerp, to_profile, PTRACE_MODE_ATTACH);
 
 out:
+	rcu_read_unlock();
 	if (cred)
 		put_cred(cred);
 


