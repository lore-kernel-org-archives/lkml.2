Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2GDKFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:05:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:38967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab2GDKE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:04:59 -0400
Subject: Re: [PATCH 5/5] perf/x86: Add Intel Nehalem-EX uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
	 <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:04:53 +0200
Message-ID: <1341396293.2507.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 14:00 +0800, Yan, Zheng wrote:
> +static void nhmex_uncore_msr_enable_event(struct intel_uncore_box *box,
> +                                         struct perf_event *event)
> +{
> +       struct hw_perf_event *hwc = &event->hw;
> +
> +       if (box->pmu->type == &nhmex_uncore_bbox)
> +               nhmex_bbox_msr_enable_event(box, event);
> +       else if (box->pmu->type == &nhmex_uncore_sbox)
> +               nhmex_sbox_msr_enable_event(box, event);
> +       else if (box->pmu->type == &nhmex_uncore_mbox)
> +               nhmex_mbox_msr_enable_event(box, event);
> +       else if (box->pmu->type == &nhmex_uncore_rbox)
> +               nhmex_rbox_msr_enable_event(box, event);
> +       else if (hwc->idx >= UNCORE_PMC_IDX_FIXED)
> +               wrmsrl(hwc->config_base, NHMEX_PMON_CTL_EN_BIT0);
> +       else if (box->pmu->type->event_mask & NHMEX_PMON_CTL_EN_BIT0)
> +               wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT22);
> +       else
> +               wrmsrl(hwc->config_base, hwc->config | NHMEX_PMON_CTL_EN_BIT0);
> +} 

wouldn't it be easier to do something like:

  box->pmu->type->enable_event(box, event);

The same for these other functions that are massive ->type switches.

Also, can you please add more comments, note all the face_cpuc stuff,
and there's some rather dense code in all the alternative stuff. 

Also, how can a single extra register require 192 bits of config space?

