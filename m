Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab2FFXPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:15:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:14851 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab2FFXPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161905465"
Subject: Re: [tip:x86/apic] x86/x2apic/cluster: Use all the members of one
 cluster specified in the smp_affinity mask for the interrupt destination
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Wed, 06 Jun 2012 16:14:40 -0700
In-Reply-To: <CAE9FiQUzHGPvYMMhBQrzOCFex-xWDPN-SWw0WgHhUM9H-MDN3w@mail.gmail.com>
References: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
	 <tip-0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0@git.kernel.org>
	 <CAE9FiQUzHGPvYMMhBQrzOCFex-xWDPN-SWw0WgHhUM9H-MDN3w@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339024480.28766.63.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 15:21 -0700, Yinghai Lu wrote:
> On Wed, Jun 6, 2012 at 8:04 AM, tip-bot for Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > Commit-ID:  0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
> > Gitweb:     http://git.kernel.org/tip/0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
> > Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> > AuthorDate: Mon, 21 May 2012 16:58:02 -0700
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 6 Jun 2012 09:51:22 +0200
> >
> > x86/x2apic/cluster: Use all the members of one cluster specified in the smp_affinity mask for the interrupt destination
> >
> > If the HW implements round-robin interrupt delivery, this
> > enables multiple cpu's (which are part of the user specified
> > interrupt smp_affinity mask and belong to the same x2apic
> > cluster) to service the interrupt.
> >
> > Also if the platform supports Power Aware Interrupt Routing,
> > then this enables the interrupt to be routed to an idle cpu or a
> > busy cpu depending on the perf/power bias tunable.
> >
> > We are now grouping all the cpu's in a cluster to one vector
> > domain. So that will limit the total number of interrupt sources
> > handled by Linux. Previously we support "cpu-count *
> > available-vectors-per-cpu" interrupt sources but this will now
> > reduce to "cpu-count/16 * available-vectors-per-cpu".
> 
> with this patch, will waste/hide several irq vector on some cpus.
> 
> for example:
> very beginning after boot, one irq will have vector from 16 cpus of
> same cluster.
> later if user using irq affinity change to one cpu only.
> cfg->domain will be not changed, but ioapic or irte will be confined to one cpu.
> because mask is used for new dest_id.
>  *dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
> 
> all other 15 cpu vector are wasted or hided.

Yinghai, As I mentioned in the other thread, we should be able to
restrict the vector allocation to only the cpu's specified in the mask
and cleanup the allocation for the others in the same cluster domain. We
didn't do this for legacy xapic in the past mainly because of some
platform bugs which sent interrupts to different logical cpu's ignoring
what has been specified in IO-APIC RTE. But x2apic mode doesn't have
those HW errata, so we should be able to address this.

Will get back with a patch which does this.

thanks,
suresh

