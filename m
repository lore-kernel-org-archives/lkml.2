Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab2J3QLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:11:06 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37097 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933955Ab2J3QLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:11:03 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 08/12] VMCI: resource object implementation.
Date: Tue, 30 Oct 2012 09:11:03 -0700
Message-ID: <9263011.eEa0nD645u@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121030155159.GG14167@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com> <20121030052016.GF32055@dtor-ws.eng.vmware.com> <20121030155159.GG14167@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 08:51:59 AM Greg KH wrote:
> On Mon, Oct 29, 2012 at 10:20:16PM -0700, Dmitry Torokhov wrote:
> > On Mon, Oct 29, 2012 at 07:29:05PM -0700, Greg KH wrote:
> > > On Mon, Oct 29, 2012 at 06:04:58PM -0700, George Zhang wrote:
> > > > +static struct vmci_resource *vmci_resource_lookup(struct vmci_handle
> > > > handle) +{
> > > > +	struct vmci_resource *r, *resource = NULL;
> > > > +	struct hlist_node *node;
> > > > +	unsigned int idx = vmci_resource_hash(handle);
> > > > +
> > > > +	BUG_ON(VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE));
> > > 
> > > You just crashed a machine, with no chance for recovery.  Not a good
> > > idea.  Never a good idea.  Customers just lost data, and now they are
> > > mad.  Make sure you at least print out your email address so they know
> > > who to blame :)
> > > 
> > > Seriously, never BUG() in a driver, warn, sure, but this just looks like
> > > a debugging assert().  Please remove all of these, they are sprinkled
> > > all over the driver code here, I'm only responding to one of them here.
> > > 
> > > Even better yet, properly handle the error and keep on going, that's
> > > what the rest of the kernel does.  Or should :)
> > 
> > For public APIs it certainly makes sense to check and handle erroneous
> > input;
> It's not "public", it's an in-kernel api.  See the static up there?  :)

Yes, exactly, that is not public but internal and that is why it might
be acceptable to enforce invariant. Cross-subsystem (i.e public from
the in-kernel POV) APIs should of course check and refuse bad input.

> 
> > internally it often makes sense to simply enforce invariants, because if
> > we managed to get into that state that we consider impossible we can't
> > really trust anything.
> 
> Then error out, don't crash the box.  Again, this really looks like an
> ASSERT() you are trying to catch, which you know how well we like those
> in kernel code...

At certain point it simply does not make sense to add error handling
paths to handle situation that should be impossible to happen.

> 
> > FWIW:
> > [dtor@dtor-ws kernel]$ grep -r BUG_ON . | wc -l
> > 11269
> 
> I'm not saying that those are acceptable either, I just don't want to
> add any more to the kernel.

I do not think eradicating BUG_ONs from kernel in general is a good idea.
At some point you should just die with as much information as possible.

That said we'll go and see what could be converted from BUG_ON to WARN_ON
and what could be handled without taking the box down...

Thanks,
Dmitry

