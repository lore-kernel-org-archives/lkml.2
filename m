Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2J3Ptq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:49:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2J3Pto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:49:44 -0400
Date: Tue, 30 Oct 2012 08:49:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 04/12] VMCI: device driver implementaton.
Message-ID: <20121030154940.GD14167@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010409.17788.6745.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030022347.GE1920@kroah.com>
 <20121030041522.GC32055@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030041522.GC32055@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 09:15:22PM -0700, Dmitry Torokhov wrote:
> On Mon, Oct 29, 2012 at 07:23:47PM -0700, Greg KH wrote:
> > On Mon, Oct 29, 2012 at 06:04:15PM -0700, George Zhang wrote:
> > > +static int __init vmci_core_init(void)
> > > +{
> > > +	int result;
> > > +
> > > +	result = vmci_ctx_init();
> > > +	if (result < VMCI_SUCCESS) {
> > > +		pr_err("Failed to initialize VMCIContext (result=%d).\n",
> > > +			result);
> > 
> > If you are going to use pr_* functions, it's usually a good idea to
> > define pr_fmt in a consistant way so that it shows up the same across
> > all of your .c files.  See other drivers for examples of how to do this
> > properly.
> 
> pr_fmt() is defined in drivers/misc/vmw_vmci/vmci_common_int.h

I think that is too late in the #include file chain, shouldn't it be set
before any #include files are called?

> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	result = vmci_datagram_init();
> > > +	if (result < VMCI_SUCCESS) {
> > > +		pr_err("Failed to initialize VMCIDatagram (result=%d).\n",
> > > +			result);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	result = vmci_event_init();
> > > +	if (result < VMCI_SUCCESS) {
> > > +		pr_err("Failed to initialize VMCIEvent (result=%d).\n", result);
> > > +		return -EINVAL;
> > > +	}
> > 
> > You don't free and unwind things properly if things go wrong here, why
> > not?
> 
> We do, the above calls do not need to be cleaned up.

Ah, that's helpful :)

> > > +	return 0;
> > > +}
> > > +
> > > +static void __exit vmci_core_exit(void)
> > > +{
> > > +	vmci_event_exit();
> > > +}
> > > +
> > > +static int __init vmci_drv_init(void)
> > > +{
> > > +	int error;
> > > +
> > > +	error = vmci_core_init();
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	if (!vmci_disable_guest) {
> > > +		error = vmci_guest_init();
> > > +		if (error) {
> > > +			pr_warn("Failed to initialize guest personality (err=%d).\n",
> > > +				error);
> > > +		} else {
> > > +			vmci_guest_personality_initialized = true;
> > > +			pr_info("Guest personality initialized and is %s\n",
> > > +				vmci_guest_code_active() ?
> > > +				"active" : "inactive");
> > > +		}
> > > +	}
> > > +
> > > +	if (!vmci_disable_host) {
> > > +		error = vmci_host_init();
> > > +		if (error) {
> > > +			pr_warn("Unable to initialize host personality (err=%d).\n",
> > > +				error);
> > > +		} else {
> > > +			vmci_host_personality_initialized = true;
> > > +			pr_info("Initialized host personality\n");
> > > +		}
> > > +	}
> > > +
> > > +	if (!vmci_guest_personality_initialized &&
> > > +	    !vmci_host_personality_initialized) {
> > > +		vmci_core_exit();
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	pr_debug("Module is initialized\n");
> > 
> > Really?  You need this message still?
> 
> These are debug messages so do not show up in logs by default.

I know, but even if you do enable debugging, are such things really
needed?  They look like left-over tracing function calls to me.

thanks,

greg k-h
