Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab2EJOrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:47:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50244 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2EJOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:47:34 -0400
Message-ID: <4FABD503.4030808@vflare.org>
Date: Thu, 10 May 2012 10:47:31 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-3-git-send-email-minchan@kernel.org> <4FA28907.9020300@vflare.org> <4FA2A2F0.3030509@linux.vnet.ibm.com> <4FA33DF6.8060107@kernel.org> <20120509201918.GA7288@kroah.com> <4FAB21E7.7020703@kernel.org> <20120510140215.GC26152@phenom.dumpdata.com>
In-Reply-To: <20120510140215.GC26152@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/12 10:02 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, May 10, 2012 at 11:03:19AM +0900, Minchan Kim wrote:
>> On 05/10/2012 05:19 AM, Greg Kroah-Hartman wrote:
>>
>>> On Fri, May 04, 2012 at 11:24:54AM +0900, Minchan Kim wrote:
>>>> On 05/04/2012 12:23 AM, Seth Jennings wrote:
>>>>
>>>>> On 05/03/2012 08:32 AM, Nitin Gupta wrote:
>>>>>
>>>>>> On 5/3/12 2:40 AM, Minchan Kim wrote:
>>>>>>> We should use zs_handle instead of void * to avoid any
>>>>>>> confusion. Without this, users may just treat zs_malloc return value as
>>>>>>> a pointer and try to deference it.
>>>>>>>
>>>>>>> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
>>>>>>> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
>>>>>>> Signed-off-by: Minchan Kim<minchan@kernel.org>
>>>>>>> ---
>>>>>>>    drivers/staging/zcache/zcache-main.c     |    8 ++++----
>>>>>>>    drivers/staging/zram/zram_drv.c          |    8 ++++----
>>>>>>>    drivers/staging/zram/zram_drv.h          |    2 +-
>>>>>>>    drivers/staging/zsmalloc/zsmalloc-main.c |   28
>>>>>>> ++++++++++++++--------------
>>>>>>>    drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
>>>>>>>    5 files changed, 34 insertions(+), 27 deletions(-)
>>>>>>
>>>>>> This was a long pending change. Thanks!
>>>>>
>>>>>
>>>>> The reason I hadn't done it before is that it introduces a checkpatch
>>>>> warning:
>>>>>
>>>>> WARNING: do not add new typedefs
>>>>> #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
>>>>> +typedef void * zs_handle;
>>>>>
>>>>
>>>>
>>>> Yes. I did it but I think we are (a) of chapter 5: Typedefs in Documentation/CodingStyle.
>>>>
>>>>   (a) totally opaque objects (where the typedef is actively used to _hide_
>>>>       what the object is).
>>>>
>>>> No?
>>>
>>> No.
>>>
>>> Don't add new typedefs to the kernel.  Just use a structure if you need
>>> to.
>>
>>
>> I tried it but failed because there were already tightly coupling between [zcache|zram]
>> and zsmalloc.
>> They already knows handle's internal well so they used it as pointer, even zcache keeps
>> handle's value as some key in tmem_put and tmem_get
>> AFAIK, ramster also will use zsmalloc sooner or later and add more coupling codes. Sigh.
>> Please fix it as soon as possible.
>>
>> Dan, Seth
>> Any ideas?
>
> struct zs {
> 	void *ptr;
> };
>
> And pass that structure around?
>

A minor problem is that we store this handle value in a radix tree node. 
If we wrap it as a struct, then we will not be able to store it directly 
in the node -- the node will have to point to a 'struct zs'. This will 
unnecessarily waste sizeof(void *) for every object stored.

We could 'memcpy' struct zs to a void * and then store that directly in 
the radix node but not sure if that would be less ugly than just 
returning the handle as a void * as is done currently.

Thanks,
Nitin
