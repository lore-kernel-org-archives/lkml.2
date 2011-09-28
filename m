Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1I1Wk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1I1WkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:29 2011
Message-Id: <20110928220129.262623316@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, IvDoorn@gmail.com,
        Stanislaw Gruszka <sgruszka@redhat.com>, jpiszcz@lucidpixels.com,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [038/244] rt2x00: fix crash in rt2800usb_get_txwi
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 674db1344443204b6ce3293f2df8fd1b7665deea upstream.

Patch should fix this oops:

BUG: unable to handle kernel NULL pointer dereference at 000000a0
IP: [<f81b30c9>] rt2800usb_get_txwi+0x19/0x70 [rt2800usb]
*pdpt = 0000000000000000 *pde = f000ff53f000ff53
Oops: 0000 [#1] SMP
Pid: 198, comm: kworker/u:3 Tainted: G        W   3.0.0-wl+ #9 LENOVO 6369CTO/6369CTO
EIP: 0060:[<f81b30c9>] EFLAGS: 00010283 CPU: 1
EIP is at rt2800usb_get_txwi+0x19/0x70 [rt2800usb]
EAX: 00000000 EBX: f465e140 ECX: f4494960 EDX: ef24c5f8
ESI: 810f21f5 EDI: f1da9960 EBP: f4581e80 ESP: f4581e70
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/u:3 (pid: 198, ti=f4580000 task=f4494960 task.ti=f4580000)
Call Trace:
 [<f804790f>] rt2800_txdone_entry+0x2f/0xf0 [rt2800lib]
 [<c045110d>] ? warn_slowpath_common+0x7d/0xa0
 [<f81b3a38>] ? rt2800usb_work_txdone+0x288/0x360 [rt2800usb]
 [<f81b3a38>] ? rt2800usb_work_txdone+0x288/0x360 [rt2800usb]
 [<f81b3a13>] rt2800usb_work_txdone+0x263/0x360 [rt2800usb]
 [<c046a8d6>] process_one_work+0x186/0x440
 [<c046a85a>] ? process_one_work+0x10a/0x440
 [<f81b37b0>] ? rt2800usb_probe_hw+0x120/0x120 [rt2800usb]
 [<c046c283>] worker_thread+0x133/0x310
 [<c04885db>] ? trace_hardirqs_on+0xb/0x10
 [<c046c150>] ? manage_workers+0x1e0/0x1e0
 [<c047054c>] kthread+0x7c/0x90
 [<c04704d0>] ? __init_kthread_worker+0x60/0x60
 [<c0826b42>] kernel_thread_helper+0x6/0x1

Oops might happen because we check rt2x00queue_empty(queue) twice,
but this condition can change and we can process entry in
rt2800_txdone_entry(), which was already processed by
rt2800usb_txdone_entry_check() -> rt2x00lib_txdone_noinfo() and
has nullify entry->skb .

Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -764,12 +764,11 @@ void rt2800_txdone(struct rt2x00_dev *rt
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 			if (rt2800_txdone_entry_check(entry, reg))
 				break;
+			entry = NULL;
 		}
 
-		if (!entry || rt2x00queue_empty(queue))
-			break;
-
-		rt2800_txdone_entry(entry, reg);
+		if (entry)
+			rt2800_txdone_entry(entry, reg);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone);


