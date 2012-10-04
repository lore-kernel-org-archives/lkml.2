Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2JDUj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:39:26 -0400
Received: from mxout1.idt.com ([157.165.5.25]:55017 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab2JDUjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:39:13 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: RE: [PATCH 5/5] rapidio: add destination ID allocation mechanism
Thread-Topic: [PATCH 5/5] rapidio: add destination ID allocation mechanism
Thread-Index: AQHNoZwpoIGDCZeEDUW6exyb7S8HmpeooSqAgADq5dA=
Date: Thu, 4 Oct 2012 20:39:01 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D1499FC823@corpmail2.na.ads.idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
	<1349291923-22860-6-git-send-email-alexandre.bounine@idt.com>
 <20121003153625.39fd5af7.akpm@linux-foundation.org>
In-Reply-To: <20121003153625.39fd5af7.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 03, 2012 6:36 PM
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> On Wed,  3 Oct 2012 15:18:43 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > ...
> >
> > +static u16 rio_destid_alloc(struct rio_net *net)
> > +{
> > +	int destid;
> > +	struct rio_id_table *idtab = &net->destid_table;
> > +
> > +	spin_lock(&idtab->lock);
> > +	destid = find_next_zero_bit(idtab->table, idtab->max, idtab-
> >next);
> > +	if (destid >= idtab->max)
> > +		destid = find_first_zero_bit(idtab->table, idtab->max);
> > +
> > +	if (destid < idtab->max) {
> > +		idtab->next = destid + 1;
> > +		if (idtab->next >= idtab->max)
> > +			idtab->next = 0;
> > +		set_bit(destid, idtab->table);
> > +		destid += idtab->start;
> > +	} else
> > +		destid = RIO_INVALID_DESTID;
> > +
> > +	spin_unlock(&idtab->lock);
> > +	return (u16)destid;
> > +}
> 
> This is round-robin rather than the simpler first-fit, and this reader
> doesn't know why.  Suggest the addition of a code comment explaining
> this decision.

This is to make debugging easier. Having fresh new destID assigned to
a device after insertion helps to analyze switch routing table updates.
Yes, find-first is sufficient and better understandable (I had it in
early version).
I will switch to find-first scenario to make things clear.   

> 
> > +/*
> > + * rio_destid_reserve - Reserve the specivied destID
> > + * net: RIO network
> > + * destid: destID to reserve
> > + *
> > + * Tries to reserve the specified destID.
> > + * Returns 0 if successfull.
> > + */
> > +static int rio_destid_reserve(struct rio_net *net, u16 destid)
> > +{
> > +	int oldbit;
> > +	struct rio_id_table *idtab = &net->destid_table;
> > +
> > +	destid -= idtab->start;
> > +	spin_lock(&idtab->lock);
> > +	oldbit = test_and_set_bit(destid, idtab->table);
> > +	spin_unlock(&idtab->lock);
> > +	return oldbit;
> > +}
> > +
> > +/*
> > + * rio_destid_free - free a previously allocated destID
> > + * net: RIO network
> > + * destid: destID to free
> > + *
> > + * Makes the specified destID available for use.
> > + */
> > +static void rio_destid_free(struct rio_net *net, u16 destid)
> > +{
> > +	struct rio_id_table *idtab = &net->destid_table;
> > +
> > +	destid -= idtab->start;
> > +	spin_lock(&idtab->lock);
> > +	clear_bit(destid, idtab->table);
> > +	spin_unlock(&idtab->lock);
> > +}
> > +
> > +/*
> > + * rio_destid_first - return first destID in use
> > + * net: RIO network
> > + */
> > +static u16 rio_destid_first(struct rio_net *net)
> > +{
> > +	int destid;
> > +	struct rio_id_table *idtab = &net->destid_table;
> > +
> > +	spin_lock(&idtab->lock);
> > +	destid = find_first_bit(idtab->table, idtab->max);
> > +	if (destid >= idtab->max)
> > +		destid = RIO_INVALID_DESTID;
> > +	else
> > +		destid += idtab->start;
> > +	spin_unlock(&idtab->lock);
> > +	return (u16)destid;
> > +}
> > +
> > +/*
> > + * rio_destid_next - return next destID in use
> > + * net: RIO network
> > + * from: destination ID from which search shall continue
> > + */
> 
> All these code comments look like kerneldoc, but they aren't.
> kerneldoc
> uses /** and identifiers have a leading `@'.  And that's OK - one
> doesn't *have* to use kerneldoc.  But a lot of
> drivers/rapidio/rio-scan.c is already using kerneldoc so the
> inconsistency is odd.

Idea here was that keeping static functions out of kerneldoc may
have sense and result in cleaner doc output. This was my first attempt
to take that path. Probably, kerneldoc adjustment patch for entire
file (or even all RapidIO files) would be more appropriate instead of
changing style half-way.
As you noticed, these comments are similar to kerneldoc - easy to get back
to old style. I will restore kerneldoc style for affected functions. 

> 
> >
> > ...
> >
> > -static struct rio_net __devinit *rio_alloc_net(struct rio_mport
> *port)
> > +static struct rio_net __devinit *rio_alloc_net(struct rio_mport
> *port,
> > +					       int do_enum, u16 start)
> >  {
> >  	struct rio_net *net;
> >
> >  	net = kzalloc(sizeof(struct rio_net), GFP_KERNEL);
> > +	if (net && do_enum) {
> > +		net->destid_table.table = kzalloc(
> > +			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size))
> *
> > +			sizeof(long),
> > +			GFP_KERNEL);
> 
> kcalloc() would be idiomatic here.

Agree. Will change.

> 
> > +		if (net->destid_table.table == NULL) {
> > +			pr_err("RIO: failed to allocate destID table\n");
> > +			kfree(net);
> > +			net = NULL;
> > +		} else {
> > +			net->destid_table.start = start;
> > +			net->destid_table.next = 0;
> > +			net->destid_table.max =
> > +					RIO_MAX_ROUTE_ENTRIES(port->sys_size);
> > +			spin_lock_init(&net->destid_table.lock);
> > +		}
> > +	}
> > +
> >
> > ...
> >

