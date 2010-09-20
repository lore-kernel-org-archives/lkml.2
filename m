Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0ITTSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:18:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159Ab0ITTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:18:31 -0400
Date: Mon, 20 Sep 2010 12:17:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Micha Nelissen" <micha@neli.hopto.org>
Subject: Re: [PATCH v2 03/10] RapidIO: Use stored ingress port number
 instead of register read
Message-Id: <20100920121725.66bb96d0.akpm@linux-foundation.org>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
	<1284476363-1677-4-git-send-email-alexandre.bounine@idt.com>
	<20100914151219.5d92c6f9.akpm@linux-foundation.org>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 07:31:22 -0700
"Bounine, Alexandre" <Alexandre.Bounine@idt.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > @@ -219,6 +219,7 @@ struct rio_net {
> > >  /**
> > >   * struct rio_switch - RIO switch info
> > >   * @node: Node in global list of switches
> > > + * @rdev: Associated RIO device structure
> > >   * @switchid: Switch ID that is unique across a network
> > >   * @hopcount: Hopcount to this switch
> > >   * @destid: Associated destid in the path
> > > @@ -234,6 +235,7 @@ struct rio_net {
> > >   */
> > >  struct rio_switch {
> > >  	struct list_head node;
> > > +	struct rio_dev *rdev;
> > >  	u16 switchid;
> > >  	u16 hopcount;
> > >  	u16 destid;
> > 
> > What is the locking for rdev?
> 
> This question prompted me consider the following change:
> 
> Because the rio_switch structure (in current implementation) is a
> dynamically allocated part of rio_dev, I think it may be simpler to
> combine them into single allocation by using zero length array
> declaration:
> 
> struct rio_dev {
>     struct list_head global_list;
>     struct list_head net_list;
>     .....
>     ..... rest of rio_dev
>     .....
>     struct rio_switch switch[0];
> }
> 
> This will remove extra memory allocation, remove overlapping structure
> members and clean code sections like one shown below:
> 
> 	u8 hopcount = 0xff;
> 	u16 destid = rdev->destid;
> 
> 	if (rdev->rswitch) {
> 		destid = rdev->rswitch->destid;
> 		hopcount = rdev->rswitch->hopcount;
> 	}    
> 
> And this looks better aligned with RapidIO definitions - both: endpoints
> and switches are RIO devices. The current implementation of rio_dev
> somewhat separates rio_switch from its common part (this is why I have
> added that link into rio_switch). We may keep using the pointer to
> associated rio_dev, but reworking the rio_dev structure seems better way
> to me.
> 
> Please, let me know what do you think about this conversion. And if
> there are no objections I will make a patch.
> 

If you say so ;)

The "variable length array at the end of the struct" thing is pretty
commonly used and works well.  As long as we never want to change the
number of switches on the fly (hotplug?).

