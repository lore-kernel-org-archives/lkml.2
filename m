Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1HKVjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:39:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61517 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1HKVjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110811180507.GC5884@xanatos>
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
	<4E42A4AE.4020008@gmail.com>
	<20110810231552.GA7194@xanatos>
	<CACTFLAP9eRG6TVtFsNGO+oDu0U0gOUth-_TzLeW2yGb6Jxn2tA@mail.gmail.com>
	<20110811164539.GB5884@xanatos>
	<CACTFLAOi5u-YL+FKGotPSBv5BgEhKO5FLwZeJKdgyis3nZLbcw@mail.gmail.com>
	<20110811180507.GC5884@xanatos>
Date: Thu, 11 Aug 2011 23:39:03 +0200
Message-ID: <CACTFLAMcOMv4D8k-P24TAkPwLRgYps4hoO-vC1NH+cibcsrUFQ@mail.gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
From: Daniel Mack <zonque@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
        =?UTF-8?B?TWF0xJtqIExhaXRs?= <matej@laitl.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 8:05 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Thu, Aug 11, 2011 at 07:27:15PM +0200, Daniel Mack wrote:
>> On Thu, Aug 11, 2011 at 6:45 PM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>> > On Thu, Aug 11, 2011 at 02:57:41AM +0200, Daniel Mack wrote:
>> >> On Thu, Aug 11, 2011 at 1:15 AM, Sarah Sharp
>> >> <sarah.a.sharp@linux.intel.com> wrote:
>> >> > On Wed, Aug 10, 2011 at 05:33:02PM +0200, Daniel Mack wrote:
>> >> >> On 08/10/2011 04:32 PM, Alan Stern wrote:
>> >> >> >Looking at the driver's current code, it appears that your patch
>> >> >> >does not fix the bug properly.  Using discontiguous regions in the
>> >> >> >transfer buffer is perfectly okay.  The real problem is later on,
>> >> >> >where you do:
>> >> >> >
>> >> >> >if (send_it) { out->number_of_packets = FRAMES_PER_URB;
>> >> >> >
>> >> >> >This should be
>> >> >> >
>> >> >> >out->number_of_packets = outframe;
>> >> >> >
>> >> >> >The way it is now, the USB stack will try to use data from all the
>> >> >> >frame descriptors, and the last few will be stale because the loop
>> >> >> >doesn't set them.
>> >> >>
>> >> >> That's actually true, even though it doesn't seem to cause any trouble.
>> >> >> I tested everything here of course, and the output URBs return back from
>> >> >> the USB stack with their length fields zeroed out, which then
>> >> >> causes the stack to send packets with zero-length fields at the end.
>> >> >
>> >> > Actually, it causes system hangs when the driver is loaded on a device
>> >> > attached to a USB 3.0 port, as Alan Stern pointed out:
>> >> >
>> >> > https://bugzilla.kernel.org/show_bug.cgi?id=40702
>> >>
>> >> Yes, I've noticed this.
>> >>
>> >> > Please don't submit zero-length transfers.  The xHCI driver just isn't
>> >> > able to handle it.  Arguably, it probably should have just rejected your
>> >> > URB when it found a zero length buffer, so I'll probably be submitting a
>> >> > patch to fix that.
>> >>
>> >> According to the spec, sending zero-length frames should be fine, no?
>> >> Is there any particular reason why XCHI can't handle this while EHCI
>> >> can? And does my patch fix the driver for XHCI?
>> >
>> > Ok, yes, you're correct that the xHCI spec allows the transfer length to
>> > be set to zero.  In the case where the frame buffer is zero-length, is
>> > the buffer pointer still valid?  It's not clear from the spec whether it
>> > needs to be.
>>
>> Well, the buffer pointer is set in the URB, not in its individual iso
>> subframes which just denotes them via the offset field. So yes, it is
>> valid in my case. But it doesn't matter anymore, as the code which
>> does that is now gone :)
>
> Do you mean it was removed with this patch:
>
> http://git.kernel.org/?p=linux/kernel/git/tiwai/sound-2.6.git;a=commitdiff;h=15439b
>
> Because according to Matej, he applied that patch, plus my patch to
> reject zero-length buffers[1], and he saw debugging that indicated he
> *did* see zero-length buffers.  Is there any chance your driver might
> submit a zero-length buffer in the middle of the isochronous URB
> transfer array?

Hmm, judging from the code, this can only ever happen if we receive an
inbound iso frame which has a valid status and an actual_length of
zero. Also, it was not neccessary to catch this case for EHCI.

Maetj, does this patch make any difference?


Daniel



diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index aa52b3e..b48adb9 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -633,6 +634,10 @@ static void read_completed(struct urb *urb)
                        continue;

                len = urb->iso_frame_desc[outframe].actual_length;
+
+               if (len == 0)
+                       continue;
+
                out->iso_frame_desc[outframe].length = len;
                out->iso_frame_desc[outframe].actual_length = 0;
                out->iso_frame_desc[outframe].offset = offset;
