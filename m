Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0HPOeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:34:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50167 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab0HPOeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:34:16 -0400
Message-ID: <4C694C60.6030207@austin.ibm.com>
Date: Mon, 16 Aug 2010 09:34:08 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/8] v5 De-couple sysfs memory directories from memory
 sections
References: <4C60407C.2080608@austin.ibm.com> <20100812120816.e97d8b9e.akpm@linux-foundation.org>
In-Reply-To: <20100812120816.e97d8b9e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 02:08 PM, Andrew Morton wrote:
> On Mon, 09 Aug 2010 12:53:00 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> This set of patches de-couples the idea that there is a single
>> directory in sysfs for each memory section.  The intent of the
>> patches is to reduce the number of sysfs directories created to
>> resolve a boot-time performance issue.  On very large systems
>> boot time are getting very long (as seen on powerpc hardware)
>> due to the enormous number of sysfs directories being created.
>> On a system with 1 TB of memory we create ~63,000 directories.
>> For even larger systems boot times are being measured in hours.
> 
> And those "hours" are mainly due to this problem, I assume.

Yes, those hours are spent creating the sysfs directories for each
of the memory sections.

> 
>> This set of patches allows for each directory created in sysfs
>> to cover more than one memory section.  The default behavior for
>> sysfs directory creation is the same, in that each directory
>> represents a single memory section.  A new file 'end_phys_index'
>> in each directory contains the physical_id of the last memory
>> section covered by the directory so that users can easily
>> determine the memory section range of a directory.
> 
> What you're proposing appears to be a non-back-compatible
> userspace-visible change.  This is a big issue!
> 
> It's not an unresolvable issue, as this is a must-fix problem.  But you
> should tell us what your proposal is to prevent breakage of existing
> installations.  A Kconfig option would be good, but a boot-time kernel
> command line option which selects the new format would be much better.

This shouldn't break existing installations, unless an architecture chooses
to do so.  With my patch only the powerpc/pseries arch is updated such that
what is seen in userspace is different.

The default behavior is maintained for all architectures unless they define
their own version of memory_block_size_bytes().  The default definition of
this routine (defined as __weak in Patch 5/8) sets the memory block size
to the same size it currently is, and thus preserving the exisitng 1 sysfs
directory per memory section.  The only change that will be seen is a new
propery for memory section, end_phys_addr, which will have the same value
as the existing 'phys_addr' property.

> 
> However you didn't mention this issue at all, and it's the most
> important one.
> 
> 
>> Updates for version 5 of the patchset include the following:
>>
>> Patch 4/8 Add mutex for add/remove of memory blocks
>> - Define the mutex using DEFINE_MUTEX macro.
>>
>> Patch 8/8 Update memory-hotplug documentation
>> - Add information concerning memory holes in phys_index..end_phys_index.
> 
> And you forgot to tell us how long those machines boot with the
> patchset applied, which is the entire point of the patchset!

Yes,  I am working on getting more time on our large systems to get
performance numbers with this patch.  I'll post them when I get them.

-Nathan
