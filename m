Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2LCXBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:01:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2LCXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:01:11 -0500
Date: Mon, 3 Dec 2012 15:01:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: protect against concurrent vma expansion
Message-Id: <20121203150110.39c204ff.akpm@linux-foundation.org>
In-Reply-To: <1354344987-28203-1-git-send-email-walken@google.com>
References: <1354344987-28203-1-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 22:56:27 -0800
Michel Lespinasse <walken@google.com> wrote:

> expand_stack() runs with a shared mmap_sem lock. Because of this, there
> could be multiple concurrent stack expansions in the same mm, which may
> cause problems in the vma gap update code.
> 
> I propose to solve this by taking the mm->page_table_lock around such vma
> expansions, in order to avoid the concurrency issue. We only have to worry
> about concurrent expand_stack() calls here, since we hold a shared mmap_sem
> lock and all vma modificaitons other than expand_stack() are done under
> an exclusive mmap_sem lock.
> 
> I previously tried to achieve the same effect by making sure all
> growable vmas in a given mm would share the same anon_vma, which we
> already lock here. However this turned out to be difficult - all of the
> schemes I tried for refcounting the growable anon_vma and clearing
> turned out ugly. So, I'm now proposing only the minimal fix.
> 

I think I don't understand the problem fully.  Let me demonstrate:

a) vma_lock_anon_vma() doesn't take a lock which is specific to
   "this" anon_vma.  It takes anon_vma->root->mutex.  That mutex is
   shared with vma->vm_next, yes?  If so, we have no problem here? 
   (which makes me suspect that the races lies other than where I think
   it lies).

b) I can see why a broader lock is needed in expand_upwards(): it
   plays with a different vma: vma->vm_next.  But expand_downwards()
   doesn't do that - it only alters "this" vma.  So I'd have thought
   that vma_lock_anon_vma("this" vma) would be sufficient.


What are the performance costs of this change?
