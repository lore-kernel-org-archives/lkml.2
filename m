Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1CARJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:09:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab1CARJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Epz/mCq7GpnhmB2lZuYCnd8HXKXvLXQMAhl3J4Joih/cvmS0irM/HJHRGGiiyvelAO
         DqTNuV47b5yilAJuGlMA==
MIME-Version: 1.0
In-Reply-To: <1298998076.2170.62.camel@localhost>
References: <1298998076.2170.62.camel@localhost>
Date: Tue, 1 Mar 2011 18:09:05 +0100
Message-ID: <AANLkTimvx+MYhOw8VFsJn4V6FQutKiYO6pHxgd9xGY8A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] perf-events: Add support for supplementary event registers
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p21H9JR3014710

Lin,

See comments below:

On Tue, Mar 1, 2011 at 5:47 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>  static struct event_constraint *
> +intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> +{
> +       struct hw_perf_event *hwc = &event->hw;
> +       unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
> +       struct event_constraint *c;
> +       struct intel_percore *pc;
> +       struct er_account *era;
> +       int i;
> +       int free_slot;
> +       int found;
> +
> +       if (!x86_pmu.percore_constraints || hwc->extra_alloc)
> +               return NULL;
> +
> +       for (c = x86_pmu.percore_constraints; c->cmask; c++) {
> +               if (e != c->code)
> +                       continue;
> +
> +               /*
> +                * Allocate resource per core.
> +                */
> +               c = NULL;

Not sure I understand this c = NULL, given you hardcoded return NULL
outside of the
loop. I forgot to mention this earlier.

> +               pc = cpuc->per_core;
> +               if (!pc)
> +                       break;
> +               c = &emptyconstraint;
> +               raw_spin_lock(&pc->lock);
> +               free_slot = -1;
> +               found = 0;
> +               for (i = 0; i < MAX_EXTRA_REGS; i++) {
> +                       era = &pc->regs[i];
> +                       if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
> +                               /* Allow sharing same config */
> +                               if (hwc->extra_config == era->extra_config) {
> +                                       era->ref++;
> +                                       cpuc->percore_used = 1;
> +                                       hwc->extra_alloc = 1;
> +                                       c = NULL;
> +                               }
> +                               /* else conflict */
> +                               found = 1;
> +                               break;
> +                       } else if (era->ref == 0 && free_slot == -1)
> +                               free_slot = i;
> +               }
> +               if (!found && free_slot != -1) {
> +                       era = &pc->regs[free_slot];
> +                       era->ref = 1;
> +                       era->extra_reg = hwc->extra_reg;
> +                       era->extra_config = hwc->extra_config;
> +                       cpuc->percore_used = 1;
> +                       hwc->extra_alloc = 1;
> +                       c = NULL;
> +               }
> +               raw_spin_unlock(&pc->lock);
> +               return c;
> +       }
> +
> +       return NULL;
> +}
> +
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8ceb5a6..48d966a 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -225,8 +225,14 @@ struct perf_event_attr {
>        };
>
>        __u32                   bp_type;
> -       __u64                   bp_addr;
> -       __u64                   bp_len;
> +       union {
> +               __u64           bp_addr;
> +               __u64           config1; /* extension of config0 */
> +       };
> +       union {
> +               __u64           bp_len;
> +               __u64           config2; /* extension of config1 */
> +       };
>  };
>
I don't see where those config0 or config1 are coming from.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
