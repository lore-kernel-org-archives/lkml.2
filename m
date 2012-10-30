Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2J3Chm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:37:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2J3Chl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:37:41 -0400
Date: Mon, 29 Oct 2012 19:38:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 12/12] VMCI: Some header and config files.
Message-ID: <20121030023835.GK1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010533.17788.79417.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010533.17788.79417.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:05:38PM -0700, George Zhang wrote:
> +/*
> + * Driver version.
> + *
> + * Increment major version when you make an incompatible change.
> + * Compatibility goes both ways (old driver with new executable
> + * as well as new driver with old executable).
> + */
> +
> +/* Never change VMCI_VERSION_SHIFT_WIDTH */
> +#define VMCI_VERSION_SHIFT_WIDTH 16
> +#define VMCI_MAKE_VERSION(_major, _minor)			\
> +	((_major) << VMCI_VERSION_SHIFT_WIDTH | (u16) (_minor))
> +
> +#define VMCI_VERSION_MAJOR(v)  ((u32) (v) >> VMCI_VERSION_SHIFT_WIDTH)
> +#define VMCI_VERSION_MINOR(v)  ((u16) (v))
> +
> +/*
> + * VMCI_VERSION is always the current version.  Subsequently listed
> + * versions are ways of detecting previous versions of the connecting
> + * application (i.e., VMX).
> + *
> + * VMCI_VERSION_NOVMVM: This version removed support for VM to VM
> + * communication.
> + *
> + * VMCI_VERSION_NOTIFY: This version introduced doorbell notification
> + * support.
> + *
> + * VMCI_VERSION_HOSTQP: This version introduced host end point support
> + * for hosted products.
> + *
> + * VMCI_VERSION_PREHOSTQP: This is the version prior to the adoption of
> + * support for host end-points.
> + *
> + * VMCI_VERSION_PREVERS2: This fictional version number is intended to
> + * represent the version of a VMX which doesn't call into the driver
> + * with ioctl VERSION2 and thus doesn't establish its version with the
> + * driver.
> + */

Do we care about these old versions anymore, now that this is really
"new" code going into the kernel?

> +
> +#define VMCI_VERSION                VMCI_VERSION_NOVMVM
> +#define VMCI_VERSION_NOVMVM         VMCI_MAKE_VERSION(11, 0)
> +#define VMCI_VERSION_NOTIFY         VMCI_MAKE_VERSION(10, 0)
> +#define VMCI_VERSION_HOSTQP         VMCI_MAKE_VERSION(9, 0)
> +#define VMCI_VERSION_PREHOSTQP      VMCI_MAKE_VERSION(8, 0)
> +#define VMCI_VERSION_PREVERS2       VMCI_MAKE_VERSION(1, 0)
> +
> +#define VMCI_SOCKETS_MAKE_VERSION(_p)					\
> +	((((_p)[0] & 0xFF) << 24) | (((_p)[1] & 0xFF) << 16) | ((_p)[2]))
> +
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

Huh?  I don't understand, why aren't the "normal" macros good enough for
you?  What are you doing special from the entire rest of the kernel that
you need to do things differently?

> +enum {
> +	/*
> +	 * We need to bracket the range of values used for ioctls,
> +	 * because x86_64 Linux forces us to explicitly register ioctl
> +	 * handlers by value for handling 32 bit ioctl syscalls.
> +	 * Hence FIRST and LAST.  Pick something for FIRST that
> +	 * doesn't collide with vmmon (2001+).
> +	 */
> +	IOCTLCMD(FIRST) = 1951,
> +	IOCTLCMD(VERSION) = IOCTLCMD(FIRST),

I don't understand, what are you doing here with the numbering?

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
> +
> +	/*
> +	 * The following used to be for shared memory. It is now
> +	 * unused and and is reserved for future use. It will fail if
> +	 * issued.
> +	 */
> +	IOCTLCMD(RESERVED3),
> +
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

What do these two comments mean?

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

Again, what are you doing here?  What are you trying to be compatible
with?

Oh, and all of your ioctls _are_ 32/64bit safe, right?  I didn't check
for that here, sorry, but you have, right?

thanks,

greg k-h
