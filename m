Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2EXCXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:23:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:18919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2EXCXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:23:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="147699907"
Message-ID: <4FBD9BAA.7070902@linux.intel.com>
Date: Thu, 24 May 2012 10:23:38 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1205230859190.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com> <alpine.LFD.2.02.1205232044150.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/5/24 4:53, Luck, Tony 写道:
>> If that's the case, then I really can't understand the 5 CMCIs per
>> second threshold for defining the storm and switching to poll mode.
>> I'd rather expect 5 of them in a row.
> We don't have a lot of science to back up the "5" number (and
> can change it to conform to any better numbers if someone has
> some real data).
>
> My general approximation for DRAM corrected error rates is
> "one per gigabyte per month, plus or minus two orders of
>  magnitude". So if I saw 1600 errors per month on a 16GB
> workstation, I'd think that was a high rate - but still
> plausible from natural causes (especially if the machine
> was some place 5000 feet above sea level with a lot less
> atmosphere to block neutrons). That only amounts to a couple
> of errors per hour. So five in a second is certainly a storm!
>
> Looking at this from another perspective ... how many
> CMCIs can we take per second before we start having a
> noticeable impact on system performance. RT answer may
> be quite a small number, generic throughput computing
> answer might be several hundred per second.
>
> The situation we are trying to avoid is a stuck bit on
> some very frequently accessed piece of memory generating
> a solid stream of CMCI that make the system unusable. In
> this case the question is for how long do we let the storm
> rage before we turn of CMCI to get some real work done.
>
> Once we are in polling mode, we do lose data on the location
> of some corrected errors. But I don't think that this is
> too serious. If there are few errors, we want to know about
> them all. If there are so many that we have difficulty
> counting them all - then sampling from a subset will
> give us reasonable data most of the time (the exception
> being the case where we have one error source that is
> 100,000 times as noisy as some other sources that we'd
> still like to keep tabs on ... we'll need a *lot* of samples
> to see the quieter error sources amongst the noise).
>
> So I think there are justifications for numbers in the
> 2..1000 range. We could punt it to the user by making
> it configurable/tunable ... but I think we already have
> too many tunables that end-users don't have enough information
> to really set in meaningful ways to meet their actual
> needs - so I'd prefer to see some "good enough" number
> that meets the needs, rather than yet another /sys/...
> file that people can tweak.
>
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thanks very much for your elaboration, Tony. You give so much detail
than I want
to tell :-).

Hi, Thomas, yes, you can say 5 is just a arbitraty value and I can't
give you too
many proofs though I ever found some guys to help to test on the real
platform.
I only can say it works based on our internal test bench, but I really
hope someone
can use this patch on their actual machines and give me the feedback. I
can decide
what value is proper or if we need a tunable switch. By now, as Tony
said, there are
too many switches for end users so I don't want to add more.

BTW, I will update the description in the next version.

Hi, Boris, when I write these codes I don't care if it is specific for
Intel or AMD. I just
noticed it should be general for x86 platform and all related codes are
general too,
which in mce.c, so I think it should be fine to place the codes in mce.c.

