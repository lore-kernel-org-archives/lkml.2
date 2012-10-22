Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2JVRZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:25:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45484 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab2JVRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <1350925299.8609.978.camel@edumazet-glaptop>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	<1350925299.8609.978.camel@edumazet-glaptop>
Date: Mon, 22 Oct 2012 10:25:42 -0700
X-Google-Sender-Auth: Lpc5AQbYv5lzv1VzRI4rbaa7dqQ
Message-ID: <CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
Subject: Re: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:01 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> This looks like a corruption of s->sequence, and is value is odd, even
> if no writer is alive.
>
> Does local_bh_disable() disables preemption on RT ?

Hmmm....

With PREEMPT_RT_FULL defined (as we have):

void local_bh_disable(void)
{
        migrate_disable();
        current->softirq_nestcnt++;
}

And the RT patches add the following:

#ifdef CONFIG_PREEMPT_RT_FULL
# define preempt_disable_rt()          preempt_disable()
# define preempt_enable_rt()           preempt_enable()
# define preempt_disable_nort()                do { } while (0)
# define preempt_enable_nort()         do { } while (0)
# ifdef CONFIG_SMP
   extern void migrate_disable(void);
   extern void migrate_enable(void);
# else /* CONFIG_SMP */
#  define migrate_disable()            do { } while (0)
#  define migrate_enable()             do { } while (0)
# endif /* CONFIG_SMP */
#else
# define preempt_disable_rt()          do { } while (0)
# define preempt_enable_rt()           do { } while (0)
# define preempt_disable_nort()                preempt_disable()
# define preempt_enable_nort()         preempt_enable()
# define migrate_disable()             preempt_disable()
# define migrate_enable()              preempt_enable()
#endif

And since we are not SMP, local_bh_disable() essentially does nothing.
 These definitions are consistent across all the RT patches, up to
3.6.2-rt4 (as far as I can tell).

Now, is preemption required to be disabled in non-SMP systems?
