Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab2BHR5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:57:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56468 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2BHR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:56:59 -0500
Message-ID: <4F32B776.6070007@gmail.com>
Date: Wed, 08 Feb 2012 12:57:10 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND][PATCH] Mark thread stack correctly in proc/<pid>/maps
References: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk> <1326776095-2629-1-git-send-email-siddhesh.poyarekar@gmail.com> <CAAHN_R2g9zaujw30+zLf91AGDHNqE6HDc8Z4yJbrzgJcJYFkXg@mail.gmail.com> <4F2B02BC.8010308@gmail.com> <CAAHN_R0O7a+RX7BDfas3+vC+mnQpp0h3y4bBa1u4T-Jt=S9J_w@mail.gmail.com> <CAHGf_=qA6EFue2-mNUg9udWV4xSx86XQsnyGV07hfZOUx6_egw@mail.gmail.com> <CAAHN_R0+ExGcdpLM7KwC_KsPOemVOiRrmyWcowiu5_cWW3BPLQ@mail.gmail.com> <CAAHN_R0N=3J4=VqvDsGB=_2Ln9yKBjOevW2=_UAMBK1pGepqvA@mail.gmail.com>
In-Reply-To: <CAAHN_R0N=3J4=VqvDsGB=_2Ln9yKBjOevW2=_UAMBK1pGepqvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2/7/12 11:00 PM), Siddhesh Poyarekar wrote:
> On Sat, Feb 4, 2012 at 12:04 AM, Siddhesh Poyarekar
> <siddhesh.poyarekar@gmail.com>  wrote:
>> On Fri, Feb 3, 2012 at 1:31 PM, KOSAKI Motohiro
>> <kosaki.motohiro@gmail.com>  wrote:
>>> The fact is, now process stack and pthread stack clearly behave
>>> different dance. libc don't expect pthread stack grow automatically.
>>> So, your patch will break userland. Just only change display thing.
> <snip>
>> I have also dropped an email on the libc-alpha list here to solicit
>> comments from libc maintainers on this:
>>
>> http://sourceware.org/ml/libc-alpha/2012-02/msg00036.html
>>
>
> Kosaki-san, your suggestion of adding an extra flag seems like the
> right way to go about this based on the discussion on libc-alpha,
> specifically, your point about pthread_getattr_np() -- it may not be a
> standard, but it's a breakage anyway. However, looking at the vm_flags
> options in mm.h, it looks like the entire 32-bit space has been
> exhausted for the flag value. The vm_flags is an unsigned long, so it
> ought to take 8 bytes on a 64-bit system, but 32-bit systems will be
> left behind.
>
> So there are two options for this:
>
> 1) make vm_flags 64-bit for all arches. This will cause ABI breakage
> on 32-bit systems, so any external drivers will have to be rebuilt

Several month ago, Linus NAKed this way.


> 2) Implement this patch for 64-bit only by defining the new flag only
> for 64-bit. 32-bit systems behave as is

No. That's bad than status quo. Enduser may get inconsistent and bad user
experience.

Now, we are using some bit saving hack. example,

1) use ifdef

#ifndef CONFIG_TRANSPARENT_HUGEPAGE
#define VM_MAPPED_COPY 0x01000000      /* T if mapped copy of data (nommu mmap) */
#else
#define VM_HUGEPAGE    0x01000000      /* MADV_HUGEPAGE marked this vma */
#endif

2) use bit combination

#define VM_STACK_INCOMPLETE_SETUP      (VM_RAND_READ | VM_SEQ_READ)


Maybe you can take a similar way. And of course, you can ban some useless flag
bits.

thanks.

> Which of these would be better? I prefer the latter because it looks
> like the path of least breakage.
>

