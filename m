Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2JVTYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:24:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39049 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2JVTYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	<1350925299.8609.978.camel@edumazet-glaptop>
	<CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
Date: Mon, 22 Oct 2012 12:24:49 -0700
X-Google-Sender-Auth: fJNsky6cli3JuCvtgpmFABq-XHg
Message-ID: <CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
Subject: Re: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, is preemption required to be disabled in non-SMP systems?

I did more digging, and I found this.

In linux/netfilter/x_tables.h, there is the definition of
xt_write_recseq_begin.  This function updates the sequence number for
the sequence locks.  This is called in the iptables kernel code.  From
the header for the function:

/**
 * xt_write_recseq_begin - start of a write section
 *
 * Begin packet processing : all readers must wait the end
 * 1) Must be called with preemption disabled
 * 2) softirqs must be disabled too (or we should use irqsafe_cpu_add())
 * Returns :
 *  1 if no recursion on this cpu
 *  0 if recursion detected
 */

Note #1.  Your earlier response what that local_bh_disable should
disable preemption.  Indeed, looking at the calls to
xt_write_recseq_begin in the code, all are preceeded by a call to
local_bh_disable().  This call (local_bh_disable) is modified by the
RT patch.  The standard kernel calls __local_bh_disable, which does
quite a bit of work.  From the standard kernel:

static inline void _local_bh_enable_ip(unsigned long ip)
{
        WARN_ON_ONCE(in_irq() || irqs_disabled());
#ifdef CONFIG_TRACE_IRQFLAGS
        local_irq_disable();
#endif
        /*
         * Are softirqs going to be turned on now:
         */
        if (softirq_count() == SOFTIRQ_DISABLE_OFFSET)
                trace_softirqs_on(ip);
        /*
         * Keep preemption disabled until we are done with
         * softirq processing:
         */
        sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);

        if (unlikely(!in_interrupt() && local_softirq_pending()))
                do_softirq();

        dec_preempt_count();
#ifdef CONFIG_TRACE_IRQFLAGS
        local_irq_enable();
#endif
        preempt_check_resched();
}

But the patch changes things:

void local_bh_disable(void)
{
       migrate_disable();
       current->softirq_nestcnt++;
}

And the call to migrate_disable() is defined as a macro, depending
upon the configuration.  From the patch:

#ifdef CONFIG_PREEMPT_RT_FULL
# define preempt_disable_rt()           preempt_disable()
# define preempt_enable_rt()            preempt_enable()
# define preempt_disable_nort()         do { } while (0)
# define preempt_enable_nort()          do { } while (0)
# ifdef CONFIG_SMP
   extern void migrate_disable(void);
   extern void migrate_enable(void);
# else /* CONFIG_SMP */
#  define migrate_disable()             do { } while (0)
#  define migrate_enable()              do { } while (0)
# endif /* CONFIG_SMP */
#else
# define preempt_disable_rt()           do { } while (0)
# define preempt_enable_rt()            do { } while (0)
# define preempt_disable_nort()         preempt_disable()
# define preempt_enable_nort()          preempt_enable()
# define migrate_disable()              preempt_disable()
# define migrate_enable()               preempt_enable()
#endif

In our configuration, we have CONFIG_PREEMPT_RT_FULL defined, and do
not have CONFIG_SMP defined.  So migrate_enable() becomes a NOP.  This
seems to violate the requirement on the xt_write_recseq_begin
requirement.  However, enabling SMP does enable the actual function.

Should local_bh_disable() call the actual function in non-SMP systems
to meet the requirements for xt_write_recseq_begin()?
