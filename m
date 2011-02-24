Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1BXFiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:38:20 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62344 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1BXFiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:38:19 -0500
Date: Wed, 23 Feb 2011 22:38:14 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness (v2)
Message-ID: <20110224053814.GA6046@angua.secretlab.ca>
References: <20110223150357.5a40793d@queued.net>
 <20110223232815.GC5404@angua.secretlab.ca>
 <20110223161630.3ae470bf@queued.net>
 <20110224040638.GB22111@angua.secretlab.ca>
 <20110223203649.4fcbe1db@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223203649.4fcbe1db@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 08:36:49PM -0800, Andres Salomon wrote:
> On Wed, 23 Feb 2011 21:06:38 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > > If the pkg2path hook isn't set and we're not sparc, we fall back to
> > > dp->name.  That sucks, but I don't know of a better way to do
> > > things.
> > 
> > More that sucks, it is just plain *wrong*.  :-)
> > 
> > so, to sum up, of_pdt_build_tree goes through the following process:
> > 
> > 1) dp = of_pdt_create_node
> >   - dp->name = of_pdt_get_one_property(node, "name"); /* name w/o
> > addr */
> > 
> > 2) (SPARC) dp->path_component_name = build_path_component(dp);
> >   - format <node name>@<address>
> >   - uses dp->name value
> >   - not on OLPC
> 
> Also:
>   - returns only the node name, not the full path
>   - implemented differently depending upon bus type (see
>     pci_path_component/sbus_path_component/ebus_path_component/ambapp_path_component)
>   - sparc32 implemented differently versus sparc64
> 
> > 
> > 3) dp->full_name = of_pdt_build_full_name(dp)
> >   - (SPARC) use dp->path_component_name
> >   - (OLPC) depend on value from of_pdt_try_pkg2path(node);
> >   - (others) fake it with an incorrect value?
> > 
> > Am I correct?
> 
> No.
> 
> (others) use of_pdt_try_pkg2path

Regardless, in all cases the semantics are absolutely clear; all
platforms *must* have a reliable way of obtaining the full path and
the path_component_name.  It it doesn't then it is fundamentally
broken.

> The reason why we fall back to dp->name is because I don't know what
> other architectures out there might not have package-to-path.  I'm
> perfectly fine with falling back to a WARN or BUG.

Respin to fallback on WARN() and bail out.  I'd be okay with merging a
patch that does that.  Falling back to dp->name is absolutely incorrect.

I agree that API refinements can be deferred to 2.6.39.

g.

