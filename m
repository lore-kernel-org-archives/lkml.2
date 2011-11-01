Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1KAD75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:59:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44525 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab1KAD74 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:59:56 -0400
Message-ID: <1320119973.30281.7.camel@deadeye>
Subject: [PATCH] module: Enable dynamic debugging regardless of taint
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Baron <jbaron@redhat.com>, Nick Bowler <nbowler@elliptictech.com>,
        Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 01 Nov 2011 03:59:33 +0000
In-Reply-To: <87r51svbit.fsf@rustcorp.com.au>
References: <1319773094.6759.32.camel@deadeye>
	 <87obwxq5tz.fsf@rustcorp.com.au> <1320068657.6759.107.camel@deadeye>
	 <87r51svbit.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic debugging is currently disabled for tainted modules, except
for TAINT_CRAP.  This prevents use of dynamic debugging for
out-of-tree modules now that they are also tainted.

This condition was apparently intended to avoid a crash if a force-
loaded module has an incompatible definition of dynamic debug
structures.  However, a administrator that forces us to load a module
is claiming that it *is* compatible even though it fails our version
checks.  If they are mistaken, there are any number of ways the module
could crash the system.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/module.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index dab585e..ef8cb70 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2881,8 +2881,7 @@ static struct module *load_module(void __user *umod,
 	}
 
 	/* This has to be done once we're sure module name is unique. */
-	if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
-		dynamic_debug_setup(info.debug, info.num_debug);
+	dynamic_debug_setup(info.debug, info.num_debug);
 
 	/* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2918,8 +2917,7 @@ static struct module *load_module(void __user *umod,
 	module_bug_cleanup(mod);
 
  ddebug:
-	if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
-		dynamic_debug_remove(info.debug);
+	dynamic_debug_remove(info.debug);
  unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
-- 
1.7.7


-- 
Ben Hutchings
Computers are not intelligent.	They only think they are.
