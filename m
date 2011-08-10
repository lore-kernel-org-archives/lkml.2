Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1HJJEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:04:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59019 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1HJJEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:04:45 -0400
Date: Wed, 10 Aug 2011 11:03:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@linux.intel.com,
        Avi Kivity <avi@redhat.com>, mjg@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
Message-ID: <20110810090330.GF26762@elte.hu>
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
 <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
 <4E4009A50200007800050258@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4009A50200007800050258@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 08.08.11 at 15:40, Matt Fleming <matt@console-pimps.org> wrote:
> > On Fri, 2011-08-05 at 18:04 +0100, Jan Beulich wrote:
> >> 
> >> Virtual platforms will have to take care of the serialization in the
> >> host anyway, so the guest side implementation of getwallclock et al
> >> is entirely unaffected.
> > 
> > Ah, OK, that's the important part. I didn't realise that rtc_lock isn't
> > actually required by any other code. In which case, yes, it completely
> > makes sense to push the locking of rtc_lock down into the
> > implementations that actually need it.
> > 
> > It'd be great if I could get some ACK's from the virtualization guys.
> > 
> > --------8<--------
> > 
> > From a0a39dbb69f6ac675846bf00f30ad153506a4567 Mon Sep 17 00:00:00 2001
> > From: Matt Fleming <matt.fleming@intel.com>
> > Date: Mon, 8 Aug 2011 12:59:35 +0100
> > Subject: [PATCH] x86, efi: Don't recursively acquire rtc_lock
> > 
> > A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> > Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> > friends can be called with rtc_lock already held by
> > read_persistent_time(), e.g.
> > 
> > timekeeping_init()
> >     read_persistent_clock()     <-- acquire rtc_lock
> >         efi_get_time()
> >             phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
> > 
> > To fix this let's push the locking down into the get_wallclock() and
> > set_wallclock() implementations. Only the clock implementations that
> > access the x86 RTC directly need to acquire rtc_lock, so it makes
> > sense to push the locking down into the rtc, vrtc and efi code.
> > 
> > The virtualization implementations don't require rtc_lock to be held
> > because they provide their own serialization.
> > 
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> 
> Acked-by: Jan Beulich <jbeulich@novell.com>

How urgent is thix fix - can it wait until Thomas comes back and 
starts processing patches again?

Thanks,

	Ingo
