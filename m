Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab2HWRWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:22:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52890 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2HWRWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:22:32 -0400
Date: Thu, 23 Aug 2012 10:14:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
Message-ID: <20120823171431.GG2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
 <alpine.LFD.2.02.1208231245510.2856@ionos>
 <20120823154346.GB2465@linux.vnet.ibm.com>
 <CA+icZUXq9p4yOuse5dzCb2FGmgSKdU8ufDkDcTjWJ0dE79tvUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXq9p4yOuse5dzCb2FGmgSKdU8ufDkDcTjWJ0dE79tvUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082317-2398-0000-0000-000009B516F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 06:06:23PM +0200, Sedat Dilek wrote:
> On Thu, Aug 23, 2012 at 5:43 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

[ . . . ]

> Applying this patch on top of my local GIT tree results in error-messages:
> 
> [...]
>   CC      kernel/rcupdate.o
>   AS      arch/x86/platform/efi/efi_stub_64.o
>   CC      arch/x86/kernel/irqinit.o
>   LD      arch/x86/platform/efi/built-in.o
> arch/x86/platform/efi/efi_64.o:(.rodata+0x0): multiple definition of
> `softirq_stop_idle_mask'
> arch/x86/platform/efi/efi.o:(.rodata+0x50): first defined here
> make[5]: *** [arch/x86/platform/efi/built-in.o] Error 1
> make[4]: *** [arch/x86/platform/efi] Error 2
> make[3]: *** [arch/x86/platform] Error 2
> make[3]: *** Waiting for unfinished jobs....
> [...]
> 
> $ LC_ALL=C grep softirq_stop_idle_mask -nr linux-next/arch/x86/platform/efi/
> Binary file linux-next/arch/x86/platform/efi/efi.o matches
> Binary file linux-next/arch/x86/platform/efi/efi_64.o matches

Right...  Clearly I was spinning a bit too quickly on that one.  :-/
So back to old tech: C-preprocessor macros.

This one actually builds, boots, and passes mild rcutorture testing
under KVM.

							Thanx, Paul

-------------------------------------------------------------------------

time: RCU permitted to stop idle entry via softirq

The can_stop_idle_tick() function complains if a softirq vector is
raised too late in the idle-entry process, presumably in order to
prevent dangling softirq invocations from being delayed across the
full idle period, which might be indefinitely long -- and if softirq
was asserted any later than the call to this function, such a delay
might well happen.

However, RCU needs to be able to use softirq to stop idle entry in
order to be able to drain RCU callbacks from the current CPU, which in
turn enables faster entry into dyntick-idle mode, which in turn reduces
power consumption.  Because RCU takes this action at a well-defined
point in the idle-entry path, it is safe for RCU to take this approach.

This commit therefore silences the error message that is sometimes
produced when the going-idle CPU suddenly finds that it has an RCU_SOFTIRQ
to process.  The error message will continue to be issued for other
softirq vectors.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c5f856a..5e4e617 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -430,6 +430,8 @@ enum
 	NR_SOFTIRQS
 };
 
+#define SOFTIRQ_STOP_IDLE_MASK (~(1 << RCU_SOFTIRQ))
+
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 024540f..4b1785a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -436,7 +436,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
 
-		if (ratelimit < 10) {
+		if (ratelimit < 10 &&
+		    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
 			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 			       (unsigned int) local_softirq_pending());
 			ratelimit++;

