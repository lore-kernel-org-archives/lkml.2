Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2BFO3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:29:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43010 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2BFO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:29:35 -0500
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
References: <20120202211709.GA1642@x4> <20120202213220.GB1642@x4>
	 <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	 <20120204135110.GA6437@elte.hu>
	 <CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	 <CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
	 <1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
	 <1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 15:29:28 +0100
Message-ID: <1328538568.2482.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 15:13 +0100, Stephane Eranian wrote:
> Ok, I found the problem!
> 
> it comes from perf_adjust_freq_unthr_context() vs perf_adjust_period().
> The latter can under certain condition stop and restart the event. So we
> had:
> 
>       stop()
>       if (delta > 0) {
>            perf_adjust_period() {
>                if (period > 8*...) {
>                    stop()
>                    ...
>                    start()
>                }
>            }
>        }
>        start()
> 
> Could have a double stop() and double start(), thus triggering the warning in
> x86_pmu_start().
> 
> Will post a patch shortly to fix this. 

Nice, thanks for looking at this!

