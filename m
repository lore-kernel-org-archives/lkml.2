Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0IMQ50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:57:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35811 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0IMQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:57:25 -0400
Date: Mon, 13 Sep 2010 18:57:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913185721.59ad9b4d@basil.nowhere.org>
In-Reply-To: <20100913154750.GA26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284087065-32722-5-git-send-email-ying.huang@intel.com>
	<20100910160211.GH4879@redhat.com>
	<20100910181929.4f35ab7c@basil.nowhere.org>
	<20100910184039.GK4879@redhat.com>
	<1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
	<20100913141140.GB27371@redhat.com>
	<20100913172438.37443bf7@basil.nowhere.org>
	<20100913154750.GA26290@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 11:47:50 -0400
Don Zickus <dzickus@redhat.com> wrote:

> 
> > 
> > Then there isn't necessarily something to "debug": data corruption
> > can happen without any bugs being around (and in fact
> > that's the common case, assuming production systems)
> > 
> > So I'm not sure what you're debugging here. Are you being the
> > support technician for the system through bugzilla? That sounds
> > inefficient.
> 
> The problem I repeatedly deal with for RHEL systems is a customer
> sees an unknown NMI printed on their screen and sometimes the machine
> falls apart shortly after, sometimes it doesn't.  Obviously they are
> going to file a bug asking why.  A chunk of the problems are bad
> hardware/firmware.  But the problem is which one.

NMIs are usually hardware.

BTW one big issue here is that we don't display anything
on the screen so the system seems hung. KMS solves this,
but unfortunately not for the video chipsets 
often used in servers.

Part of it is solved by serializing the error
and defaulting to reboot after panic (currently NMI doesn't do that,
MCE already does, NMI should too imho) 

> 
> Replacing a slot card is easy, replacing a motherboard is not.  So I
> usually try to determine which device is failing by walking the pci
> bus and looking for the serr bits or some of the pci-e status bits.

You don't necessarily need to replace anything, it could
be just unlucky data corruption (e.g. a big enough cosmic ray
that flipped enough bits that the normal error correction
couldn't fix it anymore)

> 
> It is inefficient, but I haven't had time to figure out a way to
> clean it up.  And just for the record, I usually see an unknown NMI
> report every other week.

At least ignoring the data corruption is not the way to handle
it. I don't think you'll do your customers a favor this way.
 
> > Anyways for hardware support we could probably dump some
> > more information at panic or better through error
> > serialization, but the word "debug" is IMHO an very wrong
> > way to think about that.
> 
> Well, I can use 'diagnos' or 'determine' if you want.  But at the end
> of the day, we have customers that see scary software messages and
> expect us to give them reasonable direction to fix their problems.

Usually these problems shouldn't be handled by kernel hackers,
it's something for a hardware technician. If kernel
hackers have to handle it something is very wrong.

IMHO the software should give the customer enough information
to fix (or rather let their hardware technician) work it out.

If it's not good enough for this we have to improve it. But
ignoring the errors is not the way to do that.

BTW one issue is that the screen is not big enough for all
the information that is really useful for this. So I suspect
to have it really useful you need to accept that some information
will only be available through serialization (e.g. if you 
wanted to dump parts of the PCI config space)

-Andi



-- 
ak@linux.intel.com -- Speaking for myself only.
