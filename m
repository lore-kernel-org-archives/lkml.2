Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0JTOQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0JTOQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:16:45 -0400
Date: Wed, 20 Oct 2010 10:15:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, peterz@infradead.org
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101020141558.GB19090@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101011212006.GB23882@redhat.com>
 <1287555157.3026.21.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287555157.3026.21.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:12:37PM +0800, Huang Ying wrote:
> Hi, Don,
> 
> On Tue, 2010-10-12 at 05:20 +0800, Don Zickus wrote:
> > > @@ -366,6 +368,15 @@ unknown_nmi_error(unsigned char reason,
> > >  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
> > >  			NOTIFY_STOP)
> > >  		return;
> > > +	/*
> > > +	 * On some platforms, hardware errors may be notified via
> > > +	 * unknown NMI
> > > +	 */
> > > +	if (unknown_nmi_as_hwerr)
> > > +		panic(
> > > +		"NMI for hardware error without error record: Not continuing\n"
> > > +		"Please check BIOS/BMC log for further information.");
> > > +
> > >  #ifdef CONFIG_MCA
> > >  	/*
> > >  	 * Might actually be able to figure out what the guilty party
> > 
> > The only quirk I have left is the above piece, which is basically a
> > philosophy difference with Robert and myself.  Where we believe it should
> > be on the die_chain and Andi and yourself would like to see it explicitly
> > called out.
> 
> After some more thought, I found this is different from DIE_NMI and
> DIE_NMI_IPI case. I think the code added is for general unknown NMI
> processing instead of a device driver. What we do is not to add special
> processing for some devices, but treat unknown NMI as hardware error
> notification in general and use a white list to deal with broken
> hardware and stone age machine. Do you agree?
> 
> If so, it should not be turned into a notifier block unless you want to
> turn all general unknown NMI processing code into a notifier block.

Well, yes I actually do, mainly to keep the code simpler.  But also, after
having a conversation with someone yesterday, realized that unknown NMIs
are dealt with on a platform level and not a chipset level.

The reason I say that is some companies, like HP, have a special driver
hpwdt that they want to run in the case of an unknown NMI.  They don't
care about HEST or the other stuff, they want their BIOS call to take care
of it.  So now that hack has to be put into notifier somewhere.

I can only imagine Dell trying to do something similar as a value add.

To me it just makes sense to setup all the HEST stuff as default notifier
blocks and then have platform specific drivers register on top of them
(using the priority scheme).  This to me gives everyone flexibility on how
to handle the unknown NMIs.

Thoughts?

Cheers,
Don
