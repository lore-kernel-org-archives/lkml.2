Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2AZJoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:44:24 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:61165 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2AZJoW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 26 Jan 2012 04:44:22 -0500
Message-Id: <4F212ECC020000780006F26B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 26 Jan 2012 09:45:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dave Airlie" <airlied@linux.ie>
Cc: "Michal Kubecek" <mkubecek@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] agp: fix scratch page cleanup
References: <20120125161350.82538402A7@alaris.suse.cz>
 <alpine.DEB.2.00.1201251900330.12477@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1201251900330.12477@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.01.12 at 20:01, Dave Airlie <airlied@linux.ie> wrote:

>> In error cleanup of agp_backend_initialize() and in agp_backend_cleanup(),
>> agp_destroy_page() is passed virtual address of the scratch page. This
>> leads to a kernel warning if the initialization fails (or upon regular
>> cleanup) as pointer to struct page should be passed instead.
> 
> Jan can you check and ack this if okay? since you wrote this chunk 
> originally?

The change here is fine, but rather fixes an omission of your own
"agp: switch AGP to use page array instead of unsigned long array"
(which went in for 2.6.31, whereas my change went into 2.6.26),
which also wasn't noticed when David Woodhouse touched the
code again for 2.6.32 ("agp: Switch agp_{un,}map_page() to take
struct page * argument").

Jan

>> 
>> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>> ---
>>  drivers/char/agp/backend.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
>> index 4b71647..317c28c 100644
>> --- a/drivers/char/agp/backend.c
>> +++ b/drivers/char/agp/backend.c
>> @@ -194,10 +194,10 @@ static int agp_backend_initialize(struct 
> agp_bridge_data *bridge)
>>  
>>  err_out:
>>  	if (bridge->driver->needs_scratch_page) {
>> -		void *va = page_address(bridge->scratch_page_page);
>> +		struct page *page = bridge->scratch_page_page;
>>  
>> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
>> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
>> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_UNMAP);
>> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_FREE);
>>  	}
>>  	if (got_gatt)
>>  		bridge->driver->free_gatt_table(bridge);
>> @@ -221,10 +221,10 @@ static void agp_backend_cleanup(struct agp_bridge_data 
> *bridge)
>>  
>>  	if (bridge->driver->agp_destroy_page &&
>>  	    bridge->driver->needs_scratch_page) {
>> -		void *va = page_address(bridge->scratch_page_page);
>> +		struct page *page = bridge->scratch_page_page;
>>  
>> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
>> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
>> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_UNMAP);
>> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_FREE);
>>  	}
>>  }
>>  
>> 



