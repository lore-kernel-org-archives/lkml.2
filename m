Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab2FFWVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:21:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62488 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2FFWVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <tip-0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0@git.kernel.org>
References: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
	<tip-0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0@git.kernel.org>
Date: Wed, 6 Jun 2012 15:21:47 -0700
X-Google-Sender-Auth: PZ7drVZ0eeqii1AUpgOEiV4Brz4
Message-ID: <CAE9FiQUzHGPvYMMhBQrzOCFex-xWDPN-SWw0WgHhUM9H-MDN3w@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86/x2apic/cluster: Use all the members of one
 cluster specified in the smp_affinity mask for the interrupt destination
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 8:04 AM, tip-bot for Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Commit-ID:  0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
> Gitweb:     http://git.kernel.org/tip/0b8255e660a0c229ebfe8f9fde12a8d4d34c50e0
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Mon, 21 May 2012 16:58:02 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Jun 2012 09:51:22 +0200
>
> x86/x2apic/cluster: Use all the members of one cluster specified in the smp_affinity mask for the interrupt destination
>
> If the HW implements round-robin interrupt delivery, this
> enables multiple cpu's (which are part of the user specified
> interrupt smp_affinity mask and belong to the same x2apic
> cluster) to service the interrupt.
>
> Also if the platform supports Power Aware Interrupt Routing,
> then this enables the interrupt to be routed to an idle cpu or a
> busy cpu depending on the perf/power bias tunable.
>
> We are now grouping all the cpu's in a cluster to one vector
> domain. So that will limit the total number of interrupt sources
> handled by Linux. Previously we support "cpu-count *
> available-vectors-per-cpu" interrupt sources but this will now
> reduce to "cpu-count/16 * available-vectors-per-cpu".

with this patch, will waste/hide several irq vector on some cpus.

for example:
very beginning after boot, one irq will have vector from 16 cpus of
same cluster.
later if user using irq affinity change to one cpu only.
cfg->domain will be not changed, but ioapic or irte will be confined to one cpu.
because mask is used for new dest_id.
 *dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);

all other 15 cpu vector are wasted or hided.

Yinghai
