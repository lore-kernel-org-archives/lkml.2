Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab1ETEUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:20:17 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41822 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1ETEUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DR9h81/Nr5alepy8U4pihvwtlnKNRHcFXCkAIEPe7WZMt9Gli/Z7iX5Uxgd18W0uBT
         GSpSWXiX04PFFtm1RlfD+kLGO8pnJLf5BffbdnEhJWbThdP2QnL5FIOB2MnFVX8oCd7m
         My3sR+1dlM2StqxAsP6qW+PEHqKuZgl3YxlLI=
MIME-Version: 1.0
In-Reply-To: <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
	<20110512054631.GI6008@one.firstfloor.org>
	<BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
	<BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
	<20110517060001.GC24069@localhost>
	<BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
	<BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com>
	<BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
	<BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com>
	<BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
	<BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
	<4DD5DC06.6010204@jp.fujitsu.com>
	<BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
Date: Fri, 20 May 2011 13:20:15 +0900
Message-ID: <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com,
        andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, hannes@cmpxchg.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:38 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, May 19, 2011 at 11:12 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>> Right after that happened, I hit ctrl-c to kill test_mempressure.sh.
>>> The system was OK until I typed sync, and then everything hung.
>>>
>>> I'm really confused.  shrink_inactive_list in
>>> RECLAIM_MODE_LUMPYRECLAIM will call one of the isolate_pages functions
>>> with ISOLATE_BOTH.  The resulting list goes into shrink_page_list,
>>> which does VM_BUG_ON(PageActive(page)).
>>>
>>> How is that supposed to work?
>>
>> Usually clear_active_flags() clear PG_active before calling
>> shrink_page_list().
>>
>> shrink_inactive_list()
>>    isolate_pages_global()
>>    update_isolated_counts()
>>        clear_active_flags()
>>    shrink_page_list()
>>
>>
>
> That makes sense.  And I have CONFIG_COMPACTION=y, so the lumpy mode
> doesn't get set anyway.

Could you see the problem with disabling CONFIG_COMPACTION?

>
> But the pages I'm seeing have flags=100000000008005D.  If I'm reading
> it right, that means locked,referenced,uptodate,dirty,active.  How
> does a page like that end up in shrink_page_list?  I don't see how a
> page that's !PageLRU can get marked Active.  Nonetheless, I'm hitting
> that VM_BUG_ON.

Thanks for proving that it's not a problem of latest my patch.

>
> Is there a race somewhere?

First of all, let's finish your first problem about hang. :)
And let's make another thread to fix this problem.

I think this is a severe problem because 2.6.39 includes my deactivate_pages
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=315601809d124d046abd6c3ffa346d0dbd7aa29d)

It touches page states more and more. (2.6.38.6 doesn't include it so
it's not a problem of my deactivate_pages problem)
And now inorder-putback series which I will push for 2.6.40 touches it
more and more.

So I want to resolve your problem asap.
We don't have see report about that. Could you do git-bisect?
FYI, Recently, big change of mm is compaction,transparent huge pages.
Kame, could you point out thing related to memcg if you have a mind?

>
> --Andy
>



-- 
Kind regards,
Minchan Kim
