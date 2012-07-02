Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2GBSwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:52:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39451 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2GBSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <4FF14957.3040007@redhat.com>
References: <20120701172012.078559139@decadent.org.uk> <4FF14957.3040007@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jul 2012 11:52:23 -0700
X-Google-Sender-Auth: SjYN8qY2e9qTMlqMFjKBRGxUB4k
Message-ID: <CA+55aFyRTXqSvf9m08gbHCB0WhVF14Y6J2-AiFGiuTStq0Jr6Q@mail.gmail.com>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
To: Hans de Goede <hdegoede@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 12:10 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>
> So since 3.2 already tries READ_CAPACITY(10) first, this patch is
> not needed. It does not harm either, and if the scsi level reporting
> change ever finds its way into 3.2 stable (which it should not
> IMHO), then this patch will be needed.

Yeah, it should definitely not make it into stable. In fact, I'd
rather remove it from mainline too. The whole idea to do
READ_CAPACITY_16 by default was moronic.

James? Why does the SCSI subsystem always do these idiotic defaults?
We *know* that devices are buggy. Sure, USB storage tends to be
buggier than most, but the whole idea of "let's use the new way of
reporting that gets almost no testing" is just wrong.

I don't think the USB layer should have needed to work around this. I
don't think there should be a "try_10b" flag at all. I think the SCSI
code should just *never* do the 16b version unless it has done the 10b
version first and determined that the size doesn't fit.

And the code already had that logic got the read_10b case. The whole
logic to do 16b by default was crap. It *used* to at least only do it
for disks that were marked as having "protection", now it wants to do
it for anything that should be able to handle it. Which is bogus. The
whole "let's assume devices get it right" mindset is broken.

The mindset should be "let's assume devices are buggy, and be careful".

                         Linus
