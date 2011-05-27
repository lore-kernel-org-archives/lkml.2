Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1E0MXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:23:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1E0MXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:23:13 -0400
Date: Fri, 27 May 2011 14:23:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110527122301.GA32754@elte.hu>
References: <20110526133948.GX20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526133948.GX20052@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Robert Richter (1):
>       oprofile, x86: Enable preemption during pci device setup in IBS init

I'm wondering about this bit, as from a preempt_enable()/disable() 
pattern POV it looks bogus. It does:

        preempt_disable();
        for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
                if (get_eilvt(offset))
                        break;
        }
        preempt_enable();

	...


	ret = setup_ibs_ctl(offset);

So whatever condition it established at the get_eilvt() stage might 
not be valid at the setup_ibs_ctl() point: we might be on a different 
CPU.

Or are the IBS MSRs (which get twiddled in get_eilvt() absolutely 
symmetric across all CPUs, thus making this a preempt invariant 
thing? In that case we'd at least need a big fat comment in the code 
as it's not obvious at all ...

But i really do not see how this can work. get_eilvt() twiddles the 
APIC LVT of this current CPU. Does IBS only activate on a single CPU? 
How will this LVT entry be cleared on deinit?

Mysteries, mysteries!

Thanks,

	Ingo
