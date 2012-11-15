Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161253Ab2KOAvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:51:06 -0500
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45393 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2KOAvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:51:04 -0500
Date: Wed, 14 Nov 2012 17:51:00 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        Myron Stowe <myron.stowe@gmail.com>, Lance Ortiz <lance.ortiz@hp.com>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Patterson <andrew.patterson@hp.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [ PATCH RESEND ] PCI-AER: Do not report successful error
 recovery for devices with AER-unaware drivers
Message-ID: <20121115005100.GA6613@google.com>
References: <F9E001219150CB45BEDC82A650F360C90146794E@G9W0717.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F9E001219150CB45BEDC82A650F360C90146794E@G9W0717.americas.hpqcorp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Lance, Huang, Hidetoshi, Andrew, Zhang]

On Sat, Nov 10, 2012 at 07:41:04AM +0000, Pandarathil, Vijaymohan R wrote:
> When an error is detected on a PCIe device which does not have an
> AER-aware driver, prevent AER infrastructure from reporting
> successful error recovery.
> 
> This is because the report_error_detected() function that gets
> called in the first phase of recovery process allows forward
> progress even when the driver for the device does not have AER
> capabilities. It seems that all callbacks (in pci_error_handlers
> structure) registered by drivers that gets called during error
> recovery are not mandatory. So the intention of the infrastructure
> design seems to be to allow forward progress even when a specific
> callback has not been registered by a driver. However, if error
> handler structure itself has not been registered, it doesn't make
> sense to allow forward progress.
> 
> As a result of the current design, in the case of a single device
> having an AER-unaware driver or in the case of any function in a
> multi-function card having an AER-unaware driver, a successful
> recovery is reported.
> 
> Typical scenario this happens is when a PCI device is detached
> from a KVM host and the pci-stub driver on the host claims the
> device. The pci-stub driver does not have error handling capabilities
> but the AER infrastructure still reports that the device recovered
> successfully.
> 
> The changes proposed here leaves the device in an unrecovered state
> if the driver for the device or for any function in a multi-function
> card does not have error handler structure registered. This reflects
> the true state of the device and prevents any partial recovery (or no
> recovery at all) reported as successful.
> 
> Please also see comments from Linas Vepstas at the following link
> http://www.spinics.net/lists/linux-pci/msg18572.html
> 
> Reviewed-by: Linas Vepstas <linasvepstas <at> gmail.com>
> Reviewed-by: Myron Stowe <mstowe <at> redhat.com>
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil <at> hp.com>
> 
> ---
> 
> drivers/pci/pcie/aer/aerdrv_core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 06bad96..030b229 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -215,6 +215,12 @@ static int report_error_detected(struct pci_dev *dev, void *data)
>  
>  	dev->error_state = result_data->state;
>  
> +	if ((!dev->driver || !dev->driver->err_handler) &&
> +		!(dev->hdr_type & PCI_HEADER_TYPE_BRIDGE)) {
> +		dev_info(&dev->dev, "AER: Error detected but no driver has claimed this device or the driver is AER-unaware\n");
> +		result_data->result = PCI_ERS_RESULT_NONE;
> +		return 1;

This doesn't seem right because returning 1 here causes pci_walk_bus()
to terminate, which means we won't set dev->error_state or notify
drivers for any devices we haven't visited yet.

> +	}
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
>  		!dev->driver->err_handler->error_detected) {

If none of the drivers in the affected hierarchy supports error handling,
I think the call tree looks like this:

    do_recovery                                 # uncorrectable only
        broadcast_error_message(dev, ..., report_error_detected)
            result_data.result = CAN_RECOVER            
            pci_walk_bus(..., report_error_detected)
                report_error_detected           # (each dev in subtree)
                    return 0                    # no change to result
            return result_data.result
        broadcast_error_message(dev, ..., report_mmio_enabled)
            result_data.result = PCI_ERS_RESULT_RECOVERED       
            pci_walk_bus(..., report_mmio_enabled)
                report_mmio_enabled             # (each dev in subtree)
                    return 0                    # no change to result
        dev_info("recovery successful")

Specifically, there are no error_handler functions, so we never change
result_data.result, and the default is that we treat the error as
"recovered successfully."  That seems broken.  An uncorrectable error
is by definition recoverable only by device-specific software, i.e.,
the driver.  We didn't call any drivers, so we can't have recovered
anything.

What do you think of the following alternative?  I don't know why you
checked for bridge devices in your patch, so I don't know whether
that's important here or not.

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 06bad96..a109c68 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -231,11 +231,11 @@ static int report_error_detected(struct pci_dev *dev, void *data)
 				   dev->driver ?
 				   "no AER-aware driver" : "no driver");
 		}
-		return 0;
+		vote = PCI_ERS_RESULT_DISCONNECT;
+	} else {
+		err_handler = dev->driver->err_handler;
+		vote = err_handler->error_detected(dev, result_data->state);
 	}
-
-	err_handler = dev->driver->err_handler;
-	vote = err_handler->error_detected(dev, result_data->state);
 	result_data->result = merge_result(result_data->result, vote);
 	return 0;
 }
