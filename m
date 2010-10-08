Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab0JHRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:36:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43088 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0JHRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:36:53 -0400
Date: Fri, 8 Oct 2010 11:36:50 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Miller <davem@davemloft.net>
Cc: dilinger@queued.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2 v2] of: move phandle/ihandle into types.h and
 export to userspace
Message-ID: <20101008173650.GH3863@angua.secretlab.ca>
References: <20101008004354.13b5b254@debxo>
 <20101008171210.GE3863@angua.secretlab.ca>
 <20101008.101759.193728130.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008.101759.193728130.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:17:59AM -0700, David Miller wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Fri, 8 Oct 2010 11:12:10 -0600
> 
> > On Fri, Oct 08, 2010 at 12:43:54AM -0700, Andres Salomon wrote:
> >> 
> >> We need phandle for some exported sparc headers; of.h isn't an
> >> exported header, and it would be silly to export it when all we
> >> really need is one or two types from it.  Also, later patches
> >> use phandle in structs that are exported to userspace, so export
> >> a __kernel_phandle type.
> >> 
> >> Signed-off-by: Andres Salomon <dilinger@queued.net>
> > 
> > Looks okay to me.  I'm build testing it now on powerpc and
> > microblaze.  If davem agrees, then I'll pick it up into my
> > devicetree-next branch.
> > 
> > Question though; since sparc userspace is the only user of this,
> > should the types.h header avoid exposing it on non-sparc?
> 
> I can't think of anything in Sparc userspace that needs the
> phandle_t type.
> 
> In fact I was a bit confused when you asked Andres to expose
> it to userspace.
> 
> What I remember from a previous thread is that some other platforms
> use the type in their DT device-tree building tools or whatever, but
> they define phandle_t for themselves I remember specifically
> mentioning sparc has no use for this currently.

Weird.  Yeah, no other platforms expect to get a phandle type
definition from the kernel headers.  The only thing driving this
conversation is from arch/sparc/include/asm/Kbuild:

header-y += openprom.h

I don't have any background on the history of that file or why it
needs to be exported to userspace.  There seems to be a lot of stuff
in there; but I cannot see the *_funcs structures having any utility
outside of the kernel.  Perhaps they should be moved out of
asm/openprom.h?

Here are the two affected structures:

$ git grep linux_nodeops arch/sparc/include
arch/sparc/include/asm/openprom.h:      struct linux_nodeops *pv_nodeops;
arch/sparc/include/asm/openprom.h:struct linux_nodeops {
arch/sparc/include/asm/oplib_32.h:extern struct linux_nodeops *prom_nodeops;
$ git grep linux_dev_v2_funcs arch/sparc/include
arch/sparc/include/asm/openprom.h:struct linux_dev_v2_funcs {
arch/sparc/include/asm/openprom.h:      struct linux_dev_v2_funcs pv_v2devops;
(devicetree/next) ~/hacking/linux-2.6$ 

And linux_romvec references linux_nodeops:
$ git grep linux_romvec arch/sparc/include
arch/sparc/include/asm/openprom.h:struct linux_romvec {
arch/sparc/include/asm/oplib_32.h:extern struct linux_romvec *romvec;
arch/sparc/include/asm/oplib_32.h:extern void prom_init(struct linux_romvec *rom_ptr);

oplib_32.h is not exported.

g.
