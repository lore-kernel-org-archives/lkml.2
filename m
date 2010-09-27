Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab0I0Kt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:49:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42039 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab0I0Kt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cJVh+r3WfK3Q0UAfmDR67ED5f2p82VORpAbwiF0RAYXxJRfIX19J0MF/IjllHBp+16
         4PXdX3Ydl+ggSrc7HzD9Eyo0j8owvL0xjVv3LtF7L+5QgPZu7m3YTU62aBBmIWZr3t2a
         Oxme0KbMD7khmcNjyblOUAJgAsMv/y3Zj8MtQ=
MIME-Version: 1.0
In-Reply-To: <m1ocbl9z4z.fsf@fess.ebiederm.org>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
	<m1ocbl9z4z.fsf@fess.ebiederm.org>
Date: Mon, 27 Sep 2010 13:49:57 +0300
X-Google-Sender-Auth: cg3QIDpM40TDxuXPk0iJvjAm6W8
Message-ID: <AANLkTimozc_iWu6qFHS4CptwdLX7Fjv0owQzyh03hcqE@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: Introduce revoke_mappings.
From: Pekka Enberg <penberg@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH 1/3] mm: Introduce revoke_mappings.
>
> When the backing store of a file becomes inaccessible we need a function
> to remove that file from the page tables and arrange for page faults
> to trigger SIGBUS.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

> +static void revoke_vma(struct vm_area_struct *old)
> +{
> +	/* Atomically replace a vma with an identical one that returns
> +	 * VM_FAULT_SIGBUS to every mmap request.
> +	 *
> +	 * This function must be called with the mm->mmap semaphore held.
> +	 */
> +	unsigned long start, end, len, pgoff, vm_flags;
> +	struct vm_area_struct *new;
> +	struct mm_struct *mm;
> +	struct file *file;
> +
> +	file  = revoked_filp;
> +	mm    = old->vm_mm;
> +	start = old->vm_start;
> +	end   = old->vm_end;
> +	len   = end - start;
> +	pgoff = old->vm_pgoff;
> +
> +	/* Preserve user visble vm_flags. */
> +	vm_flags = VM_SHARED | VM_MAYSHARE | (old->vm_flags & REVOKED_VM_FLAGS);
> +
> +	/* If kmem_cache_zalloc fails return and ultimately try again */
> +	new = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
> +	if (!new)
> +		goto out;
> +
> +	/* I am freeing exactly one vma so munmap should never fail.
> +	 * If munmap fails return and ultimately try again.
> +	 */
> +	if (unlikely(do_munmap(mm, start, len)))
> +		goto fail;
> +
> +	INIT_LIST_HEAD(&new->anon_vma_chain);
> +	new->vm_mm    = mm;
> +	new->vm_start = start;
> +	new->vm_end   = end;
> +	new->vm_flags = vm_flags;
> +	new->vm_page_prot = vm_get_page_prot(vm_flags);
> +	new->vm_pgoff = pgoff;
> +	new->vm_file  = file;
> +	get_file(file);
> +	new->vm_ops   = &revoked_vm_ops;
> +
> +	/* Since the area was just umapped there is no excuse for
> +	 * insert_vm_struct to fail.
> +	 *
> +	 * If insert_vm_struct fails we will cause a SIGSEGV instead
> +	 * a SIGBUS.  A shame but not the end of the world.

Can we simply fix up the old vma to avoid kmem_cache_zalloc() and
insert_vm_struct altogether? We're protected by ->mmap_sem so that shouldn't be
a problem?

> +	 */
> +	if (unlikely(insert_vm_struct(mm, new)))
> +		goto fail;
> +
> +	mm->total_vm += len >> PAGE_SHIFT;
> +
> +	perf_event_mmap(new);
> +
> +	return;
> +fail:
> +	kmem_cache_free(vm_area_cachep, new);
> +	WARN_ONCE(1, "%s failed\n", __func__);

Why don't we just propagate errors such as -ENOMEM to the callers? It seems
pointless to try to retry the operation at this level.

> +out:
> +	return;
> +}
> +
> +static bool revoke_mapping(struct address_space *mapping, struct mm_struct *mm,
> +			   unsigned long addr)
> +{
> +	/* Returns true if the locks were dropped */
> +	struct vm_area_struct *vma;
> +
> +	/*
> +	 * Drop i_mmap_lock and grab the mm sempahore so I can call

s/sempahore/semaphore/

> +	 * revoke_vma.
> +	 */
> +	if (!atomic_inc_not_zero(&mm->mm_users))
> +		return false;
> +	spin_unlock(&mapping->i_mmap_lock);
> +	down_write(&mm->mmap_sem);
> +
> +	/* There was a vma at mm, addr that needed to be revoked.
> +	 * Look and see if there is still a vma there that needs
> +	 * to be revoked.
> +	 */
> +	vma = find_vma(mm, addr);

Why aren't we checking for NULL vma here? AFAICT, there's a tiny window between
dropping ->i_mmap_lock and grabbing ->mmap_sem where the vma might have been
unmapped.

> +	if (vma->vm_file->f_mapping == mapping)
> +		revoke_vma(vma);
> +
> +	up_write(&mm->mmap_sem);
> +	mmput(mm);
> +	spin_lock(&mapping->i_mmap_lock);
> +	return true;
> +}
> +
> +void revoke_mappings(struct address_space *mapping)
> +{
> +	/* Make any access to previously mapped pages trigger a SIGBUS,
> +	 * and stop calling vm_ops methods.
> +	 *
> +	 * When revoke_mappings returns invocations of vm_ops->close
> +	 * may still be in progress, but no invocations of any other
> +	 * vm_ops methods will be.
> +	 */
> +	struct vm_area_struct *vma;
> +	struct prio_tree_iter iter;
> +
> +	spin_lock(&mapping->i_mmap_lock);
> +
> +restart_tree:
> +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
> +		if (revoke_mapping(mapping, vma->vm_mm, vma->vm_start))
> +			goto restart_tree;
> +	}
> +
> +restart_list:
> +	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
> +		if (revoke_mapping(mapping, vma->vm_mm, vma->vm_start))
> +			goto restart_list;
> +	}
> +

What prevents a process from remapping the file after we've done revoking the
vma prio tree? Shouldn't we always restart from the top?

Also, don't we need spin_needbreak() on ->i_mmap_lock and cond_resched()
somewhere here like we do in mm/memory.c, for example?

> +	spin_unlock(&mapping->i_mmap_lock);
> +}
> +EXPORT_SYMBOL_GPL(revoke_mappings);
