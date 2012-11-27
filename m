Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab2K0ADK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:03:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:39744 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932Ab2K0ADH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:03:07 -0500
Date: Mon, 26 Nov 2012 16:03:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 12/12] VMCI: Some header and config files.
Message-ID: <20121127000304.GA18680@kroah.com>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121107184258.9658.95698.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107184258.9658.95698.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 10:43:03AM -0800, George Zhang wrote:
> +#ifndef _VMCI_COMMONINT_H_
> +#define _VMCI_COMMONINT_H_
> +
> +#include <linux/printk.h>

Why printk from a .h file?

> +
> +#define ASSERT(cond) BUG_ON(!(cond))

No, please no.

> +
> +#define PCI_VENDOR_ID_VMWARE	0x15AD
> +#define PCI_DEVICE_ID_VMWARE_VMCI	0x0740

Align these properly?  Why do they need to be in a .h file?

> +#define VMCI_DRIVER_VERSION_STRING	"1.0.0.0-k"

Is this needed at all anymore?

> +#define MODULE_NAME "vmw_vmci"

This isn't needed, use the built-in macro instead.

> +/* Print magic... whee! */
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#define pr_fmt(fmt) MODULE_NAME ": " fmt
> +#endif

That's not how you do this, sorry.  Please do it like the rest of the
kernel.

> --- /dev/null
> +++ b/include/linux/vmw_vmci_api.h

With the new uapi rework, should this file still be here?  What about
the other .h files?

> +typedef u32 vmci_id;
> +typedef u32 vmci_privilege_flags;
> +typedef u32 vmci_event;

Ick, no typdefs please.

> +static inline struct vmci_handle VMCI_MAKE_HANDLE(vmci_id cid, vmci_id rid)
> +{
> +	struct vmci_handle h;
> +	h.context = cid;
> +	h.resource = rid;
> +	return h;
> +}

You return a structure on the stack that just went away?  Yeah, I know
it's an inline, but come on, that's not ok.

> +#define VMCI_HANDLE_TO_CONTEXT_ID(_handle) ((_handle).context)
> +#define VMCI_HANDLE_TO_RESOURCE_ID(_handle) ((_handle).resource)

It's longer to write the macro out than to just do .context or
.resource, just use them instead.

> +#define VMCI_HANDLE_EQUAL(_h1, _h2) ((_h1).context == (_h2).context &&	\
> +				     (_h1).resource == (_h2).resource)

Inline function instead?  How often do you really need this?

> +#define VMCI_INVALID_ID ~0
> +static const struct vmci_handle VMCI_INVALID_HANDLE = { VMCI_INVALID_ID,
> +	VMCI_INVALID_ID
> +};

C99 initializers please.

> +
> +#define VMCI_HANDLE_INVALID(_handle)				            \
> +	VMCI_HANDLE_EQUAL((_handle), VMCI_INVALID_HANDLE)

Gotta love magic values :(

> +/*
> + * The below defines can be used to send anonymous requests.
> + * This also indicates that no response is expected.
> + */
> +#define VMCI_ANON_SRC_CONTEXT_ID   VMCI_INVALID_ID
> +#define VMCI_ANON_SRC_RESOURCE_ID  VMCI_INVALID_ID
> +#define VMCI_ANON_SRC_HANDLE       vmci_make_handle(VMCI_ANON_SRC_CONTEXT_ID, \
> +						    VMCI_ANON_SRC_RESOURCE_ID)

So you just created an invalid message?

> +/* The lowest 16 context ids are reserved for internal use. */
> +#define VMCI_RESERVED_CID_LIMIT ((u32) 16)
> +
> +/*
> + * Hypervisor context id, used for calling into hypervisor
> + * supplied services from the VM.
> + */
> +#define VMCI_HYPERVISOR_CONTEXT_ID 0
> +
> +/*
> + * Well-known context id, a logical context that contains a set of
> + * well-known services. This context ID is now obsolete.
> + */
> +#define VMCI_WELL_KNOWN_CONTEXT_ID 1
> +
> +/*
> + * Context ID used by host endpoints.
> + */
> +#define VMCI_HOST_CONTEXT_ID  2
> +
> +#define VMCI_CONTEXT_IS_VM(_cid) (VMCI_INVALID_ID != (_cid) &&		\
> +				  (_cid) > VMCI_HOST_CONTEXT_ID)
> +

Are you sure all of this stuff needs to be in a .h file that lives in
include/linux/?

> +/*
> + * Linux defines _IO* macros, but the core kernel code ignore the encoded
> + * ioctl value. It is up to individual drivers to decode the value (for
> + * example to look at the size of a structure to determine which version
> + * of a specific command should be used) or not (which is what we
> + * currently do, so right now the ioctl value for a given command is the
> + * command itself).
> + *
> + * Hence, we just define the IOCTL_VMCI_foo values directly, with no
> + * intermediate IOCTLCMD_ representation.
> + */
> +#define IOCTLCMD(_cmd) IOCTL_VMCI_ ## _cmd

I don't recall ever getting a valid answer for this (if you did, my
appologies, can you repeat it).  What in the world are you talking about
here?  Why is your driver somehow special from the thousands of other
ones that use the in-kernel IO macros properly for an ioctl?

> +enum {
> +	/*
> +	 * We need to bracket the range of values used for ioctls,
> +	 * because x86_64 Linux forces us to explicitly register ioctl
> +	 * handlers by value for handling 32 bit ioctl syscalls.
> +	 * Hence FIRST and LAST.  Pick something for FIRST that
> +	 * doesn't collide with vmmon (2001+).
> +	 */

What do you mean here?  What are you trying to work around?  And why?

> +	IOCTLCMD(FIRST) = 1951,
> +	IOCTLCMD(VERSION) = IOCTLCMD(FIRST),

Huh?

> +
> +	/* BEGIN VMCI */
> +	IOCTLCMD(INIT_CONTEXT),
> +
> +	/*
> +	 * The following two were used for process and datagram
> +	 * process creation.  They are not used anymore and reserved
> +	 * for future use.  They will fail if issued.
> +	 */
> +	IOCTLCMD(RESERVED1),
> +	IOCTLCMD(RESERVED2),

Who's reserving them?  If they aren't in the driver, no need to list
them here at all, who would ever call them?  I think this is due to your
"weird" way of defining ioctls, please don't.

> +	/*
> +	 * The following used to be for shared memory. It is now
> +	 * unused and and is reserved for future use. It will fail if
> +	 * issued.
> +	 */
> +	IOCTLCMD(RESERVED3),

Same as above.

> +	/*
> +	 * The follwoing three were also used to be for shared
> +	 * memory. An old WS6 user-mode client might try to use them
> +	 * with the new driver, but since we ensure that only contexts
> +	 * created by VMX'en of the appropriate version
> +	 * (VMCI_VERSION_NOTIFY or VMCI_VERSION_NEWQP) or higher use
> +	 * these ioctl, everything is fine.
> +	 */
> +	IOCTLCMD(QUEUEPAIR_SETVA),
> +	IOCTLCMD(NOTIFY_RESOURCE),
> +	IOCTLCMD(NOTIFICATIONS_RECEIVE),
> +	IOCTLCMD(VERSION2),
> +	IOCTLCMD(QUEUEPAIR_ALLOC),
> +	IOCTLCMD(QUEUEPAIR_SETPAGEFILE),
> +	IOCTLCMD(QUEUEPAIR_DETACH),
> +	IOCTLCMD(DATAGRAM_SEND),
> +	IOCTLCMD(DATAGRAM_RECEIVE),
> +	IOCTLCMD(DATAGRAM_REQUEST_MAP),
> +	IOCTLCMD(DATAGRAM_REMOVE_MAP),
> +	IOCTLCMD(CTX_ADD_NOTIFICATION),
> +	IOCTLCMD(CTX_REMOVE_NOTIFICATION),
> +	IOCTLCMD(CTX_GET_CPT_STATE),
> +	IOCTLCMD(CTX_SET_CPT_STATE),
> +	IOCTLCMD(GET_CONTEXT_ID),
> +	IOCTLCMD(LAST),
> +	/* END VMCI */
> +
> +	/*
> +	 * VMCI Socket IOCTLS are defined next and go from
> +	 * IOCTLCMD(LAST) (1972) to 1990.  VMware reserves a range of
> +	 * 4 ioctls for VMCI Sockets to grow.  We cannot reserve many
> +	 * ioctls here since we are close to overlapping with vmmon
> +	 * ioctls (2001+).  Define a meta-ioctl if running out of this
> +	 * binary space.
> +	 */
> +	IOCTLCMD(SOCKETS_FIRST) = IOCTLCMD(LAST),
> +	IOCTLCMD(SOCKETS_VERSION) = IOCTLCMD(SOCKETS_FIRST),
> +	IOCTLCMD(SOCKETS_BIND),
> +	IOCTLCMD(SOCKETS_SET_SYMBOLS),
> +	IOCTLCMD(SOCKETS_CONNECT),

As you don't have any in-kernel code using these ioctls, why define them
yet?

And again, what's with the "reserving" ioctls?  That's not ok.

> +	/*
> +	 * The next two values are public (vmci_sockets.h) and cannot be
> +	 * changed. That means the number of values above these cannot be
> +	 * changed either unless the base index (specified below) is updated
> +	 * accordingly.
> +	 */
> +	IOCTLCMD(SOCKETS_GET_AF_VALUE),
> +	IOCTLCMD(SOCKETS_GET_LOCAL_CID),
> +	IOCTLCMD(SOCKETS_GET_SOCK_NAME),
> +	IOCTLCMD(SOCKETS_GET_SOCK_OPT),
> +	IOCTLCMD(SOCKETS_GET_VM_BY_NAME),
> +	IOCTLCMD(SOCKETS_IOCTL),
> +	IOCTLCMD(SOCKETS_LISTEN),
> +	IOCTLCMD(SOCKETS_RECV),
> +	IOCTLCMD(SOCKETS_RECV_FROM),
> +	IOCTLCMD(SOCKETS_SELECT),
> +	IOCTLCMD(SOCKETS_SEND),
> +	IOCTLCMD(SOCKETS_SEND_TO),
> +	IOCTLCMD(SOCKETS_SET_SOCK_OPT),
> +	IOCTLCMD(SOCKETS_SHUTDOWN),
> +	IOCTLCMD(SOCKETS_SOCKET),	/* 1990 on Linux. */
> +
> +	IOCTLCMD(SOCKETS_LAST) = 1994,	/* 1994 on Linux. */
> +
> +	/*
> +	 * The VSockets ioctls occupy the block above.  We define a
> +	 * new range of VMCI ioctls to maintain binary compatibility
> +	 * between the user land and the kernel driver.  Careful,
> +	 * vmmon ioctls start from 2001, so this means we can add only
> +	 * 4 new VMCI ioctls.  Define a meta-ioctl if running out of
> +	 * this binary space.
> +	 */
> +	IOCTLCMD(FIRST2),
> +	IOCTLCMD(SET_NOTIFY) = IOCTLCMD(FIRST2),	/* 1995 on Linux. */
> +	IOCTLCMD(LAST2),
> +};

I still don't understand, sorry.

Please redo this in the "normal" Linux kernel way of defining ioctls.
No need to be "special" here.

And shouldn't something like this be in a separate .h file, that gets
included from userspace?  Not all of the stuff in this .h file should
get exported to userspace, right?

> +static inline struct vmci_handle vmci_make_handle(u32 cid, u32 rid)
> +{
> +	struct vmci_handle h;
> +
> +	h.context = cid;
> +	h.resource = rid;
> +
> +	return h;
> +}

Where have I see this before... :)

thanks,

greg k-h
