Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2ENCZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:25:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51230 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2ENCZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:25:55 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-77-4fb06d304ea6
Message-ID: <4FB06D4C.1050209@kernel.org>
Date: Mon, 14 May 2012 11:26:20 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <4FABD503.4030808@vflare.org> <4FABDA9F.1000105@linux.vnet.ibm.com> <20120510151941.GA18302@kroah.com> <4FABECF5.8040602@vflare.org> <20120510164418.GC13964@kroah.com> <4FABF9D4.8080303@vflare.org> <20120510173322.GA30481@phenom.dumpdata.com> <4FAC4E3B.3030909@kernel.org> <8473859b-42f3-4354-b5ba-fd5b8cbac22f@default> <4FAC59F6.4080503@kernel.org> <20120511192915.GD3785@phenom.dumpdata.com> <4FAD8984.2050201@linux.vnet.ibm.com>
In-Reply-To: <4FAD8984.2050201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 06:49 AM, Seth Jennings wrote:

> On 05/11/2012 02:29 PM, Konrad Rzeszutek Wilk wrote:
> 
>>> At least, zram is also primary user and it also has such mess
>>> although it's not severe than zcache. zram->table[index].handle
>>> sometime has real (void*) handle, sometime (struct page*).
>>
>> Yikes. Yeah that needs to be fixed.
>>
> 
> 
> How about this (untested)?  Changes to zram_bvec_write() are a little
> hard to make out in this format.  There are a couple of checkpatch fixes
> (two split line strings) and an unused variable store_offset removal mixed
> in too. If this patch is good, I'll break them up for official submission
> after I test.
> 
> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index fbe8ac9..10dcd99 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -81,7 +81,10 @@ enum zram_pageflags {
>  
>  /* Allocated for each disk page */
>  struct table {
> -	void *handle;
> +	union {
> +		void *handle; /* compressible */
> +		struct page *page; /* incompressible */


You read my mind. That's exactly same idea with my patch which queued up to my tree.
But there is still problem.

zram has like this code

void *handle = zram->table[index].handle;
if (!handle) {

}

zram->table[index].handle = NULL;

It assume handle's size is greater than or equal to sizeof(struct page*)) for union working.
But we can't make sure handle's size.
If Nitin confirm this, too, the problem would be easy to fix.

-- 
Kind regards,
Minchan Kim
