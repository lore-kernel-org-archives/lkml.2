Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1DUOUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:20:00 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:54609 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1DUOT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:19:59 -0400
Date: Thu, 21 Apr 2011 16:19:49 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sliakh.lkml@gmail.com, jiang@cs.ncsu.edu,
        mingo@elte.hu
Subject: Re: Undoing module RONX protection
Message-ID: <20110421141949.GA10675@hal>
References: <20110418092348.GB7786@hal>
 <20110418092801.GC3837@infradead.org>
 <874o5v6drb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874o5v6drb.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 08:13:36PM +0930, Rusty Russell wrote:
> On Mon, 18 Apr 2011 11:23:48 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > While debugging I stumbled over two problems in the code that protects module
> > pages.
> > 
> > First issue is that disabling the protection before freeing init or unload of
> > a module is not symmetric with the enablement. For instance, if pages are set
> > to RO the page range from module_core to module_core + core_ro_size is
> > protected. If a module is unloaded the page range from module_core to
> > module_core + core_size is set back to RW.
> > So pages that were not set to RO are also changed to RW.
> > This is not critical but IMHO it should be symmetric.
> > 
> > Second issue is that while set_memory_rw & set_memory_ro are used for
> > RO/RW changes only set_memory_nx is involved for NX/X. One would await that
> > the inverse function is called when the NX protection should be removed,
> > which is not the case here, unless I'm missing something.
> > 
> > The following patch addresses both issues. Works on s390. Boot tested on x86.
> > 
> > Please comment,
> 
> Applied, minus the S/390 EXPORT_SYMBOL which Christoph pointed out.  I
> turned your mail into the commit message, since it was clearer and more
> verbose.  I don't see why they would be different.

There's a bug in my patch which just killed one of my s390 machines.
Can you merge this with the previuos patch?

thanks, Jan
---

From: Jan Glauber <jang@linux.vnet.ibm.com>

A module may not have an init part so set_page_attributes may try to
change an invalid page range. Modifying page 0 is fatal on s390. Bail
out in case the module_core or module_init is not present.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 kernel/module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1610,14 +1610,14 @@ static void set_section_ro_nx(void *base
 /* Setting memory back to W+X before releasing it */
 void unset_section_ro_nx(struct module *mod, void *module_region)
 {
-	if (mod->module_core == module_region) {
+	if (mod->module_core && mod->module_core == module_region) {
 		set_page_attributes(mod->module_core + mod->core_text_size,
 			mod->module_core + mod->core_size,
 			set_memory_x);
 		set_page_attributes(mod->module_core,
 			mod->module_core + mod->core_ro_size,
 			set_memory_rw);
-	} else if (mod->module_init == module_region) {
+	} else if (mod->module_init && mod->module_init == module_region) {
 		set_page_attributes(mod->module_init + mod->init_text_size,
 			mod->module_init + mod->init_size,
 			set_memory_x);
