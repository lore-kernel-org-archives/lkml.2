Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1HJJfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:35:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:14784 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1HJJfp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:8:1>);
	Wed, 10 Aug 2011 05:35:45 -0400
Message-Id: <4E426D4702000078000508B5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 10 Aug 2011 10:36:39 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Matt Fleming" <matt@console-pimps.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <hpa@linux.intel.com>,
        "Avi Kivity" <avi@redhat.com>, <mjg@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>,
        "johnstultz" <johnstul@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
 <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
 <4E4009A50200007800050258@nat28.tlf.novell.com>
 <20110810090330.GF26762@elte.hu>
In-Reply-To: <20110810090330.GF26762@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.08.11 at 11:03, Ingo Molnar <mingo@elte.hu> wrote:

> * Jan Beulich <JBeulich@novell.com> wrote:
> 
>> >>> On 08.08.11 at 15:40, Matt Fleming <matt@console-pimps.org> wrote:
>> > On Fri, 2011-08-05 at 18:04 +0100, Jan Beulich wrote:
>> >> 
>> >> Virtual platforms will have to take care of the serialization in the
>> >> host anyway, so the guest side implementation of getwallclock et al
>> >> is entirely unaffected.
>> > 
>> > Ah, OK, that's the important part. I didn't realise that rtc_lock isn't
>> > actually required by any other code. In which case, yes, it completely
>> > makes sense to push the locking of rtc_lock down into the
>> > implementations that actually need it.
>> > 
>> > It'd be great if I could get some ACK's from the virtualization guys.
>> > 
>> > --------8<--------
>> > 
>> > From a0a39dbb69f6ac675846bf00f30ad153506a4567 Mon Sep 17 00:00:00 2001
>> > From: Matt Fleming <matt.fleming@intel.com>
>> > Date: Mon, 8 Aug 2011 12:59:35 +0100
>> > Subject: [PATCH] x86, efi: Don't recursively acquire rtc_lock
>> > 
>> > A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
>> > Serialize EFI time accesses on rtc_lock") because efi_get_time() and
>> > friends can be called with rtc_lock already held by
>> > read_persistent_time(), e.g.
>> > 
>> > timekeeping_init()
>> >     read_persistent_clock()     <-- acquire rtc_lock
>> >         efi_get_time()
>> >             phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
>> > 
>> > To fix this let's push the locking down into the get_wallclock() and
>> > set_wallclock() implementations. Only the clock implementations that
>> > access the x86 RTC directly need to acquire rtc_lock, so it makes
>> > sense to push the locking down into the rtc, vrtc and efi code.
>> > 
>> > The virtualization implementations don't require rtc_lock to be held
>> > because they provide their own serialization.
>> > 
>> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
>> 
>> Acked-by: Jan Beulich <jbeulich@novell.com>
> 
> How urgent is thix fix - can it wait until Thomas comes back and 
> starts processing patches again?

Without it booting on EFI can't be expected to work (and while I was
really sure I tested this before submitting, I apparently must have
used a stale kernel then - I'm really sorry for that), so getting it
applied soon would be rather desirable.

But then again I don't seem to be able to boot 3.0.1 with both patches
applied on my only EFI box, so there must be something else that
broke, and hence maybe I really did test it (on 3.0-rc7) and it worked
then. Debugging...

Jan

