Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab0G3Rf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:35:59 -0400
Received: from kroah.org ([198.145.64.141]:35698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759400Ab0G3Ree (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:06 2010
Message-Id: <20100730173106.809358749@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Baron <jbaron@redhat.com>
Subject: [045/140] dynamic debug: move ddebug_remove_module() down into free_module()
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Baron <jbaron@redhat.com>

commit b82bab4bbe9efa7bc7177fc20620fff19bd95484 upstream.

The command

	echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control

causes an oops.

Move the call to ddebug_remove_module() down into free_module().  In this
way it should be called from all error paths.  Currently, we are missing
the remove if the module init routine fails.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Reported-by: Thomas Renninger <trenn@suse.de>
Tested-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/module.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -720,7 +720,6 @@ SYSCALL_DEFINE2(delete_module, const cha
 	mutex_lock(&module_mutex);
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
-	ddebug_remove_module(mod->name);
 	free_module(mod);
 
  out:
@@ -1383,6 +1382,9 @@ static void free_module(struct module *m
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
+	/* Remove dynamic debug info */
+	ddebug_remove_module(mod->name);
+
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 


