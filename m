Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2EGUW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:22:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab2EGUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:22:27 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0in4RCm__d4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=1XWaLZrsAAAA:8 a=QjmRiQR0HTpL7ykG8VkA:9 a=mYhzdc5Xt2c7tbz9X4EA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336422144.14207.155.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 16:22:24 -0400
In-Reply-To: <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 18:59 -0700, Vaibhav Nagarnaik wrote:
> This patch adds the capability to remove pages from a ring buffer
> without destroying any existing data in it.
> 
> This is done by removing the pages after the tail page. This makes sure
> that first all the empty pages in the ring buffer are removed. If the
> head page is one in the list of pages to be removed, then the page after
> the removed ones is made the head page. This removes the oldest data
> from the ring buffer and keeps the latest data around to be read.
> 
> To do this in a non-racey manner, tracing is stopped for a very short
> time while the pages to be removed are identified and unlinked from the
> ring buffer. The pages are freed after the tracing is restarted to
> minimize the time needed to stop tracing.
> 
> The context in which the pages from the per-cpu ring buffer are removed
> runs on the respective CPU. This minimizes the events not traced to only
> NMI trace contexts.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

After applying this patch, I get this:

# trace-cmd start -e all
# echo 100 > /debug/tracing/buffer_size_kb

BUG: scheduling while atomic: trace-cmd/2018/0x00000002
no locks held by trace-cmd/2018.
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 kvm uinput snd_hda_codec_idt
 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 shpchp microcode pata_acpi firewire_ohci firewire_core crc_itu
_t ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
Pid: 2018, comm: trace-cmd Not tainted 3.4.0-rc2-test+ #2
Call Trace:
 [<ffffffff81480d52>] __schedule_bug+0x66/0x6a
 [<ffffffff81487d16>] __schedule+0x93/0x605
 [<ffffffff8107a045>] ? __lock_acquire+0x4dc/0xcf1
 [<ffffffff8148833b>] schedule+0x64/0x66
 [<ffffffff81486b28>] schedule_timeout+0x37/0xf7
 [<ffffffff81489386>] ? _raw_spin_unlock_irq+0x2d/0x5e
 [<ffffffff8107b117>] ? trace_hardirqs_on_caller+0x121/0x158
 [<ffffffff81487b73>] wait_for_common+0x97/0xf1
 [<ffffffff8105c922>] ? try_to_wake_up+0x1ec/0x1ec
 [<ffffffff810a4d29>] ? call_rcu_bh+0x19/0x19
 [<ffffffff810b4845>] ? tracing_iter_reset+0x8b/0x8b
 [<ffffffff81487c81>] wait_for_completion+0x1d/0x1f
 [<ffffffff8104ba3d>] wait_rcu_gp+0x5c/0x77
 [<ffffffff8104ba58>] ? wait_rcu_gp+0x77/0x77
 [<ffffffff810a39eb>] synchronize_sched+0x25/0x27
 [<ffffffff810ae27f>] ring_buffer_reset_cpu+0x4e/0xd1
 [<ffffffff810b4845>] ? tracing_iter_reset+0x8b/0x8b
 [<ffffffff810b30e6>] tracing_reset_online_cpus+0x49/0x74
 [<ffffffff810b4885>] tracing_open+0x40/0x2c9
 [<ffffffff810b4845>] ? tracing_iter_reset+0x8b/0x8b
 [<ffffffff8111491b>] __dentry_open+0x166/0x299
 [<ffffffff81115850>] nameidata_to_filp+0x60/0x67
 [<ffffffff8112270a>] do_last+0x565/0x59f
 [<ffffffff81122922>] path_openat+0xd0/0x30e
 [<ffffffff8107ace8>] ? lock_acquire+0xe0/0x112
 [<ffffffff8112cc9e>] ? alloc_fd+0x3c/0xfe
 [<ffffffff81122c5d>] do_filp_open+0x38/0x86
 [<ffffffff814892d1>] ? _raw_spin_unlock+0x48/0x56
 [<ffffffff8112cd4e>] ? alloc_fd+0xec/0xfe
 [<ffffffff811158c6>] do_sys_open+0x6f/0x101
 [<ffffffff81115979>] sys_open+0x21/0x23
 [<ffffffff8148f3e9>] system_call_fastpath+0x16/0x1b

Let me know if you need my config.

-- Steve


