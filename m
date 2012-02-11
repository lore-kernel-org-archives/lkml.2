Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2BKKTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 05:19:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38838 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2BKKTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 05:19:02 -0500
MIME-Version: 1.0
In-Reply-To: <4F32B776.6070007@gmail.com>
References: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
	<1326776095-2629-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<CAAHN_R2g9zaujw30+zLf91AGDHNqE6HDc8Z4yJbrzgJcJYFkXg@mail.gmail.com>
	<4F2B02BC.8010308@gmail.com>
	<CAAHN_R0O7a+RX7BDfas3+vC+mnQpp0h3y4bBa1u4T-Jt=S9J_w@mail.gmail.com>
	<CAHGf_=qA6EFue2-mNUg9udWV4xSx86XQsnyGV07hfZOUx6_egw@mail.gmail.com>
	<CAAHN_R0+ExGcdpLM7KwC_KsPOemVOiRrmyWcowiu5_cWW3BPLQ@mail.gmail.com>
	<CAAHN_R0N=3J4=VqvDsGB=_2Ln9yKBjOevW2=_UAMBK1pGepqvA@mail.gmail.com>
	<4F32B776.6070007@gmail.com>
Date: Sat, 11 Feb 2012 15:49:01 +0530
Message-ID: <CAAHN_R1=87w+NFXPA5MGER8wLR4LwOv-2_eG-d+Fe=+j08FKYQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 11:27 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> Now, we are using some bit saving hack. example,
>
> 1) use ifdef
>
> #ifndef CONFIG_TRANSPARENT_HUGEPAGE
> #define VM_MAPPED_COPY 0x01000000      /* T if mapped copy of data (nommu
> mmap) */
> #else
> #define VM_HUGEPAGE    0x01000000      /* MADV_HUGEPAGE marked this vma */
> #endif
>
> 2) use bit combination
>
> #define VM_STACK_INCOMPLETE_SETUP      (VM_RAND_READ | VM_SEQ_READ)
>
>
> Maybe you can take a similar way. And of course, you can ban some useless
> flag
> bits.

I found the thread in which Linus rejected the idea of expanding vm_flags:

https://lkml.org/lkml/2011/11/10/522

and based on that, I don't think I can justify the need for a new flag
for this patch since it is purely for display purposes and has nothing
to do with the actual treatment of the vma. So I figured out another
way to identify a thread stack without changing the way the vma
properties (I should have done this in the first place I think) which
is by checking if the vma contains the stack pointer of the task.

With this change:

/proc/pid/task/tid/maps: will only mark the stack that the task uses

/proc/pid/maps: will mark all stacks. This path will be slower since
it will iterate through the entire thread group for each vma.

I'll test this and attach a new version of the patch.

Regards,
Siddhesh

-- 
Siddhesh Poyarekar
http://siddhesh.in
