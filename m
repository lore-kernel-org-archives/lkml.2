Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab1ELU70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:59:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53569 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab1ELU7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:59:25 -0400
MIME-Version: 1.0
In-Reply-To: <1305232563.2575.85.camel@mulgrave.site>
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
	<201105122203.13671.rjw@sisk.pl>
	<1305232563.2575.85.camel@mulgrave.site>
Date: Thu, 12 May 2011 16:59:24 -0400
Message-ID: <BANLkTin1peZBPiRZCbMEeqaME=-ok5dCQw@mail.gmail.com>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone
 (one line)
From: Charles Hannum <root@ihack.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 16:36, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2011-05-12 at 22:03 +0200, Rafael J. Wysocki wrote:
>> Hi,
>>
>> Added some CCs.
>>
>> On Thursday, May 12, 2011, Charles Hannum wrote:
>> > Short version: My laptop doesn't suspend when my Android phone is
>> > connected and has been “ejected”.
>> >
>> > Long version:
>> >
>> > Android phones connect as USB mass storage devices.  After the “Turn
>> > on USB storage” button has been clicked, there are a few different
>> > ways to detach the “disk”:
>> >
>> > 1) pull the cable
>> > 2) click “Turn off USB storage”
>> > 3) “eject” the device
>> >
>> > In cases 2 & 3, the USB device is still attached to the system, but
>> > will now return MEDIUM NOT PRESENT for many commands, including
>> > SYNCHRONIZE CACHE—basically it acts like any device with removable
>> > media.  However, the act of the “media” being removed does not
>> > invalidate sdkp->WCE; therefore sd_shutdown() and sd_suspend() still
>> > call sd_sync_cache(), which *fails* because it gets a MEDIUM NOT
>> > PRESENT sense code.  In the sd_suspend() case, this causes the entire
>> > suspend to fail, and the laptop rewakes immediately.
>
> So this was the subject of some debate when suspend of sd was first
> introduced.  The synopsis of that debate is that by suspending, we're
> about the power down the system, and anything in the cache will be lost,
> possibly causing corruption, so failure to synchronise the cache
> *should* abort suspend.

If the device has been “ejected”, there is by definition no data in
the cache that needs to be synchronized—or, if there is, it's because
we failed to do a SYNCHRONIZE CACHE in the eject path.  At this point
the device believes there's no medium present, and the driver even
agrees, so it's perfectly reasonable for the device to return MEDIUM
NOT PRESENT.  The problem here is a generic failure of the suspend
code in the case of removable media that has been removed—there is a
piece of state left behind in the driver that causes it to misbehave.

Nothing I have mentioned (other than enumerating the cable-pulling
case), nor the change I proposed, has anything whatsoever to do with
the user inappropriately yanking an active device.

>> > There are a few different ways to fix this; e.g. one could
>> > specifically test media_not_present() if a sense code is returned in
>> > sd_sync_cache().
>
> Isn't this the best approach?  For removable medium, the onus is on the
> user not to eject with the cache unsynced.  If the user ignores that, we
> should recognise the problem and take a caveat emptor approach.

I was attempting to make the case where the user behaved completely
appropriately work right, not worrying about the other cases.  It
seems a bit silly to even call sd_sync_cache() if we already know the
medium has been removed; furthermore, it means the behavior is
different between when the device is first plugged in (WCE is still 0)
and when it's been used and then ejected (WCE remains 1 until a new
medium is inserted); this inconsistency seems poor.

> As a side note: having write through caches on removable media is a
> really silly idea because of the above problem ...

In the Android case, I see no reason why it's a problem, and the
device acts appropriately under the circumstances.  And given tray
locking, I'm not sure why it's a problem even for spinning media.  But
regardless, these are real devices, and that ship has long since
sailed.
