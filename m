Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0JLACq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:02:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab0JLACp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:02:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:in-reply-to:to:from:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=GD9QKMryn/C7JM3bh5YKcNyUqaCqnPkafncDnn2ykU60+H+jJRNkTXnGxLJD+ES8D
	nmPcUDPDeiSspXVkoKFPA==
Subject: [PATCH] Fix a complex race in hrtimer code.
In-Reply-To: <AANLkTimUfWxB_7Y+bpKJKfBemJdy3LDa4f2AT0z2C4kw@mail.gmail.com>
To: akpm@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
From: Salman Qazi <sqazi@google.com>
Date: Mon, 11 Oct 2010 17:02:36 -0700
Message-ID: <20101012000159.7091.84336.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The race is described as follows:

CPU X                                 CPU Y
remove_hrtimer
// state & QUEUED == 0
timer->state = CALLBACK
unlock timer base
timer->f(n) //very long
                                  hrtimer_start
                                    lock timer base
                                    remove_hrtimer // no effect
                                    hrtimer_enqueue
                                    timer->state = CALLBACK |
                                                   QUEUED
                                    unlock timer base
                                  hrtimer_start
                                    lock timer base
                                    remove_hrtimer
                                        mode = INACTIVE
                                        // CALLBACK bit lost!
                                    switch_hrtimer_base
                                            CALLBACK bit not set:
                                                    timer->base
                                                    changes to a
                                                    different CPU.
lock this CPU's timer base

Bug reproducible and fix testable using a kernel module that hrtimer_start()s
a timer with a very long running callback from multiple CPUs:

MODULE_LICENSE("GPL");

static long timer_func_time = 1000;
module_param(timer_func_time, long, 0600);
static long timer_starts = 2500;
module_param(timer_starts, long, 0600);
static long timer_expire = 1000;
module_param(timer_expire, long, 0600);

DEFINE_PER_CPU(struct task_struct *, hrtimer_thread);

/* There are other issues, like deadlocks between multiple hrtimer_start observed
 * calls, at least in 2.6.34 that this lock works around.  Will look into
 * those later.
 */
static DEFINE_SPINLOCK(blah_lock);

static ktime_t mytime;
static struct hrtimer timer;

static enum hrtimer_restart timer_restart(struct hrtimer *timer)
{
        unsigned long i;
        /* We have to make the callback longer to improve the
         * probability of having a race.
         */
        for (i = 0; i < timer_func_time / 100; i++) {
                touch_nmi_watchdog();
                touch_softlockup_watchdog();
                udelay(100);
        }

        return HRTIMER_NORESTART;
}

static int restart_hrtimer_repeatedly(void *input)
{
        int i;
        unsigned long range;
        while (!kthread_should_stop()) {
                for (i = 0; i < timer_starts; i++) {
                        /* Avoid deadlocks for now */
                        spin_lock(&blah_lock);
                        hrtimer_start(&timer, mytime, HRTIMER_MODE_REL);
                        spin_unlock(&blah_lock);
                        touch_nmi_watchdog();
                        touch_softlockup_watchdog();
                }
                cond_resched();
        }
        hrtimer_cancel(&timer);
        return 0;
}

static int hrtimer_unit_test_init(void)
{
        int cpu;
        mytime = ktime_set(0, 0);
        mytime = ktime_add_ns(mytime, timer_expire);
        hrtimer_init(&timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
        timer.function = timer_restart;
        for_each_online_cpu(cpu) {
                per_cpu(hrtimer_thread, cpu) = kthread_create(
                        restart_hrtimer_repeatedly, NULL, "hrtimer_test/%d",
                        cpu);
                if (IS_ERR(per_cpu(hrtimer_thread, cpu))) {
                       printk(KERN_ERR
                                "Failed to create hrtimer test thread\n");
                        BUG();
                }
                kthread_bind(per_cpu(hrtimer_thread, cpu), cpu);
                wake_up_process(per_cpu(hrtimer_thread, cpu));
        }
        return 0;
}

static void hrtimer_unit_test_exit(void)
{
        int cpu;
        for_each_online_cpu(cpu) {
                (void)kthread_stop(per_cpu(hrtimer_thread, cpu));
        }
}

module_init(hrtimer_unit_test_init);
module_exit(hrtimer_unit_test_exit);
---
 kernel/hrtimer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1decafb..57846d5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -944,8 +944,8 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
-				 reprogram);
+		__remove_hrtimer(timer, base,
+				 (timer->state & HRTIMER_STATE_CALLBACK), reprogram);
 		return 1;
 	}
 	return 0;
@@ -1231,6 +1231,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 

