Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2KYUJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 15:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab2KYUJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 15:09:39 -0500
Message-ID: <50B27AD1.6010703@redhat.com>
Date: Sun, 25 Nov 2012 15:08:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: =?UTF-8?B?TWV0aW4gRMO2xZ9sw7w=?= <metindoslu@gmail.com>,
        Jaegeuk Hanse <jaegeuk.hanse@gmail.com>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: Problem in Page Cache Replacement
References: <20121120182500.GH1408@quack.suse.cz> <1353485020.53500.YahooMailNeo@web141104.mail.bf1.yahoo.com> <1353485630.17455.YahooMailNeo@web141106.mail.bf1.yahoo.com> <50AC9220.70202@gmail.com> <20121121090204.GA9064@localhost> <50ACA209.9000101@gmail.com> <1353491880.11679.YahooMailNeo@web141102.mail.bf1.yahoo.com> <50ACA634.5000007@gmail.com> <CAJOrxZBpefqtkXr+XTxEZ6qy-6SCwQJ11makD=Lg_M4itY5Ang@mail.gmail.com> <20121122154107.GB11736@localhost> <20121122155318.GA12636@localhost>
In-Reply-To: <20121122155318.GA12636@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 10:53 AM, Fengguang Wu wrote:

> Ah it's more likely caused by this logic:
>
>          if (is_active_lru(lru)) {
>                  if (inactive_list_is_low(mz, file))
>                          shrink_active_list(nr_to_scan, mz, sc, priority, file);
>
> The active file list won't be scanned at all if it's smaller than the
> active list. In this case, it's inactive=33586MB > active=25719MB. So
> the data-1 pages in the active list will never be scanned and reclaimed.

That's it, indeed.

The reason we have that code is that otherwise one large streaming
IO could easily end up evicting the entire page cache working set.

Usually it works well, because the new page cache working set tends
to get touched twice while on the inactive list, and the old working
set gets demoted from the active list.

Only in a few very specific cases, where the inter-reference distance
of the new working set is larger than the size of the inactive list,
does it fail.

Something like Johannes's patches should solve the problem.

-- 
All rights reversed
