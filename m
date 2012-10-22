Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2JVRM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:12:26 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34347 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2JVRMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <20121022160705.GC13791@core.coreip.homeip.net>
References: <1350424679-20725-1-git-send-email-scott.liu@emc.com.tw>
	<87hapnnp5t.fsf@emc.com.tw>
	<20121022160705.GC13791@core.coreip.homeip.net>
Date: Mon, 22 Oct 2012 19:12:22 +0200
Message-ID: <CAN+gG=HyzcRnp_Bd=WRq2Hn_5QKCVCjvFjXCvO1xXbAcyBOJfQ@mail.gmail.com>
Subject: Re: [PATCH v1] Support Elan Touchscreen eKTF product.
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jian-Jhong Ding <jj_ding@emc.com.tw>, Scott Liu <scott.liu@emc.com.tw>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse <jesse@emc.com.tw>,
        Vincent Wang <vincent.wang@emc.com.tw>, Paul <paul.liang@emc.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 6:07 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, Oct 22, 2012 at 11:47:42AM +0800, Jian-Jhong Ding wrote:
>> Scott Liu <scott.liu@emc.com.tw> writes:
>> > +
>> > +struct mt_device {
>> > +   struct mt_slot curdata; /* placeholder of incoming data */
>> > +   __u8 num_received;      /* how many contacts we received */
>> > +   __u8 num_expected;      /* expected last contact index */
>> > +   __u8 maxcontacts;
>> > +   bool curvalid;          /* is the current contact valid? */
>> > +   struct mt_slot *slots;
>> > +};
>>
>> With Benjamin's i2c-hid implimentation, is it possible to make
>> hid-multitouch not depend on USBHID and reuse it to drive this device?

We can already use hid-multitouch with hid over I2C devices (I'm
testing my i2c devices with this module).
But it's true that hid-multitouch depends on usbhid, and I the funny
think is that I was removing this dependency today.
The fact is that currently, i2c devices do not segfault with
hid-multitouch  because win8 devices do not require anymore to set
some feature at plug.

>
> Exactly. Before looking any further - is this the same part that Tom Lin
> posted a driver for earlier this summer?

I'm not Elan, and I can not be sure, but judging from the "hello
packets" and the other commands, I doubt this device is an I2C over
HID one.

Anyway, reusing hid-multitouch for this specific case seams to be a
little bit difficult. You would have first to provide a fake report
descriptor (or inject commands as if you were hid-core) and then, you
would have to reformat the incoming data into valid win7 (or 8)
packets. Judging by the functions elan_touch_parse_fid,
elan_touch_parse_wid and elants_parse_xy, the data seem to be mixed
(all the finger ids at the beginning, and not one per touch), so it is
definitively needed to recreate a valid HID packet.

So I'm not surprised with the duplicated code. However, Henrik did a
big job in kernel 3.7 to factorize mt code, and some part of the
duplication can be achieve with these functions (look at
input_mt_sync_frame and input_mt_get_slot_by_key for example).

Cheers,
Benjamin

>
> Thanks.
>
> --
> Dmitry
