Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0IGB67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:58:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55938 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0IGB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:58:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: Important news regarding the two different patches
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <4C8596B1.6010005@superonline.com>
References: <201009062043.37819.rjw@sisk.pl> <4C8596B1.6010005@superonline.com>
Message-Id: <20100907104218.C8EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  7 Sep 2010 10:58:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> 
> When I apply both of the patches, then I don't get any hangs with
> hibernation. However, I do get another problem, which I am not sure
> is related or not. I should note that I haven't experienced this
> with only the vmscan.c patch, but maybe I haven't repeated my test
> enough times.
> 
> One test consists of an automated run of 7 hibernate/thaw cycles. 
> 
> Here's what I got in dmesg in two of the iterations in one test.
> Sorry for the long e-mail and the long lines.
> 
> === 8< ===
> [  166.512085] PM: Hibernation mode set to 'reboot'
> [  166.516503] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
> [  166.517654] PM: Basic memory bitmaps created
> [  166.518781] PM: Syncing filesystems ... done.
> [  166.546308] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  166.559596] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  166.571649] PM: Preallocating image memory... 
> [  185.712457] iwl3945: page allocation failure. order:0, mode:0xd0
> [  185.714564] Pid: 1225, comm: iwl3945 Not tainted 2.6.35.4-test-mm5v2-vmscan+snapshot-dirty #7
> [  185.715741] Call Trace:
> [  185.716853]  [<c019aa67>] ? __alloc_pages_nodemask+0x577/0x630
> [  185.718126]  [<f8a562c5>] ? iwl3945_rx_allocate+0x75/0x240 [iwl3945]
> [  185.719379]  [<c03f0516>] ? schedule+0x356/0x730
> [  185.720556]  [<f8a56d50>] ? iwl3945_rx_replenish+0x20/0x50 [iwl3945]
> [  185.721914]  [<f8a56dbc>] ? iwl3945_bg_rx_replenish+0x3c/0x50 [iwl3945]
> [  185.723929]  [<c014b167>] ? worker_thread+0x117/0x1f0
> [  185.725745]  [<f8a56d80>] ? iwl3945_bg_rx_replenish+0x0/0x50 [iwl3945]
> [  185.727097]  [<c014ebd0>] ? autoremove_wake_function+0x0/0x40
> [  185.728468]  [<c014b050>] ? worker_thread+0x0/0x1f0
> [  185.730235]  [<c014e854>] ? kthread+0x74/0x80
> [  185.731601]  [<c014e7e0>] ? kthread+0x0/0x80
> [  185.732919]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10

Hm, interesting.

Rafael's patch seems works intentionally. preallocate much much memory and
release over allocated memory. But on your system, iwl3945 allocate memory 
concurrently. If it try to allocate before the hibernation code release 
extra memory, It may get allocation failure.

So, I'm not sure wich behavior is desired.
  1) preallocate enough much memory
	pros) hibernate faster
	cons) failure risk of network card memory allocation
  2) preallocate small memory
	pros) hibernate slower
	cons) don't makes network card memory allocation

But, I wonder why this kernel thread is not frozen. afaik, hibernation
doesn't need network capability. Is this really intentional?

Rafael, Could you please explain the design of hibernation and your
intention?

Vefa, note: this allocation failure doesn't makes any problem. this mean
network card can't receive one network packet. But while hibernation,
we always can't receive network patchet. so no problem.



