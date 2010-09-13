Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0IMRyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:54:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab0IMRx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:53:59 -0400
Date: Mon, 13 Sep 2010 13:53:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913175346.GC26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-5-git-send-email-ying.huang@intel.com>
 <20100910160211.GH4879@redhat.com>
 <20100910181929.4f35ab7c@basil.nowhere.org>
 <20100910184039.GK4879@redhat.com>
 <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
 <20100913141140.GB27371@redhat.com>
 <20100913172438.37443bf7@basil.nowhere.org>
 <20100913154750.GA26290@redhat.com>
 <20100913185721.59ad9b4d@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913185721.59ad9b4d@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 06:57:21PM +0200, Andi Kleen wrote:
> On Mon, 13 Sep 2010 11:47:50 -0400
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > 
> > > 
> > > Then there isn't necessarily something to "debug": data corruption
> > > can happen without any bugs being around (and in fact
> > > that's the common case, assuming production systems)
> > > 
> > > So I'm not sure what you're debugging here. Are you being the
> > > support technician for the system through bugzilla? That sounds
> > > inefficient.
> > 
> > The problem I repeatedly deal with for RHEL systems is a customer
> > sees an unknown NMI printed on their screen and sometimes the machine
> > falls apart shortly after, sometimes it doesn't.  Obviously they are
> > going to file a bug asking why.  A chunk of the problems are bad
> > hardware/firmware.  But the problem is which one.
> 
> NMIs are usually hardware.
> 
> BTW one big issue here is that we don't display anything
> on the screen so the system seems hung. KMS solves this,
> but unfortunately not for the video chipsets 
> often used in servers.

No most of our customer see messages being sent to the console or serial
part.  I haven't seen KMS hiding the info yet.

> 
> Part of it is solved by serializing the error
> and defaulting to reboot after panic (currently NMI doesn't do that,
> MCE already does, NMI should too imho) 
> 
> > 
> > Replacing a slot card is easy, replacing a motherboard is not.  So I
> > usually try to determine which device is failing by walking the pci
> > bus and looking for the serr bits or some of the pci-e status bits.
> 
> You don't necessarily need to replace anything, it could
> be just unlucky data corruption (e.g. a big enough cosmic ray
> that flipped enough bits that the normal error correction
> couldn't fix it anymore)

No, these are easily reproducible NMIs.  So far it they have been the
result of bad firmware (either features that are marked supported but not,
or register settings that changed between updates), nic cards that had
issues, or bad motherboards.

None of these issues went away because of a reboot.

> 
> > 
> > It is inefficient, but I haven't had time to figure out a way to
> > clean it up.  And just for the record, I usually see an unknown NMI
> > report every other week.
> 
> At least ignoring the data corruption is not the way to handle
> it. I don't think you'll do your customers a favor this way.

I never said I ignore them.  We try to resolve them quickly.

>  
> > > Anyways for hardware support we could probably dump some
> > > more information at panic or better through error
> > > serialization, but the word "debug" is IMHO an very wrong
> > > way to think about that.
> > 
> > Well, I can use 'diagnos' or 'determine' if you want.  But at the end
> > of the day, we have customers that see scary software messages and
> > expect us to give them reasonable direction to fix their problems.
> 
> Usually these problems shouldn't be handled by kernel hackers,
> it's something for a hardware technician. If kernel
> hackers have to handle it something is very wrong.
> 
> IMHO the software should give the customer enough information
> to fix (or rather let their hardware technician) work it out.

Yes, I agree, but the hardware folks usually like it when we give them a
better clue than 'hardware is broken'.  Something like the network stopped
working or your storage controller's firmware went bad, is usually more
helpful.

And the thing is, the hardware usually leaves a bread cumb trail of where
things went wrong.  It is just a matter of poking different chips to find
out who generated the error and report that.

> 
> BTW one issue is that the screen is not big enough for all
> the information that is really useful for this. So I suspect
> to have it really useful you need to accept that some information
> will only be available through serialization (e.g. if you 
> wanted to dump parts of the PCI config space)

Honestly, I don't think you need much screen real estate.  It would be
nice when an unknown NMI comes in, if the kernel just pokes around the hardware
registers and display a summary of what it found.  For example,

The following devices had error bits set in the status registers:
PCI device x:y.z - STATUS_BIT1 | STATUS_BIT2
HW device xyz - STATUS_BIT3
...

This at least gives the users some hardware they can remove/replace to see
if the problem goes away.

Right now I feel like it is one giant guessing game.

But I guess if we accept the fact that an unknown NMI will panic the box,
then we can probably be a little more liberal in breaking spinlocks and
poking around the hardware to display some userful info.

Just some thoughts.

Cheers,
Don
