Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2EGVtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:49:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61924 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2EGVtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:49:21 -0400
MIME-Version: 1.0
In-Reply-To: <1336422144.14207.155.camel@gandalf.stny.rr.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
 <1336096792-25373-1-git-send-email-vnagarnaik@google.com> <1336422144.14207.155.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 7 May 2012 14:48:50 -0700
Message-ID: <CAL26m8LOiaiXPccVsf3avxN28bH6JomjmssfuODnOdpM21tTig@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 1:22 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> After applying this patch, I get this:
>
> # trace-cmd start -e all
> # echo 100 > /debug/tracing/buffer_size_kb
>
> BUG: scheduling while atomic: trace-cmd/2018/0x00000002
> no locks held by trace-cmd/2018.
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 kvm uinput snd_hda_codec_idt
>  snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 shpchp microcode pata_acpi firewire_ohci firewire_core crc_itu
> _t ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> Pid: 2018, comm: trace-cmd Not tainted 3.4.0-rc2-test+ #2
> Call Trace:
>  [<ffffffff81480d52>] __schedule_bug+0x66/0x6a
>  [<ffffffff81487d16>] __schedule+0x93/0x605
>  [<ffffffff8107a045>] ? __lock_acquire+0x4dc/0xcf1
>  [<ffffffff8148833b>] schedule+0x64/0x66
>  [<ffffffff81486b28>] schedule_timeout+0x37/0xf7
>  [<ffffffff81489386>] ? _raw_spin_unlock_irq+0x2d/0x5e
>  [<ffffffff8107b117>] ? trace_hardirqs_on_caller+0x121/0x158
>  [<ffffffff81487b73>] wait_for_common+0x97/0xf1
>  [<ffffffff8105c922>] ? try_to_wake_up+0x1ec/0x1ec
>  [<ffffffff810a4d29>] ? call_rcu_bh+0x19/0x19
>  [<ffffffff810b4845>] ? tracing_iter_reset+0x8b/0x8b
>  [<ffffffff81487c81>] wait_for_completion+0x1d/0x1f
>  [<ffffffff8104ba3d>] wait_rcu_gp+0x5c/0x77
>  [<ffffffff8104ba58>] ? wait_rcu_gp+0x77/0x77
>  [<ffffffff810a39eb>] synchronize_sched+0x25/0x27
>  [<ffffffff810ae27f>] ring_buffer_reset_cpu+0x4e/0xd1

The following seems to be the culprit. I am guessing you have a preempt
kernel?

@@ -3662,8 +3808,12 @@ void ring_buffer_reset_cpu(struct ring_buffer
*buffer, int cpu)
       if (!cpumask_test_cpu(cpu, buffer->cpumask))
               return;

+       atomic_inc(&buffer->resize_disabled);
       atomic_inc(&cpu_buffer->record_disabled);

+       /* Make sure all commits have finished */
+       synchronize_sched();
+
       raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);


I guess I can disable resizing in ring_buffer_record_disable(), that
seems to be a reasonable assumption.



Vaibhav Nagarnaik
