Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0DSQSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:18:16 -0400
Received: from claw.goop.org ([74.207.240.146]:39128 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab0DSQSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:18:15 -0400
Message-ID: <4BCC8246.9040202@goop.org>
Date: Mon, 19 Apr 2010 09:18:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>	 <4BCC3A3E.9070909@redhat.com>	 <20100419142158.GD14158@mothafucka.localdomain>	 <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop>
In-Reply-To: <1271688411.1488.248.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 07:46 AM, Peter Zijlstra wrote:
> What avi says! :-)
>
> On a 32bit machine a 64bit read are two 32bit reads, so
>
>   last = last_value;
>
> becomes:
>
>   last.high = last_value.high;
>   last.low  = last_vlue.low;
>
> (or the reverse of course)
>
> Now imagine a write getting interleaved with that ;-)
>   

You could explicitly do:

	do {
		h = last.high;
		barrier();
		l = last.low;
		barrier();
	} while (last.high != h);


This works because we expect last to be always increasing, so the only
worry is low wrapping and incrementing high, and is more efficient than
making the read fully atomic (the write is still cmpxchg64).  But it's
pretty ugly to open code just for 32b architectures; its something that
might be useful to turn into a general abstraction (monotonic_read_64
FTW!).  I already have code like this in the Xen time code, so I could
make immediate use of it.

    J
