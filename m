Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab2CURN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:13:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48060 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2CURN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120321102107.473.89777.sendpatchset@codeblue.in.ibm.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <20120321102107.473.89777.sendpatchset@codeblue.in.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Mar 2012 10:13:04 -0700
X-Google-Sender-Auth: 6EnNnJ0eOUesjO7broJXObxXPhg
Message-ID: <CA+55aFzJn_U=2-kxGX15v6zLaCV+Jgtxjop2PudizzsqSn+nLg@mail.gmail.com>
Subject: Re: [PATCH RFC V6 2/11] x86/ticketlock: don't inline _spin_unlock
 when using paravirt spinlocks
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 3:21 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> The code size expands somewhat, and its probably better to just call
> a function rather than inline it.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  arch/x86/Kconfig     |    3 +++
>  kernel/Kconfig.locks |    2 +-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5bed94e..10c28ec 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -623,6 +623,9 @@ config PARAVIRT_SPINLOCKS
>
>          If you are unsure how to answer this question, answer N.
>
> +config ARCH_NOINLINE_SPIN_UNLOCK
> +       def_bool PARAVIRT_SPINLOCKS
> +
>  config PARAVIRT_CLOCK
>        bool
>
> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
> index 5068e2a..584637b 100644
> --- a/kernel/Kconfig.locks
> +++ b/kernel/Kconfig.locks
> @@ -125,7 +125,7 @@ config INLINE_SPIN_LOCK_IRQSAVE
>                 ARCH_INLINE_SPIN_LOCK_IRQSAVE
>
>  config INLINE_SPIN_UNLOCK
> -       def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK)
> +       def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK) && !ARCH_NOINLINE_SPIN_UNLOCK
>
>  config INLINE_SPIN_UNLOCK_BH
>        def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH

Ugh. This is getting really ugly.

Can we just fix it by
 - getting rid of INLINE_SPIN_UNLOCK entirely

 - replacing it with UNINLINE_SPIN_UNLOCK instead with the reverse
meaning, and no "def_bool" at all, just a simple

        config UNINLINE_SPIN_UNLOCK
                bool

 - make the various people who want to uninline the spinlocks (like
spinlock debugging, paravirt etc) all just do

        select UNINLINE_SPIN_UNLOCK

because quite frankly, the whole spinunlock inlining logic is
*already* unreadable, and you just made it worse.

                      Linus
