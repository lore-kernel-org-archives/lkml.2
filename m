Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2EJRYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:24:40 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57140 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab2EJRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:24:38 -0400
Message-ID: <4FABF9D4.8080303@vflare.org>
Date: Thu, 10 May 2012 13:24:36 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <4FA28907.9020300@vflare.org> <4FA2A2F0.3030509@linux.vnet.ibm.com> <4FA33DF6.8060107@kernel.org> <20120509201918.GA7288@kroah.com> <4FAB21E7.7020703@kernel.org> <20120510140215.GC26152@phenom.dumpdata.com> <4FABD503.4030808@vflare.org> <4FABDA9F.1000105@linux.vnet.ibm.com> <20120510151941.GA18302@kroah.com> <4FABECF5.8040602@vflare.org> <20120510164418.GC13964@kroah.com>
In-Reply-To: <20120510164418.GC13964@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/12 12:44 PM, Greg Kroah-Hartman wrote:
> On Thu, May 10, 2012 at 12:29:41PM -0400, Nitin Gupta wrote:
>> On 5/10/12 11:19 AM, Greg Kroah-Hartman wrote:
>>> On Thu, May 10, 2012 at 10:11:27AM -0500, Seth Jennings wrote:
>>>> On 05/10/2012 09:47 AM, Nitin Gupta wrote:
>>>>
>>>>> On 5/10/12 10:02 AM, Konrad Rzeszutek Wilk wrote:
>>>>>> struct zs {
>>>>>>      void *ptr;
>>>>>> };
>>>>>>
>>>>>> And pass that structure around?
>>>>>>
>>>>>
>>>>> A minor problem is that we store this handle value in a radix tree node.
>>>>> If we wrap it as a struct, then we will not be able to store it directly
>>>>> in the node -- the node will have to point to a 'struct zs'. This will
>>>>> unnecessarily waste sizeof(void *) for every object stored.
>>>>
>>>>
>>>> I don't think so. You can use the fact that for a struct zs var,&var
>>>> and&var->ptr are the same.
>>>>
>>>> For the structure above:
>>>>
>>>> void * zs_to_void(struct zs *p) { return p->ptr; }
>>>> struct zs * void_to_zs(void *p) { return (struct zs *)p; }
>>>
>>> Do like what the rest of the kernel does and pass around *ptr and use
>>> container_of to get 'struct zs'.  Yes, they resolve to the same pointer
>>> right now, but you shouldn't "expect" to to be the same.
>>>
>>>
>>
>> I think we can just use unsigned long as zs handle type since all we
>> have to do is tell the user that the returned value is not a
>> pointer. This will be less pretty than a typedef but still better
>> than a single entry struct + container_of stuff.
>
> But then you are casting the thing all around just as much as you were
> with the void *, right?
>
> Making this a "real" structure ensures type safety and lets the compiler
> find the problems you accidentally create at times :)
>

If we return a 'struct zs' from zs_malloc then I cannot see how we are 
solving the original problem of storing the handle directly in a radix 
node. If we pass a struct zs we will require pointing radix node to this 
struct, wasting sizeof(void *) for every object.   If we pass unsigned 
long, then this problem is solved and it also makes it clear that the 
passed value is not a pointer.

Its true that making it a real struct would prevent accidental casts to 
void * but due to the above problem, I think we have to stick with 
unsigned long.

Thanks,
Nitin

