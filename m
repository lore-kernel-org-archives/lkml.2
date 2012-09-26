Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab2IZXVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:21:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2IZXVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:21:53 -0400
Date: Wed, 26 Sep 2012 16:21:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] binfmt_elf: Fix corner case kfree of
 uninitialized data
Message-Id: <20120926162151.ef9a552d.akpm@linux-foundation.org>
In-Reply-To: <20120919144410.16893.57933.stgit@localhost.localdomain>
References: <20120919144410.16893.57933.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012 15:44:35 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Could do with double checking...
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> If elf_core_dump is called and fill_note_info fails in the kmalloc then
> it returns 0 but has not yet initialised all the needed fields. As a result
> we do a kfree(randomness) after correctly skipping the thread data.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  fs/binfmt_elf.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 1b4efbc..bf6d82b 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1492,8 +1492,10 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  	info->thread = NULL;
>  
>  	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
> -	if (psinfo == NULL)
> +	if (psinfo == NULL) {
> +		info->psinfo.data = NULL;	/* So we don't free this wrongly */
>  		return 0;
> +        }
>  
>  	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);

afaict it's NotABug, because fill_note_info() does

	info->thread = NULL;

	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
	if (psinfo == NULL) {

and free_note_info() does

        struct elf_thread_core_info *threads = info->thread;
        while (threads) {

so free_note_info() won't enter the freeing loop at all.

Which is just as well, because info->thread_notes is uninitialised at
this time.


It all looks rather fragile - I'm wondering if it would be sanest to
memset `info' right at the outset in elf_core_dump(), then weed out all
the now-unneeded zeroizings in fill_note_info().


Also, how irritating is it that fill_note_info() has a local var
`psinfo' which has a different type from info->psinfo.  That had me
running around for a while...
