Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1ECGbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:31:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab1ECGbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:31:44 -0400
Date: Tue, 3 May 2011 08:31:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using
 cluster groups v4
Message-ID: <20110503063130.GC7751@elte.hu>
References: <20110502113445.751391656@openvz.org>
 <20110502114024.222582172@openvz.org>
 <20110502132232.GA3873@elte.hu>
 <4DBEB96A.8000309@openvz.org>
 <4DBEBE72.3040702@gmail.com>
 <20110502150552.GA21974@elte.hu>
 <4DBECAB4.7020809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBECAB4.7020809@gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 05/02/2011 07:05 PM, Ingo Molnar wrote:
> ...
> >>
> >>   Ingo, would it be fine to make apic->init() either _before_ this series or 
> >> on top of them (because if I introduce it inside this particular patch it 
> >> would contain some unrelated code snippets such as .init = NULL for all apics 
> >> declaration).
> > 
> > Of course it should be a separate patch - even this patch looks a bit large - 
> > any way to split it up further?
> 
>   Well, for this particular path the only minimum is used, so i fear there is no
> way to split it, probably I could drop some 'cleanup' bits from it and make it
> a separate one. Gimme some time.

Well, first try to do *all* preparatory and cleanup changes that have low 
regression risk.

*Then* keep the most dangerous part to the end of it - so that it's easily 
reverted, should the need arise. Preferably the dangerous part should be much 
smaller than:

 3 files changed, 136 insertions(+), 46 deletions(-)

And no, it is not at all true that there is 'no way' to split the patch up any 
further: you could certainly add the data structures, init methods and such 
support code (which is low regression risk) in a separate patch than the 
changes that modify the existing x2apic_send_IPI_mask_allbutself() function and 
such.

Also, the loop body in the new __x2apic_send_IPI_mask() function could 
certainly be split out into a helper inline, making the code flow clearer.

Thanks,

	Ingo
