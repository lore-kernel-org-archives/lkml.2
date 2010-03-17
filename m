Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0CQRGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab0CQRGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:06:39 -0400
Message-ID: <4BA10C07.7000904@redhat.com>
Date: Wed, 17 Mar 2010 19:06:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Chris Webb <chris@arachsys.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com> <4BA101C5.9040406@redhat.com> <4BA105FE.2000607@redhat.com> <20100317165725.GB29548@lst.de>
In-Reply-To: <20100317165725.GB29548@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 06:57 PM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2010 at 06:40:30PM +0200, Avi Kivity wrote:
>    
>> Chris, can you carry out an experiment?  Write a program that pwrite()s
>> a byte to a file at the same location repeatedly, with the file opened
>> using O_SYNC.  Measure the write rate, and run blktrace on the host to
>> see what the disk (/dev/sda, not the volume) sees.  Should be a (write,
>> flush, write, flush) per pwrite pattern or similar (for writing the data
>> and a journal block, perhaps even three writes will be needed).
>>
>> Then scale this across multiple guests, measure and trace again.  If
>> we're lucky, the flushes will be coalesced, if not, we need to work on it.
>>      
> As the person who has written quite a bit of the current O_SYNC
> implementation and also reviewed the rest of it I can tell you that
> those flushes won't be coalesced.  If we always rewrite the same block
> we do the cache flush from the fsync method and there's is nothing
> to coalesced it there.  If you actually do modify metadata (e.g. by
> using the new real O_SYNC instead of the old one that always was O_DSYNC
> that I introduced in 2.6.33 but that isn't picked up by userspace yet)
> you might hit a very limited transaction merging window in some
> filesystems, but it's generally very small for a good reason.  If it
> were too large we'd make the once progress wait for I/O in another just
> because we might expect transactions to coalesced later.  There's been
> some long discussion about that fsync transaction batching tuning
> for ext3 a while ago.
>    

I definitely don't expect flush merging for a single guest, but for 
multiple guests there is certainly an opportunity for merging.  Most 
likely we don't take advantage of it and that's one of the problems.  
Copying data into pagecache so that we can merge the flushes seems like 
a very unsatisfactory implementation.




-- 
error compiling committee.c: too many arguments to function

