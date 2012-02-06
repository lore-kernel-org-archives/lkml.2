Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2BFOcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:32:48 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38524 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab2BFOcr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:32:47 -0500
MIME-Version: 1.0
In-Reply-To: <1328538568.2482.5.camel@laptop>
References: <20120202211709.GA1642@x4>
	<20120202213220.GB1642@x4>
	<CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	<20120204135110.GA6437@elte.hu>
	<CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	<CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
	<1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
	<1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
	<1328538568.2482.5.camel@laptop>
Date: Mon, 6 Feb 2012 15:32:46 +0100
Message-ID: <CABPqkBSuQCJkmJYbno_qsb=erOOf3uf84sQsSCzoov-6=7r40Q@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 3:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-02-06 at 15:13 +0100, Stephane Eranian wrote:
>> Ok, I found the problem!
>>
>> it comes from perf_adjust_freq_unthr_context() vs perf_adjust_period().
>> The latter can under certain condition stop and restart the event. So we
>> had:
>>
>>       stop()
>>       if (delta > 0) {
>>            perf_adjust_period() {
>>                if (period > 8*...) {
>>                    stop()
>>                    ...
>>                    start()
>>                }
>>            }
>>        }
>>        start()
>>
>> Could have a double stop() and double start(), thus triggering the warning in
>> x86_pmu_start().
>>
>> Will post a patch shortly to fix this.
>
> Nice, thanks for looking at this!
>
I am wondering why we stop and restart the code in perf_adjust_period()
when it's called from __perf_event_overflow(). Isn't it supposed to be stopped
already by the model specific interrupt handler. Looks like we do stop/start,
just to get the reload aspect of start. Is that right?
