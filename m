Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1BXTmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:42:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58568 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1BXTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:42:38 -0500
Date: Thu, 24 Feb 2011 12:42:34 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: dsd@laptop.org, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v5] of/promtree: allow DT device matching by fixing
 'name' brokenness
Message-ID: <20110224194234.GA8907@angua.secretlab.ca>
References: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
 <20110224093341.5a809a13@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224093341.5a809a13@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:33:41AM -0800, Andres Salomon wrote:
> On Thu, 24 Feb 2011 10:04:41 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > From: Andres Salomon <dilinger@queued.net>
> > 
> > Commit e2f2a93b, "of/promtree: add package-to-path support to pdt"
> > changed dp->name from using the 'name' property to using
> > package-to-path.  This fixed /proc/device-tree creation by eliminating
> > conflicts between names (the 'name' property provides names like
> > 'battery', whereas package-to-path provides names like
> > '/foo/bar/battery@0', which we stripped to 'battery@0').  However, it
> > also breaks of_device_id table matching.
> > 
> > The fix that we _really_ wanted was to keep dp->name based upon
> > the name property ('battery'), but based dp->full_name upon
> > package-to-path ('battery@0').  This patch does just that.
> > 
> > This changes all users (except SPARC) of promtree to use the full
> > result from package-to-path for full_name, rather than stripping the
> > directory out.  In practice, the strings end up being exactly the
> > same; this change saves time, code, and memory.
> > 
> > SPARC continues to use the existing build_path_component() code.
> > 
> > v2: combine two patches and revert of_pdt_node_name to original
> > version v3: use dp->phandle instead of passing around node
> > v4: warn/bail out for non-sparc archs if pkg2path is not set
> > v5: split of_pdt_build_full_name into sparc & non-sparc versions
> >     BUG() when pkg2path doesn't work.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > 
> > Hi Andres,
> > 
> > This is what I think the patch should really look like.  The
> > of_pdt_node_name() stuff really doesn't make sense to keep around
> > because what we *really* care about is the full name, not the path
> > component name.  Therefore I reorganized it so SPARC continues to use
> > it's build_path_component() to build up the full path; but everyone
> > else *must* provide a working mechanism to obtain the full path; be it
> > an actual call to OFW pkg2path, or something else.
> > 
> > Please take a look at let me know what you think.
> > 
> > g.
> > 
> >  drivers/of/pdt.c |  110
> > ++++++++++++++++++++---------------------------------- 1 files
> > changed, 40 insertions(+), 70 deletions(-)
> > 
> > diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> > index 28295d0..ab54819 100644
> > --- a/drivers/of/pdt.c
> > +++ b/drivers/of/pdt.c
> > @@ -36,19 +36,53 @@ unsigned int of_pdt_unique_id __initdata;
> >  	(p)->unique_id = of_pdt_unique_id++; \
> >  } while (0)
> >  
> > -static inline const char *of_pdt_node_name(struct device_node *dp)
> > +static char * __init of_pdt_build_full_name(struct device_node *dp)
> >  {
> > -	return dp->path_component_name;
> > +	int len, ourlen, plen;
> > +	char *n;
> > +
> > +	dp->path_component_name = build_path_component(dp);
> > +
> > +	plen = strlen(dp->parent->full_name);
> > +	ourlen = strlen(dp->path_component_name);
> > +	len = ourlen + plen + 2;
> > +
> > +	n = prom_early_alloc(len);
> > +	strcpy(n, dp->parent->full_name);
> > +	if (!of_node_is_root(dp->parent)) {
> > +		strcpy(n + plen, "/");
> > +		plen++;
> > +	}
> > +	strcpy(n + plen, dp->path_component_name);
> > +
> > +	return n;
> >  }
> 
> Sure, this part is fine.  The reason why this was originally in 2
> separate patches (and what I'd been attempting to do all along) was to
> keep the bugfix portion of it to a minimal size, and to have a separate
> generic cleanup patch that changed around more stuff.
> 
> 
> >  
> > -#else
> > +#else /* CONFIG_SPARC */
> >  
> >  static inline void of_pdt_incr_unique_id(void *p) { }
> >  static inline void irq_trans_init(struct device_node *dp) { }
> >  
> > -static inline const char *of_pdt_node_name(struct device_node *dp)
> > +static char * __init of_pdt_build_full_name(struct device_node *dp)
> >  {
> > -	return dp->name;
> > +	char *buf;
> > +	int len;
> > +
> > +	if (!of_pdt_prom_ops->pkg2path)
> > +		BUG();
> 
> I'd rather see WARN_ON() here.

This one needs to be BUG.  It is a *requirement* for the platform to
supply a pkg2path hook.  Although, I think I'll remove this line
anyway; if a new platform doesn't supply the hook, then it isn't even
going to boot, so no point bothering to execute this test for each an
every node in the tree.

> Our options if any of
> this fail are to BUG (causing bootup to fail, most likely),

Absolutely boot will fail.

> WARN and
> return NULL (causing the DT creation to not happen, which may affect
> things differently depending upon what the DT is being used for), or
> WARN and return dp->name (which would cause the DT to be created,
> albeit not correctly.  The more I think about it, the more I like that
> last option.  If the DT is being used for booting, that option would
> provide the best attempt at actually booting up.

I'm adamant on this point.  pkg2path *must* return a value path
string.  If it does not, then the node must not get registered.  I've
taken a look at the sparc code, and it really looks like the
assignment of full_name can be moved into of_pdt_create_node.  None of
the SPARC *_path_component functions seem to depend on the sibling or
allnodes pointers being populated.

> 
> 
> 
> > +
> > +	if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, 0, &len))
> > +		BUG();

I just noticed another potential bug here.  buf is unassigned and
random here.  Even though length is passed as '0', a random value is
effectively getting passed as the buf pointer.  It should be passed as
NULL to avoid any accidents.  Changed in my version of the patch.

> 
> Well, no, if pkg2path fails, we shouldn't really BUG().  There may be
> some reason why the call fails for only a particular node (for
> example, perhaps an invalid phandle gets passed, or there's a bug in
> the firmware for that particular node).  I'd rather disable the DT or
> just disable the node and have the machine at least bring up a
> framebuffer console with kernel logs showing some kind of warning/error
> message.

If firmware is buggy, then pkg2path must deal with it.  It is not okay
for it to return NULL.  (I know that pkg2path is an OFW command, but
in this context it really means the linux wrapper to pkg2path which
has the semantics, "give me the unique, full and accurate path for
this node").  If OFW pkg2path doesn't work, then the platform code
must work around it.  I'm pushing back on this because I do not want
to see platform workarounds in the common code.

(I'd almost rather see all promtree users adopt the sparc approach of
building up from known data instead of calling into higher level OFW
functions, but that's an orthogonal debate).

*however* if you really want to implement a dp->name fallback, then I
would be okay with something like this:  At least it ensures every
full_path string is unique in the system.

static int broken_unique_id = 0;
sprintf(buf, "%s/%s-broken%i", parent->full_name, dp->name, broken_unique_id++);
pr_err("pkg2path busted; ugly name workaround applied\n");

For now I'm inclined to keep the BUG(), and I'll let you handle any
workarounds in the OLPC code if needed.

> 
> 
> 
> > +
> > +	buf = prom_early_alloc(len + 1);
> > +	if (!buf)
> > +		BUG();
> 
> Ditto.

If we cannot allocate ram at this point, we've got much bigger
problems.  BUG is appropriate here.... actually, if prom_early_alloc()
cannot provide memory, it should fail hard like sparc prom_64 does.
Care to craft a separate patch to make that change for OLPC?  (for
2.6.39; no rush)

I've pushed the latest version out to my devicetree/experimental
branch on git://git.secretlab.ca/git/linux-2.6.  Give it a spin and
make sure everything is still working for you.

g.
