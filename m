Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1ILOjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:39:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56538 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab1ILOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:39:03 -0400
Message-ID: <4E6E18C6.8080900@linux.vnet.ibm.com>
Date: Mon, 12 Sep 2011 09:35:50 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
        dan.magenheimer@oracle.com, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        linux-mm@kvack.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
In-Reply-To: <4E6ACE5B.9040401@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11091214-8974-0000-0000-0000001585A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 09:41 PM, Nitin Gupta wrote:
> On 09/09/2011 04:34 PM, Greg KH wrote:
> 
>> On Wed, Sep 07, 2011 at 09:09:04AM -0500, Seth Jennings wrote:
>>> Changelog:
>>> v2: fix bug in find_remove_block()
>>>     fix whitespace warning at EOF
>>>
>>> This patchset introduces a new memory allocator for persistent
>>> pages for zcache.  The current allocator is xvmalloc.  xvmalloc
>>> has two notable limitations:
>>> * High (up to 50%) external fragmentation on allocation sets > PAGE_SIZE/2
>>> * No compaction support which reduces page reclaimation
>>
>> I need some acks from other zcache developers before I can accept this.
>>
> 
> First, thanks for this new allocator; xvmalloc badly needed a replacement :)
> 

Hey Nitin, I hope your internship went well :)  It's good to hear from you.

> I went through xcfmalloc in detail and would be posting detailed
> comments tomorrow.  In general, it seems to be quite similar to the
> "chunk based" allocator used in initial implementation of "compcache" --
> please see section 2.3.1 in this paper:
> http://www.linuxsymposium.org/archives/OLS/Reprints-2007/briglia-Reprint.pdf
> 

Ah, indeed they look similar.  I didn't know that this approach
had already been done before in the history of this project.

> I'm really looking forward to a slab based allocator as I mentioned in
> the initial mail:
> http://permalink.gmane.org/gmane.linux.kernel.mm/65467
> 
> With the current design xcfmalloc suffers from issues similar to the
> allocator described in the paper:
>  - High metadata overhead
>  - Difficult implementation of compaction
>  - Need for extra memcpy()s  etc.
> 
> With slab based approach, we can almost eliminate any metadata overhead,
> remove any free chunk merging logic, simplify compaction and so on.
> 

Just to align my understanding with yours, when I hear slab-based,
I'm thinking each page in the compressed memory pool will contain
1 or more blocks that are all the same size.  Is this what you mean?

If so, I'm not sure how changing to a slab-based system would eliminate
metadata overhead or do away with memcpy()s.

The memcpy()s are a side effect of having an allocation spread over
blocks in different pages.  I'm not seeing a way around this.

It also follows that the blocks that make up an allocation must be in
a list of some kind, leading to some amount of metadata overhead.

If you want to do compaction, it follows that you can't give the user
a direct pointer to the data, since the location of that data may change.
In this case, an indirection layer is required (i.e. xcf_blkdesc and
xcf_read()/xcf_write()).

The only part of the metadata that could be done away with in a slab-
based approach, as far as I can see, is the prevoffset field in xcf_blkhdr,
since the size of the previous block in the page (or the previous object
in the slab) can be inferred from the size of the current block/object.

I do agree that we don't have to worry about free block merging in a
slab-based system.

I didn't implement compaction so a slab-based system could very well
make it easier.  I guess it depends on how one ends up doing it.

Anyway, I look forward to your detailed comments :)

--
Seth

