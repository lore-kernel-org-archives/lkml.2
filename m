Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab1LGQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab1LGQUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:29 2011
Message-Id: <20111207160829.159142439@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:40 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>
Subject: [80/80] clockevents: Set noop handler in clockevents_exchange_device()
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit de28f25e8244c7353abed8de0c7792f5f883588c upstream.

If a device is shutdown, then there might be a pending interrupt,
which will be processed after we reenable interrupts, which causes the
original handler to be run. If the old handler is the (broadcast)
periodic handler the shutdown state might hang the kernel completely.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clockevents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -286,6 +286,7 @@ void clockevents_exchange_device(struct
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);


