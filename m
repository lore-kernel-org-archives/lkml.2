Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab2BFOln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:41:43 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:62763 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab2BFOlm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120206143844.GA23807@elte.hu>
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
	<20120206143844.GA23807@elte.hu>
Date: Mon, 6 Feb 2012 15:41:40 +0100
Message-ID: <CABPqkBR2nydKxU91NUaoKSUX2w+hN4ZFCi1khHPvMLB+Rid33A@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 3:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
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
> Please send a patch against tip:master (or perf/urgent), on top
> of:
>
>  84f2b9b2edc0: perf: Remove deprecated WARN_ON_ONCE()
>
> Note that I updated that patch to removed one more WARN_ON()
> than you originally sent - please add it back as appropriate, in
> the delta fix patch.
>
I have already added the warning back. Will send against tip:master

> Thanks,
>
>        Ingo
