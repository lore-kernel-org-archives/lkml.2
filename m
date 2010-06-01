Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0FACkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:40:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61941 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0FACku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ebPR/Fle/Fug80m/JUEHpqvjagSvI7ETT4/t2RK7AEh+M/Zju0wQRLzeN0XJl2vkji
         4hbi4k1tf+DHn65UJ920CLfUzyHwAE92u2gPABPerJVcQmkZvJDXvudVuSQ0Efk3pPbV
         XRNNVlXLQASzwO2lCP8MY4yKUFj7z3VCZMKuA=
Date: Tue, 1 Jun 2010 10:44:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] Make the module 'usage' lists be two-way
Message-ID: <20100601024439.GA5134@cr0.nay.redhat.com>
References: <201005252300.07739.rjw@sisk.pl>
 <201005312130.17038.rusty@rustcorp.com.au>
 <201005312131.43238.rusty@rustcorp.com.au>
 <201005312132.28631.rusty@rustcorp.com.au>
 <20100531094834.c1a684d1.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
 <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org>
 <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 01:16:23PM -0700, Linus Torvalds wrote:
>
>From: Linus Torvalds <torvalds@linux-foundation.org>
>Date: Mon, 31 May 2010 12:19:37 -0700
>Subject: [PATCH 1/2] Make the module 'usage' lists be two-way
>
>When adding a module that depends on another one, we used to create a
>one-way list of "modules_which_use_me", so that module unloading could
>see who needs a module.
>
>It's actually quite simple to make that list go both ways: so that we
>not only can see "who uses me", but also see a list of modules that are
>"used by me".
>
>In fact, we always wanted that list in "module_unload_free()": when we
>unload a module, we want to also release all the other modules that are
>used by that module.  But because we didn't have that list, we used to
>first iterate over all modules, and then iterate over each "used by me"
>list of that module.
>
>By making the list two-way, we simplify module_unload_free(), and it
>allows for some trivial fixes later too.
>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Hi, Linus,

> 
> /* Clear the unload stuff of the module. */
> static void module_unload_free(struct module *mod)
> {
>-	struct module *i;
>+	struct module_use *use, *tmp;
> 
>-	list_for_each_entry(i, &modules, list) {
>-		struct module_use *use;
>-
>-		list_for_each_entry(use, &i->modules_which_use_me, list) {
>-			if (use->module_which_uses == mod) {
>-				DEBUGP("%s unusing %s\n", mod->name, i->name);
>-				module_put(i);
>-				list_del(&use->list);
>-				kfree(use);
>-				sysfs_remove_link(i->holders_dir, mod->name);
>-				/* There can be at most one match. */
>-				break;
>-			}
>-		}
>+	list_for_each_entry_safe(use, tmp, &mod->target_list, target_list) {
>+		struct module *i = use->target;
>+		DEBUGP("%s unusing %s\n", mod->name, i->name);
>+		module_put(i);
>+		list_del(&use->source_list);
>+		list_del(&use->target_list);
>+		kfree(use);
>+		sysfs_remove_link(i->holders_dir, mod->name);


I think it's nice to have a remove_module_usage() here, since we already
have add_module_usage().

Thanks.
