Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab0I0OXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:23:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60666 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab0I0OXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:23:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
	<m1ocbl9z4z.fsf@fess.ebiederm.org>
	<AANLkTimozc_iWu6qFHS4CptwdLX7Fjv0owQzyh03hcqE@mail.gmail.com>
Date: Mon, 27 Sep 2010 07:23:08 -0700
In-Reply-To: <AANLkTimozc_iWu6qFHS4CptwdLX7Fjv0owQzyh03hcqE@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 27 Sep 2010 13:49:57 +0300")
Message-ID: <m1k4m7s1tf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pekka Enberg <penberg@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] mm: Introduce revoke_mappings.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@kernel.org> writes:

>> Subject: [PATCH 1/3] mm: Introduce revoke_mappings.
>>
>> When the backing store of a file becomes inaccessible we need a function
>> to remove that file from the page tables and arrange for page faults
>> to trigger SIGBUS.
>>
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
>> +static void revoke_vma(struct vm_area_struct *old)
>> +{
>> +	/* Atomically replace a vma with an identical one that returns
>> +	 * VM_FAULT_SIGBUS to every mmap request.
>> +	 *
>> +	 * This function must be called with the mm->mmap semaphore held.
>> +	 */
>> +	unsigned long start, end, len, pgoff, vm_flags;
>> +	struct vm_area_struct *new;
>> +	struct mm_struct *mm;
>> +	struct file *file;
>> +
>> +	file  = revoked_filp;
>> +	mm    = old->vm_mm;
>> +	start = old->vm_start;
>> +	end   = old->vm_end;
>> +	len   = end - start;
>> +	pgoff = old->vm_pgoff;
>> +
>> +	/* Preserve user visble vm_flags. */
>> +	vm_flags = VM_SHARED | VM_MAYSHARE | (old->vm_flags & REVOKED_VM_FLAGS);
>> +
>> +	/* If kmem_cache_zalloc fails return and ultimately try again */
>> +	new = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
>> +	if (!new)
>> +		goto out;
>> +
>> +	/* I am freeing exactly one vma so munmap should never fail.
>> +	 * If munmap fails return and ultimately try again.
>> +	 */
>> +	if (unlikely(do_munmap(mm, start, len)))
>> +		goto fail;
>> +
>> +	INIT_LIST_HEAD(&new->anon_vma_chain);
>> +	new->vm_mm    = mm;
>> +	new->vm_start = start;
>> +	new->vm_end   = end;
>> +	new->vm_flags = vm_flags;
>> +	new->vm_page_prot = vm_get_page_prot(vm_flags);
>> +	new->vm_pgoff = pgoff;
>> +	new->vm_file  = file;
>> +	get_file(file);
>> +	new->vm_ops   = &revoked_vm_ops;
>> +
>> +	/* Since the area was just umapped there is no excuse for
>> +	 * insert_vm_struct to fail.
>> +	 *
>> +	 * If insert_vm_struct fails we will cause a SIGSEGV instead
>> +	 * a SIGBUS.  A shame but not the end of the world.
>
> Can we simply fix up the old vma to avoid kmem_cache_zalloc() and
> insert_vm_struct altogether? We're protected by ->mmap_sem so that shouldn't be
> a problem?

So far this looks far more obvious, and easier to maintain than simply
reusing the vma.  Certainly I would want to factor out a
remove_vm_struct of or something similar if we go down that direction.

Simply reusing the vm struct requires being wise in the subtle and
twisted ways of the linux mm subsystem.  I tried that, and my patch
was sufficiently non-obvious that it was completely non-trivial to
review.

Using do_munmap and insert_vm_struct is a bit tedious but it is straight
forward.  Given how excessively complicated the mm is today with an
excess of flags, data structures and magic list order removals to
prevent truncate races it seems best to just avoid that mess as much as
possible.

>> +	 */
>> +	if (unlikely(insert_vm_struct(mm, new)))
>> +		goto fail;
>> +
>> +	mm->total_vm += len >> PAGE_SHIFT;
>> +
>> +	perf_event_mmap(new);
>> +
>> +	return;
>> +fail:
>> +	kmem_cache_free(vm_area_cachep, new);
>> +	WARN_ONCE(1, "%s failed\n", __func__);
>
> Why don't we just propagate errors such as -ENOMEM to the callers? It seems
> pointless to try to retry the operation at this level.

The two errors that come here are of the kind that should never happen.
That is do_munmap and insert_vm_struct with the arguments I am giving
can not fail today.  But since the routines have the potential to
return an error I am handling that, and screaming.

I am not currently propagating errors because what can be done with an
error?  The hardware that I am working on has just been removed.  I must
remove it's mappings.  About the only legitimate thing I could do with
an out of memory error here is to trigger the OOM killer.  Which is to
say while sys_revoke can use this mechanism.  My primary target is
hotplug removal of drivers.

>> +out:
>> +	return;
>> +}
>> +
>> +static bool revoke_mapping(struct address_space *mapping, struct mm_struct *mm,
>> +			   unsigned long addr)
>> +{
>> +	/* Returns true if the locks were dropped */
>> +	struct vm_area_struct *vma;
>> +
>> +	/*
>> +	 * Drop i_mmap_lock and grab the mm sempahore so I can call
>
> s/sempahore/semaphore/

Thanks.
>
>> +	 * revoke_vma.
>> +	 */
>> +	if (!atomic_inc_not_zero(&mm->mm_users))
>> +		return false;
>> +	spin_unlock(&mapping->i_mmap_lock);
>> +	down_write(&mm->mmap_sem);
>> +
>> +	/* There was a vma at mm, addr that needed to be revoked.
>> +	 * Look and see if there is still a vma there that needs
>> +	 * to be revoked.
>> +	 */
>> +	vma = find_vma(mm, addr);
>
> Why aren't we checking for NULL vma here? AFAICT, there's a tiny window between
> dropping ->i_mmap_lock and grabbing ->mmap_sem where the vma might have been
> unmapped.

Good catch.  I'm certain I checked for that in at least one version.
Brain fart.

>> +	if (vma->vm_file->f_mapping == mapping)
>> +		revoke_vma(vma);
>> +
>> +	up_write(&mm->mmap_sem);
>> +	mmput(mm);
>> +	spin_lock(&mapping->i_mmap_lock);
>> +	return true;
>> +}
>> +
>> +void revoke_mappings(struct address_space *mapping)
>> +{
>> +	/* Make any access to previously mapped pages trigger a SIGBUS,
>> +	 * and stop calling vm_ops methods.
>> +	 *
>> +	 * When revoke_mappings returns invocations of vm_ops->close
>> +	 * may still be in progress, but no invocations of any other
>> +	 * vm_ops methods will be.
>> +	 */
>> +	struct vm_area_struct *vma;
>> +	struct prio_tree_iter iter;
>> +
>> +	spin_lock(&mapping->i_mmap_lock);
>> +
>> +restart_tree:
>> +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
>> +		if (revoke_mapping(mapping, vma->vm_mm, vma->vm_start))
>> +			goto restart_tree;
>> +	}
>> +
>> +restart_list:
>> +	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
>> +		if (revoke_mapping(mapping, vma->vm_mm, vma->vm_start))
>> +			goto restart_list;
>> +	}
>> +
>
> What prevents a process from remapping the file after we've done revoking the
> vma prio tree? Shouldn't we always restart from the top?

Synchronization at the caller.  I am assuming that mmap is already
refusing to create new mappings when this code is called.  Throwing
away the mappings simply does not make sense if someone can be creating
more at the same time.

Look at where unmap_mapping_range is called in sysfs or in my most
recent uio patches.  That is where I expect to be calling
revoke_mappings when the dust clears.

I'm certain I had a comment to that effect once...

> Also, don't we need spin_needbreak() on ->i_mmap_lock and cond_resched()
> somewhere here like we do in mm/memory.c, for example?

Why?  Whenever we actually do something we drop the lock, and call
blocking operations so the lock hold times should be quite short.

>> +	spin_unlock(&mapping->i_mmap_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(revoke_mappings);
