Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab2FFWSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:18:17 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:23644 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2FFWSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:18:16 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ido@wizery.com" <ido@wizery.com>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 6 Jun 2012 18:18:12 -0400
Subject: RE: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Thread-Topic: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Thread-Index: Ac1ECTOquSzc4insTfKVBsH9sAtFdwAKF2KQ
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317EEFC74FD0@VMBX108.ihostexchange.net>
References: <1334873492-31255-1-git-send-email-ido@wizery.com>
	 <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
 <1339003443.23343.6.camel@twins>
In-Reply-To: <1339003443.23343.6.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] wrote
> On Wed, 2012-06-06 at 09:18 -0700, tip-bot for Shai Fultheim wrote:
> 
> > [ I absolutely hate these locking patterns ... yet I have no better idea.  Maybe the gents on Cc: ... ]
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Oh yuck, this is vile..
> 
> static struct static_key scale_mp_trainwreck = STATIC_KEY_INIT_FALSE;
> 
> static DEFINE_SPINLOCK(_cpa_lock);
> 
> static inline void cpa_lock(void)
> {
> 	if (static_key_false(&scale_mp_trainwreck))
> 		return;
> 
> 	spin_lock(&_cpa_lock);
> }
> 
> static inline void cpa_unlock(void)
> {
> 	if (static_key_false(&scale_mp_trainwreck))
> 		return;
> 
> 	spin_lock(&_cpa_lock);
> }
> 
> And then use cpa_{,un}lock(), and the scale-mp guys can
> static_key_slow_inc(&scale_mp_trainwreck).
> 
> [ and yes I hate those jump_label names ... but I'm not wanting
>   to go through another round of bike-shed painting. ]

Looks pretty straight forward to do.  
We will try this route, as I'm concerned that synthetic CPUID bit will be kind of a global change for a pretty local consideration.

Comments?

(and we will also fix the other error pointed by Ingo - we are missing an include in this patch)

Regards,
Shai.
