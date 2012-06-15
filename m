Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2FOMhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:37:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35022 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2FOMhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:37:19 -0400
Date: Fri, 15 Jun 2012 18:03:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH v2 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
Message-ID: <20120615123300.GA5748@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120608093257.GG13409@in.ibm.com>
 <20120611161215.GA12116@redhat.com>
 <20120612165404.GB30555@linux.vnet.ibm.com>
 <20120612174305.GA16349@redhat.com>
 <20120613191519.GA14246@redhat.com>
 <20120614114514.GA12051@linux.vnet.ibm.com>
 <20120614181934.GA9424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120614181934.GA9424@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061512-5930-0000-0000-000008E0F5D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Lets say we do find a 32 bit app and 64 bit app using the same library
> > and the underlying instruction is valid for tracing in 64 bit and not 32
> > bit. So when we are registering, and failed to insert a breakpoint  for
> > the 32 bit app, should we just bail out or should we return a failure?
> 
> I do not really know, I tend to think we should not fail. But this is
> another story...
> 
> Look. Suppose that a 32-bit app starts after uprobe_register() succeeds.
> In this case we have no option, uprobe_mmap()->install_breakpoint()
> should "silently" fail. Currently it doesn't, this is one of the reasons
> why I think the validation logic is wrong.
> 
> And. if install_breakpoint() can fail later anyway (in this case), then
> I think uprobe_register() should not fail.
> 
> But probably this needs more discussion.
> 
> 
> > I would probably prefer to read the underlying file something similar to
> > what exec does and based on the magic decipher if we should verify for
> > 32 bit instructions or 64 bit instructions.
> 
> But this can't protect from the malicious user who does
> mmap(64-bit-code, PROT_EXEC) from a 32-bit app, and this can confuse
> uprobes even if that 32-bit app never tries to actually execute that
> 64-bit-code.
> 

So if we read just after we allocate uprobe struct but before
probe insertion, then we dont need to check this for each process.

So if the library was 64 bit mapped in 32 bit process and has a valid
instruction for 64 bit, then we just check for valid 64 bit instructions
and allow insertion of the breakpoint even in the 32 bit process.

So in this case, the behaviour of such processes would be similar with
or without breakpoints.

> That is why I think we need the additional (and arch-dependant) check
> before every set_swbp(), but arch_uprobe_analyze_insn/etc should not
> depend on task/mm/vaddr/whatever.
> 

Here is a very crude implementation of the same. 
Also this depends on read_mapping_page taking NULL as an valid argument
for file. As a side-effect we can do away with UPROBE_COPY_INSN which 
was set and read at just one place.

1. Move the copy_insn to just after alloc_uprobe.
2. Assume that copy_insn can work without struct file
3. Read the elfhdr for the file.
4. Pass the elfhdr to the arch specific analyze insn
5. Move the analyze instruction to before the actual probe insertion.

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 94c46af..41effbc 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
+#include <linux/elf.h>
 
 #include <linux/uprobes.h>
 
@@ -578,16 +579,14 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 }
 
 static int
-__copy_insn(struct address_space *mapping, struct file *filp, char *insn,
-			unsigned long nbytes, loff_t offset)
+__copy_insn(struct address_space *mapping, char *insn, unsigned long nbytes,
+			loff_t offset)
 {
 	struct page *page;
 	void *vaddr;
 	unsigned long off;
 	pgoff_t idx;
 
-	if (!filp)
-		return -EINVAL;
 	if (!mapping->a_ops->readpage)
 		return -EIO;
 
@@ -598,7 +597,7 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 	 * Ensure that the page that has the original instruction is
 	 * populated and in page-cache.
 	 */
-	page = read_mapping_page(mapping, idx, filp);
+	page = read_mapping_page(mapping, idx, NULL);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
@@ -610,7 +609,7 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 	return 0;
 }
 
-static int copy_insn(struct uprobe *uprobe, struct file *filp)
+static int copy_insn(struct uprobe *uprobe)
 {
 	struct address_space *mapping;
 	unsigned long nbytes;
@@ -627,13 +626,13 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
 
 	/* Instruction at the page-boundary; copy bytes in second page */
 	if (nbytes < bytes) {
-		int err = __copy_insn(mapping, filp, uprobe->arch.insn + nbytes,
+		int err = __copy_insn(mapping, uprobe->arch.insn + nbytes,
 				bytes - nbytes, uprobe->offset + nbytes);
 		if (err)
 			return err;
 		bytes = nbytes;
 	}
-	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
+	return __copy_insn(mapping, uprobe->arch.insn, bytes, uprobe->offset);
 }
 
 /*
@@ -675,25 +674,6 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	if (!uprobe->consumers)
 		return -EEXIST;
 
-	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
-		ret = copy_insn(uprobe, vma->vm_file);
-		if (ret)
-			return ret;
-
-		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
-			return -ENOTSUPP;
-
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
-		if (ret)
-			return ret;
-
-		/* write_opcode() assumes we don't cross page boundary */
-		BUG_ON((uprobe->offset & ~PAGE_MASK) +
-				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
-
-		uprobe->flags |= UPROBE_COPY_INSN;
-	}
-
 	/*
 	 * Ideally, should be updating the probe count after the breakpoint
 	 * has been successfully inserted. However a thread could hit the
@@ -897,6 +877,7 @@ static void __uprobe_unregister(struct uprobe *uprobe)
  */
 int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
 {
+	struct elfhdr elf_ex;
 	struct uprobe *uprobe;
 	int ret;
 
@@ -906,10 +887,29 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (offset > i_size_read(inode))
 		return -EINVAL;
 
-	ret = 0;
+	if ((offset & ~PAGE_MASK) + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE)
+		return -EINVAL;
+
 	mutex_lock(uprobes_hash(inode));
 	uprobe = alloc_uprobe(inode, offset);
 
+	ret = copy_insn(uprobe);
+	if (ret)
+		goto out;
+
+	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn)) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	ret = __copy_insn(uprobe->inode->i_mapping, &elf_ex, sizeof(elf_ex), 0);
+	if (ret)
+		goto out;
+
+	ret = arch_uprobe_analyze_insn(&uprobe->arch, uprobe->offset, &elf_ex);
+	if (ret)
+		goto out;
+
 	if (uprobe && !consumer_add(uprobe, uc)) {
 		ret = __uprobe_register(uprobe);
 		if (ret) {
@@ -920,6 +920,7 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 		}
 	}
 
+out:
 	mutex_unlock(uprobes_hash(inode));
 	put_uprobe(uprobe);
 

