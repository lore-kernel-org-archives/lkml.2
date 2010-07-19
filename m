Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0GSGsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 02:48:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60646 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab0GSGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 02:48:07 -0400
Message-ID: <4C43F541.7070902@vflare.org>
Date: Mon, 19 Jul 2010 12:18:33 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] Use xvmalloc to store compressed chunks
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>	<1279283870-18549-8-git-send-email-ngupta@vflare.org>	<4C42B2E4.4040504@cs.helsinki.fi>	<4C42B98E.4020208@vflare.org> <AANLkTinjJLaDVenwNcxgN7ycr97XLN_DVi1ckXBZetZm@mail.gmail.com>
In-Reply-To: <AANLkTinjJLaDVenwNcxgN7ycr97XLN_DVi1ckXBZetZm@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 10:06 AM, Minchan Kim wrote:
> Hi Nitin,
> 
> On Sun, Jul 18, 2010 at 5:21 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> On 07/18/2010 01:23 PM, Pekka Enberg wrote:
>>> Nitin Gupta wrote:
>>>> @@ -528,17 +581,32 @@ static int zcache_store_page(struct zcache_inode_rb *znode,
>>>>          goto out;
>>>>      }
>>>>
>>>> -    dest_data = kmap_atomic(zpage, KM_USER0);
>>>> +    local_irq_save(flags);
>>>
>>> Does xv_malloc() required interrupts to be disabled? If so, why doesn't the function do it by itself?
>>>
>>
>>
>> xvmalloc itself doesn't require disabling interrupts but zcache needs that since
>> otherwise, we can have deadlock between xvmalloc pool lock and mapping->tree_lock
>> which zcache_put_page() is called. OTOH, zram does not require this disabling of
>> interrupts. So, interrupts are disable separately for zcache case.
> 
> cleancache_put_page always is called with spin_lock_irq.
> Couldn't we replace spin_lock_irq_save with spin_lock?
> 

I was missing this point regarding cleancache_put(). So, we can now:
 - take plain (non-irq) spin_lock in zcache_put_page()
 - take non-irq rwlock  in zcache_inode_create() which is called only by
zcache_put_page().
 - Same applies to zcache_store_page(). So, we can also get rid of unnecessary
preempt_disable()/enable() in this function.

I will put up a comment for all these functions and make these changes.

Thanks,
Nitin


