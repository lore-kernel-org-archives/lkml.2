Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1BKUTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:19:13 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33460 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab1BKUTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dxF3PHSEXSHe5yV3Y8ZKnr6wtp/diUOMkFfXSDM0a7VG2eE70MFqQgRWOuaxO8Q/Vw
         D75K2wa6HZNplxpdu+HOmGZb9kybwG3zuM94x3LRHqTBunYzAKYEjfbrTQgxQWBnJ5hK
         PovKQG0/FcpGJNxxIU570BvKfdzQfwlEPzQws=
MIME-Version: 1.0
In-Reply-To: <20110211191359.GC2010@jolsa.brq.redhat.com>
References: <1297432830-3912-1-git-send-email-jolsa@redhat.com>
	<m14o8a34em.fsf@fess.ebiederm.org>
	<20110211170722.GA2010@jolsa.brq.redhat.com>
	<AANLkTikCAbe5ATHjqgQDOFuCjcuG1=8e_5+ADaCQ3M6R@mail.gmail.com>
	<20110211191359.GC2010@jolsa.brq.redhat.com>
Date: Fri, 11 Feb 2011 15:19:11 -0500
Message-ID: <AANLkTikJ-MjMsa8ULwKbSO8YhjdO6NuK4L02fu8FXzE=@mail.gmail.com>
Subject: Re: [PATCH] x86_64: disable identity mappings statically
From: Brian Gerst <brgerst@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 2:13 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Feb 11, 2011 at 12:59:47PM -0500, Brian Gerst wrote:
>> On Fri, Feb 11, 2011 at 12:07 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Fri, Feb 11, 2011 at 08:46:41AM -0800, Eric W. Biederman wrote:
>> >> Jiri Olsa <jolsa@redhat.com> writes:
>> >>
>> >> > hi,
>> >> >
>> >> > while browsing the page table setup code, I noticed the x86_64 head
>> >> > code might not need the identity mappings at all.
>> >> > It seems it's ok to switch it off completely from the begining,
>> >> > unless I'm missing something.
>> >>
>> >> Have you tested it?
>> >
>> > yes, I booted it with no problem
>>
>> The only reason this doesn't crash is because the identity mappings
>> provided by the boot code are marked as global, and therefore might
>> not be flushed by simply loading cr3.  The cpu can evict TLB entries
>> at any time though, so it's a bad idea to run without the identity
>> mappings even for the brief moment before jumping to the virtual
>> address.
>
> I added code for flushing whole TLB (including global pages) and it
> still boots (attached).
>
> I'm sorry if I'm missing something obvious (probably the TLB flushing
> code is wrong), but I'd like to understand this part.
>
> What instruction/action would require the identity mapping,
> after the page table is set?
>
> thanks (and again sry for noise :) )
> jirka
>
>
> ---
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index c55e6fa..073f489 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -165,6 +165,13 @@ ENTRY(secondary_startup_64)
>        movl    $(X86_CR4_PAE | X86_CR4_PGE), %eax
>        movq    %rax, %cr4
>
> +       /* invalidate whole TLB */
> +       movq %cr4, %rax
> +       movq %rax, %rdx
> +       andq $~X86_CR4_PGE, %rax
> +       movq %rax, %cr4
> +       movq %rdx, %cr4
> +
>        /* Setup early boot stage 4 level pagetables. */
>        movq    $(init_level4_pgt - __START_KERNEL_map), %rax
>        addq    phys_base(%rip), %rax
>

The way you have it, it will immediately reload the global identity
entry into the TLB when it executes the next instruction, because cr3
is still pointing to the old pagetables.  Disable PGE during or
immediately after the load of cr3 to make sure the global identity
entries are flushed.

--
Brian Gerst
