Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2AEGRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:17:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:62778 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2AEGRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:17:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92571784"
Message-ID: <4F05406F.5030805@linux.intel.com>
Date: Thu, 05 Jan 2012 14:17:19 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
References: <212c4cabb390880e855be9509e7d2be002699907.1325716284.git.tony.luck@intel.com>
In-Reply-To: <212c4cabb390880e855be9509e7d2be002699907.1325716284.git.tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/1/5 6:29, Tony Luck 写道:
> ACPI 5.0 provides extensions to the EINJ mechanism to specify the
> target for the error injection - by APICID for cpu related errors,
> by address for memory related errors, and by segment/bus/device/function
> for PCIe related errors. Also extensions for vendor specific error
> injections.
>
> Tested-by: Chen Gong<gong.chen@linux.intel.com>
> Signed-off-by: Tony Luck<tony.luck@intel.com>
> ---
>
> [Code is identical to version posted on November 29th, 2011 - but added changes
>   to einj.txt in response to all the questions from Chen Gong]
>
>   Documentation/acpi/apei/einj.txt |   43 ++++++--
>   drivers/acpi/apei/einj.c         |  217 +++++++++++++++++++++++++++++++------
>   include/acpi/actbl1.h            |    3 +-
>   3 files changed, 215 insertions(+), 48 deletions(-)
>
> diff --git a/Documentation/acpi/apei/einj.txt b/Documentation/acpi/apei/einj.txt
> index 5cc699b..95a2b22 100644
> --- a/Documentation/acpi/apei/einj.txt
> +++ b/Documentation/acpi/apei/einj.txt
> @@ -47,20 +47,41 @@ directory apei/einj. The following files are provided.
>
>   - param1
>     This file is used to set the first error parameter value. Effect of
> -  parameter depends on error_type specified. For memory error, this is
> -  physical memory address.  Only available if param_extension module
> -  parameter is specified.
> +  parameter depends on error_type specified.
>
>   - param2
>     This file is used to set the second error parameter value. Effect of
> -  parameter depends on error_type specified. For memory error, this is
> -  physical memory address mask.  Only available if param_extension
> -  module parameter is specified.
> +  parameter depends on error_type specified.
>
> -Injecting parameter support is a BIOS version specific extension, that
> -is, it only works on some BIOS version.  If you want to use it, please
> -make sure your BIOS version has the proper support and specify
> -"param_extension=y" in module parameter.
> +BIOS versions based in the ACPI 4.0 specification have limited options
> +to control where the errors are injected.  Your BIOS may support an
> +extension (enabled with the param_extension=1 module parameter, or
> +boot command line einj.param_extension=1). This allows the address
> +and mask for memory injections to be specified by the param1 and
> +param2 files in apei/einj.
> +
> +BIOS versions using the ACPI 5.0 specification have more control over
> +the target of the injection. For processor related errors (type 0x1,
> +0x2 and 0x4) the APICID of the target should be provided using the
> +param1 file in apei/einj. For memory errors (type 0x8, 0x10 and 0x20)
> +the address is set using param1 with a mask in param2 (0x0 is equivalent
> +to all ones). For PCI express errors (type 0x80, 0x80 and 0x100) the
                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
                                     should be 0x40, 0x80 and 0x100

> +segment, bus, device and function are specified using param1:
> +
> +         31     24 23    16 15    11 10      8  7        0
> +	+-------------------------------------------------+
> +	| segment |   bus  | device | function | reserved |
> +	+-------------------------------------------------+
> +
> +An ACPI 5.0 BIOS may also allow vendor specific errors to be injected.
> +In this case a file named vendor will contain identifying information
> +from the BIOS that hopefully will allow an application wishing to use
> +the vendor specific extension to tell that they are running on a BIOS
> +that supports it. All vendor extensions have the 0x80000000 bit set in
> +error_type. A file vendor_flags controls the interpretation of param1
> +and param2 (1 = PROCESSOR, 2 = MEMORY, 4 = PCI). See your BIOS vendor
> +documentation for details (and expect changes to this API if vendors
> +creativity in using this feature expands beyond our expectations).
>
>   For more information about EINJ, please refer to ACPI specification
> -version 4.0, section 17.5.
> +version 4.0, section 17.5 and ACPI 5.0, section 18.6.

In my own opinion, it is too hard for the one to use all kinds of combinations
to control test conditions. If still keeping current parameters, I suggest
adding some examples to clarify them.
