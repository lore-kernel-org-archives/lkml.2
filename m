Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1EaQgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:36:41 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58323 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab1EaQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gTtshWt+as9/eM6LKGKoevvomm+BgLY4miTJvrss1Aq8e9fNP4k7CqzSC81tWKzBgm
         k46+/3hMWbxTw1l4N53Rta7+hi+vdnNOCzKNMnjxE+1JVABL7NZgAu2Qm3g8nWOO8bSY
         7snHcn9HsaHwiSKcKJWfmqOtSyBqmRUkwmn+w=
MIME-Version: 1.0
Date: Wed, 1 Jun 2011 00:36:39 +0800
Message-ID: <BANLkTi=_37v5C3-yK8Nn2Kbo3gC0mUyY=g@mail.gmail.com>
Subject: [3.0-rc1] mce: unsafe smp_processor_id usage
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 3.0-rc1 with preemption enabled, we hit a warning in
mce_raise_notify [1]; the value of 'cpu' in mce_raise_notify isn't
guaranteed correct if preemption occurs. It looks like we need to
disable preemption along part of the path, or to use
raw_smp_processor_id, since the changing the cpumask is safe.

If raw_smp_processor_id, I can cook and test a patch pretty quick.

Thanks,
  Daniel

--- [1]

BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/990
caller is mce_raise_notify+0x2e/0x120
Pid: 990, comm: Xorg Tainted: G        WC  3.0.0-rc1-100debug+ #1
Call Trace:
 [<ffffffff81343b64>] debug_smp_processor_id+0xe4/0x100
 [<ffffffff8101a5ce>] mce_raise_notify+0x2e/0x120
 [<ffffffff81030344>] ? __change_page_attr+0x164/0x240
 [<ffffffff8108421b>] notifier_call_chain+0x8b/0x100
 [<ffffffff8108483c>] __atomic_notifier_call_chain+0x6c/0xb0
 [<ffffffff810847d0>] ? register_reboot_notifier+0x20/0x20
 [<ffffffff81084891>] atomic_notifier_call_chain+0x11/0x20
 [<ffffffff810849fe>] notify_die+0x2e/0x30
 [<ffffffff81003695>] do_general_protection+0x145/0x180
 [<ffffffff8171aff4>] ? restore_args+0x30/0x30
 [<ffffffff8171b1af>] general_protection+0x1f/0x30
 [<ffffffff81509e49>] ? evdev_poll+0x29/0x70
 [<ffffffff81153c92>] do_select+0x312/0x610
 [<ffffffff81153980>] ? poll_select_set_timeout+0x90/0x90
 [<ffffffff81153400>] ? poll_freewait+0xb0/0xb0
 [<ffffffff811534f0>] ? __pollwait+0xf0/0xf0
 [<ffffffff811534f0>] ? __pollwait+0xf0/0xf0
 [<ffffffff811534f0>] ? __pollwait+0xf0/0xf0
 [<ffffffff811534f0>] ? __pollwait+0xf0/0xf0
 [<ffffffff8112b72f>] ? check_object+0xaf/0x270
 [<ffffffff8112bd96>] ? init_object+0x46/0x80
 [<ffffffff8112d17a>] ? free_debug_processing+0x17a/0x290
 [<ffffffff810933dd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff811541af>] core_sys_select+0x21f/0x430
 [<ffffffff81153fd7>] ? core_sys_select+0x47/0x430
 [<ffffffff810704ae>] ? set_current_blocked+0x4e/0x60
 [<ffffffff81002612>] ? handle_signal+0x102/0x220
 [<ffffffff8100279e>] ? do_signal+0x6e/0x180
 [<ffffffff8115459a>] sys_select+0x3a/0x100
 [<ffffffff8171b73b>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
