Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2BTPci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:32:38 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36557 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2BTPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:32:37 -0500
Date: Mon, 20 Feb 2012 10:28:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, riel@redhat.com, amit shah <amit.shah@redhat.com>,
        mtosatti@redhat.com, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com
Subject: Re: [PATCH] BUG in pv_clock when overflow condition is detected
Message-ID: <20120220152855.GA25535@phenom.dumpdata.com>
References: <28a9ca8a-4696-4c9c-bd15-f2fa5558740e@zmail16.collab.prod.int.phx2.redhat.com>
 <4F3D0CB1.5070707@redhat.com>
 <4F3E7150.7000804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3E7150.7000804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F42677D.0041,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 04:25:04PM +0100, Igor Mammedov wrote:
> On 02/16/2012 03:03 PM, Avi Kivity wrote:
> >On 02/15/2012 07:18 PM, Igor Mammedov wrote:
> >>>On 02/15/2012 01:23 PM, Igor Mammedov wrote:
> >>>>>>   static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time
> >>>>>>*shadow)
> >>>>>>   {
> >>>>>>-    u64 delta = native_read_tsc() - shadow->tsc_timestamp;
> >>>>>>+    u64 delta;
> >>>>>>+    u64 tsc = native_read_tsc();
> >>>>>>+    BUG_ON(tsc<   shadow->tsc_timestamp);
> >>>>>>+    delta = tsc - shadow->tsc_timestamp;
> >>>>>>       return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
> >>>>>>                      shadow->tsc_shift);
> >>>>>
> >>>>>Maybe a WARN_ON_ONCE()?  Otherwise a relatively minor hypervisor
> >>>>>bug can
> >>>>>kill the guest.
> >>>>
> >>>>
> >>>>An attempt to print from this place is not perfect since it often
> >>>>leads
> >>>>to recursive calling to this very function and it hang there
> >>>>anyway.
> >>>>But if you insist I'll re-post it with WARN_ON_ONCE,
> >>>>It won't make much difference because guest will hang/stall due
> >>>>overflow
> >>>>anyway.
> >>>
> >>>Won't a BUG_ON() also result in a printk?
> >>Yes, it will. But stack will still keep failure point and poking
> >>with crash/gdb at core will always show where it's BUGged.
> >>
> >>In case it manages to print dump somehow (saw it couple times from ~
> >>30 test cycles), logs from console or from kernel message buffer
> >>(again poking with gdb) will show where it was called from.
> >>
> >>If WARN* is used, it will still totaly screwup clock and
> >>"last value" and system will become unusable, requiring looking with
> >>gdb/crash at the core any way.
> >>
> >>So I've just used more stable failure point that will leave trace
> >>everywhere it manages (maybe in console log, but for sure in stack)
> >>in case of WARN it might leave trace on console or not and probably
> >>won't reflect failure point in stack either leaving only kernel
> >>message buffer for clue.
> >>
> >
> >Makes sense.  But do get an ack from the Xen people to ensure this
> >doesn't break for them.
> >
> Konrad, Ian
> 
> Could you please review patch form point of view of xen?
> Whole thread could be found here https://lkml.org/lkml/2012/2/13/286

What are the conditions under which this happens? You should probably
include that in the git description as well? Is this something that happens
often? If there is an overflow can you synthesize a value instead of
crashing the guest?

Hm, so are you asking for review for this patch or for
http://www.spinics.net/lists/kvm/msg68440.html ?

(which would also entail a early_percpu_clock_init implementation
in the Xen code naturally).

