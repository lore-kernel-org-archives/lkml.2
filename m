Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0DXBws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 21:52:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41894 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0DXBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 21:52:47 -0400
Message-ID: <4BD24E37.30204@vflare.org>
Date: Sat, 24 Apr 2010 07:19:43 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       JBeulich@novell.com, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default 4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com>
In-Reply-To: <4BD1B427.9010905@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 08:22 PM, Avi Kivity wrote:
> On 04/23/2010 05:43 PM, Dan Magenheimer wrote:
>>>
>>> Perhaps I misunderstood.  Isn't frontswap in front of the normal swap
>>> device?  So we do have double swapping, first to frontswap (which is in
>>> memory, yes, but still a nonzero cost), then the normal swap device.
>>> The io subsystem is loaded with writes; you only save the reads.
>>> Better to swap to the hypervisor, and make it responsible for
>>> committing
>>> to disk on overcommit or keeping in RAM when memory is available.  This
>>> way we avoid the write to disk if memory is in fact available (or at
>>> least defer it until later).  This way you avoid both reads and writes
>>> if memory is available.
>>>      
>> Each page is either in frontswap OR on the normal swap device,
>> never both.  So, yes, both reads and writes are avoided if memory
>> is available and there is no write issued to the io subsystem if
>> memory is available.  The is_memory_available decision is determined
>> by the hypervisor dynamically for each page when the guest attempts
>> a "frontswap_put".  So, yes, you are indeed "swapping to the
>> hypervisor" but, at least in the case of Xen, the hypervisor
>> never swaps any memory to disk so there is never double swapping.
>>    
> 
> I see.  So why not implement this as an ordinary swap device, with a
> higher priority than the disk device?  this way we reuse an API and keep
> things asynchronous, instead of introducing a special purpose API.
> 

ramzswap is exactly this: an ordinary swap device which stores every page
in (compressed) memory and its enabled as highest priority swap. Currently,
it stores these compressed chunks in guest memory itself but it is not very
difficult to send these chunks out to host/hypervisor using virtio.
 
However, it suffers from unnecessary block I/O layer overhead and requires
weird hooks in swap code, say to get notification when a swap slot is freed.
OTOH frontswap approach gets rid of any such artifacts and overheads.
(ramzswap: http://code.google.com/p/compcache/)

Thanks,
Nitin
