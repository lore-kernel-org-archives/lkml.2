Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2GJPT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:19:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50256 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2GJPT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:19:28 -0400
Message-ID: <4FFC478C.4050505@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 10:17:32 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] zsmalloc: add details to zs_map_object boiler plate
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FFB94FF.8030401@kernel.org>
In-Reply-To: <4FFB94FF.8030401@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071015-9360-0000-0000-000008436BC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 09:35 PM, Minchan Kim wrote:
> On 07/03/2012 06:15 AM, Seth Jennings wrote:
>> Add information on the usage limits of zs_map_object()
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/zsmalloc/zsmalloc-main.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 4942d41..abf7c13 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -747,7 +747,12 @@ EXPORT_SYMBOL_GPL(zs_free);
>>   *
>>   * Before using an object allocated from zs_malloc, it must be mapped using
>>   * this function. When done with the object, it must be unmapped using
>> - * zs_unmap_object
>> + * zs_unmap_object.
>> + *
>> + * Only one object can be mapped per cpu at a time. There is no protection
>> + * against nested mappings.
>> + *
>> + * This function returns with preemption and page faults disabled.
>>  */
>>  void *zs_map_object(struct zs_pool *pool, unsigned long handle)
>>  {
>>
> 
> The comment is good but I hope we can detect it automatically with DEBUG
> option. It wouldn't be hard but it's a debug patch so not critical
> until we receive some report about the bug.

Yes, we could implement some detection scheme later.

> 
> The possibility for nesting is that it is used by irq context.
> 
> A uses the mapping
> .
> .
> .
> IRQ happen
> 	B uses the mapping in IRQ context
> 	.
> 	.
> 	.
> 
> Maybe we need local_irq_save/restore in zs_[un]map_object path.

I'd rather not disable interrupts since that will create
unnecessary interrupt latency for all users, even if they
don't need interrupt protection.  If a particular user uses
zs_map_object() in an interrupt path, it will be up to that
user to disable interrupts to ensure safety.

Thanks,
Seth


