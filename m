Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1B0RVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:21:09 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:58327 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab1B0RVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:21:07 -0500
Date: Sun, 27 Feb 2011 18:20:52 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110227172052.GB2474@nik-comp.lan>
References: <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz> <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz> <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D67C077.6060108@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4668956 records (last update: 20110227)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was not aware of the thread.  Please cc me directly, or add a keyword  
> I track - timekeeping, TSC..
Hello Zachary, thanks for Your time looking at this!
> That change alone may not bisect well; without further fixes on top of  
> it, you may end up with a hang or stall, which is likely to manifest in  
> a vendor-specific way.
I'm not sure I really understand You here, but this change is exactly to
what I got while bisecting. With later revisions, including this one,
32bit SMP guests don't boot, before it, they do..
>
> Basically there were a few differences in the platform code about how  
> TSC was dealt with on systems which did not have stable clocks, this  
> brought the logic into one location, but there was a slight change to  
> the logic here.
>
> Note very carefully, the logic on SVM is gated by a condition before  
> this change:
>
>         if (unlikely(cpu != vcpu->cpu)) {
> -               u64 delta;
> -
> -               if (check_tsc_unstable()) {
> -                       /*
> -                        * Make sure that the guest sees a monotonically
> -                        * increasing TSC.
> -                        */
> -                       delta = vcpu->arch.host_tsc - native_read_tsc();
> -                       svm->vmcb->control.tsc_offset += delta;
> -                       if (is_nested(svm))
> -                               svm->nested.hsave->control.tsc_offset +=  
> delta;
> -               }
> -               vcpu->cpu = cpu;
> -               kvm_migrate_timers(vcpu);
>
>
> So this only happens with a system which reports TSC as unstable.  After  
> the change, KVM itself may report the TSC as unstable:
>
> +       if (unlikely(vcpu->cpu != cpu)) {
> +               /* Make sure TSC doesn't go backwards */
> +               s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
> +                               native_read_tsc() -  
> vcpu->arch.last_host_tsc;
> +               if (tsc_delta < 0)
> +                       mark_tsc_unstable("KVM discovered backwards TSC");
> +               if (check_tsc_unstable())
> +                       kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
> +               kvm_migrate_timers(vcpu);
> +               vcpu->cpu = cpu;
> +       }
>
> If the platform has very small TSC deltas across CPUs, but indicates the  
> TSC is stable, this could result in KVM marking the TSC unstable.  If  
> that is the case, this compensation logic will kick in to avoid  
> backwards TSCs.
>
> Note however, that the logic is not perfect; time which passes while not  
> running on any CPU will be erased, as the delta compensation removes not  
> just backwards, but any elapsed time from the TSC.  In extreme cases,  
> this could result in time appearing to stand still.... with guests  
> failing to boot.
>
> This was addressed with a later change, which catches up the missing time:
>
> commit c285545f813d7b0ce989fd34e42ad1fe785dc65d
yes, but this change is already included in 2.6.37, so maybe some other fix is needed?
if You have some idea what could be changed, I'll gladly test whatever You recommend,
but I'm afraid that's all I can do, since this is a bit of a rocket science for me, sorry :(
nik




> Author: Zachary Amsden <zamsden@redhat.com>
> Date:   Sat Sep 18 14:38:15 2010 -1000
>
>     KVM: x86: TSC catchup mode
>
>     Negate the effects of AN TYM spell while kvm thread is preempted by  
> tracking
>     conversion factor to the highest TSC rate and catching the TSC up  
> when it has
>     fallen behind the kernel view of time.  Note that once triggered, we 
> don't
>     turn off catchup mode.
>
>     A slightly more clever version of this is possible, which only does  
> catchup
>     when TSC rate drops, and which specifically targets only CPUs with  
> broken
>     TSC, but since these all are considered unstable_tsc(), this patch  
> covers
>     all necessary cases.
>
>     Signed-off-by: Zachary Amsden <zamsden@redhat.com>
>     Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
