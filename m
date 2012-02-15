Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2BORST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:18:19 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46104 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2BORSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:18:18 -0500
Date: Wed, 15 Feb 2012 12:18:06 -0500 (EST)
From: Igor Mammedov <imammedo@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
        amit shah <amit.shah@redhat.com>, mtosatti@redhat.com
Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
Message-ID: <28a9ca8a-4696-4c9c-bd15-f2fa5558740e@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4F3BBADC.7020305@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.4.220]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Avi Kivity" <avi@redhat.com>
> To: "Igor Mammedov" <imammedo@redhat.com>
> Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
> riel@redhat.com, "amit shah" <amit.shah@redhat.com>, mtosatti@redhat.com
> Sent: Wednesday, February 15, 2012 3:02:04 PM
> Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
> 
> On 02/15/2012 01:23 PM, Igor Mammedov wrote:
> >>>   static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time
> >>> *shadow)
> >>>   {
> >>> -    u64 delta = native_read_tsc() - shadow->tsc_timestamp;
> >>> +    u64 delta;
> >>> +    u64 tsc = native_read_tsc();
> >>> +    BUG_ON(tsc<  shadow->tsc_timestamp);
> >>> +    delta = tsc - shadow->tsc_timestamp;
> >>>       return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
> >>>                      shadow->tsc_shift);
> >>
> >> Maybe a WARN_ON_ONCE()?  Otherwise a relatively minor hypervisor
> >> bug can
> >> kill the guest.
> >
> >
> > An attempt to print from this place is not perfect since it often
> > leads
> > to recursive calling to this very function and it hang there
> > anyway.
> > But if you insist I'll re-post it with WARN_ON_ONCE,
> > It won't make much difference because guest will hang/stall due
> > overflow
> > anyway.
> 
> Won't a BUG_ON() also result in a printk?
Yes, it will. But stack will still keep failure point and poking
with crash/gdb at core will always show where it's BUGged.

In case it manages to print dump somehow (saw it couple times from ~
30 test cycles), logs from console or from kernel message buffer
(again poking with gdb) will show where it was called from.

If WARN* is used, it will still totaly screwup clock and 
"last value" and system will become unusable, requiring looking with
gdb/crash at the core any way.

So I've just used more stable failure point that will leave trace
everywhere it manages (maybe in console log, but for sure in stack)
in case of WARN it might leave trace on console or not and probably
won't reflect failure point in stack either leaving only kernel
message buffer for clue.

> 
> >
> > If there is an intention to keep guest functional after the event
> > then
> > maybe this patch is a way to go
> >   http://www.spinics.net/lists/kvm/msg68463.html
> > this way clock will be re-silent to this kind of errors, like
> > bare-metal
> > one is.
> 
> It's the same patch... do you mean something that detects the
> overflow
> and uses the last value?
I'm sorry, pasted wrong link
here it goes: 
  "pvclock: Make pv_clock more robust and fixup it if overflow happens"
     http://www.spinics.net/lists/kvm/msg68440.html

> 
> --
> error compiling committee.c: too many arguments to function
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
