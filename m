Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2LNATo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:19:44 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54309 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2LNATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:19:43 -0500
Message-ID: <50CA7067.4080706@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2012 16:18:47 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net> <20121207155125.d3117244.akpm@linux-foundation.org> <50C28720.3070205@linux.vnet.ibm.com> <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net> <50C933E9.2040707@linux.vnet.ibm.com> <1355364222.9244.3.camel@buesod1.americas.hpqcorp.net> <50C95E4A.9010509@linux.vnet.ibm.com> <1355440542.1823.21.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1355440542.1823.21.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121400-5806-0000-0000-00001CF62B87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 03:15 PM, Davidlohr Bueso wrote:
> On Wed, 2012-12-12 at 20:49 -0800, Dave Hansen wrote:
>> How is that possible?  If NUMA nodes are defined by distances from CPUs
>> to memory, how could a DIMM have more than a single distance to any
>> given CPU?
> 
> Can't this occur when interleaving emulated nodes with physical ones?

I'm glad you mentioned numa=fake. Its interleaving node configuration
would also make the patch you've proposed completely useless.  Let's say
you've got a two-node system with 16GB of RAM:

|        0        |      1      |

And you use numa=fake=1G, you'll get the interleaved like this:

|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|

The information that is exported from the interface you're proposing
would be:

node0: start_pfn=0  and spanned_pages = 15G
node1: start_pfn=1G and spanned_pages = 15G

In that situation, there is no way, to figure out which DIMM is backed
by a given node since the node ranges overlap.

>>>> How do you plan to use this in practice, btw?
>>>
>>> It started because I needed to recognize the address of a node to remove
>>> it from the e820 mappings and have the system "ignore" the node's
>>> memory.
>>
>> Actually, now that I think about it, can you check in the
>> /sys/devices/system/ directories for memory and nodes?  We have linkages
>> there for each memory section to every NUMA node, and you can also
>> derive the physical address from the phys_index in each section.  That
>> should allow you to work out physical addresses for a given node.
>> 
> I had looked at the memory-hotplug interface but found that this
> 'phys_index' doesn't include holes, while ->node_spanned_pages does.

I'm not sure what you mean.  Each memory section in sysfs accounts for
SECTION_SIZE where sections are 128MB by default on x86_64.

