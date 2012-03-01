Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031286Ab2CAPKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:10:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031193Ab2CAPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:10:04 -0500
Date: Thu, 1 Mar 2012 10:09:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Eugene Surovegin <surovegin@google.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
Message-ID: <20120301150957.GA13533@redhat.com>
References: <1330536083-13098-1-git-send-email-surovegin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330536083-13098-1-git-send-email-surovegin@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 09:21:23AM -0800, Eugene Surovegin wrote:
> Per-CPU allocations are not guaranteed to be physically contiguous.
> However, kdump kernel and user-space code assumes that per-CPU
> memory, used for saving CPU registers on crash, is.
> This can cause corrupted /proc/vmcore in some cases - the main
> symptom being huge ELF note section.
> 
> Force page alignment for note_buf_t to ensure that this assumption holds.
> 

Hi Eugene,

Where do we make assumption that crash_notes address is page aligned?

In first kernel we save notes using virtual addresses as returned by
per_cpu_ptr(). So first kernel should be fine (crash_save_cpu()).

In second kernel, fs/proc/vmcore.c code does not seem to be assuming 
that notes are stored as page aligned address.

merge_note_headers_elf64()
  read_from_oldmem()
       offset = (unsigned long)(*ppos % PAGE_SIZE);
        pfn = (unsigned long)(*ppos / PAGE_SIZE);

We see to calculate pfn and offset inside the page. Map the pfn and then
access offset.

So as long as whole of the note section is stored on a single physical
page it is not a problem.

Are you referring to the fact that note could be stored on two different
physical pages and then kexec-tools does not know about the physical
address of second page, hence second kernel does not know about it
and we never read that data. That sounds like a problem.

So it make sense to force the page size alignment and if notes ever
grow beyond 1 page, we need to come up with more complex ways of
communicating more than 1 physical address to second kernel.

Thanks
Vivek


> Signed-off-by: Eugene Surovegin <surovegin@google.com>
> CC: Eric Biederman <ebiederm@xmission.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: kexec-list <kexec@lists.infradead.org>
> ---
>  kernel/kexec.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 7b08867..e641b5c 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1232,8 +1232,13 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
>  
>  static int __init crash_notes_memory_init(void)
>  {
> -	/* Allocate memory for saving cpu registers. */
> -	crash_notes = alloc_percpu(note_buf_t);
> +	/* Allocate memory for saving cpu registers.
> +	 * Force page alignment to avoid crossing physical page boundary -
> +	 * kexec-tools and kernel /proc/vmcore handler assume these per-CPU
> +	 * chunks are physically contiguous.
> +	 */
> +	crash_notes = (note_buf_t __percpu *)__alloc_percpu(sizeof(note_buf_t),
> +							    PAGE_SIZE);
>  	if (!crash_notes) {
>  		printk("Kexec: Memory allocation for saving cpu register"
>  		" states failed\n");
> -- 
> 1.7.9.1
