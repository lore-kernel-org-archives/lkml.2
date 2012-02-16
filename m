Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab2BPODl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:03:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2BPODj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:03:39 -0500
Message-ID: <4F3D0CB1.5070707@redhat.com>
Date: Thu, 16 Feb 2012 16:03:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
        amit shah <amit.shah@redhat.com>, mtosatti@redhat.com
Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
References: <28a9ca8a-4696-4c9c-bd15-f2fa5558740e@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <28a9ca8a-4696-4c9c-bd15-f2fa5558740e@zmail16.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 07:18 PM, Igor Mammedov wrote:
> > On 02/15/2012 01:23 PM, Igor Mammedov wrote:
> > >>>   static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time
> > >>> *shadow)
> > >>>   {
> > >>> -    u64 delta = native_read_tsc() - shadow->tsc_timestamp;
> > >>> +    u64 delta;
> > >>> +    u64 tsc = native_read_tsc();
> > >>> +    BUG_ON(tsc<  shadow->tsc_timestamp);
> > >>> +    delta = tsc - shadow->tsc_timestamp;
> > >>>       return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
> > >>>                      shadow->tsc_shift);
> > >>
> > >> Maybe a WARN_ON_ONCE()?  Otherwise a relatively minor hypervisor
> > >> bug can
> > >> kill the guest.
> > >
> > >
> > > An attempt to print from this place is not perfect since it often
> > > leads
> > > to recursive calling to this very function and it hang there
> > > anyway.
> > > But if you insist I'll re-post it with WARN_ON_ONCE,
> > > It won't make much difference because guest will hang/stall due
> > > overflow
> > > anyway.
> > 
> > Won't a BUG_ON() also result in a printk?
> Yes, it will. But stack will still keep failure point and poking
> with crash/gdb at core will always show where it's BUGged.
>
> In case it manages to print dump somehow (saw it couple times from ~
> 30 test cycles), logs from console or from kernel message buffer
> (again poking with gdb) will show where it was called from.
>
> If WARN* is used, it will still totaly screwup clock and 
> "last value" and system will become unusable, requiring looking with
> gdb/crash at the core any way.
>
> So I've just used more stable failure point that will leave trace
> everywhere it manages (maybe in console log, but for sure in stack)
> in case of WARN it might leave trace on console or not and probably
> won't reflect failure point in stack either leaving only kernel
> message buffer for clue.
>

Makes sense.  But do get an ack from the Xen people to ensure this
doesn't break for them.


-- 
error compiling committee.c: too many arguments to function

