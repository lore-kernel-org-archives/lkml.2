Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0IMP2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:28:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62844 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0IMP2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qzjql2aaaKeg4lRuYgic+GFRaJEG78s0W6qlgCakcMX0DVyTTvGv5I5YRYgOd+CDxX
         Rhk/nu0jX6FPJPWNpxkObW3A9B6hTFH+3NjAjV0AD/dX0YT0QRCPvi5I1c+qugPOa2bz
         0P+2zypm7fZKXC7JNU3AJeU/PKWH086/KNv5Y=
MIME-Version: 1.0
In-Reply-To: <20100913084741.GD17950@balbir.in.ibm.com>
References: <20100913160822.0c2cd732.kamezawa.hiroyu@jp.fujitsu.com>
	<20100913084741.GD17950@balbir.in.ibm.com>
Date: Tue, 14 Sep 2010 00:28:30 +0900
Message-ID: <AANLkTimsUQuEeS2QvSwY_WhnQY7n=D73fNmOoqgrTqbZ@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] memcg: fix race in file_mapped accouting flag management
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/13 Balbir Singh <balbir@linux.vnet.ibm.com>:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-09-13 16:08:22]:
>
>>
>> I think this small race is not very critical but it's bug.
>> We have this race since 2.6.34.
>> =
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Now. memory cgroup accounts file-mapped by counter and flag.
>> counter is working in the same way with zone_stat but FileMapped flag only
>> exists in memcg (for helping move_account).
>>
>> This flag can be updated wrongly in a case. Assume CPU0 and CPU1
>> and a thread mapping a page on CPU0, another thread unmapping it on CPU1.
>>
>>     CPU0                              CPU1
>>                               rmv rmap (mapcount 1->0)
>>    add rmap (mapcount 0->1)
>>    lock_page_cgroup()
>>    memcg counter+1            (some delay)
>>    set MAPPED FLAG.
>>    unlock_page_cgroup()
>>                               lock_page_cgroup()
>>                               memcg counter-1
>>                               clear MAPPED flag
>>
>> In above sequence, counter is properly updated but FLAG is not.
>> This means that representing a state by a flag which is maintained by
>> counter needs some specail care.
>
> In the situation above who has the PTE lock? Are we not synchronized
> via the PTE lock such that add rmap and rm rmap, will not happen
> simultaneously?
>
In this case, a process for map and one for unmap can be different.

Assume process A maps a file cache and process B not.
While process A unmap a file, process B can map it.
pte lock is no help.

Thanks,
-Kame

Thanks,
-Kame
