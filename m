Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2J3CWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:22:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63381 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2J3CWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:22:52 -0400
Date: Mon, 29 Oct 2012 19:23:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 04/12] VMCI: device driver implementaton.
Message-ID: <20121030022347.GE1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010409.17788.6745.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010409.17788.6745.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:04:15PM -0700, George Zhang wrote:
> +static int __init vmci_core_init(void)
> +{
> +	int result;
> +
> +	result = vmci_ctx_init();
> +	if (result < VMCI_SUCCESS) {
> +		pr_err("Failed to initialize VMCIContext (result=%d).\n",
> +			result);

If you are going to use pr_* functions, it's usually a good idea to
define pr_fmt in a consistant way so that it shows up the same across
all of your .c files.  See other drivers for examples of how to do this
properly.

> +		return -EINVAL;
> +	}
> +
> +	result = vmci_datagram_init();
> +	if (result < VMCI_SUCCESS) {
> +		pr_err("Failed to initialize VMCIDatagram (result=%d).\n",
> +			result);
> +		return -EINVAL;
> +	}
> +
> +	result = vmci_event_init();
> +	if (result < VMCI_SUCCESS) {
> +		pr_err("Failed to initialize VMCIEvent (result=%d).\n", result);
> +		return -EINVAL;
> +	}

You don't free and unwind things properly if things go wrong here, why
not?

> +
> +	return 0;
> +}
> +
> +static void __exit vmci_core_exit(void)
> +{
> +	vmci_event_exit();
> +}
> +
> +static int __init vmci_drv_init(void)
> +{
> +	int error;
> +
> +	error = vmci_core_init();
> +	if (error)
> +		return error;
> +
> +	if (!vmci_disable_guest) {
> +		error = vmci_guest_init();
> +		if (error) {
> +			pr_warn("Failed to initialize guest personality (err=%d).\n",
> +				error);
> +		} else {
> +			vmci_guest_personality_initialized = true;
> +			pr_info("Guest personality initialized and is %s\n",
> +				vmci_guest_code_active() ?
> +				"active" : "inactive");
> +		}
> +	}
> +
> +	if (!vmci_disable_host) {
> +		error = vmci_host_init();
> +		if (error) {
> +			pr_warn("Unable to initialize host personality (err=%d).\n",
> +				error);
> +		} else {
> +			vmci_host_personality_initialized = true;
> +			pr_info("Initialized host personality\n");
> +		}
> +	}
> +
> +	if (!vmci_guest_personality_initialized &&
> +	    !vmci_host_personality_initialized) {
> +		vmci_core_exit();
> +		return -ENODEV;
> +	}
> +
> +	pr_debug("Module is initialized\n");

Really?  You need this message still?

> +	return 0;
> +}
> +module_init(vmci_drv_init);
> +
> +static void __exit vmci_drv_exit(void)
> +{
> +	if (vmci_guest_personality_initialized)
> +		vmci_guest_exit();
> +
> +	if (vmci_host_personality_initialized)
> +		vmci_host_exit();
> +
> +	vmci_core_exit();
> +	pr_debug("Module is unloaded\n");

Same here, is this really needed?

thanks,

greg k-h
