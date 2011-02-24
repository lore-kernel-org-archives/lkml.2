Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab1BXEhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:37:03 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40044 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab1BXEhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:37:01 -0500
Date: Wed, 23 Feb 2011 20:36:49 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness (v2)
Message-ID: <20110223203649.4fcbe1db@queued.net>
In-Reply-To: <20110224040638.GB22111@angua.secretlab.ca>
References: <20110223150357.5a40793d@queued.net>
	<20110223232815.GC5404@angua.secretlab.ca>
	<20110223161630.3ae470bf@queued.net>
	<20110224040638.GB22111@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 21:06:38 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Wed, Feb 23, 2011 at 04:16:30PM -0800, Andres Salomon wrote:
> > On Wed, 23 Feb 2011 16:28:15 -0700
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
> > > On Wed, Feb 23, 2011 at 03:03:57PM -0800, Andres Salomon wrote:
> > > > 
> > > > Commit e2f2a93b changed dp->name from using the 'name' property
> > > > to using package-to-path.  This fixed /proc/device-tree
> > > > creation by eliminating conflicts between names (the 'name'
> > > > property provides names like 'battery', whereas package-to-path
> > > > provides names like '/foo/bar/battery@0', which we stripped to
> > > > 'battery@0').  However, it also breaks of_device_id table
> > > > matching.
> > > > 
> > > > The fix that we _really_ wanted was to keep dp->name based upon
> > > > the name property ('battery'), but based dp->full_name upon
> > > > package-to-path ('battery@0').  This patch does just that.
> > > > 
> > > > This also changes OLPC behavior to use the full result from
> > > > package-to-path for full_name, rather than stripping the
> > > > directory out.  In practice, the strings end up being exactly
> > > > the same; this change saves time, code, and memory.
> > > > 
> > > > Note that this affects sparc by reverting dp->name back to what
> > > > sparc was originally doing (looking at the name property).
> > > > 
> > > > v2: combine two patches and revert of_pdt_node_name to original
> > > > version.
> > > > 
> > > > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > > 
> > > Hi Andres, comments below.
> > > 
> > > g.
> > > 
> > > > ---
> > > >  drivers/of/pdt.c |   42
> > > > +++++++++++++++--------------------------- 1 files changed, 15
> > > > insertions(+), 27 deletions(-)
> > > > 
> > > > diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> > > > index 28295d0..a7aa85e 100644
> > > > --- a/drivers/of/pdt.c
> > > > +++ b/drivers/of/pdt.c
> > > > @@ -134,7 +134,7 @@ static char * __init
> > > > of_pdt_get_one_property(phandle node, const char *name) 
> > > >  static char * __init of_pdt_try_pkg2path(phandle node)
> > > >  {
> > > > -	char *res, *buf = NULL;
> > > > +	char *buf = NULL;
> > > >  	int len;
> > > >  
> > > >  	if (!of_pdt_prom_ops->pkg2path)
> > > > @@ -147,29 +147,6 @@ static char * __init
> > > > of_pdt_try_pkg2path(phandle node) pr_err("%s: package-to-path
> > > > failed\n", __func__); return NULL;
> > > >  	}
> > > > -
> > > > -	res = strrchr(buf, '/');
> > > > -	if (!res) {
> > > > -		pr_err("%s: couldn't find / in %s\n", __func__,
> > > > buf);
> > > > -		return NULL;
> > > > -	}
> > > > -	return res+1;
> > > > -}
> > > > -
> > > > -/*
> > > > - * When fetching the node's name, first try using
> > > > package-to-path; if
> > > > - * that fails (either because the arch hasn't supplied a PROM
> > > > callback,
> > > > - * or some other random failure), fall back to just looking at
> > > > the node's
> > > > - * 'name' property.
> > > > - */
> > > > -static char * __init of_pdt_build_name(phandle node)
> > > > -{
> > > > -	char *buf;
> > > > -
> > > > -	buf = of_pdt_try_pkg2path(node);
> > > > -	if (!buf)
> > > > -		buf = of_pdt_get_one_property(node, "name");
> > > > -
> > > >  	return buf;
> > > >  }
> > > >  
> > > 
> > > It seems to me that of_pdt_build_full_name will still be missing
> > > the '@<addr>' component on non-sparc non-olpc builds because it
> > > uses the broken of_pdt_node_name().  That needs to be fixed too,
> > > even if there are no current users (or removed).
> > 
> > 
> > The intent if for them to use the pkg2path hook.  If
> > they can't use that, they'll need an architecture-specific way to
> > figure out the @<addr> component.  It may even be possible for sparc
> > to use package-to-path; but either way, if an architecture doesn't
> > have package-to-path (OLPC and powerpc have it; I don't know about
> > sparc), and can't fake it, it'll need to do something special.
> > 
> > If the pkg2path hook isn't set and we're not sparc, we fall back to
> > dp->name.  That sucks, but I don't know of a better way to do
> > things.
> 
> More that sucks, it is just plain *wrong*.  :-)
> 
> so, to sum up, of_pdt_build_tree goes through the following process:
> 
> 1) dp = of_pdt_create_node
>   - dp->name = of_pdt_get_one_property(node, "name"); /* name w/o
> addr */
> 
> 2) (SPARC) dp->path_component_name = build_path_component(dp);
>   - format <node name>@<address>
>   - uses dp->name value
>   - not on OLPC

Also:
  - returns only the node name, not the full path
  - implemented differently depending upon bus type (see
    pci_path_component/sbus_path_component/ebus_path_component/ambapp_path_component)
  - sparc32 implemented differently versus sparc64

> 
> 3) dp->full_name = of_pdt_build_full_name(dp)
>   - (SPARC) use dp->path_component_name
>   - (OLPC) depend on value from of_pdt_try_pkg2path(node);
>   - (others) fake it with an incorrect value?
> 
> Am I correct?

No.

(others) use of_pdt_try_pkg2path

The reason why we fall back to dp->name is because I don't know what
other architectures out there might not have package-to-path.  I'm
perfectly fine with falling back to a WARN or BUG.

> 
> Faking it is clearly not acceptable.  The solution is to *force* all
> platforms to implement a method for obtaining the full path.  That
> means BUG() or WARN() if pkg2path is not populated, or if it returns
> NULL.  It also means no mucking about with of_pdt_try_pkg2path().
> Call ops->pkg2path directly and complain loudly when it does not work.
> 
> I see two choices:
> 1) implement ops->pkg2path for SPARC, but back it with
>    build_path_component() instead of a call to OF
> 2) #ifdef of_pdt_build_full_name() to use the current behaviour for
>    SPARC, but call pkg2path for everyone else.

Either of these are fine, but I don't think they should be within the
scope of the proposed patch.  I'd like to hear from Davem about whether
#1 is doable.  Also note that ops are different for sparc32 and sparc64.



> 
> Actually, I'd like to see build_path_component() refactored to return
> the full_name instead.  It is trivial to get the path component from


Again, this is Davem-land; I don't have a sparc machine to test any of
this with.  The proposed patch is a bug fix that I'd like to see go in;
I'm perfectly happy to refactor the APIs after that.


> the full name at any time, but it is not trivial to go the other
> direction.... but that is probably more surgery than should be done in
> this immediate bug-fix.  I'm assuming a fix is necessary before 2.6.38
> is finalized?

Well, a fix only affects Daniel's work.  It does, however, fix a bug
in sparc code.  I don't know if that breaks anything in practice.
