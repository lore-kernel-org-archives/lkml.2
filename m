Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0ENQWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:22:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34755 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0ENQWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bxuOfUu3H6ANEMxsJsgifowyj54Eqc3uZXj7Efn9rZyIecuqpQKTIiZ20Gkx7cSrro
         Pn9tj+jaKdXn+T/BX2YJ7AUFczRfiuWixtWJj4FWB3mZhzAQcBndOv1WKk0Q4+W1leXg
         rKvxr/f7WCgB2YQtQY+RNfQwQ1CezFEXftXqo=
MIME-Version: 1.0
In-Reply-To: <20100514145213.GA13509@lenovo>
References: <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
	 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
	 <1273834571.3530.82.camel@minggr.sh.intel.com>
	 <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo>
	 <20100514145213.GA13509@lenovo>
Date: Fri, 14 May 2010 21:52:28 +0530
Message-ID: <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

On Fri, May 14, 2010 at 8:22 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [PATCH -tip/master] x86,perf: P4 PMU - fix counters allocation logic and sign issue
>
> Jaswinder reported GP:
> |
> | Message from syslogd@ht at May 14 09:39:32 ...
> | kernel:[  314.908612] EIP: [<c100ccca>]
> | x86_perf_event_set_period+0x19d/0x1b2 SS:ESP 0068:edac3d70
> |
>
> Ming has narrowed it down to comparision issue between arguments with
> different sizes. As result event index reaches value 255 which in turn
> leads to GP fault.
>
> Also it was found that p4_next_cntr has a broken logic and should return
> counter index if only it was not yet borrowed for another event.
>
> Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
> Reported-by: Lin Ming <ming.m.lin@intel.com>
> Bisected-by: Lin Ming <ming.m.lin@intel.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---

Yes, this works for me. Now I am not getting general protection fault.

It seems hardware events are not supported for P4 yet.

$ ./perf stat -e
cycles,instructions,cache-references,cache-misses,branches,branch-misses,bus-cycles
ls > /dev/null

 Performance counter stats for 'ls':

  <not counted>  cycles
         601636  instructions             #      0.000 IPC    (scaled
from 91.80%)
  <not counted>  cache-references
  <not counted>  cache-misses
  <not counted>  branches
  <not counted>  branch-misses
  <not counted>  bus-cycles

    0.003364910  seconds time elapsed


Thanks,
--
Jaswinder Singh.



>  arch/x86/kernel/cpu/perf_event_p4.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -747,11 +747,11 @@ static int p4_get_escr_idx(unsigned int
>  static int p4_next_cntr(int thread, unsigned long *used_mask,
>                        struct p4_event_bind *bind)
>  {
> -       int i = 0, j;
> +       int i, j;
>
>        for (i = 0; i < P4_CNTR_LIMIT; i++) {
> -               j = bind->cntr[thread][i++];
> -               if (j == -1 || !test_bit(j, used_mask))
> +               j = bind->cntr[thread][i];
> +               if (j != (unsigned char)-1 && !test_bit(j, used_mask))
>                        return j;
>        }
>
>
