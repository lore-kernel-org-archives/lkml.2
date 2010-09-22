Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0IVSlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:41:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36660 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0IVSlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:41:02 -0400
Message-ID: <4C9A4DBB.6080500@austin.ibm.com>
Date: Wed, 22 Sep 2010 13:40:59 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] De-couple sysfs memory directories from memory sections
References: <4C9A0F8F.2030409@austin.ibm.com> <1285168800.3292.5228.camel@nimitz>
In-Reply-To: <1285168800.3292.5228.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 10:20 AM, Dave Hansen wrote:
> On Wed, 2010-09-22 at 09:15 -0500, Nathan Fontenot wrote:
>> For architectures that define their own version of this routine,
>> as is done for powerpc in this patchset, the view in userspace
>> would change such that each memoryXXX directory would span
>> multiple memory sections.  The number of sections spanned would
>> depend on the value reported by memory_block_size_bytes.
>>
>> In both cases a new file 'end_phys_index' is created in each
>> memoryXXX directory.  This file will contain the physical id
>> of the last memory section covered by the sysfs directory.  For
>> the default case, the value in 'end_phys_index' will be the same
>> as in the existing 'phys_index' file.
> 
> Hi Nathan,
> 
> There's one bit missing here, I think.
> 
> "block_size_bytes" today means two things today:
> 1. the SECTION_SIZE from sparsemem
> 2. the size covered by each memoryXXXX directory
> 
> SECTION_SIZE isn't exposed to userspace, but the memoryXXXX directories
> are.  You've done all of the heavy lifting here to make sure that the
> memory directories are no longer bound to SECTION_SIZE, but you've also
> broken the assumption that _each_ directory covers "block_size_bytes".
> 
> I think it's fairly simple to fix.  block_size_bytes() needs to return
> memory_block_size_bytes(),

yes, missed that.  I will update the patch set to include this.

>                            and phys_index's calculation needs to be:
> 
> 	mem->start_phys_index * SECTION_SIZE / memory_block_size_bytes()

I'm not sure if  I follow where you suggest using this formula.  Is this
instead of what is used now, the base_memory_block_id() calculation?

If so, then I'm not sure it would work. The formula used in base_memory_block_id()
is done because the memory sections are not guaranteed to be added to the
memory block starting with the first section of the block.

If you meant somewhere else let me know.

-Nathan
> 
> That way, to userspace, it just looks like before, but with a larger
> SECTION_SIZE.  Doing that preserves the ABI pretty nicely, I believe.
> 
> -- Dave
> 

