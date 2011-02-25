Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1BYOpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:45:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1BYOpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:45:16 -0500
Message-ID: <4D67C077.6060108@redhat.com>
Date: Fri, 25 Feb 2011 09:45:11 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz> <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz> <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz>
In-Reply-To: <20110225104823.GD29840@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 05:48 AM, Nikola Ciprich wrote:
> (CC: Zachary)
>
> Hello,
> Zachary, in case You haven't noticed the thread, we're trying
> to find out the reason why 32bit SMP guests stopped working
> in 2.6.37.
> bisect shows this as the culprit:
>    

I was not aware of the thread.  Please cc me directly, or add a keyword 
I track - timekeeping, TSC..

> e48672fa25e879f7ae21785c7efd187738139593 is first bad commit
> commit e48672fa25e879f7ae21785c7efd187738139593
> Author: Zachary Amsden<zamsden@redhat.com>
> Date:   Thu Aug 19 22:07:23 2010 -1000
>
>      KVM: x86: Unify TSC logic
>
>      Move the TSC control logic from the vendor backends into x86.c
>      by adding adjust_tsc_offset to x86 ops.  Now all TSC decisions
>      can be done in one place.
>
>      Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>      Signed-off-by: Marcelo Tosatti<mtosatti@redhat.com>
>    

That change alone may not bisect well; without further fixes on top of 
it, you may end up with a hang or stall, which is likely to manifest in 
a vendor-specific way.

Basically there were a few differences in the platform code about how 
TSC was dealt with on systems which did not have stable clocks, this 
brought the logic into one location, but there was a slight change to 
the logic here.

Note very carefully, the logic on SVM is gated by a condition before 
this change:

         if (unlikely(cpu != vcpu->cpu)) {
-               u64 delta;
-
-               if (check_tsc_unstable()) {
-                       /*
-                        * Make sure that the guest sees a monotonically
-                        * increasing TSC.
-                        */
-                       delta = vcpu->arch.host_tsc - native_read_tsc();
-                       svm->vmcb->control.tsc_offset += delta;
-                       if (is_nested(svm))
-                               svm->nested.hsave->control.tsc_offset += 
delta;
-               }
-               vcpu->cpu = cpu;
-               kvm_migrate_timers(vcpu);


So this only happens with a system which reports TSC as unstable.  After 
the change, KVM itself may report the TSC as unstable:

+       if (unlikely(vcpu->cpu != cpu)) {
+               /* Make sure TSC doesn't go backwards */
+               s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
+                               native_read_tsc() - 
vcpu->arch.last_host_tsc;
+               if (tsc_delta < 0)
+                       mark_tsc_unstable("KVM discovered backwards TSC");
+               if (check_tsc_unstable())
+                       kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
+               kvm_migrate_timers(vcpu);
+               vcpu->cpu = cpu;
+       }

If the platform has very small TSC deltas across CPUs, but indicates the 
TSC is stable, this could result in KVM marking the TSC unstable.  If 
that is the case, this compensation logic will kick in to avoid 
backwards TSCs.

Note however, that the logic is not perfect; time which passes while not 
running on any CPU will be erased, as the delta compensation removes not 
just backwards, but any elapsed time from the TSC.  In extreme cases, 
this could result in time appearing to stand still.... with guests 
failing to boot.

This was addressed with a later change, which catches up the missing time:

commit c285545f813d7b0ce989fd34e42ad1fe785dc65d
Author: Zachary Amsden <zamsden@redhat.com>
Date:   Sat Sep 18 14:38:15 2010 -1000

     KVM: x86: TSC catchup mode

     Negate the effects of AN TYM spell while kvm thread is preempted by 
tracking
     conversion factor to the highest TSC rate and catching the TSC up 
when it has
     fallen behind the kernel view of time.  Note that once triggered, 
we don't
     turn off catchup mode.

     A slightly more clever version of this is possible, which only does 
catchup
     when TSC rate drops, and which specifically targets only CPUs with 
broken
     TSC, but since these all are considered unstable_tsc(), this patch 
covers
     all necessary cases.

     Signed-off-by: Zachary Amsden <zamsden@redhat.com>
     Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

