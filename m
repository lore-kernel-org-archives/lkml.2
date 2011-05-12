Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab1ELVG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:06:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50075 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713Ab1ELVGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:06:24 -0400
Date: Thu, 12 May 2011 23:06:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: eranian@google.com, acme@redhat.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512210605.GB16600@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <20110512.140630.1779004012724490077.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512.140630.1779004012724490077.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Stephane Eranian <eranian@google.com>
> Date: Thu, 12 May 2011 16:48:46 +0200
> 
> > I think there is a serious problem with kernel symbol correlation
> > with the latest perf in 2.6.39-rc7-tip.
> 
> The behavior seems to be intentional, so that we don't expose internal
> kernel addresses to userspace.
> 
> I hate this too, and I think it's absolutely rediculous.
> 
> Also, like you, I lost an entire afternoon trying to figure out why
> this started happening.

I lost about an hour with Arnaldo on IRC to help me until we figured out that 
/proc/kallsyms started having zero value entries ... I'm too running perf as an 
unprivileged user.

Zero is a valid symbol address so nothing within perf tripped up explicitly, 
but perf report and perf top results were nonsensical.

There was another problem with it: perf is caching and storing known kernel 
buildid addresses in ~/.debug, under the (previously correct) assumption that 
kernel symbols do not change for one given kernel build. But with kptr_restrict 
it would cache the zero values - which were cached even after kptr_restrict was 
set back to 0.

Thanks,

	Ingo
