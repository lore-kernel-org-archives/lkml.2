Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1EMPac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:30:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26631 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1EMPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:30:29 -0400
Date: Fri, 13 May 2011 11:30:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: yinghai@kernel.org, jeremy@goop.org, stefano.stabellini@eu.citrix.com,
        hpa@zytor.com, hpa@linux.intel.com,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
Message-ID: <20110513153010.GB16519@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DCD4E8E.0061:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka, remove the hack added by git commit 609cfda586c7fe3e5d1a02c51edb587506294167
(Merge branch 'stable/bug-fixes-for-rc5' of git://git.kernel.org/../xen)

One idea that is on the table was proposed by Yinghai:
"Xen should set RAM for page-table to RO after init_memory mapping."

In other words, don't do the magic 'mask_rw_pte' when set_pte is called.
(and don't do the calls to make_lowmem_page_readonly when allocating
the PTE table, nor PMD, nor PUD) - I think?

But instead do:
 a). when we load the cr3? We could go through the whole pagetable and
     set the RO as we need?
 b). when we are finished with the creation of a page table? So similary 
     to the point above - don't set the RO on the pages until we have completed
     the full creation of the page.
 c). when post_allocator_start is called?
 d). other ideas?

But I vaguelly recall that we are using the page table as we are adding in the
entries. And that we are pinning them as well. Perhaps the trigger to scan the
pagetable and set them to RO should be done .. at what point? When the PUD/PMD
allocations are done? And when PUD/PMD are set?
