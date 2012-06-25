Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2FYJyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:54:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51497 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2FYJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:54:12 -0400
Date: Mon, 25 Jun 2012 11:54:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, gorcunov@openvz.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/3] x86, x2apic: limit the vector reservation to the
 user specified mask
Message-ID: <20120625095407.GA27081@gmail.com>
References: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
 <1340316145-4431-3-git-send-email-suresh.b.siddha@intel.com>
 <CAE9FiQWjVVsr-AsKEJ6CLPaGLYEZ1XRAnKGHiJEHvkr3xsAJyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWjVVsr-AsKEJ6CLPaGLYEZ1XRAnKGHiJEHvkr3xsAJyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Thu, Jun 21, 2012 at 3:02 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > For the x2apic cluster mode, vector for an interrupt is currently reserved on
> > all the cpu's that are part of the x2apic cluster. But the interrupts will
> > be routed only to the cluster (derived from the first cpu in the mask) members
> > specified in the mask. So there is no need to reserve the vector in the unused
> > cluster members.
> >
> > Modify __assign_irq_vector() to reserve the vectors based on the user
> > specified irq destination mask. If the new mask is a proper subset of
> > the currently used mask, cleanup the vector allocation on the unused cpu
> > members.
> >
> > Also, allow the apic driver to tune the vector domain based on the
> > affinity mask (which in most cases is the user-specified mask).
> >
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  arch/x86/include/asm/apic.h           |    9 ++++++---
> >  arch/x86/kernel/apic/apic_noop.c      |    3 ++-
> >  arch/x86/kernel/apic/io_apic.c        |   31 +++++++++++++++----------------
> >  arch/x86/kernel/apic/x2apic_cluster.c |    6 +++---
> >  4 files changed, 26 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> > index b37fa12..c276809 100644
> > --- a/arch/x86/include/asm/apic.h
> > +++ b/arch/x86/include/asm/apic.h
> > @@ -306,7 +306,8 @@ struct apic {
> >        unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
> >        unsigned long (*check_apicid_present)(int apicid);
> >
> > -       void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
> > +       void (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
> > +                                        const struct cpumask *mask);
> 
> there is one left over for vsmp_64 need to be updated.
> 
> arch/x86/kernel/vsmp_64.c: In function ‘vsmp_apic_post_init’:
> arch/x86/kernel/vsmp_64.c:221:33: warning: assignment from
> incompatible pointer type [enabled by default]

Other than this omission the series looks good to me as well, if 
this is fixed and the Acked-by's of the three gents is added to 
all three patches then I can apply it to -tip.

Thanks,

	Ingo
