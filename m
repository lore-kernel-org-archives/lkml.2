Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1IVR1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:27:52 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14465 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1IVR1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:27:50 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 13:27:50 EDT
Subject: Re: [PATCH v4] acpi: Fix CPU hot removal problem
From: Khalid Aziz <khalid.aziz@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "canquan.shen" <shencanquan@huawei.com>, len.brown@intel.com,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <CAErSpo71cC5=K7DXYs+aEnU2J91TX7ys8bpnUSmdob1dgdaBSg@mail.gmail.com>
References: <4E714FAA.8060708@huawei.com>
	 <CAErSpo5gV7AspUQp7_JOFuY0c0YnFWxj2TKUX-r6-0dVkj5FPA@mail.gmail.com>
	 <CAErSpo71cC5=K7DXYs+aEnU2J91TX7ys8bpnUSmdob1dgdaBSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 11:18:27 -0600
Message-ID: <1316711907.7244.217.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 10:53 -0600, Bjorn Helgaas wrote:
> On Wed, Sep 14, 2011 at 8:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Sep 14, 2011 at 7:06 PM, canquan.shen <shencanquan@huawei.com> wrote:
> >> We run linux as a guest in Xen environment. When we used the xen tools
> >> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
> >> encountered the failure on vcpu removal. We found the reason is that it
> >> didn't go to really remove cpu in the cpu removal code path.
> >>
> >> This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix this
> >> issue. With this patch, it works fine for us.
> >>
> >> Signed-off-by:Canquan Shen <shencanquan@huawei.com>
> >
> > Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> On second thought, let's think about this a bit more.
> 
> As I mentioned before, I have a long-term goal to move the hotplug
> flow out of drivers and into the ACPI core.  That will be easier if
> the code in the drivers is as generic as possible.
> 
> The dock and acpiphp hot-remove code calls acpi_bus_trim(), then
> evaluates _EJ0.  The core acpi_bus_hot_remove_device() function
> already does both acpi_bus_trim() and _EJ0.  This function is
> currently only used when we write to sysfs "eject" files, but I wonder
> if we should use it in acpi_processor_hotplug_notify() as well.
> 
> That would get us one step closer to removing this gunk from the
> drivers and having acpi_bus_notify() look something like this:
> 
>     case ACPI_NOTIFY_EJECT_REQUEST:
>         driver->ops.remove(device);
>         acpi_bus_hot_remove_device(device);
>         break;
> 
> There is a description of a CPU hot-remove that does include _EJ0
> methods in the "DIG64 Hot-Plug & Partitioning Flows Specification"
> [1], sec 2.2.4.  I know this document is Itanium-oriented, but this
> part seems fairly generic and it's the only description of the process
> I've seen so far.
> 
> So would using acpi_bus_hot_remove_device() instead of acpi_bus_trim()
> also solve your problem, Canquan?

I have been looking at this code and I have been thinking along the same
lines. Using acpi_bus_trim() to remove CPU does not power down the CPU
and allow firmware to deconfigure it. Calling
acpi_bus_hot_remove_device() is a better approach. While we are at it,
we should also fix the conditional in acpi_bus_hot_remove_device() after
executing _EJ0 to make sure we do not print warning if _EJ0 is not
supported by firmware:

--- scan.c.orig	2011-09-22 11:14:52.801074429 -0600
+++ scan.c	2011-09-22 11:15:24.061699647 -0600
@@ -129,7 +129,7 @@ static void acpi_bus_hot_remove_device(v
 	 * TBD: _EJD support.
 	 */
 	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
 		printk(KERN_WARNING PREFIX
 				"Eject device failed\n");
 

--
Khalid


> Bjorn
> 
> [1] http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf
> 
> >> ---
> >>  drivers/acpi/processor_driver.c |    6 ++++++
> >>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/acpi/processor_driver.c
> >> b/drivers/acpi/processor_driver.c
> >> index a4e0f1b..03d92d6 100644
> >> --- a/drivers/acpi/processor_driver.c
> >> +++ b/drivers/acpi/processor_driver.c
> >> @@ -641,6 +641,7 @@ static void acpi_processor_hotplug_notify(acpi_handle
> >> handle,
> >>        struct acpi_processor *pr;
> >>        struct acpi_device *device = NULL;
> >>        int result;
> >> +       u32 id;
> >>
> >>
> >>        switch (event) {
> >> @@ -677,6 +678,11 @@ static void acpi_processor_hotplug_notify(acpi_handle
> >> handle,
> >>                                    "Driver data is NULL, dropping EJECT\n");
> >>                        return;
> >>                }
> >> +               id = pr->id;
> >> +               if (acpi_bus_trim(device, 1)) {
> >> +                       printk(KERN_ERR  PREFIX
> >> +                                   "Fail to Remove CPU %d\n", id);
> >> +               }
> >>                break;
> >>        default:
> >>                ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> >> --
> >> 1.7.6.0
> >>
> >>
> >

-- 
====================================================================
Khalid Aziz                          Server Solutions Technology Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

