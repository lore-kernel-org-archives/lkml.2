Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2ECLsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:48:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21411 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2ECLsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:48:23 -0400
X-IronPort-AV: E=Sophos;i="4.75,522,1330923600"; 
   d="scan'208";a="193210476"
Message-ID: <4FA27084.4030005@citrix.com>
Date: Thu, 3 May 2012 12:48:20 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] auto balloon initial domain and fix dom0_mem=X inconsistencies
 (v5).
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com> <20120501163707.GA8741@phenom.dumpdata.com>
In-Reply-To: <20120501163707.GA8741@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/12 17:37, Konrad Rzeszutek Wilk wrote:
> On Mon, Apr 16, 2012 at 01:15:31PM -0400, Konrad Rzeszutek Wilk wrote:
>> Changelog v5 [since v4]:
>>  - used populate_physmap, fixed bugs.
>> [v2-v4: not posted]
>>  - reworked the code in setup.c to work properly.
>> [v1: https://lkml.org/lkml/2012/3/30/492]
>>  - initial patchset
> 
> One bug I found was that with 'dom0_mem=max:1G' (with and without these
> patches) I would get a bunch of
> 
> (XEN) page_alloc.c:1148:d0 Over-allocation for domain 0: 2097153 > 2097152
> (XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (0 of 17)
> 
> where the (0 of X), sometimes was 1, 2,3,4 or 17 -depending on the machine
> I ran on it. I figured it out that the difference was in the ACPI tables
> that are allocated - and that those regions - even though are returned
> back to the hypervisor, cannot be repopulated. I can't find the actual
> exact piece of code in the hypervisor to pin-point and say "Aha".

It was tricky to track down what is going here but I think I see what's
happening.

The problem pages (on the system I looked at) were located just before
the ISA memory region (so PFN < a0) and so they are mapped in the
bootstrap page tables and have an additional ref so are not immediately
freed when the page is released.  They do get freed later on, presumably
when the page tables are swapped over.

I think the mapping needs to be removed with
HYPERVISOR_update_va_mapping() before releasing the page.  This is
already done for the ISA region in xen_ident_map_ISA().

I may be easier to avoid doing anything with the PFNs < 0x100 and take
the minimal lose of memory.

David
