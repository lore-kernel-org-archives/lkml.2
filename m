Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1D2QgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:36:19 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:56879 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab1D2QgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:36:18 -0400
Date: Fri, 29 Apr 2011 18:35:00 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sliakh.lkml@gmail.com, jiang@cs.ncsu.edu,
        mingo@elte.hu
Subject: Re: Undoing module RONX protection fix
Message-ID: <20110429163500.GA5241@linux.vnet.ibm.com>
References: <20110418092348.GB7786@hal> <20110418092801.GC3837@infradead.org> <874o5v6drb.fsf@rustcorp.com.au> <20110421141949.GA10675@hal> <87ipu0l1kt.fsf@rustcorp.com.au> <1303985300.3495.93.camel@localhost.localdomain> <87tyditxo8.fsf@rustcorp.com.au> <20110428134321.GA10759@hal> <87hb9hd5zn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hb9hd5zn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 02:11:16PM +0930, Rusty Russell wrote:
> On Thu, 28 Apr 2011 15:43:21 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > On Thu, Apr 28, 2011 at 09:06:39PM +0930, Rusty Russell wrote:
> > > On Thu, 28 Apr 2011 12:08:20 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > > > How about this?
> > > > 
> > > > To be honest I don't like the inverse naming like in unset no-execute
> > > > too much, it makes me feel dizzy. But I wanted to keep the changes
> > > > minimal.
> > > 
> > > Yes, it should probably just be called protect_module_pages and
> > > unprotect_module_pages.  The current names provide far too much
> > > information.
> > > 
> > > But going back a bit, how did we end up with a NULL mod->module_init and
> > > yet module->init_text_size, mod->init_size or mod->init_ro_size
> > > non-zero?
> > 
> > printk'ing this reveals that mod->init_ro_size is not 0 but 0x1000.
> > Therefore the first page was modified.
> > 
> > Looks like init_ro_size is missing the reset to zero at the end of the init_module
> > syscall. Next patch ? ;-
> 
> Yes, that seems like a much cleaner and clearer fix to me...

Rusty, I'm not sure if I should resend a merged patch or not, going for the
later so you can apply on top of what you might have. If you would appreciate a
merged patch more please let me know...

Cheers,
Jan
------

Reset mod->init_ro_size to zero after the init part of a module is unloaded. 
That makes the check if a module part exists in the unprotect functions
superfluous so they can be removed.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 kernel/module.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1609,8 +1609,6 @@ static void set_section_ro_nx(void *base
 
 static void unset_module_core_ro_nx(struct module *mod)
 {
-	if (mod->module_core == NULL)
-		return;
 	set_page_attributes(mod->module_core + mod->core_text_size,
 		mod->module_core + mod->core_size,
 		set_memory_x);
@@ -1621,8 +1619,6 @@ static void unset_module_core_ro_nx(stru
 
 static void unset_module_init_ro_nx(struct module *mod)
 {
-	if (mod->module_init == NULL)
-		return;
 	set_page_attributes(mod->module_init + mod->init_text_size,
 		mod->module_init + mod->init_size,
 		set_memory_x);
@@ -2941,6 +2937,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
+	mod->init_ro_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
 
