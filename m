Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1KGPlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:41:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1KGPlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:41:49 -0500
Date: Mon, 7 Nov 2011 17:41:32 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 7/9] KVM: Expose the architectural performance
 monitoring CPUID leaf
Message-ID: <20111107154132.GH8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-8-git-send-email-gleb@redhat.com>
 <1320674987.18053.39.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320674987.18053.39.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:09:46PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > +       case 0xa: { /* Architectural Performance Monitoring */
> > +               struct x86_pmu_capability cap;
> > +
> > +               perf_get_x86_pmu_capability(&cap);
> > +
> > +               /*
> > +                * Only support guest architectural pmu on a host
> > +                * with architectural pmu.
> > +                */
> > +               if (!cap.version)
> > +                       memset(&cap, 0, sizeof(cap));
> > +
> > +               entry->eax = min(cap.version, 2)
> > +                       | (cap.num_counters_gp << 8)
> > +                       | (cap.bit_width_gp << 16)
> > +                       | (cap.events_mask_len << 24);
> > +               entry->ebx = cap.events_mask;
> > +               entry->ecx = 0;
> > +               entry->edx = cap.num_counters_fixed
> > +                       | (cap.bit_width_fixed << 5);
> > +               break;
> > +       } 
> 
> would it make sense to use the cpuid10_e[ad]x unions to fill out that
> data?
Do you mean by doing cpuid here directly instead of checking perf
capability? We do not (entirely) pass through PMU to a guest. We emulate
it using perf subsystem and I can imaging cases where perf capabilities
will be different from what host reports. For instance host cpu may have
an errata that will make one of its counters unusable. In such case
code that checks for errata will have to be duplicated here too. Or we
may wan to emulate architectural PMU for a guest running on AMD host.

--
			Gleb.
