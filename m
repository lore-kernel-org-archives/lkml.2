Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1HKDWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 23:22:38 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:54807
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab1HKDWf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 23:22:35 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dK9371K936eK1432N98dK4015Lzz1202hzz8275dhz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LPQUPA-02-LGP-02
X-M-MSG: 
Subject: Re: Allocating buffers for USB transfers (again)
From: Andiry Xu <andiry.xu@amd.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Daniel Mack <zonque@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, <pedrib@gmail.com>,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>, Robert Hancock <hancockrwd@gmail.com>
In-Reply-To: <20110810231552.GA7194@xanatos>
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
	 <4E42A4AE.4020008@gmail.com>  <20110810231552.GA7194@xanatos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Aug 2011 11:22:21 +0800
Message-ID: <1313032941.1918.8.camel@brienza-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-OriginalArrivalTime: 11 Aug 2011 03:22:25.0341 (UTC) FILETIME=[E41936D0:01CC57D5]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 16:15 -0700, Sarah Sharp wrote:
> On Wed, Aug 10, 2011 at 05:33:02PM +0200, Daniel Mack wrote:
> > On 08/10/2011 04:32 PM, Alan Stern wrote:
> > >Looking at the driver's current code, it appears that your patch
> > >does not fix the bug properly.  Using discontiguous regions in the
> > >transfer buffer is perfectly okay.  The real problem is later on,
> > >where you do:
> > >
> > >if (send_it) { out->number_of_packets = FRAMES_PER_URB;
> > >
> > >This should be
> > >
> > >out->number_of_packets = outframe;
> > >
> > >The way it is now, the USB stack will try to use data from all the
> > >frame descriptors, and the last few will be stale because the loop
> > >doesn't set them.
> > 
> > That's actually true, even though it doesn't seem to cause any trouble.
> > I tested everything here of course, and the output URBs return back from
> > the USB stack with their length fields zeroed out, which then
> > causes the stack to send packets with zero-length fields at the end.
> 
> Actually, it causes system hangs when the driver is loaded on a device
> attached to a USB 3.0 port, as Alan Stern pointed out:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=40702
> 
> Please don't submit zero-length transfers.  The xHCI driver just isn't
> able to handle it.  Arguably, it probably should have just rejected your
> URB when it found a zero length buffer, so I'll probably be submitting a
> patch to fix that.
> 

I think queue a zero-length TRB to xhci host is OK. I've not tested it,
but the issue here seems is caused by td->last_trb = NULL. Check
count_isoc_trbs_needed(), num_trbs will be 0 if the packet length is
zero and (addr & (TRB_MAS_BUFF_SIZE - 1)) is zero. We can not return
num_trbs as 0 to xhci_queue_isoc_tx(), which caused a td added to ep's
td list, while it's not actually queued to ep ring and last_trb is not
set.

In order to avoid this, we just make sure count_isoc_trbs_needed()
always return 1 or larger numbers, instead of reject the urb. Is that
feasible?

Thanks,
Andiry


