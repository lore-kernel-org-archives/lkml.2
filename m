Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1ECT3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:29:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36286 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1ECT3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:29:50 -0400
Date: Mon, 2 May 2011 23:25:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110503062528.GV2294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
 <20110429083618.GL2191@linux.vnet.ibm.com>
 <20110429083904.GA12987@linux.vnet.ibm.com>
 <20110429180239.GA32566@redhat.com>
 <20110430125928.GJ2297@linux.vnet.ibm.com>
 <20110502105612.GJ18376@redhat.com>
 <20110502133608.GA4197@linux.vnet.ibm.com>
 <20110502141002.GK18376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502141002.GK18376@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:10:03PM +0300, Gleb Natapov wrote:
> On Mon, May 02, 2011 at 06:36:08AM -0700, Paul E. McKenney wrote:
> > On Mon, May 02, 2011 at 01:56:12PM +0300, Gleb Natapov wrote:
> > > On Sat, Apr 30, 2011 at 05:59:28AM -0700, Paul E. McKenney wrote:
> > > > On Fri, Apr 29, 2011 at 09:02:39PM +0300, Gleb Natapov wrote:
> > > > > On Fri, Apr 29, 2011 at 01:39:04AM -0700, Paul E. McKenney wrote:
> > > > > > On Fri, Apr 29, 2011 at 01:36:18AM -0700, Paul E. McKenney wrote:
> > > > > > > On Thu, Apr 28, 2011 at 12:52:02PM +0300, Gleb Natapov wrote:
> > > > > > > 
> > > > > > > Hmmm....  This is interesting.  KVM being a module, we either expand
> > > > > > > TINY_RCU's size a bit by making rcu_note_context_switch() be a real
> > > > > > > function in rcutiny.c and adding an export, or we expand it by adding
> > > > > > > two exports.
> > > > > > > 
> > > > > > > I would like to solve this without making TINY_RCU larger, and preferably
> > > > > > > by making it smaller.  Any ideas come to mind?  (Other than making
> > > > > > > KVM depend on CONFIG_SMP, which sounds too much like throwing out the
> > > > > > > baby with the bathwater.)
> > > > > > 
> > > > > > Nothing quite like hitting "send" to make an idea show up...
> > > > > > 
> > > > > > In a UP kernel, does it actually help anything to have KVM
> > > > > > tell RCU about executing in a guest?  If not, could we have a
> > > > > > rcu_note_context_switch_kvm() that is a static inline empty function in
> > > > > > TINY_RCU and maps to rcu_note_context_switch() for TREE_RCU?
> > > > > > 
> > > > > That will work, but does making rcu_note_context_switch() out of line
> > > > > actually increase kernel size? The function is called in two places
> > > > > currently, so by making it out of line we make two calling site smaller.
> > > > > Will measure it next week.
> > > > 
> > > > One thing to keep in mind...  Calling an out-of-line function from
> > > > KVM requires an export, each of which significantly increases TINY_RCU's
> > > > memory footprint.
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > How significantly? As I wrote in other mail I compiled two TINY_RCU
> > > kernel with and without the patch and I didn't see memory footprint
> > > increase at all. May be I measure it incorrectly, but what I see is that
> > > with out of line function + export text section becomes 64 byte bigger, but
> > > data section becomes 64 byte smaller:
> > > 
> > >    text    data     bss     dec     hex filename
> > > 4544134  590596 2023424 7158154  6d398a vmlinux     inline
> > > 4544198  590532 2023424 7158154  6d398a vmlinux.ol  out of line
> > 
> > Did you add the exports that would be needed to allow KVM to call
> > the functions in the inline case?
> > 
> Yes, this is with and without patch applied. When patch is applied the
> function is out of line and exported.

OK, here is what I am suggesting -- create a separate API for virtualization,
make it be an empty static inline function for TINY, and make it a wrapper
for TREE.  This gets rid of the export in the TINY case, and takes advantage
of the single-CPU constraint in the TINY case.  So this gains the benefit
of uninlining rcu_note_context_switch(), but avoids paying the cost of the
EXPORT_SYMBOL_GPL().

Then you call rcu_virt_note_context_switch() in place of
rcu_note_context_switch() from KVM.

Does this make sense?

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/rcutiny.h |    8 ++++++++
 include/linux/rcutree.h |   10 ++++++++++
 kernel/rcutiny.c        |    1 -
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 8e5f7cf..3cc60c0 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -96,6 +96,14 @@ static inline int rcu_needs_cpu(int cpu)
 extern void rcu_note_context_switch(int cpu);
 
 /*
+ * Take advantage of the fact that there is only one CPU, which
+ * allows us to ignore virtualization-based context switches.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+}
+
+/*
  * Return the number of grace periods.
  */
 static inline long rcu_batches_completed(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 284dad1..e65d066 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,6 +35,16 @@ extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
 
+/*
+ * Note a virtualization-based context switch.  This is simply a
+ * wrapper around rcu_note_context_switch(), which allows TINY_RCU
+ * to save a few bytes.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+	rcu_note_context_switch(cpu);
+}
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void exit_rcu(void);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 44d6479..8071010 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -83,7 +83,6 @@ void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch();
 }
-EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 /*
  * Helper function for rcu_sched_qs() and rcu_bh_qs().
