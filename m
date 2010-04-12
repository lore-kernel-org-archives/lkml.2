Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0DLCNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 22:13:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36444 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0DLCNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 22:13:49 -0400
Date: Mon, 12 Apr 2010 12:13:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the input-current
 tree
Message-Id: <20100412121346.6a04cb85.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/input/input.c between commit
2e2e3b96d98d5c17e9c09bc6088df3e182a71814 ("Input: sparse-keymap -
implement safer freeing of the keymap") from the input-current tree and
commit edeada2cde748860846784cf3e5518d7c7c51ca2 ("V4L/DVB: input: Add
support for EVIO[CS]GKEYCODEBIG") from the v4l-dvb tree.

I fixed it up (sort of and maybe not correctly - see below) and can carry
the fix as necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/input.c
index 9c79bd5,ae29af8..0000000
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@@ -660,14 -816,31 +816,36 @@@ EXPORT_SYMBOL(input_set_keycode_big)
  int input_get_keycode(struct input_dev *dev,
  		      unsigned int scancode, unsigned int *keycode)
  {
 +	unsigned long flags;
 +	int retval;
 +
 +	spin_lock_irqsave(&dev->event_lock, flags);
- 	retval = dev->getkeycode(dev, scancode, keycode);
+ 	if (dev->getkeycode) {
+ 		/*
+ 		 * Use the legacy calls
+ 		 */
+ 		return dev->getkeycode(dev, scancode, keycode);
+ 	} else {
 -		int retval;
+ 		struct keycode_table_entry kt_entry;
+ 
+ 		/*
+ 		 * Userspace is using a legacy call with a driver ported
+ 		 * to the new way. This is a bad idea with long sparsed
+ 		 * tables, since lots of the retrieved values will be in
+ 		 * blank. Also, it makes sense only if the table size is
+ 		 * lower than 2^32.
+ 		 */
+ 		memset(&kt_entry, 0, sizeof(kt_entry));
+ 		kt_entry.len = 4;
+ 		kt_entry.index = scancode;
+ 
+ 		retval = dev->getkeycodebig_from_index(dev, &kt_entry);
+ 
+ 		*keycode = kt_entry.keycode;
 -		return retval;
+ 	}
 +	spin_unlock_irqrestore(&dev->event_lock, flags);
 +
 +	return retval;
  }
  EXPORT_SYMBOL(input_get_keycode);
  
