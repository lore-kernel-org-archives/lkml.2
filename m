Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2HBRpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:45:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab2HBRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:45:44 -0400
Date: Thu, 2 Aug 2012 19:45:38 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: Tim Bird <tim.bird@am.sony.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "Heinz.Egger@linutronix.de" <Heinz.Egger@linutronix.de>,
        "thomas.wucher@linutronix.de" <thomas.wucher@linutronix.de>,
        "shmulik.ladkani@gmail.com" <shmulik.ladkani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Marius.Mazarel@ugal.ro" <Marius.Mazarel@ugal.ro>,
        "nyoushchenko@mvista.com" <nyoushchenko@mvista.com>
Subject: Re: UBI fastmap updates
Message-ID: <20120802194538.26e2ec98@spider.haslach.nod.at>
In-Reply-To: <1343929200.25013.197.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
	<20120802165132.1bf1e5d7@spider.haslach.nod.at>
	<1343924267.25013.156.camel@sauron.fi.intel.com>
	<20120802183210.7076aa48@spider.haslach.nod.at>
	<1343925930.25013.163.camel@sauron.fi.intel.com>
	<501AB2C8.9010805@am.sony.com>
	<1343929200.25013.197.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 02 Aug 2012 20:40:00 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:

> Hi Tim,
> 
> On Thu, 2012-08-02 at 10:03 -0700, Tim Bird wrote:
> > I'm don't understand what "UBI liability" is.  Can you please
> > clarify? What breaks if the PEBs get consumed?
> 
> let me try. Let's forget about bad blocks and assume we are talking
> about NOR flash. For simplicity.
> 
> Let's also first forget about fastmap so far and talk about the
> current design.
> 
> Suppose you have 100 PEBs on your flash. Suppose UBI reserves 10 for
> its internal needs (volume table, etc). 90 PEBs are available to the
> user.
> 
> User now can create one or many volumes, but the overall size of the
> volumes cannot be larger than 90 LEBs.
> 
> This means that UBI guarantees that you can always fill all volumes
> with data there will always be enough PEBs to map to. This is UBI
> liability.
> 
> UBI will not allow you to create a volume of 100 LEBs because in this
> case it will not be able to guarantee that all LEBs will be writable.
> 
> I have invented this "liability" term on the spot actually. It
> basically means what UBI already "promised", what it reserved an put
> aside.
> 
> Now let's add fastmap support to the picture.
> 
> Suppose fastmap took another 10 PEBs and now we have 80 PEBs for the
> user.
> 
> The user can create a volume of 80 LEBs in size. And UBI has to
> guarantee that the user can at any point of time fill all of them with
> data.
> 
> This means that fastmap in no circumstances can grab any more than 10
> PEBs, because they are all reserved, UBI liability is 80 PEBs.
> 
> On other words, fastmap has to know how much PEBs it needs at the UBI
> initialization time, and reserve them. The _maximum_ value.
> 
> The same way other UBI sub-systems do. E.g., the volume table code
> reserves 2 PEBs, because this is the maximum it needs at any point of
> time. The WL subsystem reserves 1 PEB.
> 
> Of course this is not about reserving any specific PEB, this is just
> accounting - we have a couple of variable for reserved PEBs count.
> 
> So let's return to the error messages I spotted. They say that fastmap
> needs a PEB but cannot find one. The flash is nandsim and has no
> badblocks. Why fastmap did not find one? Because it did not reserve
> enough. And UBI tests create volumes of maximum possible size and fill
> it with data, so all available PEBs are mapped and thus, used.
> 
> What this means that the following situation is possible: the UBI
> volume is not fully filled yet and not all LEBs are mapped, so there
> are available PEBs, and fastmap successfully grows and reduces the
> amount of available PEBs. And when the user writes more data, he gets
> -ENOSPC.
> 
> And this is basically the problem I indicated.
> 
> To make my description complete, let's add NAND to the picture. We
> simply reserve 2% (by default, it is configurable) of PEBs for bad
> blocks handling. This is because vendors typically say that this is
> the maximum amount for the flash life-time.
> 
> If NAND wears-out a lot, and we run out of reserved PEBs, we switch to
> R/O mode, because we cannot anymore keep our "promise", the liability.
> 
> You can look at it this way. If you create an UBI volume, and mount it
> with UBIFS, you usually expect that all the free file-system space is
> available to you.
> 
> You probably will be disappointed if you write your file and get
> -ENOSPC because fastmap does grew and consumed a PEB which which was
> promised to your volume.
> 

Okay, then let's explicitly reserve a few PEBs for fastmap.
This should be very easy task.
How much PEB should be reserved? 2 x sizeof(fastmap)?

Thanks,
//richard
