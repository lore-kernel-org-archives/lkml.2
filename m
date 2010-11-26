Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0KZW3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:29:43 -0500
Received: from claw.goop.org ([74.207.240.146]:32905 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0KZW3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:29:42 -0500
Message-ID: <4CF034D4.70005@goop.org>
Date: Fri, 26 Nov 2010 14:29:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>, Glauber Costa <glommer@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Olivier Hanesse <olivier.hanesse@gmail.com>,
        Avi Kivity <avi@redhat.com>, Eelco Dolstra <e.dolstra@tudelft.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/pvclock-xen: zero last_value on resume
References: <4CC708DE.1070000@goop.org> <4CEACFAB.90503@goop.org> <20101126104047.GA9798@elte.hu>
In-Reply-To: <20101126104047.GA9798@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 02:40 AM, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> On 10/26/2010 09:59 AM, Jeremy Fitzhardinge wrote:
>>> If the guest domain has been suspend/resumed or migrated, then the
>>> system clock backing the pvclock clocksource may revert to a smaller
>>> value (ie, can be non-monotonic across the migration/save-restore).
>>> Make sure we zero last_value in that case so that the domain
>>> continues to see clock updates.
>> Ping?  Looks like this fell through the gaps.
> Does not apply cleanly here - mind resending the latest version?

It rebased cleanly to 2.6.37-rc3.  You can pull it from:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git pvclock-resume

Jeremy Fitzhardinge (1):
      x86/pvclock: zero last_value on resume

 arch/x86/include/asm/pvclock.h |    1 +
 arch/x86/kernel/pvclock.c      |    5 +++++
 arch/x86/xen/time.c            |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

Thanks,
	J

Subject: [PATCH] x86/pvclock: zero last_value on resume

If the guest domain has been suspend/resumed or migrated, then the
system clock backing the pvclock clocksource may revert to a smaller
value (ie, can be non-monotonic across the migration/save-restore).
Make sure we zero last_value in that case so that the domain
continues to see clock updates.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 7f7e577..31d84ac 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -11,6 +11,7 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
+void pvclock_resume(void);
 
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 008b91e..42eb330 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -83,6 +83,11 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
+void pvclock_resume(void)
+{
+	atomic64_set(&last_value, 0);
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index b2bb5aa..5da5e53 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -426,6 +426,8 @@ void xen_timer_resume(void)
 {
 	int cpu;
 
+	pvclock_resume();
+
 	if (xen_clockevent != &xen_vcpuop_clockevent)
 		return;
 


