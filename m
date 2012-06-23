Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2FWWER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 18:04:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48640 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2FWWEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 18:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <1340316145-4431-3-git-send-email-suresh.b.siddha@intel.com>
References: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
	<1340316145-4431-3-git-send-email-suresh.b.siddha@intel.com>
Date: Sat, 23 Jun 2012 15:04:14 -0700
X-Google-Sender-Auth: DFQl_oFUQ-I2wz1bkhjh_jNSuHk
Message-ID: <CAE9FiQWjVVsr-AsKEJ6CLPaGLYEZ1XRAnKGHiJEHvkr3xsAJyA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] x86, x2apic: limit the vector reservation to the
 user specified mask
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 3:02 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> For the x2apic cluster mode, vector for an interrupt is currently reserved on
> all the cpu's that are part of the x2apic cluster. But the interrupts will
> be routed only to the cluster (derived from the first cpu in the mask) members
> specified in the mask. So there is no need to reserve the vector in the unused
> cluster members.
>
> Modify __assign_irq_vector() to reserve the vectors based on the user
> specified irq destination mask. If the new mask is a proper subset of
> the currently used mask, cleanup the vector allocation on the unused cpu
> members.
>
> Also, allow the apic driver to tune the vector domain based on the
> affinity mask (which in most cases is the user-specified mask).
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/apic.h           |    9 ++++++---
>  arch/x86/kernel/apic/apic_noop.c      |    3 ++-
>  arch/x86/kernel/apic/io_apic.c        |   31 +++++++++++++++----------------
>  arch/x86/kernel/apic/x2apic_cluster.c |    6 +++---
>  4 files changed, 26 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index b37fa12..c276809 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -306,7 +306,8 @@ struct apic {
>        unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
>        unsigned long (*check_apicid_present)(int apicid);
>
> -       void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
> +       void (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
> +                                        const struct cpumask *mask);

there is one left over for vsmp_64 need to be updated.

arch/x86/kernel/vsmp_64.c: In function ‘vsmp_apic_post_init’:
arch/x86/kernel/vsmp_64.c:221:33: warning: assignment from
incompatible pointer type [enabled by default]

Thanks

Yinghai
