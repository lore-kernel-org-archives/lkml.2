Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab2JWNEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:04:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:41989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab2JWNEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:04:01 -0400
Message-ID: <1350997423.13456.21.camel@twins>
Subject: Re: [PATCH 14/34] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 15:03:43 +0200
In-Reply-To: <1350602382-12771-15-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-15-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> @@ -1079,6 +1079,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
>  int intel_pmu_save_and_restart(struct perf_event *event)
>  {
>         x86_perf_event_update(event);
> +       /*
> +        * For a checkpointed counter always reset back to 0.  This
> +        * avoids a situation where the counter overflows, aborts the
> +        * transaction and is then set back to shortly before the
> +        * overflow, and overflows and aborts again.
> +        */
> +       if (event->hw.config & HSW_INTX_CHECKPOINTED) {

Would an unlikely() make sense there? Most events won't have this set.

> +               /* No race with NMIs because the counter should not be armed */
> +               wrmsrl(event->hw.event_base, 0);
> +               local64_set(&event->hw.prev_count, 0);
> +       }
>         return x86_perf_event_set_period(event);
>  } 
