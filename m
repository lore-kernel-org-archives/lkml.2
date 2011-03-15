Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1CODeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:34:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34205 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1CODes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:34:48 -0400
Date: Mon, 14 Mar 2011 21:34:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] of/flattree: use of_attach_node to build tree, and
 associated cleanups
Message-ID: <20110315033443.GD5600@angua.secretlab.ca>
References: <1299716167-9656-1-git-send-email-dilinger@queued.net>
 <1299716167-9656-4-git-send-email-dilinger@queued.net>
 <20110312091056.GG9347@angua.secretlab.ca>
 <20110312113726.0bf060da@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312113726.0bf060da@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 11:37:26AM -0800, Andres Salomon wrote:
> On Sat, 12 Mar 2011 02:10:56 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > On Wed, Mar 09, 2011 at 04:16:07PM -0800, Andres Salomon wrote:
> > > Use a common function (of_attach_node) to build the device tree.
> > > This simplifies the flat device tree creation a bit, and as an
> > > added bonus allows us to drop a (now unused) field from the
> > > device_node struct.
> > > 
> > > There are a few minor cleanups snuck in here as well (comment
> > > additions, etc).
> > > 
> > > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > 
> > In addition to my comment about changing the tree order on the last
> > patch, unfortunately this patch will also break the newly added
> > of_fdt_unflatten_tree().  of_fdt_unflatten_tree() allows a driver to
> > unflatten a private dtb for its own use without it being attached to
> > the global tree or the global list of all nodes.  I had also forgotten
> > about this.  Shoot.
> 
> Ah, I was wondering what that was all about.  So we'd probably end up
> with something like:
> 
> void of_attach_node(struct device_node *dp)
> {
> 	unsigned long flags;
> 
> 	write_lock_irqsave(devtree_lock, &flags);
> 	__of_attach_node(allnodes, dp);
> 	write_unlock_irqrestore(devtree_lock, &flags);
> }
> 
> Most stuff could get away with just calling of_attach_node, with the
> unflatten_dt_node calling __of_attach_node (and either not caring
> about devtree_lock, as is currently the case, or grabbing it from
> unflatten_device_tree).

Yes.  The caller would be responsible for locking its own private dt
structure.

> > 
> > The solution would be a variant of of_attach_node which accepts a
> > private allnodes pointer.  That would also help with the ordering
> > issues because the order of the list could be explicitly reversed
> > before assigning the value to the real allnodes pointer.  Another
> > possible option would be an optional 'tail' pointer argument to
> > of_attach_node() which if present it would use as the insertion point
> > for adding the node, which would preserve the current sort order.
> 
> I was leaning towards a tail pointer, but I need to take a closer look
> at the two options.

okay.

g.

