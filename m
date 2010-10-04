Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0JDWn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:43:59 -0400
Received: from www.tglx.de ([62.245.132.106]:40289 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab0JDWn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:43:58 -0400
Date: Tue, 5 Oct 2010 00:43:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
In-Reply-To: <201010041300.15234.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6> <201010041300.15234.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Arnd Bergmann wrote:

> On Sunday 03 October 2010, Thomas Gleixner wrote:
> > Current mainline triggers a list corruption bug in
> > module_bug_finalize(). dmesg excerpt below.
> > 
> > The corresponding code says:
> > 
> >         /*
> >          * Strictly speaking this should have a spinlock to protect against
> >          * traversals, but since we only traverse on BUG()s, a spinlock
> >          * could potentially lead to deadlock and thus be counter-productive.
> >          */
> >         list_add(&mod->bug_list, &module_bug_list);
> > 
> > I can see the traversal problem vs. BUG(), but what's protecting the
> > list_add() ? BKL probably did, but is that true anymore ?
> 
> BKL hasn't been in this code path since before git.

Fair enough. I have to admit that I did not even look. :)
 
> I think this relatively recent change caused module_finalize to be
> called without module_mutex held:

Yeah.

> commit 75676500f8298f0ee89db12db97294883c4b768e
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Sat Jun 5 11:17:36 2010 -0600
> 
>     module: make locking more fine-grained.
>     
>     Kay Sievers <kay.sievers@vrfy.org> reports that we still have some
>     contention over module loading which is slowing boot.
>     
>     Linus also disliked a previous "drop lock and regrab" patch to fix the
>     bne2 "gave up waiting for init of module libcrc32c" message.
>     
>     This is more ambitious: we only grab the lock where we need it.
>     
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>     Cc: Brandon Philips <brandon@ifup.org>
>     Cc: Kay Sievers <kay.sievers@vrfy.org>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 	Arnd

The patch below cures it.

Thanks,

	tglx

---->
diff --git a/lib/bug.c b/lib/bug.c
index 7cdfad8..40f32d8 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -92,18 +92,21 @@ int module_bug_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
 	}
 
 	/*
-	 * Strictly speaking this should have a spinlock to protect against
-	 * traversals, but since we only traverse on BUG()s, a spinlock
-	 * could potentially lead to deadlock and thus be counter-productive.
+	 * We need to take module_mutex here to protect the list add, though
+	 * it won't protect against a concurrent BUG().
 	 */
+	mutex_lock(&module_mutex);
 	list_add(&mod->bug_list, &module_bug_list);
+	mutex_unlock(&module_mutex);
 
 	return 0;
 }
 
 void module_bug_cleanup(struct module *mod)
 {
+	mutex_lock(&module_mutex);
 	list_del(&mod->bug_list);
+	mutex_unlock(&module_mutex);
 }
 
 #else
