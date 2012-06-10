Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2FJPr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 11:47:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46959 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2FJPrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 11:47:25 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 10 Jun 2012 17:47:24 +0200
Message-ID: <CA+icZUUD+oHPK=L6iHg-FfkpXVCPQTKHuzwDo9EaYYjYmYePCA@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/kvmclock.c:127
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see the same warning especially when resuming from a suspend (see
timestamps >=30-35sec) between Linux v3.5-rc1..v3.5-rc2.

$ sudo grep kvmclock.c /var/log/kern.log
Jun  4 21:11:32 fambox kernel: [  784.037237] WARNING: at
arch/x86/kernel/kvmclock.c:127
kvm_check_and_clear_guest_paused+0x52/0x60()
Jun  5 20:35:57 fambox kernel: [ 1928.458060] WARNING: at
arch/x86/kernel/kvmclock.c:127
kvm_check_and_clear_guest_paused+0x52/0x60()
Jun  8 09:35:52 fambox kernel: [ 3290.134637] WARNING: at
arch/x86/kernel/kvmclock.c:127
kvm_check_and_clear_guest_paused+0x52/0x60()
Jun  8 09:35:52 fambox kernel: [ 3290.238592] WARNING: at
arch/x86/kernel/kvmclock.c:127
kvm_check_and_clear_guest_paused+0x52/0x60()
Jun  8 12:11:20 fambox kernel: [ 5777.023571] WARNING: at
arch/x86/kernel/kvmclock.c:127
kvm_check_and_clear_guest_paused+0x52/0x60()
Jun  9 13:32:50 fambox kernel: [ 2778.842695] WARNING: at
arch/x86/kernel/kvmclock.c:127
kvm_check_and_clear_guest_paused+0x52/0x60()

>From [1]:

"...The warning itself is not required for the check_and_clear
function and can be removed as far as I am concerned."

>From [2] commit 3b5d56b9317fa7b5407dff1aa7b115bf6cdbd494 ("kvmclock:
Add functions to check if the host has stopped the vm")
...
+bool kvm_check_and_clear_guest_paused(void)
+{
+       bool ret = false;
+       struct pvclock_vcpu_time_info *src;
+
+       /*
+        * per_cpu() is safe here because this function is only called from
+        * timer functions where preemption is already disabled.
+        */
+       WARN_ON(!in_atomic());
+       src = &__get_cpu_var(hv_clock);
+       if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
+               __this_cpu_and(hv_clock.flags, ~PVCLOCK_GUEST_STOPPED);
+               ret = true;
+       }
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
+
...
( The export macro was dropped in a followup commit. )

So you mean "WARN_ON(!in_atomic());" can be deleted?

Regards,
- Sedat -

[1] http://www.spinics.net/lists/kvm/msg73732.html
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/kernel/kvmclock.c;h=4ba090ca689db5322fb242b98b53158de5447dc9;hp=f8492da65bfcb03e2775638ad5ce9502099d62c8;hb=3b5d56b9317fa7b5407dff1aa7b115bf6cdbd494;hpb=eae3ee7d8a7c59cf63441dedf28674889f5fc477
