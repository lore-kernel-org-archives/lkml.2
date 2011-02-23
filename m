Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1BWRCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:02:31 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58741 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab1BWRC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IHVt4Rd77CWDo3LzWi3AVSTrb+WtXtVnYkFzq93sAV9mhP/RmS3qGBxnd60ZJhK0lV
         QzH3qhOh4WzdzrQWT5INfmA/It2nm7yqQ871THUwCi3SQ0fXQfgCDNtvyuI+3EnTPDi8
         rCgGzwCdOl3B1GyUUoBjoN0UxJSpojRvpirbU=
Date: Wed, 23 Feb 2011 20:02:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Anoop P A <anoop.pa@gmail.com>
Cc: "gregkh @ suse . de" <gregkh@suse.de>,
        "dbrownell @ users . sourceforge . net" 
	<dbrownell@users.sourceforge.net>,
        "stern @ rowland . harvard . edu" <stern@rowland.harvard.edu>,
        "pkondeti @ codeaurora . org" <pkondeti@codeaurora.org>,
        "jacob . jun . pan @ intel . com" <jacob.jun.pan@intel.com>,
        "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
        "alek . du @ intel . com" <alek.du@intel.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "gadiyar @ ti . com" <gadiyar@ti.com>,
        "ralf @ linux-mips . org" <ralf@linux-mips.org>,
        "linux-mips @ linux-mips . org" <linux-mips@linux-mips.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v5] EHCI bus glue for on-chip PMC MSP USB controller
Message-ID: <20110223170205.GE19898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Anoop P A <anoop.pa@gmail.com>,
	"gregkh @ suse . de" <gregkh@suse.de>,
	"dbrownell @ users . sourceforge . net" <dbrownell@users.sourceforge.net>,
	"stern @ rowland . harvard . edu" <stern@rowland.harvard.edu>,
	"pkondeti @ codeaurora . org" <pkondeti@codeaurora.org>,
	"jacob . jun . pan @ intel . com" <jacob.jun.pan@intel.com>,
	"linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
	"alek . du @ intel . com" <alek.du@intel.com>,
	"linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
	"gadiyar @ ti . com" <gadiyar@ti.com>,
	"ralf @ linux-mips . org" <ralf@linux-mips.org>,
	"linux-mips @ linux-mips . org" <linux-mips@linux-mips.org>,
	Greg KH <greg@kroah.com>
References: <4D5ABB65.3090101@parrot.com>
 <1298388933-13707-1-git-send-email-anoop.pa@gmail.com>
 <20110222200427.GB1966@bicker>
 <1298467343.9950.119.camel@paanoop1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298467343.9950.119.camel@paanoop1-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 06:52:23PM +0530, Anoop P A wrote:
> > Cannot find the msp_usb.h in linux-next.  Doesn't compile.
> msp_usb.h has made it's way to linux-mips queue tree along with the
> platform code

Hm...  Ralf is on the CC list.  Ralf, why are the "Patches queued for
the next Linux kernel release." not included in linux-next?

> > > +	val = ehci_readl(ehci, (u32 *)base);
> > 
> > It doesn't compile so I can't test this, but I think that this will
> > cause a sparse warning.  "base" should have an __iomem tag.  Please
> > run sparse on this driver.
> Looks like mips platform build has been broken on linux-next ( unable to
> configure) . However I have tested code with linux-queue tree ( mips)
> and didn't see any such warnings

Sparse is an external tool.  You have to install it and build with
make C=1 drivers/usb/file.o

> > > +	temp = HCS_N_CC(ehci->hcs_params) * HCS_N_PCC(ehci->hcs_params);
> > > +	temp &= 0x0f;
> > 
> > companion HCs * ports per CC & 0xf?
> > 
> > What's the &= 0x0f for?  It's left out of the printk.
> Code got carried forward from ehci-pci.c . Is that says ehci-pci.c is
> uptodate? .  

My guess is that ehci-pci.c is buggy.  Anyway this is just a work around
to handle buggy hardware.  Since the code here just prints some debug
output and doesn't do the work arounds we might as well remove the whole
thing?  It seems unlikely that your mips hardware will have the same
bug.

> > > +static int ehci_msp_suspend(struct device *dev)
> > > +{
> > > +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> > > +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > > +	unsigned long flags;
> > > +	int rc;
> > > +
> > > +	return 0;
> > > +	rc = 0;
> > > +
> > > +	if (time_before(jiffies, ehci->next_statechange))
> > > +		usleep(10000);
> > 
> > Is there still a usleep() function?  Either way, can you send us
> > something that compiles on linux-next?
> Again code got carried from ehci-pci.c .(changed msleep to usleep as
> checkpatch complained about it). I am unable to compile mips targets in
> linux-next tree . However this patch is tested with both linux-stable
> and linux-queue tree of l-m-o

checkpatch.pl complains because msleep() is not accurate for tiny
amounts of time.  There is no usleep() function because trying to be
that accurate is a lot of work and causes a lot of interrupts.  There
is a usleep_range() function instead which lets the scheduler group
wakeups together.  This is documented in
Documentation/timers/timers-howto.txt

Also this is dead code.  No one will complain, if you just delete it.

regards,
dan carpenter
