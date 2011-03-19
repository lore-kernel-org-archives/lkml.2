Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1CSFfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 01:35:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1CSFe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 01:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wgIglYhC6P1nYPJF2yn+pxpBXuCwgvg69owLWsjBeT3iQfrj2V96xUTHDV7JzslNeI
         ws/LTpFwsqgH9h2wqiuw==
Date: Fri, 18 Mar 2011 22:34:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Robert Swiecki <robert@swiecki.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
In-Reply-To: <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1103182158200.18771@sister.anvils>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils> <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com> <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Robert Swiecki wrote:
> On Tue, Mar 1, 2011 at 12:35 AM, Robert Swiecki <robert@swiecki.net> wrote:
> 
> So, I compiled 2.6.38 and started fuzzing it. I'm bumping into other
> problems, and never seen anything about mremap in 2.6.38 (yet),

Thanks a lot for getting back to this, Robert, and thanks for the update.
I won't be celebrating, but this sounds like good news for my mremap patch.

> as it had been happening in 2.6.37-rc2. The output goes to
> http://alt.swiecki.net/linux_kernel/ - I'm still trying.

A problem in sys_mlock: I've Cc'ed Michel who is the current expert.

A problem in sys_munlock: Michel again, except vma_prio_tree_add is
implicated, and I used to be involved with that.  I've appended below
a debug patch which I wrote years ago, and have largely forgotten, but
Andrew keeps it around in mmotm: we might learn more if you add that
into your kernel build.

A problem in next_pidmap from find_ge_pid from ... proc_pid_readdir.
I did spend a while looking into that when you first reported it.
I'm pretty sure, from the register values, that it's a result of
a pid number (in some places signed int, in some places unsigned)
getting unexpectedly sign-extended to negative, so indexing before
the beginning of an array; but I never tracked down the root of the
problem, and failed to reproduce it with odd lseeks on the directory.

Ah, the one you report now comes from compat_sys_getdents,
whereas the original one came from compat_sys_old_readdir: okay,
I had been wondering whether it was peculiar to the old_readdir case,
but no, it's reproduced with getdents too.  Might be peculiar to compat.

Anyway, I've Cc'ed Eric who will be the best for that one.

And a couple of watchdog problems: I haven't even glanced at
those, hope someone else can suggest a good way forward on them.

Hugh

> 
> > Btw, the fuzzer is here: http://code.google.com/p/iknowthis/
> >
> > I think i was trying it with this revision:
> > http://code.google.com/p/iknowthis/source/detail?r=11 (i386 mode,
> > newest 'iknowthis' supports x86-64 natively), so feel free to try it.
> >
> > It used to crash the machine (it's BUG_ON but the system became
> > unusable) in matter of hours. Btw, when I was testing it for the last
> > time it Ooopsed much more frequently in proc_readdir (I sent report in
> > one of earliet e-mails).

From: Hugh Dickins <hughd@google.com>

Jayson Santos has sighted mm/prio_tree.c:78,79 BUGs (kernel bugzilla 8446),
and one was sighted a couple of years ago.  No reason yet to suppose
they're prio_tree bugs, but we can't tell much about them without seeing
the vmas.

So dump vma and the one it's supposed to resemble: I had expected to use
print_hex_dump(), but that's designed for u8 dumps, whereas almost every
field of vm_area_struct is either a pointer or an unsigned long - which
look nonsense dumped as u8s.

Replace the two BUG_ONs by a single WARN_ON; and if it fires, just keep
this vma out of the tree (truncation and swapout won't be able to find it).
 How safe this is depends on what the error really is; but we hold a file's
i_mmap_lock here, so it may be impossible to recover from BUG_ON.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Jayson Santos <jaysonsantos2003@yahoo.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/prio_tree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff -puN mm/prio_tree.c~prio_tree-debugging-patch mm/prio_tree.c
--- a/mm/prio_tree.c~prio_tree-debugging-patch
+++ a/mm/prio_tree.c
@@ -67,6 +67,20 @@
  * 	vma->shared.vm_set.head == NULL ==> a list node
  */
 
+static void dump_vma(struct vm_area_struct *vma)
+{
+	void **ptr = (void **) vma;
+	int i;
+
+	printk("vm_area_struct at %p:", ptr);
+	for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i++, ptr++) {
+		if (!(i & 3))
+			printk("\n");
+		printk(" %p", *ptr);
+	}
+	printk("\n");
+}
+
 /*
  * Add a new vma known to map the same set of pages as the old vma:
  * useful for fork's dup_mmap as well as vma_prio_tree_insert below.
@@ -74,14 +88,23 @@
  */
 void vma_prio_tree_add(struct vm_area_struct *vma, struct vm_area_struct *old)
 {
-	/* Leave these BUG_ONs till prio_tree patch stabilizes */
-	BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
-	BUG_ON(HEAP_INDEX(vma) != HEAP_INDEX(old));
-
 	vma->shared.vm_set.head = NULL;
 	vma->shared.vm_set.parent = NULL;
 
-	if (!old->shared.vm_set.parent)
+	if (WARN_ON(RADIX_INDEX(vma) != RADIX_INDEX(old) ||
+		    HEAP_INDEX(vma)  != HEAP_INDEX(old))) {
+		/*
+		 * This should never happen, yet it has been seen a few times:
+		 * we cannot say much about it without seeing the vma contents.
+		 */
+		dump_vma(vma);
+		dump_vma(old);
+		/*
+		 * Don't try to link this (corrupt?) vma into the (corrupt?)
+		 * prio_tree, but arrange for its removal to succeed later.
+		 */
+		INIT_LIST_HEAD(&vma->shared.vm_set.list);
+	} else if (!old->shared.vm_set.parent)
 		list_add(&vma->shared.vm_set.list,
 				&old->shared.vm_set.list);
 	else if (old->shared.vm_set.head)
