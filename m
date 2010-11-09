Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0KIBdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:33:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35414 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0KIBda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:33:30 -0500
Date: Tue, 9 Nov 2010 12:33:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20101109123326.8e4a3c99.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/hid-input.c between commit
a0bf0ea809ba0a7621e191ec4cab5775d502ef7e ("Input: hid-input - switch to
using new keycode interface") from Linus' tree and commit
587d145200f26758940099fbbc301fdd43d3f391 ("HID: Remove KERN_DEBUG from
dbg_hid use") from the hid tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-input.c
index bb0b365,76e1f64..0000000
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@@ -165,24 -127,21 +165,24 @@@ static int hidinput_setkeycode(struct i
  {
  	struct hid_device *hid = input_get_drvdata(dev);
  	struct hid_usage *usage;
 -	int old_keycode;
  
 -	usage = hidinput_find_key(hid, scancode, 0);
 +	usage = hidinput_locate_usage(hid, ke, NULL);
  	if (usage) {
 -		old_keycode = usage->code;
 -		usage->code = keycode;
 +		*old_keycode = usage->type == EV_KEY ?
 +				usage->code : KEY_RESERVED;
 +		usage->code = ke->keycode;
  
 -		clear_bit(old_keycode, dev->keybit);
 +		clear_bit(*old_keycode, dev->keybit);
  		set_bit(usage->code, dev->keybit);
- 		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n",
+ 		dbg_hid("Assigned keycode %d to HID usage code %x\n",
 -				keycode, scancode);
 -		/* Set the keybit for the old keycode if the old keycode is used
 -		 * by another key */
 -		if (hidinput_find_key (hid, 0, old_keycode))
 -			set_bit(old_keycode, dev->keybit);
 +			usage->code, usage->hid);
 +
 +		/*
 +		 * Set the keybit for the old keycode if the old keycode is used
 +		 * by another key
 +		 */
 +		if (hidinput_find_key(hid, match_keycode, *old_keycode, NULL))
 +			set_bit(*old_keycode, dev->keybit);
  
  		return 0;
  	}
