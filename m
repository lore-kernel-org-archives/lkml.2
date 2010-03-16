Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937339Ab0CPB1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:27:31 -0400
Received: from mail-yw0-f189.google.com ([209.85.211.189]:63967 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab0CPB12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:27:28 -0400
Message-ID: <4B9EDE7D.4040809@codemonkey.ws>
Date: Mon, 15 Mar 2010 20:27:25 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Chris Webb <chris@arachsys.com>, Avi Kivity <avi@redhat.com>,
       balbir@linux.vnet.ibm.com, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9EC60A.2070101@codemonkey.ws> <20100316004307.GA19470@infradead.org>
In-Reply-To: <20100316004307.GA19470@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 07:43 PM, Christoph Hellwig wrote:
> On Mon, Mar 15, 2010 at 06:43:06PM -0500, Anthony Liguori wrote:
>    
>> I knew someone would do this...
>>
>> This really gets down to your definition of "safe" behaviour.  As it
>> stands, if you suffer a power outage, it may lead to guest corruption.
>>
>> While we are correct in advertising a write-cache, write-caches are
>> volatile and should a drive lose power, it could lead to data
>> corruption.  Enterprise disks tend to have battery backed write caches
>> to prevent this.
>>
>> In the set up you're emulating, the host is acting as a giant write
>> cache.  Should your host fail, you can get data corruption.
>>
>> cache=writethrough provides a much stronger data guarantee.  Even in the
>> event of a host failure, data integrity will be preserved.
>>      
> Actually cache=writeback is as safe as any normal host is with a
> volatile disk cache, except that in this case the disk cache is
> actually a lot larger.  With a properly implemented filesystem this
> will never cause corruption.

Metadata corruption, not necessarily corruption of data stored in a file.

>    You will lose recent updates after
> the last sync/fsync/etc up to the size of the cache, but filesystem
> metadata should never be corrupted, and data that has been forced to
> disk using fsync/O_SYNC should never be lost either.

Not all software uses fsync as much as they should.  And often times, 
it's for good reason (like ext3).  This is mitigated by the fact that 
there's usually a short window of time before metadata is flushed to 
disk.  Adding another layer increases that delay.

IIUC, an O_DIRECT write using cache=writeback is not actually on the 
spindle when the write() completes.  Rather, an explicit fsync() would 
be required.  That will cause data corruption in many applications (like 
databases) regardless of whether the fs gets metadata corruption.

You could argue that the software should disable writeback caching on 
the virtual disk, but we don't currently support that so even if the 
application did, it's not going to help.

Regards,

Anthony Liguori

>    If it is that's
> a bug somewhere in the stack, but in my powerfail testing we never did
> so using xfs or ext3/4 after I fixed up the fsync code in the latter
> two.
>
>    

