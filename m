Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1K3SKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:10:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54192 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1K3SKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:10:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111130173739.GI14515@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.912537377@openvz.org>
	<20111129201938.GP5169@outflux.net>
	<20111129202951.GG1775@moon>
	<20111129203714.GH1775@moon>
	<CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
	<20111130173739.GI14515@moon>
Date: Wed, 30 Nov 2011 10:10:35 -0800
X-Google-Sender-Auth: rVemrdF-HDfgkstfkNtiKVA_6hA
Message-ID: <CAGXu5jL=46_MyxrrB8G4FntnLJBtt+DbvVX0kEXh9n8Ss+Yfsw@mail.gmail.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 9:37 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Nov 29, 2011 at 12:40:57PM -0800, Kees Cook wrote:
>> >
>> > On the other hands these fields are set up by elf hanlder code, which
>> > does mmap these areas, so we have to check that particular member
>> > belongs to existing VMA and never cross user-space area, and together
>> > with root-only approach would not it be enough? I'm sure missing something
>> > that is why I'm asking.
>>
>> Right, if you verify that the addresses are actually inside valid
>> userspace vmas, that is likely to be right, though there are probably
>> other things I haven't thought of. The trouble is avoiding vdso, stack
>> guard page, vsyscall, and anything else that isn't meant for the mm to
>> have direct access to.
>>
>
> Hi Kees,
>
> what about this one? Note that these mm_struct members don't affect
> kernel much (at least as far as I see, except maybe brk,start_brk and
> start_stack values), so I've added some sanity checks here, hope they
> would fit. Still main protection is root-only access only. The kernel
> itself uses vma_area::start/end members for overlows tests internally
> so I think even passing crazy data here won't crash the kernel itself.

Right, though besides just crashing the kernel, I'm trying to look at
this from the perspective of a paranoid admin that doesn't even trust
the root user. Is there some way this new interface could be used to
provide the building blocks for gaining kernel execute control?
(Imagine a system running with modules disabled, STRICT_DEVMEM
enabled, etc.)

> What do you think?

This looks way better, yes. I have this feeling like these validations
should be more centralized or tied to the mm code more directly to
avoid drift, but I don't have any constructive suggestions
unfortunately. Maybe other folks do?

> +       switch (opt) {
> +       case PR_SET_MM_START_CODE:
> +       case PR_SET_MM_END_CODE:
> +
> +               vm_req_flags = VM_READ | VM_EXEC;
> +               vm_bad_flags = VM_WRITE | VM_MAYSHARE;
> +
> +               if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
> +                   (vma->vm_flags & vm_bad_flags))
> +                       goto out;

Another random thought: given this very regular set of checks you're
doing, perhaps the flags should be part of a data structure instead,
just to reduce the size of this routine?

struct mm_flags {
  int req_flags;
  int bad_flags;
};

struct mm_flags opt_flags[] = {
...
 { VM_READ | VM_EXEC, VM_WRITE | VM_MAYSHARE }, /* PR_SET_MM_START_CODE */
 { VM_READ | VM_EXEC, VM_WRITE | VM_MAYSHARE }, /* PR_SET_MM_END_CODE */
...

then do validation before the switch statement all in one place, and
leave the switch for more programmatic checks?

-Kees

-- 
Kees Cook
ChromeOS Security
