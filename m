Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab0HLLaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:30:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39594 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524Ab0HLLa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G5NMrBJro+2ljJztMq/RiiOgXHaXjLh3RZDe9OXGLzLFQIBkY5bOMxJe3+KoDbY8Vy
         vddUEhoDTpLma8U2WJ3ghCt52PBMBchmf99dp9De3PU9ZedXdoaFW/qD5KcJ5SAkCtgi
         7fIei6Bkp7To5CcNJZZx29QazYU9v2ekcAUAU=
MIME-Version: 1.0
In-Reply-To: <1281609945-2861-1-git-send-email-dfeng@redhat.com>
References: <1281609945-2861-1-git-send-email-dfeng@redhat.com>
Date: Thu, 12 Aug 2010 07:30:28 -0400
Message-ID: <AANLkTikx35Sp0GR4c_REYGcZV4bMgS+T-1cugen45d58@mail.gmail.com>
Subject: Re: [PATCH] x86: fpu xstate fix memory poison overwritten
From: Brian Gerst <brgerst@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 6:45 AM, Xiaotian Feng <dfeng@redhat.com> wrote:
> fpu.state is allocated from task_xstate_cachep, the size of
> task_xstate_cachep is xstate_size. But fpu.state is an union
> struct, which size is bigger than xstate_size if cpu_has_xsave,
> so if we want to visit fpu.state->xsave, the memory we allocated
> for fpu.state is not enough.
>
> This caused many poison/redzone overwritten alerts on task_xstate while using kvm.
>
> [ 1899.399373] =============================================================================
> [ 1899.399377] BUG task_xstate: Poison overwritten
> [ 1899.399378] -----------------------------------------------------------------------------
> [ 1899.399379]
> [ 1899.399382] INFO: 0xffff88020aca2100-0xffff88020aca217f. First byte 0x0 instead of 0x6b
> [ 1899.399385] INFO: Slab 0xffffea000725c300 objects=23 used=12 fp=0xffff88020aca2100 flags=0x200000000040c1
> [ 1899.399387] INFO: Object 0xffff88020aca2100 @offset=8448 fp=0xffff88020aca23c0
>
> With this patch applied, the poison overwritten alert disappeared.
>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/process.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index d401f1d..609bee5 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -59,7 +59,7 @@ void free_thread_info(struct thread_info *ti)
>  void arch_task_cache_init(void)
>  {
>         task_xstate_cachep =
> -               kmem_cache_create("task_xstate", xstate_size,
> +               kmem_cache_create("task_xstate", sizeof(union thread_xstate),
>                                  __alignof__(union thread_xstate),
>                                  SLAB_PANIC | SLAB_NOTRACK, NULL);
>  }

This isn't the right solution.  The point of having a variable
xstate_size is to only allocate the memory that is needed for the
capabilities of the cpu.  The real bug is that some code is trying to
use xsave_struct when it either shouldn't be (because the cpu doesn't
support xsave), or because xstate_size < sizeof(xsave_struct).

Looking at xstate_enable_boot_cpu(), the xstate_size is set from
cpuid.  It's possible that it is smaller than sizeof(xsave_strruct).
Maybe a sanity check should be added there?

--
Brian Gerst
