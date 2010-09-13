Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0IMR31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:29:27 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:45470 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab0IMR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:29:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] acpi: handle ACPI0007 Device in acpi_early_set_pdc
Date: Mon, 13 Sep 2010 11:28:42 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>
References: <4C89906B.1050406@kernel.org> <20100910164556.b72d848e.akpm@linux-foundation.org> <4C8AE422.4070602@kernel.org>
In-Reply-To: <4C8AE422.4070602@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131128.42519.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 10, 2010 08:06:26 pm Yinghai Lu wrote:
> On 09/10/2010 04:45 PM, Andrew Morton wrote:
> > On Fri, 10 Sep 2010 12:20:36 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> On 09/10/2010 11:10 AM, Bjorn Helgaas wrote:
> >>> On Thursday, September 09, 2010 07:56:59 pm Yinghai Lu wrote:
> >>>>
> >>>> When bios switch to use Device object instead of Processor statement.
> >>>>
> >>>> the SSDT for Pstate/Cstate/Tstate can not be loaded dynamically.
> >>>>
> >>>> So try to scan ACPI0007 in addition to Processor.
> >>>>
> >>>> this fix regression: 2.6.32 is ok.
> >>>
> >>> Can you include the URL of the regression bug report?  And maybe
> >>> the commit that introduced the regression?
> >>
> >> the commit should be
> >>
> >> commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
> >> Author: Alex Chiang <achiang@hp.com>
> >> Date:   Mon Feb 22 12:11:39 2010 -0700
> >>
> >>     ACPI: processor: driver doesn't need to evaluate _PDC
> >>     
> >>     Now that the early _PDC evaluation path knows how to correctly
> >>     evaluate _PDC on only physically present processors, there's no
> >>     need for the processor driver to evaluate it later when it loads.
> >>     
> >>     To cover the hotplug case, push _PDC evaluation down into the
> >>     hotplug paths.
> >>     
> >>     Cc: x86@kernel.org
> >>     Cc: Tony Luck <tony.luck@intel.com>
> >>     Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >>     Signed-off-by: Alex Chiang <achiang@hp.com>
> >>     Signed-off-by: Len Brown <len.brown@intel.com>
> >>
> >> that is between 2.6.34-rc1 and 2.6.34-rc2.

There's no need to repeat the entire changelog of Alex's commit here;
all we need is the commit ID so we can find it later.

> > Maybe.  But first can you please address Bjorn's suggestions below?
> 
> fine, if you prefer 47 lines instead one line changes.

It's more important for a change to be clear and correct than for
it to be tiny.  But I do see your point, and having seen the patch
below, I prefer the original one-line version.

I timed the original on a 64-CPU box where the namespace walk cost
should be relatively high, and the walk you added takes about 0.01
seconds.  The one already there took about 0.03 seconds, so neither
costs very much.

And I don't like the fact that the patch below changes the ACPI CA
and it only partly implements acpi_get_devices(), since it ignores
_CID and _STA.

Bjorn

> [PATCH -v2] acpi: handle ACPI0007 Device in acpi_early_set_pdc
> 
> When bios switch to use Device object instead of Processor statement.
> 
> the SSDT for Pstate/Cstate/Tstate can not loaded dynamically.
> 
> So try to scan ACPI0007 in addition to Processor.
> 
> -v2: add 47 lines instead of 1 line to walk namespace one time only.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/acpi/acpica/nsxfeval.c |   43 +++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/processor_core.c  |    8 ++++---
>  include/acpi/acpixf.h          |    2 +
>  3 files changed, 50 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/processor_core.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_core.c
> +++ linux-2.6/drivers/acpi/processor_core.c
> @@ -189,7 +189,7 @@ int acpi_get_cpuid(acpi_handle handle, i
>  EXPORT_SYMBOL_GPL(acpi_get_cpuid);
>  #endif
>  
> -static bool processor_physically_present(acpi_handle handle)
> +static bool is_processor_and_physically_present(acpi_handle handle)
>  {
>  	int cpuid, type;
>  	u32 acpi_id;
> @@ -211,6 +211,8 @@ static bool processor_physically_present
>  		acpi_id = object.processor.proc_id;
>  		break;
>  	case ACPI_TYPE_DEVICE:
> +		if (acpi_match_device_hid(handle, "ACPI0007") != AE_OK)
> +			return false;
>  		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
>  		if (ACPI_FAILURE(status))
>  			return false;
> @@ -334,7 +336,7 @@ EXPORT_SYMBOL_GPL(acpi_processor_set_pdc
>  static acpi_status
>  early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
>  {
> -	if (processor_physically_present(handle) == false)
> +	if (is_processor_and_physically_present(handle) == false)
>  		return AE_OK;
>  
>  	acpi_processor_set_pdc(handle);
> @@ -349,7 +351,7 @@ void __init acpi_early_processor_set_pdc
>  	 */
>  	dmi_check_system(processor_idle_dmi_table);
>  
> -	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
> +	acpi_walk_namespace(ACPI_TYPE_ANY, ACPI_ROOT_OBJECT,
>  			    ACPI_UINT32_MAX,
>  			    early_init_pdc, NULL, NULL, NULL);
>  }
> Index: linux-2.6/drivers/acpi/acpica/nsxfeval.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/acpica/nsxfeval.c
> +++ linux-2.6/drivers/acpi/acpica/nsxfeval.c
> @@ -524,6 +524,49 @@ ACPI_EXPORT_SYMBOL(acpi_walk_namespace)
>  
>  /*******************************************************************************
>   *
> + * FUNCTION:    acpi_match_device_hid
> + *
> + * PARAMETERS:  handle and HID to be compared
> + *
> + * RETURN:      bool
> + *
> + * DESCRIPTION: check if device coresponding to handle has HID
> + *
> + ******************************************************************************/
> +acpi_status acpi_match_device_hid(acpi_handle obj_handle, const char *HID)
> +{
> +	acpi_status status;
> +	struct acpi_namespace_node *node;
> +	struct acpica_device_id *hid;
> +	int no_match;
> +
> +	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
> +	if (ACPI_FAILURE(status))
> +		return status;
> +
> +	node = acpi_ns_validate_handle(obj_handle);
> +	status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
> +	if (ACPI_FAILURE(status))
> +		return status;
> +
> +	if (!node)
> +		return AE_BAD_PARAMETER;
> +
> +	status = acpi_ut_execute_HID(node, &hid);
> +	if (ACPI_FAILURE(status))
> +		return status;
> +
> +	no_match = ACPI_STRCMP(hid->string, HID);
> +	ACPI_FREE(hid);
> +
> +	if (no_match)
> +		return AE_NOT_FOUND;
> +
> +	return AE_OK;
> +}
> +
> +/*******************************************************************************
> + *
>   * FUNCTION:    acpi_ns_get_device_callback
>   *
>   * PARAMETERS:  Callback from acpi_get_device
> Index: linux-2.6/include/acpi/acpixf.h
> ===================================================================
> --- linux-2.6.orig/include/acpi/acpixf.h
> +++ linux-2.6/include/acpi/acpixf.h
> @@ -160,6 +160,8 @@ acpi_walk_namespace(acpi_object_type typ
>  		    acpi_walk_callback post_order_visit,
>  		    void *context, void **return_value);
>  
> +acpi_status acpi_match_device_hid(acpi_handle obj_handle, const char *HID);
> +
>  acpi_status
>  acpi_get_devices(const char *HID,
>  		 acpi_walk_callback user_function,
> 
