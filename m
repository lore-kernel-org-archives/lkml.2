Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1INOpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:45:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:53957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1INOpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:45:54 -0400
Subject: Re: [PATCH 2/2] perf, x86: Fix event scheduler for constraints with
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Sep 2011 16:45:47 +0200
In-Reply-To: <1315666143-7106-3-git-send-email-robert.richter@amd.com>
References: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
	 <1315666143-7106-3-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316011547.5040.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-10 at 16:49 +0200, Robert Richter wrote:
>  struct perf_sched {
>         int                     max_weight;
>         int                     max_events;
>         struct event_constraint **constraints;
>         struct sched_state      state;
> +
> +       int                     saved_states;

This creates an ugly hole in the structure

> +       struct sched_state      saved[SCHED_STATES_MAX];
>  };
>  
>  static void perf_sched_init(struct perf_sched *sched, struct event_constraint **c,
> @@ -817,7 +849,30 @@ static void perf_sched_init(struct perf_sched *sched, struct event_constraint **
>         sched->state.unassigned = num;
>  }
>  
> -static struct sched_state *perf_sched_find_counter(struct perf_sched *sched)
> +static void perf_sched_save_state(struct perf_sched *sched)
> +{
> +       if (sched->saved_states >= SCHED_STATES_MAX)
> +               return;
> +
> +       sched->saved[sched->saved_states] = sched->state;
> +       sched->saved_states++;
> +} 

Shouldn't we fail the save_state when we're out of states? the restore
code doesn't check to see if --saved_states is within range and simply
derefs the array.


