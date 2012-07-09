Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2GIKlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:41:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2GIKlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:41:49 -0400
Date: Mon, 9 Jul 2012 12:39:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes: kill copy_vma()->uprobe_mmap()
Message-ID: <20120709103903.GB21163@redhat.com>
References: <20120708203008.GA18236@redhat.com> <1341822957.3462.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341822957.3462.18.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09, Peter Zijlstra wrote:
>
> On Sun, 2012-07-08 at 22:30 +0200, Oleg Nesterov wrote:
> > And why this uprobe_mmap() was added? I believe the intent was wrong.
> > Note that the caller is going to do move_page_tables(), all registered
> > uprobes are already faulted in, we only change the virtual addresses.
>
> I think it was because of the copy_vma + do_munmap. Since do_munmap()
> should be doing a put on the uprobe, we need an extra get to balance.

No, please see the previous email, mmap doesn't increment uprobe->ref.

But this doesn't matter. Even if it did, the new vma will not add the
new uprobes, we are going to change the virtual address of the already
existing mapping.

As for mm->uprobes_state.count, move_vma()->do_munmap(old_addr, old_len)
won't change it afaics, is_swbp_at_addr() can't be true after
move_page_tables()->ptep_get_and_clear(old_addr), the page with "int3"
was already moved.

Anyway, this uprobe_mmap() always fails. And we need more fixes, I hope
to send more patches soon.

> That said, I cannot actually find the uprobe_munmap() from do_munmap(),
> but that might be due to lack of wakefulness etc..

do_munmap()->unmap_region()->unmap_vmas()->unmap_single_vma()

Yes, I can't keep in mind this path too ;)

Oleg.

