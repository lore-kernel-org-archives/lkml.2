Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2FOQDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:03:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:46828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab2FOQDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:03:03 -0400
Message-ID: <1339776173.2559.77.camel@twins>
Subject: Re: [PATCH V6 07/13] perf: Generic pci uncore device support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 18:02:53 +0200
In-Reply-To: <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> @@ -305,6 +310,22 @@ struct intel_uncore_box *uncore_alloc_box(int cpu)
>  static struct intel_uncore_box *
>  uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
>  {
> +       static struct intel_uncore_box *box;
> +
> +       box =  *per_cpu_ptr(pmu->box, cpu);
> +       if (box)
> +               return box;
> +
> +       raw_spin_lock(&uncore_box_lock);
> +       list_for_each_entry(box, &pmu->box_list, list) {
> +               if (box->phys_id == topology_physical_package_id(cpu)) {
> +                       atomic_inc(&box->refcnt);
> +                       *per_cpu_ptr(pmu->box, cpu) = box;
> +                       break;
> +               }
> +       }
> +       raw_spin_unlock(&uncore_box_lock);
> +
>         return *per_cpu_ptr(pmu->box, cpu);
>  } 

So why can't we do that lookup from a hotplug notifier?
