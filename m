Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412Ab2CABSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:18:15 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50647 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2CABSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:18:14 -0500
Date: Thu, 1 Mar 2012 10:18:11 +0900
From: Simon Horman <horms@verge.net.au>
To: Eugene Surovegin <surovegin@google.com>
Cc: linux-kernel@vger.kernel.org, kexec-list <kexec@lists.infradead.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
Message-ID: <20120301011811.GC16483@verge.net.au>
References: <1330536083-13098-1-git-send-email-surovegin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330536083-13098-1-git-send-email-surovegin@google.com>
Organisation: Horms Solutions Ltd.
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

Ouch. I'm surprised there is an allocation on crash, perhaps
it could at least be done earlier? And am I right in thinking
that this change increases the likely hood that the allocation
could fail?

> 
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
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
