Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1BXUBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:01:16 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58916 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab1BXUBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:01:13 -0500
Date: Thu, 24 Feb 2011 12:01:09 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dsd@laptop.org, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v5] of/promtree: allow DT device matching by fixing
 'name' brokenness
Message-ID: <20110224120109.0ed9f473@queued.net>
In-Reply-To: <20110224194234.GA8907@angua.secretlab.ca>
References: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
	<20110224093341.5a809a13@queued.net>
	<20110224194234.GA8907@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 12:42:34 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Thu, Feb 24, 2011 at 09:33:41AM -0800, Andres Salomon wrote:
> > On Thu, 24 Feb 2011 10:04:41 -0700
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
> > > From: Andres Salomon <dilinger@queued.net>
[...]
> > >  static inline void irq_trans_init(struct device_node *dp) { }
> > >  
> > > -static inline const char *of_pdt_node_name(struct device_node
> > > *dp) +static char * __init of_pdt_build_full_name(struct
> > > device_node *dp) {
> > > -	return dp->name;
> > > +	char *buf;
> > > +	int len;
> > > +
> > > +	if (!of_pdt_prom_ops->pkg2path)
> > > +		BUG();
> > 
> > I'd rather see WARN_ON() here.
> 
> This one needs to be BUG.  It is a *requirement* for the platform to
> supply a pkg2path hook.  Although, I think I'll remove this line
> anyway; if a new platform doesn't supply the hook, then it isn't even
> going to boot, so no point bothering to execute this test for each an
> every node in the tree.
> 
> > Our options if any of
> > this fail are to BUG (causing bootup to fail, most likely),
> 
> Absolutely boot will fail.

Unnecessarily.  OLPC will still boot if the DT creation fails.  Even if
things are broken, it'll at least allow someone to report some errors
on the screen.  On the other hand, BUGing this early in boot means that
all a user will see is a black screen (or the OFW "loading kernel"
message). The framebuffer won't have been initialized, so.. yeah.

If it's a programmer who's hacking on this stuff, that's just
annoying.  If it's a user who has just upgraded their firmware and hit
a firmware bug in the field, that's much worse; it's
pretty much impossible to debug.


> 
> > WARN and
> > return NULL (causing the DT creation to not happen, which may affect
> > things differently depending upon what the DT is being used for), or
> > WARN and return dp->name (which would cause the DT to be created,
> > albeit not correctly.  The more I think about it, the more I like
> > that last option.  If the DT is being used for booting, that option
> > would provide the best attempt at actually booting up.
> 
> I'm adamant on this point.  pkg2path *must* return a value path
> string.  If it does not, then the node must not get registered.  I've
> taken a look at the sparc code, and it really looks like the
> assignment of full_name can be moved into of_pdt_create_node.  None of
> the SPARC *_path_component functions seem to depend on the sibling or
> allnodes pointers being populated.
> 
> > 
> > 
> > 
> > > +
> > > +	if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, 0, &len))
> > > +		BUG();
> 
> I just noticed another potential bug here.  buf is unassigned and
> random here.  Even though length is passed as '0', a random value is
> effectively getting passed as the buf pointer.  It should be passed as
> NULL to avoid any accidents.  Changed in my version of the patch.

Ah, nice catch, thanks.


> 
> > 
> > Well, no, if pkg2path fails, we shouldn't really BUG().  There may
> > be some reason why the call fails for only a particular node (for
> > example, perhaps an invalid phandle gets passed, or there's a bug in
> > the firmware for that particular node).  I'd rather disable the DT
> > or just disable the node and have the machine at least bring up a
> > framebuffer console with kernel logs showing some kind of
> > warning/error message.
> 
> If firmware is buggy, then pkg2path must deal with it.  It is not okay
> for it to return NULL.  (I know that pkg2path is an OFW command, but
> in this context it really means the linux wrapper to pkg2path which
> has the semantics, "give me the unique, full and accurate path for
> this node").  If OFW pkg2path doesn't work, then the platform code
> must work around it.  I'm pushing back on this because I do not want
> to see platform workarounds in the common code.

I'm fine with that, I just don't want to see BUG() happening that
early.  I think a workaround should be handled in common code.  I agree
that heroic workarounds for firmware bugs should be handled in
arch-specific pkg2path hooks, but a simple workaround in common code
is better than just crashing early in boot (imo).


> 
> (I'd almost rather see all promtree users adopt the sparc approach of
> building up from known data instead of calling into higher level OFW
> functions, but that's an orthogonal debate).
> 
> *however* if you really want to implement a dp->name fallback, then I
> would be okay with something like this:  At least it ensures every
> full_path string is unique in the system.
> 
> static int broken_unique_id = 0;
> sprintf(buf, "%s/%s-broken%i", parent->full_name, dp->name,
> broken_unique_id++); pr_err("pkg2path busted; ugly name workaround
> applied\n");
> 
> For now I'm inclined to keep the BUG(), and I'll let you handle any
> workarounds in the OLPC code if needed.
> 
> > 
> > 
> > 
> > > +
> > > +	buf = prom_early_alloc(len + 1);
> > > +	if (!buf)
> > > +		BUG();
> > 
> > Ditto.
> 
> If we cannot allocate ram at this point, we've got much bigger
> problems.  BUG is appropriate here.... actually, if prom_early_alloc()
> cannot provide memory, it should fail hard like sparc prom_64 does.
> Care to craft a separate patch to make that change for OLPC?  (for
> 2.6.39; no rush)
> 
> I've pushed the latest version out to my devicetree/experimental
> branch on git://git.secretlab.ca/git/linux-2.6.  Give it a spin and
> make sure everything is still working for you.
> 
> g.
