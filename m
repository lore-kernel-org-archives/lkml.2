Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1EYFmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:42:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46156 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1EYFma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=yFVpHlk52qjSTJIsJDELydV8k7NEyB2JM/qz9WcXJrzl31iOw5s5WiWXaZQBqZWORr
         uqEgKISVJY+kweZFhES9JOhDnQ/XquzgQqA7JDhau2A5SGzJsNe2RDVQOMoj2jMaMlbf
         uVeLHdtUN1BvNJG1xo8bQqo9hQHy/d2vuS/YE=
MIME-Version: 1.0
In-Reply-To: <4DDC38FE.5010700@kernel.org>
References: <4DC6E569.1060808@kernel.org>
	<1305843308.3100.10.camel@x201>
	<1306234696.7218.14.camel@i7.infradead.org>
	<1306258959.3100.79.camel@x201>
	<4DDC0858.3090406@kernel.org>
	<1306267639.3100.102.camel@x201>
	<4DDC26FE.6070207@kernel.org>
	<1306276736.3100.107.camel@x201>
	<4DDC38FE.5010700@kernel.org>
Date: Tue, 24 May 2011 22:42:29 -0700
X-Google-Sender-Auth: HbnX1k4iv0dgD7JQ7q8YtJxGPKQ
Message-ID: <BANLkTikQWQnZvaukTaDsKGpKOQ7Ct-o2Yg@mail.gmail.com>
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 4:02 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 05/24/2011 03:38 PM, Alex Williamson wrote:
>> On Tue, 2011-05-24 at 14:45 -0700, Yinghai Lu wrote:
>>> No, it does not work.
>>
>> I didn't say this wasn't without some effort, just thought it might give
>> you a jump start.
>
> ok, let me debug it tonight.
>
> looks like that pdev is not freed, but already get removed from the device tree.
>
> may need to pass pci_dev pointer directly.

keep getting:

[  784.364244] BUG: sleeping function called from invalid context at
kernel/rwsem.c:21
[  784.364253] in_atomic(): 0, irqs_disabled(): 1, pid: 29398, name:
work_for_cpu
[  784.364259] INFO: lockdep is turned off.
[  784.364265] irq event stamp: 0
[  784.364271] hardirqs last  enabled at (0): [<          (null)>]
      (null)
[  784.364282] hardirqs last disabled at (0): [<ffffffff8107ba5e>]
copy_process+0x43b/0xd95
[  784.364305] softirqs last  enabled at (0): [<ffffffff8107ba5e>]
copy_process+0x43b/0xd95
[  784.364318] softirqs last disabled at (0): [<          (null)>]
      (null)
[  784.364332] Pid: 29398, comm: work_for_cpu Not tainted
2.6.39-tip-yh-06791-gb282579-dirty #1047
[  784.364339] Call Trace:
[  784.364375]  [<ffffffff810ad12a>] ? print_irqtrace_events+0xd0/0xd4
[  784.364392]  [<ffffffff81071572>] __might_sleep+0xf2/0xf6
[  784.364410]  [<ffffffff81c20fc0>] down_read+0x26/0x91
[  784.364429]  [<ffffffff8134c089>] pci_find_next_bus+0x45/0x75
[  784.364442]  [<ffffffff8134c0fa>] pci_find_bus+0x41/0x54
[  784.364457]  [<ffffffff8136263f>] dmar_get_scope_dev+0x2f/0xe3
[  784.364474]  [<ffffffff813353ad>] ? random32+0x19/0x1b
[  784.364488]  [<ffffffff8136273d>] dmar_match_scope+0x4a/0xb6
[  784.364502]  [<ffffffff813628d4>] dmar_find_matched_drhd_unit+0x55/0x6f
[  784.364519]  [<ffffffff81367018>] get_domain_for_dev.clone.2+0x103/0x392
[  784.364533]  [<ffffffff81367459>] __get_valid_domain_for_dev+0x14/0x88
[  784.364546]  [<ffffffff813676c5>] __intel_map_single+0x58/0x174
[  784.364559]  [<ffffffff813678eb>] intel_alloc_coherent+0xc7/0xee
[  784.364575]  [<ffffffff811281dc>] pool_alloc_page.clone.0+0xc9/0x140
[  784.364588]  [<ffffffff811282d8>] dma_pool_alloc+0x85/0x131
[  784.364603]  [<ffffffff81134b8c>] ? should_failslab+0x44/0x48
[  784.364618]  [<ffffffff81132d62>] ? kmem_cache_alloc_trace+0x5e/0x123
[  784.364635]  [<ffffffff818429aa>] ehci_qh_alloc+0x59/0xd2
[  784.364649]  [<ffffffff81844451>] ehci_mem_init.clone.1+0x84/0x25c
[  784.364660]  [<ffffffff8184471b>] ehci_init+0xf2/0x245
[  784.364671]  [<ffffffff81844999>] ehci_pci_setup+0x12b/0x564
[  784.364687]  [<ffffffff818323d5>] usb_add_hcd+0x10f/0x318
[  784.364703]  [<ffffffff8183e31e>] usb_hcd_pci_probe+0x1e4/0x312
[  784.364722]  [<ffffffff8134ae25>] local_pci_probe+0x4d/0x96
[  784.364739]  [<ffffffff81093c4b>] ? cwq_dec_nr_in_flight+0x81/0x81
[  784.364754]  [<ffffffff81093c63>] do_work_for_cpu+0x18/0x2b
[  784.364770]  [<ffffffff81093c4b>] ? cwq_dec_nr_in_flight+0x81/0x81
[  784.364787]  [<ffffffff81099ea5>] kthread+0xa0/0xa8
[  784.364801]  [<ffffffff810adbcc>] ? trace_hardirqs_on_caller+0x1f/0x178
[  784.364818]  [<ffffffff81c2a214>] kernel_thread_helper+0x4/0x10
[  784.364832]  [<ffffffff81c224cc>] ? _raw_spin_unlock_irq+0x30/0x36
[  784.364846]  [<ffffffff810add32>] ? trace_hardirqs_on+0xd/0xf
[  784.364861]  [<ffffffff81c227c0>] ? retint_restore_args+0xe/0xe
[  784.364880]  [<ffffffff81099e05>] ? __init_kthread_worker+0x5b/0x5b
[  784.364893]  [<ffffffff81c2a210>] ? gs_change+0xb/0xb
[  784.364902] DMAR: Device scope device [0000:40:00.00] not found
[  784.364910] DMAR: Device scope device [0000:40:01.00] not found
[  784.364931] DMAR: Device scope device [0000:40:03.00] not found
[  784.364948] DMAR: Device scope device [0000:40:05.00] not found
[  784.364961] DMAR: Device scope device [0000:40:07.00] not found
[  784.364978] DMAR: Device scope device [0000:40:09.00] not found
[  784.365019] DMAR: Device scope device [0000:80:00.00] not found
[  784.365034] DMAR: Device scope device [0000:80:01.00] not found
[  784.365053] DMAR: Device scope device [0000:80:03.00] not found
[  784.365075] DMAR: Device scope device [0000:80:05.00] not found
[  784.365094] DMAR: Device scope device [0000:80:07.00] not found
[  784.365116] DMAR: Device scope device [0000:80:09.00] not found
[  784.365166] DMAR: Device scope device [0000:c0:00.00] not found
[  784.365193] DMAR: Device scope device [0000:c0:01.00] not found
[  784.365216] DMAR: Device scope device [0000:c0:03.00] not found
[  784.365243] DMAR: Device scope device [0000:c0:05.00] not found
[  784.365266] DMAR: Device scope device [0000:c0:07.00] not found
[  784.365284] DMAR: Device scope device [0000:c0:09.00] not found
