Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1KCKHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:07:31 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:35970 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1KCKH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:07:29 -0400
Message-ID: <1320314844.2989.6.camel@br98xy6r>
Subject: Re: [PATCH] kdump: Fix crash_kexec - smp_send_stop race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>, Don Zickus <dzickus@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org
Date: Thu, 03 Nov 2011 11:07:24 +0100
In-Reply-To: <20111031033948.a0edb7f3.akpm@linux-foundation.org>
References: <1319639649.3321.11.camel@br98xy6r>
	 <20111028161143.e5ebf617.akpm@linux-foundation.org>
	 <1320055036.2796.8.camel@br98xy6r>
	 <20111031033948.a0edb7f3.akpm@linux-foundation.org>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Mon, 2011-10-31 at 03:39 -0700, Andrew Morton wrote:
> On Mon, 31 Oct 2011 10:57:16 +0100 Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> 
> > > Should this be done earlier in the function?  As it stands we'll have
> > > multiple CPUs scribbling on buf[] at the same time and all trying to
> > > print the same thing at the same time, dumping their stacks, etc. 
> > > Perhaps it would be better to single-thread all that stuff
> > 
> > My fist patch took the spinlock at the beginning of panic(). But then
> > Eric asked, if it wouldn't be better to get both panic printk's and I
> > agreed.
> 
> Hm, why?  It will make a big mess.
> 
> > > Also...  this patch affects all CPU architectures, all configs, etc. 
> > > So we're expecting that every architecture's smp_send_stop() is able to
> > > stop a CPU which is spinning in spin_lock(), possibly with local
> > > interrupts disabled.  Will this work?
> > 
> > At least on s390 it will work. If there are architectures that can't
> > stop disabled CPUs then this problem is already there without this
> > patch.
> > 
> > Example:
> > 
> > 1. 1st CPU gets lock X and panics
> > 2. 2nd CPU is disabled and gets lock X
> 
> (irq-disabled)
> 
> > 3. 1st CPU calls smp_send_stop()
> >    -> 2nd CPU loops disabled and can't be stopped
> 
> Well OK.  Maybe some architectures do have this problem - who would
> notice?  If that is the case, we just made the failure cases much more
> common.

Ok, next idea: What, if the CPUs wait irq-enabled in panic until they
get stopped by smp_send_stop()?

See patch below:
---
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic

When two CPUs call panic at the same time there is a possible race
condition that can stop kdump.  The first CPU calls crash_kexec() and the
second CPU calls smp_send_stop() in panic() before crash_kexec() finished
on the first CPU.  So the second CPU stops the first CPU and therefore
kdump fails:

1st CPU:
panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump

2nd CPU:
panic()->crash_kexec()->kexec_mutex already held by 1st CPU
       ->smp_send_stop()-> stop 1st CPU (stop kdump)

This patch fixes the problem by introducing a spinlock in panic that
allows only one CPU to process crash_kexec() and the subsequent panic
code.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/panic.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
  */
 NORET_TYPE void panic(const char * fmt, ...)
 {
+	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
 	va_list args;
 	long i, i_next = 0;
@@ -68,8 +69,16 @@ NORET_TYPE void panic(const char * fmt,
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
+	 *
+	 * Only one CPU is allowed to execute the panic code from here. For
+	 * multiple parallel invocations of panic, all other CPUs will wait
+	 * until they are stopped by the 1st CPU with smp_send_stop().
 	 */
-	preempt_disable();
+	if (!spin_trylock(&panic_lock)) {
+		local_irq_enable();
+		while (1)
+			cpu_relax();
+	}
 
 	console_verbose();
 	bust_spinlocks(1);




