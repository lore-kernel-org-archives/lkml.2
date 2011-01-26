Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1AZPGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:06:02 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:41666 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370Ab1AZPF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:05:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAKHHP01Ld/sX/2dsb2JhbAAMhAbNZJBogSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,380,1291611600"; 
   d="scan'208";a="89300288"
Message-ID: <4D403855.4050706@teksavvy.com>
Date: Wed, 26 Jan 2011 10:05:57 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net>
In-Reply-To: <20110126020003.GA23085@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
> On Tue, Jan 25, 2011 at 03:29:14PM -0800, Dmitry Torokhov wrote:
>> On Tue, Jan 25, 2011 at 05:22:09PM -0500, Mark Lord wrote:
>>> On 11-01-25 05:00 PM, Mauro Carvalho Chehab wrote:
>>>> Em 25-01-2011 18:54, Dmitry Torokhov escreveu:
..
>>>>> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
>>>
>>> That's the problem: you did NOT keep the two old ioctls().
>>> Those got changed too.. so now we have four NEW ioctls(),
>>> none of which backward compatible with userspace.
>>>
>>
>> Please calm down. This, in fact, is not new vs old ioctl problem but
>> rather particular driver (or rather set of drivers) implementation
>> issue. Even if we drop the new ioctls and convert the RC code to use the
>> old ones you'd be observing the same breakage as RC code responds with
>> -EINVAL to not-yet-established mappings.
>>
>> I'll see what can be done for these drivers; I guess we could supply a
>> fake KEY_RESERVED entry for not mapped scancodes if there are mapped
>> scancodes "above" current one. That should result in the same behavior
>> for RCs as before.
>>
>
> I wonder if the patch below is all that is needed...


Nope. Does not work here:

$ lsinput
protocol version mismatch (expected 65536, got 65537)



>Input: ir-keymap - return KEY_RESERVED for unknown mappings
>
>Do not respond with -EINVAL to EVIOCGKEYCODE for not-yet-mapped scancodes,
>but rather return KEY_RESERVED.
>
>This fixes breakage with Ubuntu's input-kbd utility that stopped returning
>full keymaps for remote controls.
>
>Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>---
>
> drivers/media/IR/ir-keytable.c |   28 +++++++++++++++++-----------
> 1 files changed, 17 insertions(+), 11 deletions(-)
>
>
>diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
>index f60107c..c4645d7 100644
>--- a/drivers/media/IR/ir-keytable.c
>+++ b/drivers/media/IR/ir-keytable.c
>@@ -374,21 +374,27 @@ static int ir_getkeycode(struct input_dev *dev,
> 		index = ir_lookup_by_scancode(rc_tab, scancode);
> 	}
> 
>-	if (index >= rc_tab->len) {
>-		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
>-			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
>-				   scancode);
>+	if (index < rc_tab->len) {
>+		entry = &rc_tab->scan[index];
>+
>+		ke->index = index;
>+		ke->keycode = entry->keycode;
>+		ke->len = sizeof(entry->scancode);
>+		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
>+
>+	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
>+		/*
>+		 * We do not really know the valid range of scancodes
>+		 * so let's respond with KEY_RESERVED to anything we
>+		 * do not have mapping for [yet].
>+		 */
>+		ke->index = index;
>+		ke->keycode = KEY_RESERVED;
>+	} else {
> 		retval = -EINVAL;
> 		goto out;
> 	}
> 
>-	entry = &rc_tab->scan[index];
>-
>-	ke->index = index;
>-	ke->keycode = entry->keycode;
>-	ke->len = sizeof(entry->scancode);
>-	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
>-
> 	retval = 0;
> 
> out:
