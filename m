Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0GLQWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:22:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0GLQWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:22:06 -0400
Date: Mon, 12 Jul 2010 12:21:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, yehuda@hq.newdream.net
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Message-ID: <20100712162140.GA2925@redhat.com>
References: <201007011744.19564.trenn@suse.de> <201007091303.08693.trenn@suse.de> <20100709133019.GA2856@redhat.com> <201007121624.17543.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007121624.17543.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 04:24:16PM +0200, Thomas Renninger wrote:
> Hi,
> 
> it's this one:
> commit ff49d74ad383f54041378144ca1a229ee9aeaa59
> Author: Yehuda Sadeh <yehuda@hq.newdream.net>
> Date:   Sat Jul 3 13:07:35 2010 +1000
> 
> which touches same code than Jason's fix does.
> Possibly this patch also addresses (only parts of?) this problem?
> Jason: Do you mind having a look at the latest git version and review
> Yehuda's  and adjust your patch if still necessary.

So Yehuda's patch is meant to address this issue. I would still move the
remove code to free_module(), for the case that load_module() fails as
follows (on top of Yehuda's patch):

Signed-off-by: Jason Baron <jbaron@redhat.com>
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

Also, the patch i wrote addressed the issue of duplicate "module" names.
Although you can't have duplicate names of loadable modules. Dynamic
debug also refers to built in vmlinux sections by using
"KBUILD_MODNAME". These are not necessarily globally unique. Thus, we
probably should be using a better globally unique identifier in the code.
However, that improvement can probably wait...

I will re-post the above as a separate thread. Also, I should probably
post a patch to add myself to the MAINTAINERS file, since I didn't see
Yehuda's patch until now...

> If Yehuda's patch is fixing this already, we still need it backported for
> 2.6.34 stable kernel and further?
> 

Yes, patch might need to be adjusted a bit but is still relevant for
2.6.34 stable. The situation was exacerbated by:

commit 3bafeb6247042dcbb72b0141ec7c7107de9f0b99
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jun 5 11:17:36 2010 -0600

    module: move find_module check to end

during the 2.6.35 time frame.

> One question about dynamic debug (unrelated to the mem corruption
> issue):
> Would it make sense to initialize dynamic debug earlier, somewhen shortly
> after __setup is called.
> Then a boot param ddebug_enable="xy" could be added.
> The param could be in /sys/../control format or just be "all"?
> My idea is to be able to track all the pr_debug calls (as) early (as possible) 
> at boot up.
> One example is ec.c. Currently it is not possible to see the pr_debug messages
> when EC accesses are done when the ACPI interpreter is started, there
> is no userspace and no sysfs yet.
> Same for PCI related pr_debug messages at early PCI(e) initialization time?
> Would that be possible or do I miss something?
> 
> Thanks,
> 
>      Thomas

definitely a good idea, and something I just had not yet done
yet...after we resolve this issue, I'd be more than happy to review
and/or write a patch to do this. I'm glad ppl are interested in this :)

thanks,

-Jason

