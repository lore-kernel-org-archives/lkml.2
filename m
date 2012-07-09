Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2GIIab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:30:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57725 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2GIIa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:30:29 -0400
Message-ID: <1341822602.3462.15.camel@twins>
Subject: Re: [PATCH 2/5] uprobes: suppress uprobe_munmap() from mmput()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 10:30:02 +0200
In-Reply-To: <20120708203003.GA18226@redhat.com>
References: <20120708203003.GA18226@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 22:30 +0200, Oleg Nesterov wrote:
> uprobe_munmap() does get_user_pages() and it is also called from
> the final mmput()->exit_mmap() path. This slows down exit/mmput()
> for no reason, and I think  it is simply dangerous/wrong to try to
> fault-in a page into the dying mm. If nothing else, this happens
> after the last sync_mm_rss(), afaics handle_mm_fault() can change
> the task->rss_stat and make the subsequent check_mm() unhappy.
> 
> Change uprobe_munmap() to check mm->mm_users != 0.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index a93b6df..47c4e24 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1082,6 +1082,9 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
>  	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
>  		return;
>  
> +	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
> +		return;
> +
>  	if (!atomic_read(&vma->vm_mm->uprobes_state.count))
>  		return;
>  

But won't you leak uprobe refcounts like this? Those aren't tied to the
task (which is dying) but to the vma's mapping the appropriate hunk of
the text. Not doing the munmap will then not put the uprobe->ref..

Or am I missing something here?
