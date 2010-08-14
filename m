Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0HNSsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 14:48:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354Ab0HNSsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 14:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <201008141427.03946.edt@aei.ca>
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
 <AANLkTikNTZSqZ-sa0uGY0FnjDnOziu4qR8fEitD2TPQc@mail.gmail.com>
 <AANLkTi=TNsb_JaP0_us8C0XQwRK3qaUdviA-YxcwT223@mail.gmail.com> <201008141427.03946.edt@aei.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Aug 2010 11:47:45 -0700
Message-ID: <AANLkTingwMvoVm_J6cmm_K3=G9rCYwOrQ=-5vK_wzGcX@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
To: Ed Tomlinson <edt@aei.ca>
Cc: sedat.dilek@gmail.com, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, penberg@kernel.org, arthur@psw.ro,
        wylda@volny.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 11:27 AM, Ed Tomlinson <edt@aei.ca> wrote:
>
> It seems to be helping here.  Without it 35.2 would either stall in boot or give lots of tracebacks.  With it things
> start normally and my background stuff works as expected.

Ok, thanks. I've committed it to the -git tree.

Just to verify: you have CONFIG_HIGHPTE enabled on a x86-32 kernel,
right? I'd have expected this to not ever show up anywhere else, and
I'm just verifying that there isn't anything else going on. I'm
appending the commit message, the patch hasn't changed.

                            Linus
---

Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Aug 14 11:44:56 2010 -0700

    mm: fix page table unmap for stack guard page properly

    We do in fact need to unmap the page table _before_ doing the whole
    stack guard page logic, because if it is needed (mainly 32-bit x86 with
    PAE and CONFIG_HIGHPTE, but other architectures may use it too) then it
    will do a kmap_atomic/kunmap_atomic.

    And those kmaps will create an atomic region that we cannot do
    allocations in.  However, the whole stack expand code will need to do
    anon_vma_prepare() and vma_lock_anon_vma() and they cannot do that in an
    atomic region.

    Now, a better model might actually be to do the anon_vma_prepare() when
    _creating_ a VM_GROWSDOWN segment, and not have to worry about any of
    this at page fault time.  But in the meantime, this is the
    straightforward fix for the issue.

    See https://bugzilla.kernel.org/show_bug.cgi?id=16588 for details.

    Reported-by: Wylda <wylda@volny.cz>
    Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
    Reported-by: Mike Pagano <mpagano@gentoo.org>
    Reported-by: François Valenduc <francois.valenduc@tvcablenet.be>
    Tested-by: Ed Tomlinson <edt@aei.ca>
    Cc: Pekka Enberg <penberg@kernel.org>
    Cc: Greg KH <gregkh@suse.de>
    Cc: stable@kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

 mm/memory.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)
