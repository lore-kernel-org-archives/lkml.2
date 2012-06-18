Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab2FRHnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:43:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45040 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2FRHnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:43:15 -0400
Message-ID: <1340005388.15222.17.camel@twins>
Subject: Re: [PATCH V6 07/13] perf: Generic pci uncore device support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Jun 2012 09:43:08 +0200
In-Reply-To: <4FDE9B1B.8080707@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	  <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com>
	 <1339776173.2559.77.camel@twins> <4FDE9B1B.8080707@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 11:06 +0800, Yan, Zheng wrote:
> On 06/16/2012 12:02 AM, Peter Zijlstra wrote:
> > On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> >> @@ -305,6 +310,22 @@ struct intel_uncore_box *uncore_alloc_box(int cpu)
> >>  static struct intel_uncore_box *
> >>  uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
> >>  {
> >> +       static struct intel_uncore_box *box;
> >> +
> >> +       box =  *per_cpu_ptr(pmu->box, cpu);
> >> +       if (box)
> >> +               return box;
> >> +
> >> +       raw_spin_lock(&uncore_box_lock);
> >> +       list_for_each_entry(box, &pmu->box_list, list) {
> >> +               if (box->phys_id == topology_physical_package_id(cpu)) {
> >> +                       atomic_inc(&box->refcnt);
> >> +                       *per_cpu_ptr(pmu->box, cpu) = box;
> >> +                       break;
> >> +               }
> >> +       }
> >> +       raw_spin_unlock(&uncore_box_lock);
> >> +
> >>         return *per_cpu_ptr(pmu->box, cpu);
> >>  } 
> > 
> > So why can't we do that lookup from a hotplug notifier?
> > 
> We can. But I personally prefer not to mix pci uncore initialization
> code with cpu hotplug notifier. Because pci hotplug and cpu hotplug
> are separate process, I'm not completely sure which one happens first.

I suspect nobody does.. OK we'll leave it as it is. Thanks
