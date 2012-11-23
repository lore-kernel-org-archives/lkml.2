Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2KWCKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 21:10:34 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53084 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2KWCKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 21:10:33 -0500
Message-ID: <50AEDB12.6090300@gmail.com>
Date: Fri, 23 Nov 2012 10:10:26 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: =?UTF-8?B?TWV0aW4gRMO2xZ9sw7w=?= <metindoslu@gmail.com>,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Problem in Page Cache Replacement
References: <20121120182500.GH1408@quack.suse.cz> <1353485020.53500.YahooMailNeo@web141104.mail.bf1.yahoo.com> <1353485630.17455.YahooMailNeo@web141106.mail.bf1.yahoo.com> <50AC9220.70202@gmail.com> <20121121090204.GA9064@localhost> <50ACA209.9000101@gmail.com> <1353491880.11679.YahooMailNeo@web141102.mail.bf1.yahoo.com> <50ACA634.5000007@gmail.com> <CAJOrxZBpefqtkXr+XTxEZ6qy-6SCwQJ11makD=Lg_M4itY5Ang@mail.gmail.com> <20121122154107.GB11736@localhost> <20121122155318.GA12636@localhost>
In-Reply-To: <20121122155318.GA12636@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 11:53 PM, Fengguang Wu wrote:
> On Thu, Nov 22, 2012 at 11:41:07PM +0800, Fengguang Wu wrote:
>> On Wed, Nov 21, 2012 at 12:07:22PM +0200, Metin Döşlü wrote:
>>> On Wed, Nov 21, 2012 at 12:00 PM, Jaegeuk Hanse <jaegeuk.hanse@gmail.com> wrote:
>>>> On 11/21/2012 05:58 PM, metin d wrote:
>>>>
>>>> Hi Fengguang,
>>>>
>>>> I run tests and attached the results. The line below I guess shows the data-1 page caches.
>>>>
>>>> 0x000000080000006c       6584051    25718  __RU_lA___________________P________    referenced,uptodate,lru,active,private
>>>>
>>>>
>>>> I thinks this is just one state of page cache pages.
>>> But why these page caches are in this state as opposed to other page
>>> caches. From the results I conclude that:
>>>
>>> data-1 pages are in state : referenced,uptodate,lru,active,private
>> I wonder if it's this code that stops data-1 pages from being
>> reclaimed:
>>
>> shrink_page_list():
>>
>>                  if (page_has_private(page)) {
>>                          if (!try_to_release_page(page, sc->gfp_mask))
>>                                  goto activate_locked;
>>
>> What's the filesystem used?
> Ah it's more likely caused by this logic:
>
>          if (is_active_lru(lru)) {
>                  if (inactive_list_is_low(mz, file))
>                          shrink_active_list(nr_to_scan, mz, sc, priority, file);
>
> The active file list won't be scanned at all if it's smaller than the
> active list. In this case, it's inactive=33586MB > active=25719MB. So
> the data-1 pages in the active list will never be scanned and reclaimed.

Hi Fengguang,

It seems that most of data-1 file pages are in active lru cache and most 
of data-2 file pages are in inactive lru cache. As Johannes mentioned, 
if inter-reference distance is bigger than half of memory, the pages 
will not be actived. How you intend to resolve this issue? Is Johannes's 
inactive list threshing idea  available?

Regards,
Jaegeuk

>
>>> data-2 pages are in state : referenced,uptodate,lru,mappedtodisk
>> Thanks,
>> Fengguang

