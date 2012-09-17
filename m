Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2IQNvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:51:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20245 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2IQNvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:51:11 -0400
Date: Mon, 17 Sep 2012 09:39:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rob@landley.net, akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devel@linuxdriverproject.org,
        shuahkhan@gmail.com, x86@kernel.org
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120917133937.GC11553@phenom.dumpdata.com>
References: <1347843171.4370.13.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347843171.4370.13.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 06:52:51PM -0600, Shuah Khan wrote:
> A recent dma mapping error analysis effort showed that a large percentage
> of dma_map_single() and dma_map_page() returns are not checked for mapping
> errors.
> 
> Reference:
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> 
> Adding support for tracking dma mapping and unmapping errors to help assess
> the following:
> 
> When do dma mapping errors get detected?
> How often do these errors occur?
> Why don't we see failures related to missing dma mapping error checks?
> Are they silent failures?
> 
> Four new fields are added to struct device when CONFIG_DMA_API_DEBUG is
> enabled, to track the following:
> 
> dma_map_errors:
>   Total number of dma mapping errors returned by the dma mapping interfaces,
>   in response to mapping requests from this device.
> dma_map_errors_not_checked:
>   Total number of dma mapping errors the device failed to check before using
>   the returned address.
> dma_unmap_errors:
>   Total number of times the device tried to unmap or free an invalid dma
>   address.
> iotlb_overflow_cnt:
>   Tracks how many times a swiotlb overflow buffer is returned to this device
>   when regular iotlb is full.
> 
> Enhancements to dma-debug api are made to add new debugfs interfaces to
> report total dma errors, dma errors that are not checked, and unmap errors
> for the entire system. Please note that these are counts for all devices in
> the system.
> 
> The following new dma-debug interfaces are added:
> 
> debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr):
> 	Tracks dma mapping errors checked by the device. It decrements
> 	the dma_map_errors_not_checked counter that was incremented by
> 	debug_dma_map_page() when it checked for errors.
> debug_dma_dump_map_errors(struct device *dev, int all):
> 	Allows dump of dma mapping error summary or just the errors if any.
> 
> The following existing dma-debug api are changed to support this feature:
> debug_dma_map_page():
> 	Increments dma_map_errors and dma_map_errors_not_checked errors for
> 	the current device as well as totals for the system, dma-debug api
> 	keeps track of, when dma_addr is invalid. Please note that this
> 	routine can no longer call dma_mapping_error(), because of the newly
> 	added debug_dma_mapping_error() interface. Calling this routine at the
> 	time dma error unchecked state is registered, will not help if state
> 	gets changed right away.
> check_unmap():
> 	This is an existing internal routines that checks for unmap errors,
> 	changed to increment dma_unmap_errors for the current device, as well
> 	as the dma_unmap_errors counter for the system, dma-debug api keeps
> 	track of, when a device requests an invalid address to be unmapped.
> 	Please note that this routine can no longer call dma_mapping_error(),
> 	because of the newly added debug_dma_mapping_error() interface. Calling
> 	dma_mapping_error() from this routine will decrement
> 	dma_map_errors_not_checked counter incorrectly.


I like the direction of this patch. That said I am wondering why you
choose to do it this way? Was there no way to have all of the logic within
debug dma file, and within check_unmap?

> 
> The following new swiotlb interface is changed:
> swiotlb_map_page():
> 	Increments iotlb_overflow_cnt for the device when iotlb overflow
> 	buffer is returned when swiotlb is full.
> 
> Changed arch/x86/include/asm/dma-mapping.h to call debug_dma_mapping_error()
> to validate these new interfaces on x86_64. Other architectures will be
> changed in a subsequent patch.
> 
> The current dma-debug infrastructure is designed to track dma mappings, and
> debug entries are added only for correctly mapped addresses and not when
> mapping fails. Enhancing the current infrastructure to track failed mappings
> will result in unnecessary complexity. The approach to add counters to

What is the extra complexity? Can you explain as if I was a newbie to debug DMA
API - perhaps there is still some hope in doing it there?

> struct device eliminates the need for maintaining failed mappings in dma-debug
> infrastructure and is cleaner and simpler without impacting the existing
> dma-debug infrastructure.

Could you explain please why it would be more difficult to do it in the existing
dma-debug infrastructure?
