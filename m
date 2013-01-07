Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3AGHt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:49:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43162 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3AGHt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:49:56 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50EA7E07.4070902@jp.fujitsu.com>
Date: Mon, 07 Jan 2013 16:49:27 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Sha Zhengju <handai.szj@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        gthelen@google.com, fengguang.wu@intel.com, glommer@parallels.com,
        dchinner@redhat.com, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456367-14660-1-git-send-email-handai.szj@taobao.com> <20130102104421.GC22160@dhcp22.suse.cz> <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com> <alpine.LNX.2.00.1301061135400.29149@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1301061135400.29149@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/07 5:02), Hugh Dickins wrote:
> On Sat, 5 Jan 2013, Sha Zhengju wrote:
>> On Wed, Jan 2, 2013 at 6:44 PM, Michal Hocko <mhocko@suse.cz> wrote:
>>>
>>> Maybe I have missed some other locking which would prevent this from
>>> happening but the locking relations are really complicated in this area
>>> so if mem_cgroup_{begin,end}_update_page_stat might be called
>>> recursively then we need a fat comment which justifies that.
>>>
>>
>> Ohhh...good catching!  I didn't notice there is a recursive call of
>> mem_cgroup_{begin,end}_update_page_stat in page_remove_rmap().
>> The mem_cgroup_{begin,end}_update_page_stat() design has depressed
>> me a lot recently as the lock granularity is a little bigger than I thought.
>> Not only the resource but also some code logic is in the range of locking
>> which may be deadlock prone. The problem still exists if we are trying to
>> add stat account of other memcg page later, may I make bold to suggest
>> that we dig into the lock again...
>
> Forgive me, I must confess I'm no more than skimming this thread,
> and don't like dumping unsigned-off patches on people; but thought
> that on balance it might be more helpful than not if I offer you a
> patch I worked on around 3.6-rc2 (but have updated to 3.8-rc2 below).
>
> I too was getting depressed by the constraints imposed by
> mem_cgroup_{begin,end}_update_page_stat (good job though Kamezawa-san
> did to minimize them), and wanted to replace by something freer, more
> RCU-like.  In the end it seemed more effort than it was worth to go
> as far as I wanted, but I do think that this is some improvement over
> what we currently have, and should deal with your recursion issue.
>
In what case does this improve performance ?

> But if this does appear useful to memcg people, then we really ought
> to get it checked over by locking/barrier experts before going further.
> I think myself that I've over-barriered it, and could use a little
> lighter; but they (Paul McKenney, Peter Zijlstra, Oleg Nesterov come
> to mind) will see more clearly, and may just hate the whole thing,
> as yet another peculiar lockdep-avoiding hand-crafted locking scheme.
> I've not wanted to waste their time on reviewing it, if it's not even
> going to be useful to memcg people.
>
> It may be easier to understand if you just apply the patch and look
> at the result in mm/memcontrol.c, where I tried to gather the pieces
> together in one place and describe them ("These functions mediate...").
>
> Hugh
>

Hi, this patch seems interesting but...doesn't this make move_account() very
slow if the number of cpus increases because of scanning all cpus per a page ?
And this looks like reader-can-block-writer percpu rwlock..it's too heavy to
writers if there are many readers.


Thanks,
-Kame


  







