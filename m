Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0IVS6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:58:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52624 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0IVS6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:58:53 -0400
Subject: Re: [PATCH 0/8] De-couple sysfs memory directories from memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C9A4DBB.6080500@austin.ibm.com>
References: <4C9A0F8F.2030409@austin.ibm.com>
	 <1285168800.3292.5228.camel@nimitz>  <4C9A4DBB.6080500@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 22 Sep 2010 11:58:49 -0700
Message-ID: <1285181929.3292.6287.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 13:40 -0500, Nathan Fontenot wrote:
> On 09/22/2010 10:20 AM, Dave Hansen wrote:
> >                            and phys_index's calculation needs to be:
> > 
> > 	mem->start_phys_index * SECTION_SIZE / memory_block_size_bytes()
> 
> I'm not sure if  I follow where you suggest using this formula.  Is this
> instead of what is used now, the base_memory_block_id() calculation?
> 
> If so, then I'm not sure it would work. The formula used in base_memory_block_id()
> is done because the memory sections are not guaranteed to be added to the
> memory block starting with the first section of the block.
> 
> If you meant somewhere else let me know.

My point was just that if we change the "block_size_bytes" contents,
then we have to scale down the "memoryXXXX/phys_index" by that same
amount.

It *used* to be in numbers of SECTION_SIZE units, and I think it still
is:

-       mem->start_phys_index = __section_nr(section);
+       mem->start_phys_index = base_memory_block_id(__section_nr(section));
+       mem->end_phys_index = mem->start_phys_index + sections_per_block - 1;

but now it needs to be changed to be in memory_block_size_bytes() units,
*NOT* SECTION_SIZE units.

Let's say we have a system with 4 16MB sections starting at 0x0.
Before, we would have:

	block_size_bytes: 16777216
	memory0/phys_index: 0
	memory1/phys_index: 1
	memory2/phys_index: 2
	memory3/phys_index: 3

Now, we change memory_block_size_bytes() to be 32MB instead.  We reduce
the number of sections in half, and I think the right thing to get is:

	block_size_bytes: 33554432
	memory0/phys_index: 0
	memory1/phys_index: 1

I think, with your code (as it stands in these patches, no fixes) that
we'd instead get this:

	block_size_bytes: 16777216
	memory0/phys_index: 0
	memory1/phys_index: 2

Without consulting "end_phys_index" (which isn't and can't be a part of
the existing ABI), we'd think that we have two 16MB banks instead of
four.


-- Dave

