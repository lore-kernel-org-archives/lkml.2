Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0LARKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:10:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0LARKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:10:18 -0500
Message-ID: <4CF68174.10301@petalogix.com>
Date: Wed, 01 Dec 2010 18:10:12 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        John Williams <john.williams@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Flushing whole page instead of work for ptrace
References: <4CEFA8AE.2090804@petalogix.com> <20101130233250.35603401C8@magilla.sf.frob.com>
In-Reply-To: <20101130233250.35603401C8@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> This is a VM question more than a ptrace question.  
> I can't give you any authoritative answers about the VM issues.
> 
> Documentation/cachetlb.txt says:
> 
> 	Any time the kernel writes to a page cache page, _OR_
> 	the kernel is about to read from a page cache page and
> 	user space shared/writable mappings of this page potentially
> 	exist, this routine is called.
> 
> In your case, the kernel is only reading (write=0 passed to
> access_process_vm and get_user_pages).  In normal situations,
> the page in question will have only a private and read-only
> mapping in user space.  So the call should not be required in
> these cases--if the code can tell that's so.
> 
> Perhaps something like the following would be safe.
> But you really need some VM folks to tell you for sure.
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 02e48aa..2864ee7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1484,7 +1484,8 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  				pages[i] = page;
>  
>  				flush_anon_page(vma, page, start);
> -				flush_dcache_page(page);
> +				if ((vm_flags & VM_WRITE) || (vma->vm_flags & VM_SHARED)
> +					flush_dcache_page(page);
>  			}
>  			if (vmas)
>  				vmas[i] = vma;
> 
> 
> Thanks,
> Roland

Andrew any comment?

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
