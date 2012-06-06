Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab2FFXF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:05:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51102 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759280Ab2FFXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:05:53 -0400
Date: Thu, 7 Jun 2012 02:05:44 +0300
From: Ido Yariv <ido@wizery.com>
To: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Message-ID: <20120606230544.GA25288@WorkStation.localnet>
References: <1334873492-31255-1-git-send-email-ido@wizery.com>
 <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
 <1339003443.23343.6.camel@twins>
 <9B14D1490DDECA4E974F6B9FC9EBAB317EEFC74FD0@VMBX108.ihostexchange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B14D1490DDECA4E974F6B9FC9EBAB317EEFC74FD0@VMBX108.ihostexchange.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 06, 2012 at 06:18:12PM -0400, Shai Fultheim (Shai@ScaleMP.com) wrote:
> Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] wrote
> > On Wed, 2012-06-06 at 09:18 -0700, tip-bot for Shai Fultheim wrote:
> > 
> > > [ I absolutely hate these locking patterns ... yet I have no better idea.  Maybe the gents on Cc: ... ]
> > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > 
> > Oh yuck, this is vile..
> > 
> > static struct static_key scale_mp_trainwreck = STATIC_KEY_INIT_FALSE;
> > 
> > static DEFINE_SPINLOCK(_cpa_lock);
> > 
> > static inline void cpa_lock(void)
> > {
> > 	if (static_key_false(&scale_mp_trainwreck))
> > 		return;
> > 
> > 	spin_lock(&_cpa_lock);
> > }
> > 
> > static inline void cpa_unlock(void)
> > {
> > 	if (static_key_false(&scale_mp_trainwreck))
> > 		return;
> > 
> > 	spin_lock(&_cpa_lock);
> > }
> > 
> > And then use cpa_{,un}lock(), and the scale-mp guys can
> > static_key_slow_inc(&scale_mp_trainwreck).
> > 
> > [ and yes I hate those jump_label names ... but I'm not wanting
> >   to go through another round of bike-shed painting. ]
> 
> Looks pretty straight forward to do.  
> We will try this route, as I'm concerned that synthetic CPUID bit will be kind of a global change for a pretty local consideration.
> 
> Comments?

The synthetic CPUID bit approach has the advantage of setting this bit
from the platform initialization code independently (in this case, in
vsmp_64.c) instead of calling platform specific functions from
pageattr.c (such as is_vsmp_box()) or exporting the static_key variable.

We'll give this a shot and send a revised patch after testing it.

Sounds good?

Thanks,
Ido.
