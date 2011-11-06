Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1KFUNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:13:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55076 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1KFUNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:13:11 -0500
MIME-Version: 1.0
In-Reply-To: <87r51l41dj.fsf@hohndel.org>
References: <87r51l41dj.fsf@hohndel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 6 Nov 2011 12:12:49 -0800
X-Google-Sender-Auth: Qjh0Kxvdp2Da93zfE98--n16Yoc
Message-ID: <CA+55aFw22MKWqwUaWpj-=gquEmUjdTWmk_ibe3bxYPySq_mCSA@mail.gmail.com>
Subject: Re: [PATCH] Add support for the Mid 2011 MacBook Air keyboard layout
To: Dirk Hohndel <hohndel@infradead.org>
Cc: Joshua V Dillon <jvdillon@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 9:16 AM, Dirk Hohndel <hohndel@infradead.org> wrote:
>
> When adding support for the MacBookAir4,x models in commit
> 5d922baa631058c7e37ae33e81c4d3e6437f8d1d Joshua Dillon overlooked
> that they have a slightly different keyboard layout compared to the older
> MacBook Air models. With this patch the function keys all work as
> advertized, including keyboard brightness, etc.
>
> Signed-off-by: Dirk Hohndel <hohndel@infradead.org>

Hmm. I think this is wrong.

Why?

Because it works unmodified for me on my MacBook Air.

Now, I have the 11" one which apparently has a different keyboard ID,
but the *reason* it works for me is that my keyboard ID is apparently
0x0249, which is USB_DEVICE_ID_APPLE_WELLSPRING6A_ANSI.

And because that one isn't known by the broken quirks at all, it falls
back on the standard apple_fn_keys[] translation.

Which is the *right* translation for me, and judging by your patch,
it's the right translation for you too.

So I suspect that the *right* thing to do is to just remove the broken
WELLSPRING6 cases. Exactly the same way that da617c7cb915 ("HID:
consolidate MacbookAir 4,1 mappings") did for the WELLSPRING6A ones.

So I suspect the only case that should use the "macbookair_fn_keys"
thing is the *old* macbook air ("WELLSPRING4"). They were added in
commit 5d922baa6310, and that commit implies that it was never tested
all that much ("reportedly unchanged from the 3,2 predecessor and
seems to work well.")

So I think the right patch is just this one:

     drivers/hid/hid-apple.c |    3 ---
     1 files changed, 0 insertions(+), 3 deletions(-)

    diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
    index 8cdb4b45b30a..299d23871122 100644
    --- a/drivers/hid/hid-apple.c
    +++ b/drivers/hid/hid-apple.c
    @@ -183,9 +183,6 @@ static int hidinput_apple_event(struct
hid_device *hid, struct input_dev *input,
     		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
     				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
     			table = macbookair_fn_keys;
    -		else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
    -				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
    -			table = macbookair_fn_keys;
     		else if (hid->product < 0x21d || hid->product >= 0x300)
     			table = powerbook_fn_keys;
     		else

instead. Hmm? Does that work for you?

               Linus
