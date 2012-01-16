Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2APRBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:01:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48775 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2APRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:01:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
References: <1326544511-6547-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120116112802.GB7180@jl-vm1.vm.bytemark.co.uk>
	<CAAHN_R1u_btMuF+WhHu0G895EJ=mbOPNRp7NcXEgTKv3Vs-B1A@mail.gmail.com>
	<20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
Date: Mon, 16 Jan 2012 22:31:40 +0530
Message-ID: <CAAHN_R2TYtFrOJaQB40Y3FyApzKmJ0GCcO8pA_CZ=mdH21AgWA@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:01 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Aesthetically I think if the main process stack has "[stack guard]",
> it makes sense for the thread stack guards to be labelled the same.

Right, I'll mark both stack guards alike.

> One more technical thing: Now that you're using VM_STACK to change the
> text, why not set that flag for the process stack vma as well, when
> the stack is set up by exec, and get rid of the special case for
> process stack in printing?

I think the flag is already set:

static int __bprm_mm_init(struct linux_binprm *bprm)
{
...
        /*
         * Place the stack at the largest stack address the architecture
         * supports. Later, we'll move this to an appropriate place. We don't
         * use STACK_TOP because that can depend on attributes which aren't
         * configured yet.
         */
        BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
        vma->vm_end = STACK_TOP_MAX;
        vma->vm_start = vma->vm_end - PAGE_SIZE;
        vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
        vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
        INIT_LIST_HEAD(&vma->anon_vma_chain);
...
}

The only special case in the printing code for the process stack is
the skipping of the guard page. I'll modify that to mark and display
the stack guard instead.

I'll post an updated patch with these changes.

Thanks!

-- 
Siddhesh Poyarekar
