Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1DMTd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:33:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46554 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab1DMTd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=N8pa5s4+OtagjxIF4vPQE/GJWn6hpKOTSGe2uT2dYs2nED3ixXA5ZAe/aZJOpqX1IV
         RSYJ2kQiykdXlrcLjfligKPZN32qSfNTgtUu1f7Zvq8WxJhax8gGZh2Noy+4dYH84foD
         U2hqD8pNA7LFyzszaKeQLqrdnAvRRzSjyfFEk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Shaun Ruffell <sruffell@digium.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper MSR register to catch" and NMIs
Date: Wed, 13 Apr 2011 21:33:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>
References: <20110406223036.GA15721@digium.com>
In-Reply-To: <20110406223036.GA15721@digium.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104132133.51958.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33252
for your bug report, please add your address to the CC list in there, thanks!

On czwartek, 7 kwietnia 2011 o 00:30:36 Shaun Ruffell wrote:
> Hello Don,
> 
> With 2.6.39-rc2 I was seeing the following NMIs when building the kernel:
> 
> [  191.647131] Uhhuh. NMI received for unknown reason 21 on CPU 3.
> [  191.650068] Do you have a strange power saving mode enabled?
> [  191.650068] Dazed and confused, but trying to continue
> [  676.020001] Uhhuh. NMI received for unknown reason 21 on CPU 1.
> [  676.020001] Do you have a strange power saving mode enabled?
> [  676.020001] Dazed and confused, but trying to continue
> [  892.520335] Starting new kernel
> 
> I'm running on a Dell PowerEdge 2600 with the following processor:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 2
> model name      : Intel(R) Xeon(TM) CPU 3.06GHz
> stepping        : 7
> ...
> 
> I was able to bisect it down to commit 242214f9c1eeaae40, but I'm not
> certain where to go from here.  Is this something that is already known
> or is there more information I should try to collect?
> 
> Here is the commit for reference:
> 
> commit 242214f9c1eeaae40eca11e3b4d37bfce960a7cd
> Author: Don Zickus <dzickus@redhat.com>
> Date:   Thu Mar 24 23:36:25 2011 +0300
> 
>     perf, x86: P4 PMU - Read proper MSR register to catch unflagged
> overflows
> 
>     The read of a proper MSR register was missed and instead of
>     counter the configration register was tested (it has
>     ARCH_P4_UNFLAGGED_BIT always cleared) leading to unknown NMI
>     hitting the system. As result the user may obtain "Dazed and
>     confused, but trying to continue" message. Fix it by reading a
>     proper MSR register.
> 
>     When an NMI happens on a P4, the perf nmi handler checks the
>     configuration register to see if the overflow bit is set or not
>     before taking appropriate action.  Unfortunately, various P4
>     machines had a broken overflow bit, so a backup mechanism was
>     implemented.  This mechanism checked to see if the counter
>     rolled over or not.
> 
>     A previous commit that implemented this backup mechanism was
>     broken. Instead of reading the counter register, it used the
>     configuration register to determine if the counter rolled over
>     or not. Reading that bit would give incorrect results.
> 
>     This would lead to 'Dazed and confused' messages for the end
>     user when using the perf tool (or if the nmi watchdog is
>     running).
> 
>     The fix is to read the counter register before determining if
>     the counter rolled over or not.
> 
>     Signed-off-by: Don Zickus <dzickus@redhat.com>
>     Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>     Cc: Lin Ming <ming.m.lin@intel.com>
>     LKML-Reference: <4D8BAB49.3080701@openvz.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c
> b/arch/x86/kernel/cpu/perf_event_p4.c index 3769ac8..d3d7b59 100644
> --- a/arch/x86/kernel/cpu/perf_event_p4.c
> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct
> hw_perf_event *hwc) * the counter has reached zero value and continued
> counting before * real NMI signal was received:
>  	 */
> +	rdmsrl(hwc->event_base, v);
>  	if (!(v & ARCH_P4_UNFLAGGED_BIT))
>  		return 1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
