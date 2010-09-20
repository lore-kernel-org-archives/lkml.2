Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0ITOcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:32:15 -0400
Received: from mxout1.idt.com ([157.165.5.25]:52586 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab0ITOcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:32:14 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
Date: Mon, 20 Sep 2010 07:31:22 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100914151219.5d92c6f9.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
thread-index: ActUWX1I2ZMr0sPEQliB9RI0KN5TdwEcWHwQ
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-4-git-send-email-alexandre.bounine@idt.com> <20100914151219.5d92c6f9.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Micha Nelissen" <micha@neli.hopto.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > @@ -219,6 +219,7 @@ struct rio_net {
> >  /**
> >   * struct rio_switch - RIO switch info
> >   * @node: Node in global list of switches
> > + * @rdev: Associated RIO device structure
> >   * @switchid: Switch ID that is unique across a network
> >   * @hopcount: Hopcount to this switch
> >   * @destid: Associated destid in the path
> > @@ -234,6 +235,7 @@ struct rio_net {
> >   */
> >  struct rio_switch {
> >  	struct list_head node;
> > +	struct rio_dev *rdev;
> >  	u16 switchid;
> >  	u16 hopcount;
> >  	u16 destid;
> 
> What is the locking for rdev?

This question prompted me consider the following change:

Because the rio_switch structure (in current implementation) is a
dynamically allocated part of rio_dev, I think it may be simpler to
combine them into single allocation by using zero length array
declaration:

struct rio_dev {
    struct list_head global_list;
    struct list_head net_list;
    .....
    ..... rest of rio_dev
    .....
    struct rio_switch switch[0];
}

This will remove extra memory allocation, remove overlapping structure
members and clean code sections like one shown below:

	u8 hopcount = 0xff;
	u16 destid = rdev->destid;

	if (rdev->rswitch) {
		destid = rdev->rswitch->destid;
		hopcount = rdev->rswitch->hopcount;
	}    

And this looks better aligned with RapidIO definitions - both: endpoints
and switches are RIO devices. The current implementation of rio_dev
somewhat separates rio_switch from its common part (this is why I have
added that link into rio_switch). We may keep using the pointer to
associated rio_dev, but reworking the rio_dev structure seems better way
to me.

Please, let me know what do you think about this conversion. And if
there are no objections I will make a patch.

Alex.
     
