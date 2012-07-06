Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab2GFDFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:05:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36801 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2GFDF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:05:28 -0400
Date: Thu, 5 Jul 2012 21:05:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Message-ID: <20120706030525.GC17681@parisc-linux.org>
References: <20120703203512.GE28804@parisc-linux.org> <Pine.LNX.4.44L0.1207051736550.13212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1207051736550.13212-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 05:40:45PM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2012, Matthew Wilcox wrote:
> 
> > I think the necessary algorithm is simpler than that:
> > 
> > Send RC10 (unless the device supports PI, in which case it's probably
> > 	enterprisey and well-tested)
> > Send RC16
> > If RC10 capacity agrees with RC16 capacity, use extra RC16 data.
> > (for values of "agrees with" that include the "-1 to use RC16" indicator)
> > 
> > Sure, it's one extra command, but really, who cares?
> 
> Well, some USB devices might care.  Right now we don't send RC16 to 
> them at all because they get RC10 first and it indicates a capacity 
> below 2 TB.

Mmm.  I think I forgot a step:

Send RC10 (unless the device supports PI, in which case it's probably
	enterprisey and well-tested)
If the device indicates a level < SPC_2, stop here
Send RC16
If RC10 capacity agrees with RC16 capacity, use extra RC16 data.
 (for values of "agrees with" that include the "-1 to use RC16" indicator)

> In the end, usb-storage may be forced to use the NO_READ_CAPACITY_16 
> flag with all devices except those we can positively identify as a 
> USB-(S)ATA bridge.

Is that really an improvement over nobbling the IDENTIFY results to
force SCSI_2?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
