Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab2JXUgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:36:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935551Ab2JXUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:36:53 -0400
Date: Wed, 24 Oct 2012 13:36:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -mm] procfs: add VmFlags field in smaps output v3
Message-Id: <20121024133652.39ede022.akpm@linux-foundation.org>
In-Reply-To: <20121024122730.GO30983@moon>
References: <20121024122730.GO30983@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 16:27:30 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> During c/r sessions we've found that there is no way at the moment to
> fetch some VMA associated flags, such as mlock() and madvise().
> 
> This leads us to a problem -- we don't know if we should call for mlock()
> and/or madvise() after restore on the vma area we're bringing back to
> life.
> 
> This patch intorduces a new field into "smaps" output called VmFlags,
> where all set flags associated with the particular VMA is shown as two
> letter mnemonics.
> 
> [ Strictly speaking for c/r we only need mlock/madvise bits but it has been
>   said that providing just a few flags looks somehow inconsistent.  So all
>   flags are here now. ]
> 
> This feature is made available on CONFIG_CHECKPOINT_RESTORE=n kernels, as
> other applications may start to use these fields.
> 
> The data is encoded in a somewhat awkward two letters mnemonic form, to
> encourage userspace to be prepared for fields being added or removed in
> the future.
> 
> ...
>
> +	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {

for_each_set_bit() seems to be rather sucky.  Going back to 

--- a/fs/proc/task_mmu.c~a-fix
+++ a/fs/proc/task_mmu.c
@@ -568,10 +568,11 @@ static void show_smap_vma_flags(struct s
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
-	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {
-		seq_printf(m, "%c%c ",
-			   mnemonics[i][0],
-			   mnemonics[i][1]);
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		if (vma->vm_flags & (1UL << i)) {
+			seq_printf(m, "%c%c ",
+				   mnemonics[i][0], mnemonics[i][1]);
+		}
 	}
 	seq_putc(m, '\n');
 }

saves 41 bytes.  That's rather a lot for such a small code sequence.
