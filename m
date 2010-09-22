Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0IVPUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:20:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35689 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0IVPUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:20:05 -0400
Subject: Re: [PATCH 0/8] De-couple sysfs memory directories from memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C9A0F8F.2030409@austin.ibm.com>
References: <4C9A0F8F.2030409@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 22 Sep 2010 08:20:00 -0700
Message-ID: <1285168800.3292.5228.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 09:15 -0500, Nathan Fontenot wrote:
> For architectures that define their own version of this routine,
> as is done for powerpc in this patchset, the view in userspace
> would change such that each memoryXXX directory would span
> multiple memory sections.  The number of sections spanned would
> depend on the value reported by memory_block_size_bytes.
> 
> In both cases a new file 'end_phys_index' is created in each
> memoryXXX directory.  This file will contain the physical id
> of the last memory section covered by the sysfs directory.  For
> the default case, the value in 'end_phys_index' will be the same
> as in the existing 'phys_index' file.

Hi Nathan,

There's one bit missing here, I think.

"block_size_bytes" today means two things today:
1. the SECTION_SIZE from sparsemem
2. the size covered by each memoryXXXX directory

SECTION_SIZE isn't exposed to userspace, but the memoryXXXX directories
are.  You've done all of the heavy lifting here to make sure that the
memory directories are no longer bound to SECTION_SIZE, but you've also
broken the assumption that _each_ directory covers "block_size_bytes".

I think it's fairly simple to fix.  block_size_bytes() needs to return
memory_block_size_bytes(), and phys_index's calculation needs to be:

	mem->start_phys_index * SECTION_SIZE / memory_block_size_bytes()

That way, to userspace, it just looks like before, but with a larger
SECTION_SIZE.  Doing that preserves the ABI pretty nicely, I believe.

-- Dave

