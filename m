Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab2DYSNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:13:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57600 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2DYSN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:13:29 -0400
Message-ID: <4F983EC3.10108@vflare.org>
Date: Wed, 25 Apr 2012 14:13:23 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] zsmalloc: remove unnecessary type casting
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-6-git-send-email-minchan@kernel.org> <4F97FD9D.9090105@vflare.org> <20120425175639.GA14974@kroah.com>
In-Reply-To: <20120425175639.GA14974@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 01:56 PM, Greg Kroah-Hartman wrote:

> On Wed, Apr 25, 2012 at 09:35:25AM -0400, Nitin Gupta wrote:
>> On 04/25/2012 02:23 AM, Minchan Kim wrote:
>>
>>> Let's remove unnecessary type casting of (void *).
>>>
>>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>>> ---
>>>  drivers/staging/zsmalloc/zsmalloc-main.c |    3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>>> index b7d31cc..ff089f8 100644
>>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>>> @@ -644,8 +644,7 @@ void zs_free(struct zs_pool *pool, void *obj)
>>>  	spin_lock(&class->lock);
>>>  
>>>  	/* Insert this object in containing zspage's freelist */
>>> -	link = (struct link_free *)((unsigned char *)kmap_atomic(f_page)
>>> -							+ f_offset);
>>> +	link = (struct link_free *)(kmap_atomic(f_page)	+ f_offset);
>>>  	link->next = first_page->freelist;
>>>  	kunmap_atomic(link);
>>>  	first_page->freelist = obj;
>>
>>
>>
>> Incrementing a void pointer looks weired and should not be allowed by C
>> compilers though gcc and clang seem to allow this without any warnings.
>> (fortunately C++ forbids incrementing void pointers)
> 
> Huh?  A void pointer can safely be incremented by C I thought, do you
> have a pointer to where in the reference it says it is "unspecified"?
> 


Arithmetic on void pointers and function pointers is listed as a GNU C
extension, so I don't think these operations are part of C standard.
>From info gcc (section 6.23):

"""
6.23 Arithmetic on `void'- and Function-Pointers
 In GNU C, addition and subtraction operations are supported on pointers
 to `void' and on pointers to functions.  This is done by treating the
 size of a `void' or of a function as 1.


 A consequence of this is that `sizeof' is also allowed on `void' and on
function types, and returns 1.
 The option `-Wpointer-arith' requests a warning if these extensions are
used.
"""


>> So, we should keep this cast to unsigned char pointer to avoid relying
>> on a non-standard, compiler specific behavior.
> 
> I do agree about this, more people are starting to build the kernel with
> other compilers than gcc, so it would be nice to ensure that we get
> stuff like this right.
> 


As an example, MSVC does not support arithmetic on void pointers:
http://stackoverflow.com/questions/1864352/pointer-arithmetic-when-void-has-unknown-size

Thanks,
Nitin
