Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1FBPym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:54:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42739 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1FBPyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FcabKNSZgV/WuIgeYbuD34xhhMlmYdrJDoEh7ZbWd8bSjDPKodXDWm+c4kgFfIHnwE
         rtaDnK7yMCYHVmZ5EcLIwBMzrptq7+ULSZkpPJA6NkDrugoFV15FOeTDo5ivJHgqwUhl
         2jluXudWzRD7guBKUNpVHRtIPbuivpbLJrnIQ=
MIME-Version: 1.0
In-Reply-To: <20110602142408.GB28684@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-9-git-send-email-hannes@cmpxchg.org>
	<BANLkTinHs7OCkpRf8=dYO0ObH5sndZ4__g@mail.gmail.com>
	<20110602142408.GB28684@cmpxchg.org>
Date: Fri, 3 Jun 2011 00:54:39 +0900
Message-ID: <BANLkTikjjH3vCiwpKrs=+vbaaACC67H7Og@mail.gmail.com>
Subject: Re: [patch 8/8] mm: make per-memcg lru lists exclusive
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/2 Johannes Weiner <hannes@cmpxchg.org>:
> On Thu, Jun 02, 2011 at 10:16:59PM +0900, Hiroyuki Kamezawa wrote:
>> 2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
>> > All lru list walkers have been converted to operate on per-memcg
>> > lists, the global per-zone lists are no longer required.
>> >
>> > This patch makes the per-memcg lists exclusive and removes the global
>> > lists from memcg-enabled kernels.
>> >
>> > The per-memcg lists now string up page descriptors directly, which
>> > unifies/simplifies the list isolation code of page reclaim as well as
>> > it saves a full double-linked list head for each page in the system.
>> >
>> > At the core of this change is the introduction of the lruvec
>> > structure, an array of all lru list heads.  It exists for each zone
>> > globally, and for each zone per memcg.  All lru list operations are
>> > now done in generic code against lruvecs, with the memcg lru list
>> > primitives only doing accounting and returning the proper lruvec for
>> > the currently scanned memcg on isolation, or for the respective page
>> > on putback.
>> >
>> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>>
>> could you divide this into
>>   - introduce lruvec
>>   - don't record section? information into pc->flags because we see
>> "page" on memcg LRU
>>     and there is no requirement to get page from "pc".
>>   - remove pc->lru completely
>
> Yes, that makes sense.  It shall be fixed in the next version.
>

BTW, IIUC, Transparent hugepage has a code to link a page to the
page->lru directly.
And recent Minchan's work does the same kind of trick.

But it may put a page onto wrong memcgs if we do link a page to
another page's page->lru
because 2 pages may be in different cgroup each other.

Could you check there are more codes which does link page->lru to nearby page's
page->lru ? Now, I'm not sure there are other codes....but we need care.

Thanks,
-Kame
