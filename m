Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0CQRF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab0CQRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:05:57 -0400
Message-ID: <4BA10B13.70404@redhat.com>
Date: Wed, 17 Mar 2010 19:02:11 +0200
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
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com> <4BA101C5.9040406@redhat.com> <20100317165229.GA29548@lst.de>
In-Reply-To: <20100317165229.GA29548@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 06:52 PM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2010 at 06:22:29PM +0200, Avi Kivity wrote:
>    
>> They should be reorderable.  Otherwise host filesystems on several
>> volumes would suffer the same problems.
>>      
> They are reordable, just not as extremly as the the page cache.
> Remember that the request queue really is just a relatively small queue
> of outstanding I/O, and that is absolutely intentional.  Large scale
> _caching_ is done by the VM in the pagecache, with all the usual aging,
> pressure, etc algorithms applied to it.

We already have the large scale caching and stuff running in the guest.  
We have a stream of optimized requests coming out of guests, running the 
same algorithm again shouldn't improve things.  The host has an 
opportunity to do inter-guest optimization, but given each guest has its 
own disk area, I don't see how any reordering or merging could help here 
(beyond sorting guests according to disk order).

> The block devices have a
> relatively small fixed size request queue associated with it to
> facilitate request merging and limited reordering and having fully
> set up I/O requests for the device.
>    

We should enlarge the queues, increase request reorderability, and merge 
flushes (delay flushes until after unrelated writes, then adjacent 
flushes can be collapsed).

Collapsing flushes should get us better than linear scaling (since we 
collapes N writes + M flushes into N writes and 1 flush).  However the 
writes themselves scale worse than linearly, since they now span a 
larger disk space and cause higher seek penalties.

-- 
error compiling committee.c: too many arguments to function

