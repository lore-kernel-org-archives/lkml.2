Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517Ab2FUWwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:52:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760398Ab2FUWwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:52:00 -0400
Date: Thu, 21 Jun 2012 15:51:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
Message-Id: <20120621155159.239aa972.akpm@linux-foundation.org>
In-Reply-To: <4FE3A495.1030008@zytor.com>
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	<tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
	<20120621154334.05a74517.akpm@linux-foundation.org>
	<4FE3A495.1030008@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 15:47:49 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/21/2012 03:43 PM, Andrew Morton wrote:
> > 
> > Regardless of that, we have some head-scratching to do:
> > 
> > 
> > #define UNCORE_PMU_HRTIMER_INTERVAL       (60 * NSEC_PER_SEC)
> > 
> > and
> > 
> > #define NSEC_PER_SEC    1000000000L
> > 
> > and 60 billion doesn't fit in 32 bits.  So do we fix the
> > perf_event_intel_uncore.c callsites?  Or do we fix the
> > UNCORE_PMU_HRTIMER_INTERVAL definition?  Or do we fix the NSEC_PER_SEC
> > definition?
> > 
> > I'm thinking perhaps the latter.  What *is* the type of a nanosecond in
> > Linux?  include/linux/ktime.h is pretty insistent that it is u64.  If
> > so, NSEC_PER_SEC should logically have type ULL.  But changing both its
> > size and signedness is a pretty big change.
> 
> We could change the size only.  The range from 9223372036.854775808 to
> 18446744073.709551615 seconds (292-584 years) isn't really that significant.
> 

What *is* significant is the effect of a signedness change upon
arithmetic, conversions, warnings, etc.  And whether such a change
might actually introduce bugs.


Back away and ask the broader questions: why did ktime_t choose
unsigned?  Is time a signed concept?  What is the right thing to do
here, from a long-term design perspective?
