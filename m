Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2BINfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:35:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47747 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab2BINfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:35:04 -0500
Date: Thu, 9 Feb 2012 14:34:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120209133446.GD8830@elte.hu>
References: <4F32A907.6030505@gmail.com>
 <20120208174434.GI22598@amd.com>
 <4F32B680.3090502@gmail.com>
 <20120208175709.GK22598@amd.com>
 <20120209073024.GA18010@elte.hu>
 <20120209111451.GM22598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209111451.GM22598@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Feb 09, 2012 at 08:30:24AM +0100, Ingo Molnar wrote:
> > 
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > > which makes sense. It forces 
> > > > perf_session__find_machine_for_cpumode() to return the host 
> > > > machine always.
> > > 
> > > Great, thanks. I will send two patches tomorrow to fix Jason's 
> > > problem and change the default for perf_guest.
> > 
> > Well, if the crash is fixed then the the default can stay, 
> > right?
> 
> David's crash is fixed by changing the default back to its 
> original value :)

Then that's the wrong fix really.

> > Generally we should treat all input data in a perf.data or even 
> > the bits we get in the ring-buffer as external data that has to 
> > be checked carefully, with no assumptions made about data.
> 
> Well, there are two options:
> 
> 	1) Make sure machine == NULL does not happen. Changing the
> 	   default of perf_guest back to false does exactly this for
> 	   David's problem.

So what if it's turned on by the user? Do we still crash 
occasionally?

> 	2) Make sure that a machine == NULL pointer is never
> 	   dereferenced
> 
> I was going to fix it with option 1. Do you suggest option 2 is better?

Looks like the better fix. You said:

> Bottom line is that the perf-tool may receive samples tagged 
> as GUEST_KERNEL even when guest-sampling is disabled (probably 
> a race-condition). The perf-tool can not find a valid machine 
> pointer for such a sample and passes NULL down to the other 
> functions. And some functions don't seem to handle this.

tooling should never be surprised by getting some unexpected 
sample via the perf.data or the ring-buffer - regardless of 
whether that functionality is default enabled or manually 
enabled.

Thanks,

	Ingo
