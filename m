Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2LHAvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:51:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab2LHAvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:51:11 -0500
Date: Fri, 7 Dec 2012 22:49:34 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V3 RFC 2/2] kvm: Handle yield_to failure return code for
 potential undercommit case
Message-ID: <20121208004934.GA7235@amt.cnet>
References: <20121126120740.2595.33651.sendpatchset@codeblue>
 <20121126120804.2595.20280.sendpatchset@codeblue>
 <20121128011228.GH8295@amt.cnet>
 <50B59CE0.70305@linux.vnet.ibm.com>
 <20121203195620.GB590@amt.cnet>
 <50C04236.4020406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C04236.4020406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 12:29:02PM +0530, Raghavendra K T wrote:
> On 12/04/2012 01:26 AM, Marcelo Tosatti wrote:
> >On Wed, Nov 28, 2012 at 10:40:56AM +0530, Raghavendra K T wrote:
> >>On 11/28/2012 06:42 AM, Marcelo Tosatti wrote:
> >>>
> >>>Don't understand the reasoning behind why 3 is a good choice.
> >>
> >>Here is where I came from. (explaining from scratch for
> >>completeness, forgive me :))
> >>In moderate overcommits, we can falsely exit from ple handler even when
> >>we have preempted task of same VM waiting on other cpus. To reduce this
> >>problem, we try few times before exiting.
> >>The problem boils down to:
> >>what is the probability that we exit ple handler even when we have more
> >>than 1 task in other cpus. Theoretical worst case should be around 1.5x
> >>overcommit (As also pointed by Andrew Theurer). [But practical
> >>worstcase may be around 2x,3x overcommits as indicated by the results
> >>for the patch series]
> >>
> >>So if p is the probability of finding rq length one on a particular cpu,
> >>and if we do n tries, then probability of exiting ple handler is:
> >>
> >>  p^(n+1) [ because we would have come across one source with rq length
> >>1 and n target cpu rqs  with length 1 ]
> >>
> >>so
> >>num tries:         probability of aborting ple handler (1.5x overcommit)
> >>  1                 1/4
> >>  2                 1/8
> >>  3                 1/16
> >>
> >>We can increase this probability with more tries, but the problem is
> >>the overhead.
> >>Also, If we have tried three times that means we would have iterated
> >>over 3 good eligible vcpus along with many non-eligible candidates. In
> >>worst case if we iterate all the vcpus, we reduce 1x performance and
> >>overcommit performance get hit. [ as in results ].
> >>
> >>I have tried num_tries = 1,2,3 and n already ( not 4 yet). So I
> >>concluded 3 is enough.
> >>
> >>Infact I have also run kernbench and hackbench which are giving 5-20%
> >>improvement.
> >>
> >>[ As a side note , I also thought how about having num_tries = f(n) =
> >>ceil ( log(num_online_cpus)/2 ) But I thought calculation is too much
> >>overhead and also there is no point in probably making it dependent on
> >>online cpus ]
> >>
> >>Please let me know if you are happy with this rationale/ or correct me
> >>if you foresee some problem. (Infact Avi, Rik's concern about false
> >>exiting made me arrive at 'try' logic which I did not have earlier).
> >>
> >>I am currently trying out the result for 1.5x overcommit will post the
> >>result.
> >
> >Raghavendra
> >
> >Makes sense to me. Thanks.
> >
> 
> Marcelo,
> Do you think this can be considered for next merge window? or you are
> expecting anything else on this patchset.

Nope, not expecting anything else. About merge window, depends on
upstream.

