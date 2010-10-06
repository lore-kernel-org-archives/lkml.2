Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab0JFCEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:04:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43257 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0JFCEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:04:40 -0400
Date: Wed, 6 Oct 2010 13:04:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the kgdb tree with the input tree
Message-Id: <20101006130436.45d8a96a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Today's linux-next merge of the kgdb tree got a conflict in
drivers/char/sysrq.c between commit
1966cb225c6f9040ca163802cbd052c393d4448f ("Input: sysrq - add locking to
sysrq_filter()") from the input tree and commit
02307772717c91a108aca2e999bbc586a85d06a2 ("sysrq,keyboard: properly deal
with alt-sysrq in sysrq input filter") from the kgdb tree.

Just context changes.  I fixed it up (see below) and can carry the fax as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/sysrq.c
index f0ad694,9b97aad..0000000
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@@ -566,7 -566,57 +566,58 @@@ static const unsigned char sysrq_xlate[
  static bool sysrq_down;
  static int sysrq_alt_use;
  static int sysrq_alt;
 +static DEFINE_SPINLOCK(sysrq_event_lock);
+ static bool sysrq_kbd_triggered;
+ 
+ /*
+  * This function was a copy of input_pass_event but modified to allow
+  * by-passing a specific filter, to allow for injected events without
+  * filter recursion.
+  */
+ static void input_pass_event_ignore(struct input_dev *dev,
+ 			     unsigned int type, unsigned int code, int value,
+ 			     struct input_handle *ignore_handle)
+ {
+ 	struct input_handler *handler;
+ 	struct input_handle *handle;
+ 
+ 	rcu_read_lock();
+ 
+ 	handle = rcu_dereference(dev->grab);
+ 	if (handle)
+ 		handle->handler->event(handle, type, code, value);
+ 	else {
+ 		bool filtered = false;
+ 
+ 		list_for_each_entry_rcu(handle, &dev->h_list, d_node) {
+ 			if (!handle->open || handle == ignore_handle)
+ 				continue;
+ 			handler = handle->handler;
+ 			if (!handler->filter) {
+ 				if (filtered)
+ 					break;
+ 
+ 				handler->event(handle, type, code, value);
+ 
+ 			} else if (handler->filter(handle, type, code, value))
+ 				filtered = true;
+ 		}
+ 	}
+ 
+ 	rcu_read_unlock();
+ }
+ 
+ /*
+  * Pass along alt-print_screen, if there was no sysrq processing by
+  * sending a key press down and then passing the key up event.
+  */
+ static void simulate_alt_sysrq(struct input_handle *handle)
+ {
+ 	input_pass_event_ignore(handle->dev, EV_KEY, KEY_SYSRQ, 1, handle);
+ 	input_pass_event_ignore(handle->dev, EV_SYN, SYN_REPORT, 0, handle);
+ 	input_pass_event_ignore(handle->dev, EV_KEY, KEY_SYSRQ, 0, handle);
+ 	input_pass_event_ignore(handle->dev, EV_SYN, SYN_REPORT, 0, handle);
+ }
  
  static bool sysrq_filter(struct input_handle *handle, unsigned int type,
  		         unsigned int code, int value)
