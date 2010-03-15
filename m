Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937205Ab0COXnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:43:13 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:65332 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab0COXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:43:10 -0400
Message-ID: <4B9EC60A.2070101@codemonkey.ws>
Date: Mon, 15 Mar 2010 18:43:06 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
CC: Avi Kivity <avi@redhat.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com>
In-Reply-To: <20100315202353.GJ3840@arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 03:23 PM, Chris Webb wrote:
> Avi Kivity<avi@redhat.com>  writes:
>
>    
>> On 03/15/2010 10:07 AM, Balbir Singh wrote:
>>
>>      
>>> Yes, it is a virtio call away, but is the cost of paying twice in
>>> terms of memory acceptable?
>>>        
>> Usually, it isn't, which is why I recommend cache=off.
>>      
> Hi Avi. One observation about your recommendation for cache=none:
>
> We run hosts of VMs accessing drives backed by logical volumes carved out
> from md RAID1. Each host has 32GB RAM and eight cores, divided between (say)
> twenty virtual machines, which pretty much fill the available memory on the
> host. Our qemu-kvm is new enough that IDE and SCSI drives with writeback
> caching turned on get advertised to the guest as having a write-cache, and
> FLUSH gets translated to fsync() by qemu. (Consequently cache=writeback
> isn't acting as cache=neverflush like it would have done a year ago. I know
> that comparing performance for cache=none against that unsafe behaviour
> would be somewhat unfair!)
>    

I knew someone would do this...

This really gets down to your definition of "safe" behaviour.  As it 
stands, if you suffer a power outage, it may lead to guest corruption.

While we are correct in advertising a write-cache, write-caches are 
volatile and should a drive lose power, it could lead to data 
corruption.  Enterprise disks tend to have battery backed write caches 
to prevent this.

In the set up you're emulating, the host is acting as a giant write 
cache.  Should your host fail, you can get data corruption.

cache=writethrough provides a much stronger data guarantee.  Even in the 
event of a host failure, data integrity will be preserved.

Regards,

Anthony Liguori

