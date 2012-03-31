Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2CaLn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 07:43:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48407 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2CaLny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 07:43:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6665"; a="177644995"
From: "Subhash Jadavani" <subhashj@codeaurora.org>
To: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>, "'Chris Ball'" <cjb@laptop.org>
References: <000501cd0f31$6af70480$40e50d80$@codeaurora.org>
In-Reply-To: <000501cd0f31$6af70480$40e50d80$@codeaurora.org>
Subject: __blk_end_request vs blk_end_request
Date: Sat, 31 Mar 2012 17:13:45 +0530
Message-ID: <001801cd0f33$89daf7b0$9d90e710$@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0019_01CD0F61.A393F700"
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFun9URdPPGx3hfLSgH4YNw5LT/W5dBI2yw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_0019_01CD0F61.A393F700
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

For completing any block request, MMC block driver is calling:
       spin_lock_irq(queue)
       _blk_end_request()
       spin_unlock_irq(queue)

But if we analyze the sources of latency in kernel using ftrace,
__blk_end_request() function seems to hold a spinlock with interrupts
disabled for up to 6.5 ms sometimes. Attached is ftrace output for this
function.

__blk_end_request() calls couple of functions and ftrace output shows =
that
blk_update_bidi_request() function is almost taking 6ms. So I was =
wondering
why can=92t we use the blk_end_request() rather than =
__blk_end_request(). Both
function does the same thing except blk_end_request() doesn=92t take up =
the
spinlock while calling the blk_update_bidi_request().

Is there any race condition which could occur if we call
blk_update_bidi_request() without queue lock? I looked into
blk_update_bidi_request() function and I mainly updates bio's of a =
request
and doesn't look to do any manipulation with request queue structure of
block device. There are many block drivers (SCSI, IDE etc =85) other =
than MMC
uses blk_end_request() rather than __blk_end_request(). =A0
Was there any special reason we are using __blk_end_request() in MMC =
block
driver? If there is no specific reason, I would like to post a patch =
which
would make MMC driver to use blk_end_request().

Let me know your thoughts on this.

Regards,
Subhash
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora =
Forum.




------=_NextPart_000_0019_01CD0F61.A393F700
Content-Type: text/plain;
	name="ftrace-output.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ftrace-output.txt"

The calltrace is as follows:

# tracer: preemptirqsoff
#
# preemptirqsoff latency trace v1.1.5 on 3.0.8-perf-00005-g2a087eb-dirty
# --------------------------------------------------------------------
# latency: 6928 us, #3319/3319, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 =
#P:1)
#    -----------------
#    | task: mmcqd/0-72 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  =3D> started at: _raw_spin_lock_irq
#  =3D> ended at:   _raw_spin_unlock_irq
#
#
#                  _------=3D> CPU#
#                 / _-----=3D> irqs-off
#                | / _----=3D> need-resched
#                || / _---=3D> hardirq/softirq
#                ||| / _--=3D> preempt-depth
#                |||| /     delay
#  cmd     pid   ||||| time  |   caller
#     \   /      |||||  \    |   /
 mmcqd/0-72      0d.h2    0us : sub_preempt_count <-irq_exit
 mmcqd/0-72      0d..3    0us : rcu_irq_exit <-irq_exit
 mmcqd/0-72      0d..3    0us : rcu_enter_nohz <-rcu_irq_exit
 mmcqd/0-72      0d..3    0us : idle_cpu <-irq_exit
 mmcqd/0-72      0d..3    0us : sub_preempt_count <-irq_exit
 mmcqd/0-72      0d..2    0us : perf_mon_interrupt_out <-handle_IRQ
 mmcqd/0-72      0...1    0us : _raw_spin_unlock_irqrestore
 mmcqd/0-72      0...1    0us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d...    0us : trace_hardirqs_off <-_raw_spin_lock_irq
 mmcqd/0-72      0d...    0us : add_preempt_count <-_raw_spin_lock_irq
 mmcqd/0-72      0d..1    0us : _raw_spin_unlock_irq <-wait_for_common
 mmcqd/0-72      0...1    0us : _raw_spin_unlock_irq
 mmcqd/0-72      0...1    0us+: sub_preempt_count <-_raw_spin_unlock_irq
 mmcqd/0-72      0d...   31us : trace_hardirqs_off <-_raw_spin_lock_irq
 mmcqd/0-72      0d...   31us : add_preempt_count <-_raw_spin_lock_irq
 mmcqd/0-72      0d..1   31us : __blk_end_request <-mmc_blk_issue_rw_rq
 mmcqd/0-72      0d..1   31us : blk_update_bidi_request =
<-__blk_end_request
 mmcqd/0-72      0d..1   31us : blk_update_request =
<-blk_update_bidi_request
 mmcqd/0-72      0d..1   31us : __rcu_read_lock <-blk_update_request
 mmcqd/0-72      0d..1   31us : add_preempt_count <-blk_update_request
 mmcqd/0-72      0d..2   31us : sub_preempt_count <-blk_update_request
 mmcqd/0-72      0d..1   31us : __rcu_read_unlock <-blk_update_request
 mmcqd/0-72      0d..1   31us : req_bio_endio <-blk_update_request
 mmcqd/0-72      0d..1   31us : bio_endio <-req_bio_endio
 mmcqd/0-72      0d..1   31us : ext4_end_bio <-bio_endio
 mmcqd/0-72      0d..1   31us+: bio_put <-ext4_end_bio
 mmcqd/0-72      0d..1   61us : bio_fs_destructor <-bio_put
 mmcqd/0-72      0d..1   61us : bio_free <-bio_fs_destructor
 mmcqd/0-72      0d..1   61us : bvec_free_bs <-bio_free
 mmcqd/0-72      0d..1   61us : kmem_cache_free <-bvec_free_bs
 mmcqd/0-72      0d..1   61us : mempool_free <-bio_free
 mmcqd/0-72      0d..1   61us : mempool_free_slab <-mempool_free
 mmcqd/0-72      0d..1   61us : kmem_cache_free <-mempool_free_slab
 mmcqd/0-72      0d..1   61us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1   61us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1   61us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1   61us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1   61us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2   61us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3   92us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2   92us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2   92us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3   92us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2   92us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3   92us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2   92us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2   92us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2   92us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1   92us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1   92us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1   92us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1   92us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  122us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  122us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  122us : __wake_up <-__wake_up_bit
 mmcqd/0-72      0d..1  122us : _raw_spin_lock_irqsave <-__wake_up
 mmcqd/0-72      0d..1  122us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  122us : __wake_up_common <-__wake_up
 mmcqd/0-72      0d..2  122us : wake_bit_function <-__wake_up_common
 mmcqd/0-72      0d..2  122us : autoremove_wake_function =
<-wake_bit_function
 mmcqd/0-72      0d..2  122us : default_wake_function =
<-autoremove_wake_function
 mmcqd/0-72      0d..2  122us : try_to_wake_up <-default_wake_function
 mmcqd/0-72      0d..2  122us : _raw_spin_lock_irqsave <-try_to_wake_up
 mmcqd/0-72      0d..2  122us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..3  122us : task_waking_fair <-try_to_wake_up
 mmcqd/0-72      0d..3  122us : select_task_rq_fair <-try_to_wake_up
 mmcqd/0-72      0d..3  122us+: __rcu_read_lock <-select_task_rq_fair
 mmcqd/0-72      0d..3  153us : __rcu_read_unlock <-select_task_rq_fair
 mmcqd/0-72      0d..3  153us : _raw_spin_lock <-try_to_wake_up
 mmcqd/0-72      0d..3  153us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4  153us : ttwu_do_activate.clone.0 =
<-try_to_wake_up
 mmcqd/0-72      0d..4  153us : ttwu_activate <-ttwu_do_activate.clone.0
 mmcqd/0-72      0d..4  153us : activate_task <-ttwu_activate
 mmcqd/0-72      0d..4  153us : enqueue_task <-activate_task
 mmcqd/0-72      0d..4  153us : update_rq_clock <-enqueue_task
 mmcqd/0-72      0d..4  153us : msm_gpt_read <-sched_clock
 mmcqd/0-72      0d..4  153us : msm_read_timer_count <-msm_gpt_read
 mmcqd/0-72      0d..4  153us : enqueue_task_fair <-enqueue_task
 mmcqd/0-72      0d..4  153us : update_curr <-enqueue_task_fair
 mmcqd/0-72      0d..4  153us : cpuacct_charge <-update_curr
 mmcqd/0-72      0d..4  153us : __rcu_read_lock <-cpuacct_charge
 mmcqd/0-72      0d..4  153us+: __rcu_read_unlock <-cpuacct_charge
 mmcqd/0-72      0d..4  183us : place_entity <-enqueue_task_fair
 mmcqd/0-72      0d..4  183us : __enqueue_entity <-enqueue_task_fair
 mmcqd/0-72      0d..4  183us : ttwu_do_wakeup =
<-ttwu_do_activate.clone.0
 mmcqd/0-72      0d..4  183us : check_preempt_curr <-ttwu_do_wakeup
 mmcqd/0-72      0d..4  183us : check_preempt_wakeup =
<-check_preempt_curr
 mmcqd/0-72      0d..4  183us : update_curr <-check_preempt_wakeup
 mmcqd/0-72      0d..4  183us : wakeup_preempt_entity =
<-check_preempt_wakeup
 mmcqd/0-72      0d..4  183us : _raw_spin_unlock <-try_to_wake_up
 mmcqd/0-72      0d..4  183us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3  183us : _raw_spin_unlock_irqrestore =
<-try_to_wake_up
 mmcqd/0-72      0d..3  183us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..2  183us : _raw_spin_unlock_irqrestore <-__wake_up
 mmcqd/0-72      0d..2  183us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  183us+: put_page <-put_io_page
 mmcqd/0-72      0d..1  214us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  214us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  214us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  214us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  214us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  214us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  214us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  214us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  214us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  214us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  214us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  214us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  214us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  214us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  214us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  244us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  244us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  244us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  244us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  244us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  244us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  244us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  244us : put_page <-put_io_page
 mmcqd/0-72      0d..1  244us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  244us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  244us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  244us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  244us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  244us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  275us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  275us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  275us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  275us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  275us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  275us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  275us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  275us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  275us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  275us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  275us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  275us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  275us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  275us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  275us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  305us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  305us : put_page <-put_io_page
 mmcqd/0-72      0d..1  305us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  305us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  305us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  305us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  305us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  305us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  305us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  305us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  305us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  305us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  305us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  336us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  336us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  336us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  336us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  336us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  336us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  336us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  336us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  336us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  336us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  336us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  336us : put_page <-put_io_page
 mmcqd/0-72      0d..1  336us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  336us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  336us+: end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  366us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  366us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  366us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  366us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  366us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  366us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  366us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  366us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  366us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  366us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  366us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  366us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  366us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  366us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  366us+: __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  397us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  397us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  397us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  397us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  397us : put_page <-put_io_page
 mmcqd/0-72      0d..1  397us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  397us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  397us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  397us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  397us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  397us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  397us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  397us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  397us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  397us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  427us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  427us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  427us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  427us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  427us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  427us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  427us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  427us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  427us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  427us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  427us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  427us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  427us : put_page <-put_io_page
 mmcqd/0-72      0d..1  427us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  427us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  458us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  458us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  458us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  458us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  458us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  458us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  458us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  458us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  458us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  458us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  458us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  458us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  458us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  458us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  458us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  488us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  488us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  488us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  488us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  488us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  488us : put_page <-put_io_page
 mmcqd/0-72      0d..1  488us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  488us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  488us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  488us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  488us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  488us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  488us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  488us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  488us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  519us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  519us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  519us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  519us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  519us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  519us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  519us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  519us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  519us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  519us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  519us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  519us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  519us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  519us : put_page <-put_io_page
 mmcqd/0-72      0d..1  519us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  549us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  549us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  549us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  549us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  549us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  549us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  549us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  549us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  549us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  549us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  549us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  549us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  549us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  549us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  549us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  580us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  580us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  580us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  580us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  580us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  580us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  580us : put_page <-put_io_page
 mmcqd/0-72      0d..1  580us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  580us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  580us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  580us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  580us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  580us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  580us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  580us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  610us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  610us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  610us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  610us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  610us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  610us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  610us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  610us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  610us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  610us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  610us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  610us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  610us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  610us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  610us+: put_page <-put_io_page
 mmcqd/0-72      0d..1  641us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  641us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  641us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  641us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  641us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  641us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  641us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  641us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  641us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  641us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  641us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  641us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  641us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  671us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  671us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  671us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  671us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  671us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  671us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  671us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  671us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  671us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  671us : put_page <-put_io_page
 mmcqd/0-72      0d..1  671us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  671us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  671us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  671us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  671us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  702us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  702us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  702us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  702us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  702us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  702us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  702us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  702us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  702us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  702us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  702us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  702us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  702us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  702us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  702us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  732us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  732us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  732us : put_page <-put_io_page
 mmcqd/0-72      0d..1  732us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  732us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  732us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  732us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  732us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  732us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  732us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  732us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  732us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  732us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  732us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3  732us+: add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4  763us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4  763us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3  763us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  763us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  763us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3  763us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4  763us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4  763us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3  763us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  763us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  763us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  763us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  763us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  763us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  763us+: __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  794us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  794us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  794us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  794us : put_page <-put_io_page
 mmcqd/0-72      0d..1  794us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  794us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  794us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  794us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  794us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  794us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  794us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  794us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  794us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  794us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  824us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  824us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  824us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  824us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  824us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  824us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  824us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  824us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  824us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  824us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  824us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  824us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  824us : put_page <-put_io_page
 mmcqd/0-72      0d..1  824us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  824us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  855us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  855us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  855us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  855us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  855us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  855us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  855us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  855us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  855us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  855us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  855us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  855us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  855us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  855us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  855us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  885us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  885us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  885us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  885us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  885us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  885us : put_page <-put_io_page
 mmcqd/0-72      0d..1  885us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  885us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  885us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  885us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  885us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  885us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  885us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  885us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  916us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  916us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  916us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  916us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  916us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  916us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  916us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  916us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  916us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  916us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  916us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  916us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  916us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  916us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  916us : put_page <-put_io_page
 mmcqd/0-72      0d..1  916us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  946us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  946us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  946us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  946us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  946us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  946us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  946us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  946us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2  946us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  946us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  946us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3  946us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2  946us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2  946us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2  977us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1  977us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  977us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1  977us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1  977us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2  977us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1  977us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1  977us : put_page <-put_io_page
 mmcqd/0-72      0d..1  977us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1  977us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1  977us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1  977us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1  977us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1  977us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2  977us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1007us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1007us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1007us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1007us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1007us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1007us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1007us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1007us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1007us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1007us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1007us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1007us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1007us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1038us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1038us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1038us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1038us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1038us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1038us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1038us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1038us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1038us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1038us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1038us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1038us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1038us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1038us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1038us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1068us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1068us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1068us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1068us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1068us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1068us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1068us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1068us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1068us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1068us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1068us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1068us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1068us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1068us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1068us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1099us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1099us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1099us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1099us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1099us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1099us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1099us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1099us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1099us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1099us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1099us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1099us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1099us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1099us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1099us+: __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1129us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1129us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1129us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1129us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1129us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1129us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1129us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1129us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1129us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1129us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1129us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1129us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1129us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1129us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1160us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1160us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1160us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1160us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1160us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1160us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1160us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1160us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1160us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1160us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1160us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1160us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1160us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1160us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1160us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1190us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1190us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1190us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1190us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1190us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1190us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1190us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1190us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1190us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1190us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1190us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1190us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1190us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1190us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1190us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1221us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1221us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1221us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1221us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1221us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1221us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1221us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1221us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1221us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1221us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1221us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1221us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1221us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1221us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1221us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1251us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1251us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1251us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1251us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1251us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1251us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1251us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1251us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1251us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1251us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1251us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1251us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1251us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1251us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1251us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1282us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1282us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1282us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1282us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1282us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1282us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1282us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 1282us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 1282us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 1282us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 1282us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1282us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1282us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1282us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1282us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1312us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1312us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1312us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1312us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1312us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1312us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1312us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1312us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1312us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1312us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1312us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1312us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1312us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1312us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1312us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1343us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1343us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1343us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1343us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1343us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1343us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1343us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1343us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1343us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1343us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1343us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1343us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1343us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1373us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1373us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1373us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1373us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1373us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1373us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1373us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1373us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1373us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1373us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1373us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1373us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1373us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1373us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1373us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1404us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1404us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1404us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1404us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1404us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1404us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1404us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1404us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1404us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1404us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1404us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1404us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1404us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1404us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1404us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1434us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1434us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1434us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1434us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1434us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1434us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1434us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1434us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1434us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1434us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1434us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1434us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1434us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1434us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1434us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1465us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1465us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1465us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1465us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1465us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1465us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1465us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1465us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1465us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1465us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1465us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1465us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1465us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1465us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1465us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1495us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1495us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1495us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1495us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1495us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1495us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1495us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1495us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1495us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1495us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1495us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1495us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1495us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1495us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1495us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 1526us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1526us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1526us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1526us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1526us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1526us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1526us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1526us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1526us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1526us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1526us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1526us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1526us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1526us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1526us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1557us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1557us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1557us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1557us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1557us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1557us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1557us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1557us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1557us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1557us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1557us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1557us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1557us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1557us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1587us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1587us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1587us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1587us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1587us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1587us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1587us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1587us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1587us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1587us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1587us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1587us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1587us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1587us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1587us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1618us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1618us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1618us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1618us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1618us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1618us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1618us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1618us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1618us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1618us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1618us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1618us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1618us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1618us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1618us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1648us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1648us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1648us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1648us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1648us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1648us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1648us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1648us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1648us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1648us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1648us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1648us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1648us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1648us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1648us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1679us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1679us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1679us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1679us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1679us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1679us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1679us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1679us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1679us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1679us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1679us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1679us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1679us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1679us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1679us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1709us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1709us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1709us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1709us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1709us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1709us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1709us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1709us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1709us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1709us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1709us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1709us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1709us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1740us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1740us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1740us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1740us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1740us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1740us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1740us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1740us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1740us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1740us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1740us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1740us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1740us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1740us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1740us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1770us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1770us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1770us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1770us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1770us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1770us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1770us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1770us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1770us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1770us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1770us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1770us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1770us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1770us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1770us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1801us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1801us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1801us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1801us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1801us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1801us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1801us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1801us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1801us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1801us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1801us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1801us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1801us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1801us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1801us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1831us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1831us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1831us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1831us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1831us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1831us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1831us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1831us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1831us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1831us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1831us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1831us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1831us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1831us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1831us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1862us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1862us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1862us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1862us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1862us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1862us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1862us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1862us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1862us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1862us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1862us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1862us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1862us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1862us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1862us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1892us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1892us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1892us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1892us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1892us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1892us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1892us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1892us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1892us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1892us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1892us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1892us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1892us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1892us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1892us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1923us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1923us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1923us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1923us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1923us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1923us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1923us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1923us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1923us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1923us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1923us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1923us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1923us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1923us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1923us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 1953us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1953us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1953us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1953us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1953us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1953us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1953us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1953us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1953us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 1953us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1953us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1953us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 1953us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 1953us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 1953us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 1984us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 1984us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1984us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 1984us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 1984us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 1984us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 1984us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 1984us : put_page <-put_io_page
 mmcqd/0-72      0d..1 1984us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 1984us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 1984us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 1984us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 1984us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 1984us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 1984us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2014us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2014us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2014us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2014us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2014us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2014us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2014us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2014us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2014us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2014us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2014us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2014us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2014us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2014us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2014us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2045us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2045us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2045us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2045us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2045us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2045us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2045us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2045us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2045us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 2045us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 2045us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 2045us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 2045us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2075us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2075us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2075us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2075us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2075us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2075us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2075us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2075us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2075us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2075us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2075us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2075us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2075us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2075us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2075us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 2106us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2106us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2106us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2106us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2106us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2106us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2106us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2106us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2106us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2106us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2106us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2106us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2106us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2106us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2136us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2136us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2136us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2136us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2136us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2136us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2136us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2136us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2136us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2136us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2136us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2136us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2136us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2136us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2136us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2167us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2167us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2167us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2167us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2167us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2167us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2167us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2167us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2167us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2167us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2167us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2167us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2167us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2167us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2167us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2167us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2197us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2197us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2197us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2197us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2197us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2197us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2197us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2197us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2197us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2197us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2197us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2197us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2197us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2197us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2228us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2228us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2228us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2228us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2228us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2228us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2228us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2228us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2228us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2228us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2228us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2228us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2228us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2228us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2228us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2259us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2259us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2259us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2259us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2259us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2259us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2259us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2259us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2259us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2259us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2259us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2259us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2259us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2259us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2259us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2289us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2289us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2289us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2289us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2289us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2289us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2289us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2289us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2289us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2289us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2289us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2289us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2289us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2289us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 2289us+: add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 2320us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 2320us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 2320us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2320us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2320us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 2320us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 2320us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 2320us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 2320us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2320us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2320us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2320us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2320us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2320us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2320us+: __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2350us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2350us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2350us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2350us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2350us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2350us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2350us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2350us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2350us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2350us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2350us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2350us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2350us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2350us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2381us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2381us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2381us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2381us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2381us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2381us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2381us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2381us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2381us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2381us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2381us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2381us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2381us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2381us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2381us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2411us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2411us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2411us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2411us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2411us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2411us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2411us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2411us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2411us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2411us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2411us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2411us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2411us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2442us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2442us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2442us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2442us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2442us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2442us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2442us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2442us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2442us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2442us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2442us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2442us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2442us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2442us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2442us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2472us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2472us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2472us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2472us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2472us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2472us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2472us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2472us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2472us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2472us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2472us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2472us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2472us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2472us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2472us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2503us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2503us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2503us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2503us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2503us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2503us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2503us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2503us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2503us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2503us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2503us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2503us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2503us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2503us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2503us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2533us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2533us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2533us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2533us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2533us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2533us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2533us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2533us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2533us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2533us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2533us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2533us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2533us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2533us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2533us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2564us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2564us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2564us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2564us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2564us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2564us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2564us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2564us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2564us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2564us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2564us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2564us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2564us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2564us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2564us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2594us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2594us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2594us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2594us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2594us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2594us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2594us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2594us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2594us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2594us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2594us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2594us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2594us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2594us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2625us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2625us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2625us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2625us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2625us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2625us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2625us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2625us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2625us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2625us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2625us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2625us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2625us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2625us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2625us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2655us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2655us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2655us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2655us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2655us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2655us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2655us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2655us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2655us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2655us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2655us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2655us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2655us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2655us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2655us+: __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2686us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2686us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2686us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2686us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2686us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2686us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2686us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2686us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2686us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2686us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2686us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2686us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2686us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2686us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2716us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2716us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2716us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2716us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2716us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2716us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2716us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2716us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2716us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2716us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2716us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2716us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2716us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2716us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2716us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2747us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2747us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2747us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2747us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2747us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2747us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2747us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2747us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2747us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2747us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2747us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2747us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2747us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2747us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2747us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2777us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2777us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2777us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2777us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2777us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2777us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2777us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2777us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2777us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2777us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2777us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2777us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2777us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2808us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2808us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2808us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2808us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2808us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2808us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2808us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2808us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2808us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2808us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2808us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2808us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2808us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2808us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2808us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2838us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2838us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2838us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2838us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2838us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2838us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2838us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2838us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2838us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 2838us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 2838us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 2838us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 2838us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2838us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2838us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2869us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2869us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2869us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2869us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2869us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2869us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2869us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2869us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2869us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2869us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2869us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2869us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2869us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2869us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2869us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2899us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2899us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2899us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2899us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2899us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2899us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2899us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2899us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2899us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2899us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2899us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2899us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2899us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2899us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2899us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2930us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2930us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2930us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2930us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2930us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2930us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2930us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2930us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2930us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2930us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2930us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2930us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2930us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2930us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2930us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2960us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2960us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2960us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2960us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2960us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2960us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2960us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 2960us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2960us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 2960us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 2960us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 2960us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 2960us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 2960us : put_page <-put_io_page
 mmcqd/0-72      0d..1 2960us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 2991us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 2991us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 2991us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 2991us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 2991us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 2991us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2991us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2991us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 2991us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2991us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2991us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 2991us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 2991us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 2991us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 2991us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3022us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3022us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3022us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3022us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3022us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3022us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3022us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3022us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3022us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3022us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3022us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3022us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3022us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3022us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3052us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3052us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3052us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3052us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3052us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3052us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3052us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3052us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3052us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3052us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3052us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3052us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3052us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3052us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3052us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3083us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3083us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3083us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3083us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3083us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3083us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3083us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3083us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3083us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3083us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3083us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3083us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3083us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3083us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3083us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3113us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3113us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3113us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3113us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3113us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3113us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3113us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3113us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3113us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3113us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3113us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3113us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3113us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3144us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3144us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3144us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3144us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3144us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3144us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3144us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3144us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3144us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3144us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3144us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3144us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3144us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3144us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3144us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3144us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3174us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3174us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3174us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3174us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3174us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3174us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3174us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3174us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3174us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3174us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3174us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3174us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3174us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3174us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3205us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3205us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3205us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3205us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3205us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3205us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3205us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3205us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3205us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3205us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3205us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3205us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3205us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3205us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3205us+: end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3235us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3235us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3235us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3235us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3235us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3235us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3235us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3235us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3235us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3235us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3235us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3235us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3235us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3235us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3235us+: __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3266us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3266us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3266us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3266us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3266us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3266us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3266us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3266us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3266us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3266us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3266us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3266us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3266us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3266us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3296us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3296us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3296us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3296us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3296us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3296us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3296us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3296us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3296us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3296us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3296us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3296us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3296us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3296us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3296us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3327us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3327us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3327us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3327us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3327us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3327us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3327us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3327us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3327us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3327us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3327us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3327us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3327us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3327us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3327us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3327us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3357us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3357us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3357us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3357us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3357us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3357us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3357us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3357us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3357us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3357us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3357us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3357us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3357us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3357us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3388us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3388us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3388us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3388us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3388us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3388us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3388us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3388us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3388us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3388us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3388us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3388us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3388us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3388us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3388us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 3418us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3418us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3418us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3418us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3418us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3418us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3418us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3418us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3418us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3418us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3418us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3418us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3418us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3418us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3418us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3449us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3449us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3449us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3449us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3449us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3449us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3449us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3449us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3449us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3449us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3449us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3449us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3449us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3449us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3449us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3479us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3479us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3479us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3479us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3479us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3479us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3479us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3479us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3479us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3479us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3479us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3479us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3479us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3479us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3510us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3510us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3510us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3510us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3510us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3510us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3510us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3510us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3510us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3510us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3510us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3510us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3510us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3510us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3540us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3540us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3540us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3540us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3540us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3540us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3540us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3540us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3540us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3540us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3540us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3540us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3540us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3540us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3540us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3571us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3571us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3571us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3571us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3571us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3571us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3571us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3571us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3571us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3571us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3571us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3571us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3571us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3571us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3571us+: __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3601us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3601us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3601us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3601us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3601us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3601us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3601us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3601us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3601us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3601us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3601us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3601us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 3601us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 3601us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 3601us+: sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 3632us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3632us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3632us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3632us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3632us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3632us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3632us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3632us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3632us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3632us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3632us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3632us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3632us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3632us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3632us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3662us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3662us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3662us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3662us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3662us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3662us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3662us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3662us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3662us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3662us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3662us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3662us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3662us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3662us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3662us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3693us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3693us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3693us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3693us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3693us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3693us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3693us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3693us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3693us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3693us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3693us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3693us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3693us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3693us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3693us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3723us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3723us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3723us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3723us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3723us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3723us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3723us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3723us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3723us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3723us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3723us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3723us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3723us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3723us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3723us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3754us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3754us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3754us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3754us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3754us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3754us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3754us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3754us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3754us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3754us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3754us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3754us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3754us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3754us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3785us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3785us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3785us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3785us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3785us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3785us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3785us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3785us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3785us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3785us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3785us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3785us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3785us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3785us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3785us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3815us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3815us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3815us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3815us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3815us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3815us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3815us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3815us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3815us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3815us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3815us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3815us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3815us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3846us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3846us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3846us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3846us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3846us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3846us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3846us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3846us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3846us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3846us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3846us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3846us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3846us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3846us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3846us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3876us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3876us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 3876us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 3876us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 3876us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 3876us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3876us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3876us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 3876us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 3876us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 3876us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 3876us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3876us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3876us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3876us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3907us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3907us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3907us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3907us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3907us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3907us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3907us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3907us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3907us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3907us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3907us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3907us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3907us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3907us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3907us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3937us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3937us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3937us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3937us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3937us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3937us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3937us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3937us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3937us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3937us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3937us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3937us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3937us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3937us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3937us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 3968us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3968us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3968us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3968us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3968us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3968us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 3968us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3968us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3968us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 3968us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3968us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3968us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 3968us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 3968us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 3998us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 3998us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 3998us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3998us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 3998us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 3998us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 3998us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 3998us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 3998us : put_page <-put_io_page
 mmcqd/0-72      0d..1 3998us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 3998us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 3998us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 3998us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 3998us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 3998us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4029us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4029us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4029us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4029us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4029us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4029us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4029us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4029us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4029us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4029us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4029us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4029us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4029us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4029us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4029us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4059us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4059us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4059us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4059us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4059us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4059us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4059us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4059us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4059us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4059us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4059us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4059us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4059us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4059us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4059us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4090us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4090us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4090us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4090us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4090us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4090us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4090us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4090us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4090us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4090us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4090us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4090us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4090us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4090us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4090us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4120us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4120us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4120us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4120us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4120us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4120us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4120us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4120us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4120us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4120us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4120us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4120us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4120us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4120us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4120us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4151us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4151us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4151us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4151us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4151us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4151us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4151us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4151us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4151us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4151us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4151us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4151us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4151us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4151us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4151us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4181us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4181us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4181us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4181us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4181us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4181us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4181us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4181us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4181us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4181us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4181us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4181us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4181us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4212us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4212us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4212us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4212us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4212us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4212us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4212us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4212us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4212us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4212us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4212us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4212us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4212us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4212us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4212us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4242us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4242us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4242us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4242us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4242us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4242us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4242us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4242us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4242us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4242us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4242us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4242us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4242us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4242us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4242us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4273us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4273us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4273us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4273us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4273us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4273us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4273us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4273us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4273us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4273us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4273us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4273us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4273us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4273us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4273us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4303us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4303us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4303us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4303us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4303us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4303us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4303us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4303us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4303us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4303us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4303us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4303us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4303us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4303us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4303us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4334us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4334us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4334us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4334us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4334us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4334us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4334us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4334us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4334us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4334us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4334us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4334us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4334us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4334us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4334us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4364us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4364us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4364us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4364us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4364us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4364us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4364us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4364us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4364us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4364us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4364us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4364us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4364us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4364us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4364us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 4395us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4395us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4395us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4395us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4395us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4395us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4395us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4395us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 4395us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 4395us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 4395us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 4395us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4395us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4395us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4395us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4425us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4425us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4425us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4425us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4425us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4425us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4425us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4425us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4425us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4425us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4425us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4425us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4425us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4425us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4425us+: end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4456us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4456us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4456us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4456us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4456us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4456us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4456us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4456us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4456us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4456us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4456us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4456us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4456us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4456us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4456us+: __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4486us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4486us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4486us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4486us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4486us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4486us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4486us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4486us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4486us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4486us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4486us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4486us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4486us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4486us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4517us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4517us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4517us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4517us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4517us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4517us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4517us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4517us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4517us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4517us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4517us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4517us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4517us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4517us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 4548us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4548us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4548us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4548us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4548us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4548us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4548us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4548us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4548us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4548us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4548us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4548us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4548us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4548us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4548us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4578us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4578us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4578us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4578us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4578us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4578us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4578us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4578us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4578us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4578us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4578us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4578us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4578us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4578us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4578us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4609us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4609us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4609us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4609us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4609us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4609us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4609us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4609us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4609us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4609us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4609us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4609us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4609us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4609us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4609us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4639us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4639us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4639us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4639us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4639us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4639us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4639us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4639us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4639us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4639us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4639us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4639us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4639us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4639us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4639us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4670us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4670us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4670us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4670us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4670us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4670us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4670us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4670us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4670us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4670us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4670us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4670us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4670us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4670us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4670us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4700us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4700us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4700us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4700us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4700us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4700us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4700us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4700us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4700us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4700us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4700us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4700us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4700us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4700us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4700us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4731us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4731us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4731us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4731us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4731us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4731us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4731us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4731us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4731us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4731us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4731us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4731us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4731us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4731us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4761us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4761us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4761us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4761us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4761us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4761us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4761us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4761us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4761us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4761us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4761us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4761us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4761us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4761us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4761us+: test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4792us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4792us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4792us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4792us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4792us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4792us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4792us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4792us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4792us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4792us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4792us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4792us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4792us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4792us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4792us+: __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4822us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4822us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4822us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4822us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4822us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4822us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4822us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4822us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4822us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4822us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4822us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4822us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4822us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4822us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4822us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4853us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4853us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4853us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4853us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4853us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4853us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4853us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4853us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4853us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4853us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4853us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4853us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4853us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4853us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4853us+: end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4883us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4883us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4883us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4883us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4883us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4883us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4883us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4883us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4883us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4883us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4883us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4883us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4883us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4914us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4914us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4914us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4914us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4914us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4914us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4914us : put_page <-put_io_page
 mmcqd/0-72      0d..1 4914us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4914us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4914us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4914us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4914us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4914us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4914us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4914us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4944us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4944us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4944us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4944us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4944us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4944us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4944us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 4944us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 4944us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4944us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 4944us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 4944us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 4944us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 4944us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 4944us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 4975us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 4975us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 4975us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 4975us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 4975us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 4975us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 4975us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4975us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4975us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 4975us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4975us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4975us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 4975us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 4975us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 4975us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5005us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5005us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5005us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5005us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5005us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5005us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5005us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5005us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5005us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5005us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5005us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5005us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5005us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5005us+: add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5036us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5036us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5036us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5036us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5036us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5036us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5036us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5036us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5036us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5036us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5036us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5036us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5036us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5036us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5036us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5036us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5066us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5066us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5066us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5066us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5066us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5066us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5066us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5066us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5066us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5066us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5066us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5066us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5066us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5066us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5097us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5097us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5097us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5097us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5097us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5097us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5097us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5097us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5097us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5097us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5097us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5097us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5097us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5097us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5097us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5127us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5127us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5127us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5127us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5127us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5127us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5127us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5127us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5127us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5127us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5127us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5127us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5127us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5127us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5127us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5158us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5158us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5158us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5158us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5158us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5158us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5158us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5158us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5158us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5158us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5158us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 5158us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 5158us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 5158us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 5158us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5188us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5188us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5188us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5188us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5188us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5188us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5188us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5188us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5188us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5188us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5188us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5188us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5188us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5188us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5188us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 5219us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5219us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5219us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5219us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5219us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5219us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5219us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5219us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5219us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5219us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5219us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5219us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5219us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5250us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5250us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5250us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5250us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5250us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5250us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5250us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5250us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5250us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5250us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5250us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5250us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5250us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5250us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5250us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5280us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5280us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5280us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5280us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5280us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5280us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5280us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5280us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5280us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5280us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5280us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5280us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5280us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5280us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5280us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5311us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5311us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5311us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5311us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5311us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5311us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5311us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5311us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5311us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5311us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5311us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5311us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5311us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5311us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5341us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5341us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5341us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5341us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5341us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5341us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5341us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5341us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5341us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5341us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5341us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5341us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5341us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5341us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5341us+: end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5372us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5372us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5372us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5372us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5372us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5372us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5372us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5372us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5372us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5372us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5372us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5372us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5372us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5372us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5372us+: __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5402us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5402us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5402us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5402us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5402us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5402us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5402us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5402us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5402us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5402us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5402us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5402us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5402us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5402us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5402us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5433us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 5433us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 5433us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 5433us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 5433us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5433us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5433us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 5433us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 5433us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 5433us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 5433us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5433us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5433us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5433us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5433us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5463us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5463us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5463us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5463us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5463us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5463us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5463us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5463us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5463us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5463us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5463us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5463us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5463us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5463us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5463us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5494us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5494us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5494us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5494us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5494us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5494us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5494us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5494us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5494us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5494us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5494us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5494us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5494us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5494us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5494us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5524us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5524us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5524us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5524us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5524us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5524us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5524us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5524us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5524us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5524us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5524us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5524us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5524us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5524us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5555us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5555us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5555us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5555us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5555us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5555us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5555us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5555us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5555us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5555us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5555us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5555us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5555us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5555us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5555us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5585us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5585us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5585us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5585us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5585us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5585us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5585us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5585us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5585us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5585us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5585us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5585us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5585us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5585us+: sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5616us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5616us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5616us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5616us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5616us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5616us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5616us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5616us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5616us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5616us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5616us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5616us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5616us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5616us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5616us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5646us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5646us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5646us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5646us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5646us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5646us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5646us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5646us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5646us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5646us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5646us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5646us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5646us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5646us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5646us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5677us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5677us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5677us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5677us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5677us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5677us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5677us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5677us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5677us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5677us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5677us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5677us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5677us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5677us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5677us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5707us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5707us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5707us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5707us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5707us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5707us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5707us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5707us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5707us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5707us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5707us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5707us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5707us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5707us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5738us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5738us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5738us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5738us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5738us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5738us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5738us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5738us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5738us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5738us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5738us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5738us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5738us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5738us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5738us+: end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5768us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5768us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5768us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5768us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5768us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5768us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5768us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5768us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5768us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5768us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5768us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5768us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5768us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5768us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5768us+: __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5799us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5799us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5799us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5799us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5799us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5799us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5799us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5799us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5799us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5799us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5799us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5799us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5799us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5799us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5799us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5829us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5829us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5829us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5829us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5829us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5829us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5829us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5829us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5829us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5829us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5829us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5829us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5829us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5829us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5860us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5860us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5860us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5860us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5860us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5860us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5860us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5860us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5860us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5860us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5860us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5860us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5860us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5860us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5860us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5890us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5890us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5890us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5890us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5890us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5890us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5890us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5890us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5890us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5890us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5890us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5890us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5890us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5890us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5890us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5921us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5921us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5921us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5921us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5921us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5921us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5921us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5921us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5921us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5921us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5921us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5921us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5921us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5921us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5951us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5951us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 5951us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 5951us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 5951us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 5951us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5951us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 5951us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5951us : _raw_spin_lock <-__percpu_counter_add
 mmcqd/0-72      0d..3 5951us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..4 5951us : _raw_spin_unlock <-__percpu_counter_add
 mmcqd/0-72      0d..4 5951us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0d..3 5951us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5951us+: __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 5982us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5982us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5982us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 5982us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 5982us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 5982us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 5982us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 5982us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 5982us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 5982us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 5982us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 5982us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 5982us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 5982us : put_page <-put_io_page
 mmcqd/0-72      0d..1 5982us+: kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6013us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6013us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6013us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6013us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6013us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6013us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6013us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6013us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6013us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6013us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6013us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6013us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6013us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6013us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6013us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6043us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6043us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6043us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6043us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6043us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6043us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6043us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6043us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6043us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6043us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6043us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6043us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6043us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6043us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6043us+: sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6074us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6074us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6074us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6074us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6074us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6074us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6074us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6074us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6074us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6074us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6074us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6074us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6074us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6074us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6074us+: put_page <-put_io_page
 mmcqd/0-72      0d..1 6104us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6104us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6104us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6104us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6104us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6104us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6104us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6104us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6104us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6104us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6104us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6104us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6104us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6104us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6104us+: _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6135us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6135us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6135us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6135us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6135us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6135us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6135us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6135us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6135us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6135us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6135us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6135us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6135us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6135us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6135us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6165us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6165us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6165us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6165us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6165us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6165us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6165us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6165us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6165us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6165us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6165us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6165us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6165us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6165us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6165us+: __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6196us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6196us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6196us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6196us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6196us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6196us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6196us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6196us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6196us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6196us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6196us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6196us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6196us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6196us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6196us+: __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6226us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6226us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6226us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6226us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6226us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6226us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6226us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6226us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6226us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6226us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6226us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6226us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6226us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6226us+: _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6257us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6257us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6257us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6257us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6257us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6257us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6257us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6257us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6257us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6257us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6257us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6257us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6257us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6257us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6257us+: add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6287us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6287us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6287us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6287us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6287us : put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6287us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6287us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6287us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6287us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6287us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6287us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6287us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6287us+: add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6318us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6318us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6318us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6318us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6318us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6318us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6318us : dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6318us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6318us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6318us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6318us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6318us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6318us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6318us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6318us+: put_io_page <-ext4_end_bio
 mmcqd/0-72      0d..1 6348us : end_page_writeback <-put_io_page
 mmcqd/0-72      0d..1 6348us : test_clear_page_writeback =
<-end_page_writeback
 mmcqd/0-72      0d..1 6348us : _raw_spin_lock_irqsave =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6348us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..2 6348us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6348us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6348us : __rcu_read_lock <-prop_get_global
 mmcqd/0-72      0d..2 6348us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6348us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6348us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..3 6348us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0d..2 6348us : __rcu_read_unlock <-prop_put_global
 mmcqd/0-72      0d..2 6348us : _raw_spin_unlock_irqrestore =
<-test_clear_page_writeback
 mmcqd/0-72      0d..2 6348us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..1 6348us+: dec_zone_page_state =
<-test_clear_page_writeback
 mmcqd/0-72      0d..1 6379us : __dec_zone_page_state =
<-dec_zone_page_state
 mmcqd/0-72      0d..1 6379us : __dec_zone_state <-__dec_zone_page_state
 mmcqd/0-72      0d..1 6379us : add_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..2 6379us : sub_preempt_count <-__dec_zone_state
 mmcqd/0-72      0d..1 6379us : __wake_up_bit <-end_page_writeback
 mmcqd/0-72      0d..1 6379us : put_page <-put_io_page
 mmcqd/0-72      0d..1 6379us : kmem_cache_free <-put_io_page
 mmcqd/0-72      0d..1 6379us : ext4_free_io_end <-ext4_end_bio
 mmcqd/0-72      0d..1 6379us : kmem_cache_free <-ext4_free_io_end
 mmcqd/0-72      0d..1 6379us : add_disk_randomness =
<-blk_update_bidi_request
 mmcqd/0-72      0d..1 6379us : add_timer_randomness =
<-add_disk_randomness
 mmcqd/0-72      0d..1 6379us : add_preempt_count <-add_timer_randomness
 mmcqd/0-72      0d..2 6379us+: mix_pool_bytes_extract =
<-add_timer_randomness
 mmcqd/0-72      0d..2 6409us : _raw_spin_lock_irqsave =
<-mix_pool_bytes_extract
 mmcqd/0-72      0d..2 6409us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..3 6409us : _raw_spin_unlock_irqrestore =
<-mix_pool_bytes_extract
 mmcqd/0-72      0d..3 6409us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..2 6409us : credit_entropy_bits =
<-add_timer_randomness
 mmcqd/0-72      0d..2 6409us : _raw_spin_lock_irqsave =
<-credit_entropy_bits
 mmcqd/0-72      0d..2 6409us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..3 6409us : __wake_up <-credit_entropy_bits
 mmcqd/0-72      0d..3 6409us : _raw_spin_lock_irqsave <-__wake_up
 mmcqd/0-72      0d..3 6409us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..4 6409us : __wake_up_common <-__wake_up
 mmcqd/0-72      0d..4 6409us : _raw_spin_unlock_irqrestore <-__wake_up
 mmcqd/0-72      0d..4 6409us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..3 6440us : kill_fasync <-credit_entropy_bits
 mmcqd/0-72      0d..3 6440us : _raw_spin_unlock_irqrestore =
<-credit_entropy_bits
 mmcqd/0-72      0d..3 6440us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0d..2 6440us : sub_preempt_count <-add_timer_randomness
 mmcqd/0-72      0d..1 6440us : blk_finish_request <-__blk_end_request
 mmcqd/0-72      0d..1 6440us : blk_delete_timer <-blk_finish_request
 mmcqd/0-72      0d..1 6440us : blk_unprep_request <-blk_finish_request
 mmcqd/0-72      0d..1 6440us : __rcu_read_lock <-blk_finish_request
 mmcqd/0-72      0d..1 6440us : add_preempt_count <-blk_finish_request
 mmcqd/0-72      0d..2 6440us : part_round_stats <-blk_finish_request
 mmcqd/0-72      0d..2 6440us : sub_preempt_count <-blk_finish_request
 mmcqd/0-72      0d..1 6440us : __rcu_read_unlock <-blk_finish_request
 mmcqd/0-72      0d..1 6440us+: __blk_put_request <-blk_finish_request
 mmcqd/0-72      0d..1 6470us : elv_completed_request =
<-__blk_put_request
 mmcqd/0-72      0d..1 6470us : cfq_completed_request =
<-elv_completed_request
 mmcqd/0-72      0d..1 6470us : kblockd_schedule_work =
<-cfq_completed_request
 mmcqd/0-72      0d..1 6470us : queue_work <-kblockd_schedule_work
 mmcqd/0-72      0d..1 6470us : add_preempt_count <-queue_work
 mmcqd/0-72      0d..2 6470us : queue_work_on <-queue_work
 mmcqd/0-72      0d..2 6470us : __queue_work <-queue_work_on
 mmcqd/0-72      0d..2 6470us : _raw_spin_lock_irqsave <-__queue_work
 mmcqd/0-72      0d..2 6470us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..3 6470us : get_cwq <-__queue_work
 mmcqd/0-72      0d..3 6470us : insert_work <-__queue_work
 mmcqd/0-72      0d..3 6470us : wake_up_worker <-insert_work
 mmcqd/0-72      0d..3 6470us : wake_up_process <-wake_up_worker
 mmcqd/0-72      0d..3 6470us+: try_to_wake_up <-wake_up_process
 mmcqd/0-72      0d..3 6501us : _raw_spin_lock_irqsave <-try_to_wake_up
 mmcqd/0-72      0d..3 6501us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0d..4 6501us : task_waking_fair <-try_to_wake_up
 mmcqd/0-72      0d..4 6501us : select_task_rq_fair <-try_to_wake_up
 mmcqd/0-72      0d..4 6501us : __rcu_read_lock <-select_task_rq_fair
 mmcqd/0-72      0d..4 6501us : __rcu_read_unlock <-select_task_rq_fair
 mmcqd/0-72      0d..4 6501us : _raw_spin_lock <-try_to_wake_up
 mmcqd/0-72      0d..4 6501us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0d..5 6501us : ttwu_do_activate.clone.0 =
<-try_to_wake_up
 mmcqd/0-72      0d..5 6501us : ttwu_activate <-ttwu_do_activate.clone.0
 mmcqd/0-72      0d..5 6501us : activate_task <-ttwu_activate
 mmcqd/0-72      0d..5 6501us : enqueue_task <-activate_task
 mmcqd/0-72      0d..5 6501us : update_rq_clock <-enqueue_task
 mmcqd/0-72      0d..5 6501us : msm_gpt_read <-sched_clock
 mmcqd/0-72      0d..5 6501us+: msm_read_timer_count <-msm_gpt_read
 mmcqd/0-72      0d..5 6531us : enqueue_task_fair <-enqueue_task
 mmcqd/0-72      0d..5 6531us : update_curr <-enqueue_task_fair
 mmcqd/0-72      0d..5 6531us : cpuacct_charge <-update_curr
 mmcqd/0-72      0d..5 6531us : __rcu_read_lock <-cpuacct_charge
 mmcqd/0-72      0d..5 6531us : __rcu_read_unlock <-cpuacct_charge
 mmcqd/0-72      0d..5 6531us : place_entity <-enqueue_task_fair
 mmcqd/0-72      0d..5 6531us : __enqueue_entity <-enqueue_task_fair
 mmcqd/0-72      0d..5 6531us : wq_worker_waking_up <-ttwu_activate
 mmcqd/0-72      0d..5 6531us : kthread_data <-wq_worker_waking_up
 mmcqd/0-72      0d..5 6531us : ttwu_do_wakeup =
<-ttwu_do_activate.clone.0
 mmcqd/0-72      0d..5 6531us : check_preempt_curr <-ttwu_do_wakeup
 mmcqd/0-72      0d..5 6531us : check_preempt_wakeup =
<-check_preempt_curr
 mmcqd/0-72      0d..5 6531us : update_curr <-check_preempt_wakeup
 mmcqd/0-72      0d..5 6531us+: wakeup_preempt_entity =
<-check_preempt_wakeup
 mmcqd/0-72      0d..5 6562us : resched_task <-check_preempt_wakeup
 mmcqd/0-72      0dN.5 6562us : _raw_spin_unlock <-try_to_wake_up
 mmcqd/0-72      0dN.5 6562us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0dN.4 6562us : _raw_spin_unlock_irqrestore =
<-try_to_wake_up
 mmcqd/0-72      0dN.4 6562us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0dN.3 6562us : _raw_spin_unlock_irqrestore =
<-__queue_work
 mmcqd/0-72      0dN.3 6562us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0dN.2 6562us : sub_preempt_count <-queue_work
 mmcqd/0-72      0dN.1 6562us : elv_put_request <-__blk_put_request
 mmcqd/0-72      0dN.1 6562us : cfq_put_request <-elv_put_request
 mmcqd/0-72      0dN.1 6562us : put_io_context <-cfq_put_request
 mmcqd/0-72      0dN.1 6562us : cfq_put_queue <-cfq_put_request
 mmcqd/0-72      0dN.1 6562us : mempool_free <-__blk_put_request
 mmcqd/0-72      0dN.1 6562us+: mempool_free_slab <-mempool_free
 mmcqd/0-72      0dN.1 6592us : kmem_cache_free <-mempool_free_slab
 mmcqd/0-72      0dN.1 6592us : freed_request <-__blk_put_request
 mmcqd/0-72      0dN.1 6592us : __freed_request <-freed_request
 mmcqd/0-72      0dN.1 6592us : clear_bdi_congested <-__freed_request
 mmcqd/0-72      0dN.1 6592us : _raw_spin_unlock_irq =
<-mmc_blk_issue_rw_rq
 mmcqd/0-72      0dN.2 6592us : gic_handle_irq <-__irq_svc
 mmcqd/0-72      0dN.2 6592us : handle_IRQ <-gic_handle_irq
 mmcqd/0-72      0dN.2 6592us : perf_mon_interrupt_in <-handle_IRQ
 mmcqd/0-72      0dN.2 6592us : irq_enter <-handle_IRQ
 mmcqd/0-72      0dN.2 6592us : rcu_irq_enter <-irq_enter
 mmcqd/0-72      0dN.2 6592us : rcu_exit_nohz <-rcu_irq_enter
 mmcqd/0-72      0dN.2 6592us : idle_cpu <-irq_enter
 mmcqd/0-72      0dN.2 6592us+: add_preempt_count <-irq_enter
 mmcqd/0-72      0dNh2 6623us : generic_handle_irq <-handle_IRQ
 mmcqd/0-72      0dNh2 6623us : handle_percpu_devid_irq =
<-generic_handle_irq
 mmcqd/0-72      0dNh2 6623us : msm_timer_interrupt =
<-handle_percpu_devid_irq
 mmcqd/0-72      0dNh2 6623us : hrtimer_interrupt <-msm_timer_interrupt
 mmcqd/0-72      0dNh2 6623us : ktime_get <-hrtimer_interrupt
 mmcqd/0-72      0dNh2 6623us : msm_gpt_read <-ktime_get
 mmcqd/0-72      0dNh2 6623us : msm_read_timer_count <-msm_gpt_read
 mmcqd/0-72      0dNh2 6623us : _raw_spin_lock <-hrtimer_interrupt
 mmcqd/0-72      0dNh2 6623us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0dNh3 6623us : __run_hrtimer <-hrtimer_interrupt
 mmcqd/0-72      0dNh3 6623us : __remove_hrtimer <-__run_hrtimer
 mmcqd/0-72      0dNh3 6623us : _raw_spin_unlock <-__run_hrtimer
 mmcqd/0-72      0dNh3 6623us+: sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0dNh2 6653us : tick_sched_timer <-__run_hrtimer
 mmcqd/0-72      0dNh2 6653us : ktime_get <-tick_sched_timer
 mmcqd/0-72      0dNh2 6653us : msm_gpt_read <-ktime_get
 mmcqd/0-72      0dNh2 6653us : msm_read_timer_count <-msm_gpt_read
 mmcqd/0-72      0dNh2 6653us : tick_do_update_jiffies64 =
<-tick_sched_timer
 mmcqd/0-72      0dNh2 6653us : _raw_spin_lock =
<-tick_do_update_jiffies64
 mmcqd/0-72      0dNh2 6653us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0dNh3 6653us : do_timer <-tick_do_update_jiffies64
 mmcqd/0-72      0dNh3 6653us : msm_gpt_read <-do_timer
 mmcqd/0-72      0dNh3 6653us : msm_read_timer_count <-msm_gpt_read
 mmcqd/0-72      0dNh3 6653us : calc_global_load <-do_timer
 mmcqd/0-72      0dNh3 6653us+: _raw_spin_unlock =
<-tick_do_update_jiffies64
 mmcqd/0-72      0dNh3 6684us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0dNh2 6684us : update_process_times <-tick_sched_timer
 mmcqd/0-72      0dNh2 6684us : account_process_tick =
<-update_process_times
 mmcqd/0-72      0dNh2 6684us : account_system_time =
<-account_process_tick
 mmcqd/0-72      0dNh2 6684us : cpuacct_update_stats =
<-account_system_time
 mmcqd/0-72      0dNh2 6684us : __rcu_read_lock <-cpuacct_update_stats
 mmcqd/0-72      0dNh2 6684us : add_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0dNh3 6684us : sub_preempt_count <-__percpu_counter_add
 mmcqd/0-72      0dNh2 6684us : __rcu_read_unlock <-cpuacct_update_stats
 mmcqd/0-72      0dNh2 6684us : run_local_timers <-update_process_times
 mmcqd/0-72      0dNh2 6684us : hrtimer_run_queues <-run_local_timers
 mmcqd/0-72      0dNh2 6684us : raise_softirq <-run_local_timers
 mmcqd/0-72      0dNh2 6684us : rcu_check_callbacks =
<-update_process_times
 mmcqd/0-72      0dNh2 6684us+: idle_cpu <-rcu_check_callbacks
 mmcqd/0-72      0dNh2 6714us : __rcu_pending <-rcu_check_callbacks
 mmcqd/0-72      0dNh2 6714us : __rcu_pending <-rcu_check_callbacks
 mmcqd/0-72      0dNh2 6714us : raise_softirq <-rcu_check_callbacks
 mmcqd/0-72      0dNh2 6714us : printk_tick <-update_process_times
 mmcqd/0-72      0dNh2 6714us : add_preempt_count <-irq_work_run
 mmcqd/0-72      0dNh3 6714us : sub_preempt_count <-irq_work_run
 mmcqd/0-72      0dNh2 6714us : scheduler_tick <-update_process_times
 mmcqd/0-72      0dNh2 6714us : _raw_spin_lock <-scheduler_tick
 mmcqd/0-72      0dNh2 6714us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0dNh3 6714us : update_rq_clock <-scheduler_tick
 mmcqd/0-72      0dNh3 6714us : update_cpu_load <-scheduler_tick
 mmcqd/0-72      0dNh3 6714us : task_tick_fair <-scheduler_tick
 mmcqd/0-72      0dNh3 6714us : update_curr <-task_tick_fair
 mmcqd/0-72      0dNh3 6714us+: sched_slice <-task_tick_fair
 mmcqd/0-72      0dNh3 6745us : calc_delta_mine <-sched_slice
 mmcqd/0-72      0dNh3 6745us : resched_task <-task_tick_fair
 mmcqd/0-72      0dNh3 6745us : clear_buddies <-task_tick_fair
 mmcqd/0-72      0dNh3 6745us : _raw_spin_unlock <-scheduler_tick
 mmcqd/0-72      0dNh3 6745us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0dNh2 6745us : run_posix_cpu_timers =
<-update_process_times
 mmcqd/0-72      0dNh2 6745us : profile_tick <-tick_sched_timer
 mmcqd/0-72      0dNh2 6745us : _raw_spin_lock_irqsave =
<-tick_sched_timer
 mmcqd/0-72      0dNh2 6745us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0dNh3 6745us : nr_running <-tick_sched_timer
 mmcqd/0-72      0dNh3 6745us : _raw_spin_unlock_irqrestore =
<-tick_sched_timer
 mmcqd/0-72      0dNh3 6745us+: sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0dNh2 6776us : queue_work <-tick_sched_timer
 mmcqd/0-72      0dNh2 6776us : add_preempt_count <-queue_work
 mmcqd/0-72      0dNh3 6776us : queue_work_on <-queue_work
 mmcqd/0-72      0dNh3 6776us : __queue_work <-queue_work_on
 mmcqd/0-72      0dNh3 6776us : _raw_spin_lock_irqsave <-__queue_work
 mmcqd/0-72      0dNh3 6776us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0dNh4 6776us : get_cwq <-__queue_work
 mmcqd/0-72      0dNh4 6776us : insert_work <-__queue_work
 mmcqd/0-72      0dNh4 6776us : wake_up_worker <-insert_work
 mmcqd/0-72      0dNh4 6776us : wake_up_process <-wake_up_worker
 mmcqd/0-72      0dNh4 6776us : try_to_wake_up <-wake_up_process
 mmcqd/0-72      0dNh4 6776us : _raw_spin_lock_irqsave <-try_to_wake_up
 mmcqd/0-72      0dNh4 6776us : add_preempt_count =
<-_raw_spin_lock_irqsave
 mmcqd/0-72      0dNh5 6776us+: task_waking_fair <-try_to_wake_up
 mmcqd/0-72      0dNh5 6806us : select_task_rq_fair <-try_to_wake_up
 mmcqd/0-72      0dNh5 6806us : __rcu_read_lock <-select_task_rq_fair
 mmcqd/0-72      0dNh5 6806us : __rcu_read_unlock <-select_task_rq_fair
 mmcqd/0-72      0dNh5 6806us : _raw_spin_lock <-try_to_wake_up
 mmcqd/0-72      0dNh5 6806us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0dNh6 6806us : ttwu_do_activate.clone.0 =
<-try_to_wake_up
 mmcqd/0-72      0dNh6 6806us : ttwu_activate <-ttwu_do_activate.clone.0
 mmcqd/0-72      0dNh6 6806us : activate_task <-ttwu_activate
 mmcqd/0-72      0dNh6 6806us : enqueue_task <-activate_task
 mmcqd/0-72      0dNh6 6806us : update_rq_clock <-enqueue_task
 mmcqd/0-72      0dNh6 6806us : enqueue_task_fair <-enqueue_task
 mmcqd/0-72      0dNh6 6806us : update_curr <-enqueue_task_fair
 mmcqd/0-72      0dNh6 6806us : place_entity <-enqueue_task_fair
 mmcqd/0-72      0dNh6 6806us+: __enqueue_entity <-enqueue_task_fair
 mmcqd/0-72      0dNh6 6837us : wq_worker_waking_up <-ttwu_activate
 mmcqd/0-72      0dNh6 6837us : kthread_data <-wq_worker_waking_up
 mmcqd/0-72      0dNh6 6837us : ttwu_do_wakeup =
<-ttwu_do_activate.clone.0
 mmcqd/0-72      0dNh6 6837us : check_preempt_curr <-ttwu_do_wakeup
 mmcqd/0-72      0dNh6 6837us : check_preempt_wakeup =
<-check_preempt_curr
 mmcqd/0-72      0dNh6 6837us : _raw_spin_unlock <-try_to_wake_up
 mmcqd/0-72      0dNh6 6837us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0dNh5 6837us : _raw_spin_unlock_irqrestore =
<-try_to_wake_up
 mmcqd/0-72      0dNh5 6837us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0dNh4 6837us : _raw_spin_unlock_irqrestore =
<-__queue_work
 mmcqd/0-72      0dNh4 6837us : sub_preempt_count =
<-_raw_spin_unlock_irqrestore
 mmcqd/0-72      0dNh3 6837us : sub_preempt_count <-queue_work
 mmcqd/0-72      0dNh2 6837us : hrtimer_forward <-tick_sched_timer
 mmcqd/0-72      0dNh2 6837us : ktime_add_safe <-hrtimer_forward
 mmcqd/0-72      0dNh2 6837us+: ktime_add_safe <-hrtimer_forward
 mmcqd/0-72      0dNh2 6867us : _raw_spin_lock <-__run_hrtimer
 mmcqd/0-72      0dNh2 6867us : add_preempt_count <-_raw_spin_lock
 mmcqd/0-72      0dNh3 6867us : enqueue_hrtimer <-__run_hrtimer
 mmcqd/0-72      0dNh3 6867us : _raw_spin_unlock <-hrtimer_interrupt
 mmcqd/0-72      0dNh3 6867us : sub_preempt_count <-_raw_spin_unlock
 mmcqd/0-72      0dNh2 6867us : tick_program_event <-hrtimer_interrupt
 mmcqd/0-72      0dNh2 6867us : tick_dev_program_event =
<-tick_program_event
 mmcqd/0-72      0dNh2 6867us : ktime_get <-tick_dev_program_event
 mmcqd/0-72      0dNh2 6867us : msm_gpt_read <-ktime_get
 mmcqd/0-72      0dNh2 6867us : msm_read_timer_count <-msm_gpt_read
 mmcqd/0-72      0dNh2 6867us : clockevents_program_event =
<-tick_dev_program_event
 mmcqd/0-72      0dNh2 6867us : msm_timer_set_next_event =
<-clockevents_program_event
 mmcqd/0-72      0dNh2 6867us : msm_read_timer_count =
<-msm_timer_set_next_event
 mmcqd/0-72      0dNh2 6867us+: msm_read_timer_count =
<-msm_timer_set_next_event
 mmcqd/0-72      0dNh2 6898us : gic_eoi_irq <-handle_percpu_devid_irq
 mmcqd/0-72      0dNh2 6898us : irq_exit <-handle_IRQ
 mmcqd/0-72      0dNh2 6898us : sub_preempt_count <-irq_exit
 mmcqd/0-72      0dN.3 6898us : __do_softirq <-irq_exit
 mmcqd/0-72      0dN.3 6898us : __local_bh_disable <-__do_softirq
 mmcqd/0-72      0dNs3 6898us : add_preempt_count <-_raw_spin_lock_irq
 mmcqd/0-72      0dNs4 6898us : _raw_spin_unlock_irq <-run_timer_softirq
 mmcqd/0-72      0dNs3 6898us : __local_bh_enable <-__do_softirq
 mmcqd/0-72      0dNs3 6898us : sub_preempt_count <-__local_bh_enable
 mmcqd/0-72      0dN.3 6898us+: rcu_irq_exit <-irq_exit
 mmcqd/0-72      0dN.3 6928us : rcu_enter_nohz <-rcu_irq_exit
 mmcqd/0-72      0dN.3 6928us : idle_cpu <-irq_exit
 mmcqd/0-72      0dN.3 6928us : sub_preempt_count <-irq_exit
 mmcqd/0-72      0dN.2 6928us : perf_mon_interrupt_out <-handle_IRQ
 mmcqd/0-72      0.N.1 6928us : _raw_spin_unlock_irq
 mmcqd/0-72      0.N.1 6928us : sub_preempt_count <-_raw_spin_unlock_irq
 mmcqd/0-72      0.N.1 6928us : <stack trace>
 =3D> sub_preempt_count
 =3D> _raw_spin_unlock_irq
 =3D> mmc_blk_issue_rw_rq
 =3D> mmc_blk_issue_rq
 =3D> mmc_queue_thread
 =3D> kthread
 =3D> kernel_thread_exit



------=_NextPart_000_0019_01CD0F61.A393F700--

