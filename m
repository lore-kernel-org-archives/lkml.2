Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0GNUBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:01:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0GNUBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:01:54 -0400
Date: Wed, 14 Jul 2010 16:00:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, hare@suse.de,
        trenn@suse.de, yehuda@hq.newdream.net
Subject: [PATCH] dynamic debug: move ddebug_remove_module() down into
	free_module()
Message-ID: <20100714200056.GB2871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the call to ddebug_remove_module() down into free_module(). In this way
it should be called from all error paths. Currently, we are missing the
remove if the module init routine fails.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Reported-by: Thomas Renninger <trenn@suse.de>
Tested-by: Thomas Renninger <trenn@suse.de>
CC: akpm@linux-foundation.org
CC: andi@firstfloor.org
CC: hare@suse.de
CC: trenn@suse.de
CC: yehuda@hq.newdream.net
CC: linux-kernel@vger.kernel.org
---
 kernel/module.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5d2d281..6c56282 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -787,7 +787,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
-	ddebug_remove_module(mod->name);
 
 	free_module(mod);
 	return 0;
@@ -1550,6 +1549,9 @@ static void free_module(struct module *mod)
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
+	/* Remove dynamic debug info */
+	ddebug_remove_module(mod->name);
+
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
-- 
1.7.1

