Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1GJSMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:12:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab1GJSM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:12:28 -0400
Date: Sun, 10 Jul 2011 20:12:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110710181205.GA21375@elte.hu>
References: <20110707053036.173186930@google.com>
 <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins>
 <CAPM31RKH8m1CpVWmRVLi8bMNSgdQU+Qzc2sTaWbx4r1b2fHF7w@mail.gmail.com>
 <1310121147.3282.706.camel@twins>
 <CAPM31RLy4hvaRUi5iVeOyEapRtguR5rNUrn+3oGax_Mm3GxqTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RLy4hvaRUi5iVeOyEapRtguR5rNUrn+3oGax_Mm3GxqTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Paul Turner <pjt@google.com> wrote:

> Finally introducing jump labels when there are no constrained 
> groups claws back a good portion of the remaining time.
> 
> Add jump labels:
>                             cycles                  instructions
>      branches
> ----------------------------------------------------------------------------------------------------
> base                	    893,486,206 	    840,904,951 	    160,076,980
> +unconstrained      	    900,477,543 (+0.78)	    890,310,950 (+5.88)	
>   161,037,844 (+0.60)
> +10000000000/1000:  	    921,436,697 (+3.13)	    919,362,792 (+9.33)	
>   168,491,279 (+5.26)
> +10000000000/10000: 	    907,214,638 (+1.54)	    894,406,875 (+6.36)	
>   165,743,207 (+3.54)
> +10000000000/100000:	    918,094,542 (+2.75)	    910,211,234 (+8.24)	
>   167,841,828 (+4.85)
> +10000000000/1000000:	    910,698,725 (+1.93)	    885,385,460 (+5.29)	
>    166,406,742 (+3.95)

That looks pretty promising!

The +5% instruction count still looks a tad high to me: if there are 
about 1000 instructions in this particular contex-switch critical 
path then 5% means +50 instructions - a 'disabled' feature sure 
should not use that many instructions, right?

Also, i have a testing suggestion, i'd suggest to run:

	taskset 1 perf stat ...

to only measure while pinned on a single CPU. This will remove a lot 
of cross-CPU noise from the context switching overhead.

This is a valid way to progress because we are interested in the 
typical context-switch overhead on a single CPU - we know that 
there's no SMP cost when constraining is disabled.

Doing that should bring your measurement noise below the 0.1% range i 
suspect. As you are shaving off cycle after cycle i think you'll need 
that kind of measurement precision ...

Thanks,

	Ingo
