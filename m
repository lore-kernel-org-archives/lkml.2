Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2K0AYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:24:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36920 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2K0AYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:24:04 -0500
Date: Mon, 26 Nov 2012 16:23:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        acking@vmware.com
Subject: Re: [PATCH 12/12] VMCI: Some header and config files.
Message-ID: <20121127002357.GA27683@core.coreip.homeip.net>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121107184258.9658.95698.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121127000304.GA18680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127000304.GA18680@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

For some reason it still didn't go through to our corporate mail server
but I see it on LKML.

On Mon, Nov 26, 2012 at 04:03:04PM -0800, Greg KH wrote:
> On Wed, Nov 07, 2012 at 10:43:03AM -0800, George Zhang wrote:
> 
> > +static inline struct vmci_handle VMCI_MAKE_HANDLE(vmci_id cid, vmci_id rid)
> > +{
> > +	struct vmci_handle h;
> > +	h.context = cid;
> > +	h.resource = rid;
> > +	return h;
> > +}
> 
> You return a structure on the stack that just went away?  Yeah, I know
> it's an inline, but come on, that's not ok.

This is certainly OK even if it is not inline, we return the _value_,
not the pointer to the stacki memory. And yes, the structure is 64 bit
value so it is returned in registers.

> 
> > +#define VMCI_HANDLE_TO_CONTEXT_ID(_handle) ((_handle).context)
> > +#define VMCI_HANDLE_TO_RESOURCE_ID(_handle) ((_handle).resource)
> 
> It's longer to write the macro out than to just do .context or
> .resource, just use them instead.

We really want vmci_handle to be opaque where possible and use proper
accessors.

> 
> > +#define VMCI_HANDLE_EQUAL(_h1, _h2) ((_h1).context == (_h2).context &&	\
> > +				     (_h1).resource == (_h2).resource)
> 
> Inline function instead?  How often do you really need this?

OK, makes sense.

> 
> > +#define VMCI_INVALID_ID ~0
> > +static const struct vmci_handle VMCI_INVALID_HANDLE = { VMCI_INVALID_ID,
> > +	VMCI_INVALID_ID
> > +};
> 
> C99 initializers please.

OK.

> 
> > +
> > +#define VMCI_HANDLE_INVALID(_handle)				            \
> > +	VMCI_HANDLE_EQUAL((_handle), VMCI_INVALID_HANDLE)
> 
> Gotta love magic values :(

?

> 
> > +/*
> > + * The below defines can be used to send anonymous requests.
> > + * This also indicates that no response is expected.
> > + */
> > +#define VMCI_ANON_SRC_CONTEXT_ID   VMCI_INVALID_ID
> > +#define VMCI_ANON_SRC_RESOURCE_ID  VMCI_INVALID_ID
> > +#define VMCI_ANON_SRC_HANDLE       vmci_make_handle(VMCI_ANON_SRC_CONTEXT_ID, \
> > +						    VMCI_ANON_SRC_RESOURCE_ID)
> 
> So you just created an invalid message?

Anonymous one, yes.

> 
> > +/* The lowest 16 context ids are reserved for internal use. */
> > +#define VMCI_RESERVED_CID_LIMIT ((u32) 16)
> > +
> > +/*
> > + * Hypervisor context id, used for calling into hypervisor
> > + * supplied services from the VM.
> > + */
> > +#define VMCI_HYPERVISOR_CONTEXT_ID 0
> > +
> > +/*
> > + * Well-known context id, a logical context that contains a set of
> > + * well-known services. This context ID is now obsolete.
> > + */
> > +#define VMCI_WELL_KNOWN_CONTEXT_ID 1
> > +
> > +/*
> > + * Context ID used by host endpoints.
> > + */
> > +#define VMCI_HOST_CONTEXT_ID  2
> > +
> > +#define VMCI_CONTEXT_IS_VM(_cid) (VMCI_INVALID_ID != (_cid) &&		\
> > +				  (_cid) > VMCI_HOST_CONTEXT_ID)
> > +
> 
> Are you sure all of this stuff needs to be in a .h file that lives in
> include/linux/?

Probably not. We'll rebase to 3.7 and split as needed.

> 
> > +/*
> > + * Linux defines _IO* macros, but the core kernel code ignore the encoded
> > + * ioctl value. It is up to individual drivers to decode the value (for
> > + * example to look at the size of a structure to determine which version
> > + * of a specific command should be used) or not (which is what we
> > + * currently do, so right now the ioctl value for a given command is the
> > + * command itself).
> > + *
> > + * Hence, we just define the IOCTL_VMCI_foo values directly, with no
> > + * intermediate IOCTLCMD_ representation.
> > + */
> > +#define IOCTLCMD(_cmd) IOCTL_VMCI_ ## _cmd
> 
> I don't recall ever getting a valid answer for this (if you did, my
> appologies, can you repeat it).  What in the world are you talking about
> here?  Why is your driver somehow special from the thousands of other
> ones that use the in-kernel IO macros properly for an ioctl?

Hmm, not sure, we'll review ioctl definitions and fix as needed.

Thanks!

-- 
Dmitry
