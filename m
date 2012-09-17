Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2IQJ32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:29:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63936 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2IQJ3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:29:24 -0400
Subject: Re: [PATCH] Xen backend support for paged out grant targets V4.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
In-Reply-To: <1347869865.14977.15.camel@zakaz.uk.xensource.com>
Date: Mon, 17 Sep 2012 05:29:24 -0400
Cc: Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "David Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5B5132A4-93B2-41D0-B1A6-048810565DB5@gridcentric.ca>
References: <1347632819-13684-1-git-send-email-andres@lagarcavilla.org> <1347869865.14977.15.camel@zakaz.uk.xensource.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 17, 2012, at 4:17 AM, Ian Campbell wrote:

> (I think I forgot to hit send on this on Friday, sorry. Also
> s/xen.lists.org/lists.xen.org in the CC line…)
I'm on a roll here…

> 
> On Fri, 2012-09-14 at 15:26 +0100, Andres Lagar-Cavilla wrote:
>> Since Xen-4.2, hvm domains may have portions of their memory paged out. When a
>> foreign domain (such as dom0) attempts to map these frames, the map will
>> initially fail. The hypervisor returns a suitable errno, and kicks an
>> asynchronous page-in operation carried out by a helper. The foreign domain is
>> expected to retry the mapping operation until it eventually succeeds. The
>> foreign domain is not put to sleep because itself could be the one running the
>> pager assist (typical scenario for dom0).
>> 
>> This patch adds support for this mechanism for backend drivers using grant
>> mapping and copying operations. Specifically, this covers the blkback and
>> gntdev drivers (which map foregin grants), and the netback driver (which copies
> 
>                           foreign
> 
>> foreign grants).
>> 
>> * Add a retry method for grants that fail with GNTST_eagain (i.e. because the
>>  target foregin frame is paged out).
> 
>          foreign
> 
>> * Insert hooks with appropriate wrappers in the aforementioned drivers.
>> 
>> The retry loop is only invoked if the grant operation status is GNTST_eagain.
>> It guarantees to leave a new status code different from GNTST_eagain. Any other
>> status code results in identical code execution as before.
>> 
>> The retry loop performs 256 attempts with increasing time intervals through a
>> 32 second period. It uses msleep to yield while waiting for the next retry.
> [...]
>> Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Since this is more about grant tables than netback this should probably
> go via Konrad rather than Dave, is that OK with you Dave?

If that is the case hopefully Konrad can deal with the two typos? Otherwise happy to re-spin the patch.
Thanks!
Andres

> 
> (there's one more typo below)
> 
>> ---
>> drivers/net/xen-netback/netback.c  |   11 ++------
>> drivers/xen/grant-table.c          |   53 ++++++++++++++++++++++++++++++++++++
>> drivers/xen/xenbus/xenbus_client.c |    6 ++--
>> include/xen/grant_table.h          |   12 ++++++++
>> 4 files changed, 70 insertions(+), 12 deletions(-)
> [...]
>> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
>> index 11e27c3..da9386e 100644
>> --- a/include/xen/grant_table.h
>> +++ b/include/xen/grant_table.h
>> @@ -189,4 +189,16 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>> int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>> 		      struct page **pages, unsigned int count, bool clear_pte);
>> 
>> +/* Perform a batch of grant map/copy operations. Retry every batch slot
>> + * for which the hypervisor returns GNTST_eagain. This is typically due 
>> + * to paged out target frames.
>> + *
>> + * Will retry for 1, 2, ... 255 ms, i.e. 256 times during 32 seconds.
>> + *
>> + * Return value in each iand every status field of the batch guaranteed
> 
>                          and
> 
>> + * to not be GNTST_eagain. 
>> + */
>> +void gnttab_batch_map(struct gnttab_map_grant_ref *batch, unsigned count);
>> +void gnttab_batch_copy(struct gnttab_copy *batch, unsigned count);
>> +
>> #endif /* __ASM_GNTTAB_H__ */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

