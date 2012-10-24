Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2JXEcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:32:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56401 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2JXEct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:32:49 -0400
Subject: Re: Process Hang in __read_seqcount_begin
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter LaDow <petela@gocougs.wsu.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	 <1350925299.8609.978.camel@edumazet-glaptop>
	 <CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
	 <CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
	 <CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 06:32:44 +0200
Message-ID: <1351053164.6537.95.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 17:15 -0700, Peter LaDow wrote:
> (Sorry for the subject change, but I wanted to try and pull in those
> who work on RT issues, and the subject didn't make that obvious.
> Please search for the same subject without the RT Linux trailing
> text.)
> 
> Well, more information.  Even with SMP enabled (and presumably the
> migrate_enable having calls to preempt_disable), we still got the
> lockup in iptables-restore.  I did more digging, and it looks like the
> complete stack trace includes a call from iptables-restore (through
> setsockopt with IPT_SO_SET_ADD_COUNTERS).  This seems to be a
> potential multiple writer case where the counters are updated through
> the syscall and the kernel is updating the counters as it filters
> packets.
> 
> I think there might be a race on the update to xt_recseq.sequence,
> since the RT patches remove the spinlock in seqlock_t.  Thus multiple
> writers can corrupt the sequence count. 



>  And I thought the SMP
> configuration would disable preemption when local_bh_disable() is
> called.  And indeed, looking at the disassembly, I see
> preempt_disable() (though optimized, goes to add_preempt_count() ) is
> being called.
> 
> Yet we still see the lockup in the get_counters() in iptables.  Which,
> it seems, is because of some sort of problem with the sequence.  It
> doesn't appear to be related to the preemption, and perhaps there is
> some other corruption of the sequence counter happening.  But the only
> places I see it modified is in xt_write_recseq_begin and
> xt_write_recseq_end, which is only in the netfilter code
> (ip6_tables.c, ip_tables.c, and arp_tables.c).  And every single call
> is preceeded by a call to local_bh_disable().
> 
> This problem is a huge one for us.  And so far I'm unable to track
> down how this is occurring.
> 
> Any other tips?  I presume this is the proper place for RT issues.

Hmm...

Could you try following patch ?

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8d674a7..053f9e7 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -471,30 +471,24 @@ DECLARE_PER_CPU(seqcount_t, xt_recseq);
  *
  * Begin packet processing : all readers must wait the end
  * 1) Must be called with preemption disabled
- * 2) softirqs must be disabled too (or we should use this_cpu_add())
  * Returns :
  *  1 if no recursion on this cpu
  *  0 if recursion detected
  */
 static inline unsigned int xt_write_recseq_begin(void)
 {
-	unsigned int addend;
-
+	unsigned int old, new;
+	seqcount_t *ptr = &__get_cpu_var(xt_recseq);
 	/*
 	 * Low order bit of sequence is set if we already
 	 * called xt_write_recseq_begin().
 	 */
-	addend = (__this_cpu_read(xt_recseq.sequence) + 1) & 1;
-
-	/*
-	 * This is kind of a write_seqcount_begin(), but addend is 0 or 1
-	 * We dont check addend value to avoid a test and conditional jump,
-	 * since addend is most likely 1
-	 */
-	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
-
-	return addend;
+	old = ptr->sequence;
+	new = old | 1;
+	/* Note : cmpxchg() is a memory barrier, we dont need smp_wmb() */
+	if (old != new && cmpxchg(&ptr->sequence, old, new) == old)
+		return 1;
+	return 0;
 }
 
 /**


