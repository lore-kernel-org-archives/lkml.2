Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1C2Wfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:35:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683Ab1C2Wfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:35:30 -0400
Date: Tue, 29 Mar 2011 15:35:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: avoid unnecessary anon_vma lock
Message-Id: <20110329153517.3b87842f.akpm@linux-foundation.org>
In-Reply-To: <m2fwq718u4.fsf@firstfloor.org>
References: <1301277532.3981.25.camel@sli10-conroe>
	<m2fwq718u4.fsf@firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 09:57:39 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Shaohua Li <shaohua.li@intel.com> writes:
> 
> > If we only change vma->vm_end, we can avoid taking anon_vma lock even 'insert'
> > isn't NULL, which is the case of split_vma.
> > From my understanding, we need the lock before because rmap must get the
> > 'insert' VMA when we adjust old VMA's vm_end (the 'insert' VMA is linked to
> > anon_vma list in __insert_vm_struct before).
> > But now this isn't true any more. The 'insert' VMA is already linked to
> > anon_vma list in __split_vma(with anon_vma_clone()) instead of
> > __insert_vm_struct. There is no race rmap can't get required VMAs.
> > So the anon_vma lock is unnecessary, and this can reduce one locking in brk
> > case and improve scalability.
> 
> Looks good to me.

Looks way too tricky to me.

Please review this code for maintainability.  Have we documented what
we're doing as completely and as clearly as we are able?

This comment:

		/*
		 * split_vma has split insert from vma, and needs
		 * us to insert it before dropping the locks
		 * (it may either follow vma or precede it).
		 */

is now at least misleading.  It doesn't explain which "locks" it means,
and with this patch we only drop a single lock.


And this comment:

	/*
	 * When changing only vma->vm_end, we don't really need anon_vma
	 * lock. This is a fairly rare case by itself, but the anon_vma
	 * lock may be shared between many sibling processes.  Skipping
	 * the lock for brk adjustments makes a difference sometimes.
	 */

fails to explain _why_ the anon_vma lock isn't needed in this case, and
didn't tell readers why it is safe to alter vma->vm_pgoff without
anon_vma_lock().
