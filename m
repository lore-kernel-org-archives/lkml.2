Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2LER6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:58:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:20277 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2LER6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:58:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,223,1355126400"; 
   d="scan'208";a="257738090"
From: "Moore, Robert" <robert.moore@intel.com>
To: Tim Gardner <tim.gardner@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lin Ming <ming.m.lin@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 3.7-rc8] ACPICA: Fix ACPI mutex object allocation memory
 leak on error
Thread-Topic: [PATCH 3.7-rc8] ACPICA: Fix ACPI mutex object allocation
 memory leak on error
Thread-Index: AQHN0w9vUTgVa8fwzEWTIYUffeoumZgKfeOQ
Date: Wed, 5 Dec 2012 17:58:21 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346BE12BD@ORSMSX101.amr.corp.intel.com>
References: <1354729137-67135-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1354729137-67135-1-git-send-email-tim.gardner@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

Thanks. We will need to backport this change to the ACPICA source code.
Bob


> -----Original Message-----
> From: Tim Gardner [mailto:tim.gardner@canonical.com]
> Sent: Wednesday, December 05, 2012 9:39 AM
> To: linux-kernel@vger.kernel.org
> Cc: Tim Gardner; Len Brown; Rafael J. Wysocki; Lin Ming; Moore, Robert;
> linux-acpi@vger.kernel.org
> Subject: [PATCH 3.7-rc8] ACPICA: Fix ACPI mutex object allocation memory
> leak on error
> 
> An unattached mutex object is not released on error, thereby orphaning
> memory.
> 
> I stumbled on this when looking at the output of smatch:
> 
> drivers/acpi/acpica/dsmethod.c:225 acpi_ds_begin_method_execution() error:
> we previously assumed 'obj_desc->method.mutex' could be null (see line
> 209)
> 
> which led me to have a look at acpi_ds_create_method_mutex().
> 
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Lin Ming <ming.m.lin@intel.com>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: stable@vger.kernel.org #2.6.29+
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
> 
> This applied to the original version of dsmethod.c which was introduced in
> 95b482a8d31116f3f5c2a5089569393234d06385 (2.6.29).
> 
>  drivers/acpi/acpica/dsmethod.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/acpica/dsmethod.c
> b/drivers/acpi/acpica/dsmethod.c index aa9a5d4..fe89ea9 100644
> --- a/drivers/acpi/acpica/dsmethod.c
> +++ b/drivers/acpi/acpica/dsmethod.c
> @@ -151,6 +151,7 @@ acpi_ds_create_method_mutex(union acpi_operand_object
> *method_desc)
> 
>  	status = acpi_os_create_mutex(&mutex_desc->mutex.os_mutex);
>  	if (ACPI_FAILURE(status)) {
> +		acpi_ut_delete_object_desc(mutex_desc);
>  		return_ACPI_STATUS(status);
>  	}
> 
> --
> 1.7.9.5

