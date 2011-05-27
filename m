Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1E0Eee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:34:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1E0Eed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cf0EsDjBlTYImMvvoX88vuULe151WxTg9TsPolfDOLoQ+pWbtWxoMwMYPzLakYV2Ew
         am42L4CtSnDTVQdLd6ZA==
MIME-Version: 1.0
In-Reply-To: <20110527120539.91778598.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTikcdOGkJWxS0Sey8C1ereVk8ucvQQ@mail.gmail.com>
	<20110527114837.8fae7f00.kamezawa.hiroyu@jp.fujitsu.com>
	<20110527120539.91778598.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 May 2011 21:34:31 -0700
Message-ID: <BANLkTiniJjpoo+cnO2xtSm9VqzA--z9F7Q@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 0/10] memcg async reclaim
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 8:05 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 27 May 2011 11:48:37 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Thu, 26 May 2011 18:49:26 -0700
>> Ying Han <yinghan@google.com> wrote:
>
>> > Hmm.. I noticed a very strange behavior on a simple test w/ the patch set.
>> >
>> > Test:
>> > I created a 4g memcg and start doing cat. Then the memcg being OOM
>> > killed as soon as it reaches its hard_limit. We shouldn't hit OOM even
>> > w/o async-reclaim.
>> >
>> > Again, I will read through the patch. But like to post the test result first.
>> >
>> > $ echo $$ >/dev/cgroup/memory/A/tasks
>> > $ cat /dev/cgroup/memory/A/memory.limit_in_bytes
>> > 4294967296
>> >
>> > $ time cat /export/hdc3/dd_A/tf0 > /dev/zero
>> > Killed
>> >
>> > real        0m53.565s
>> > user        0m0.061s
>> > sys 0m4.814s
>> >
>>
>> Hmm, what I see is
>> ==
>> root@bluextal kamezawa]# ls -l test/1G
>> -rw-rw-r--. 1 kamezawa kamezawa 1053261824 May 13 13:58 test/1G
>> [root@bluextal kamezawa]# mkdir /cgroup/memory/A
>> [root@bluextal kamezawa]# echo 0 > /cgroup/memory/A/tasks
>> [root@bluextal kamezawa]# echo 300M > /cgroup/memory/A/memory.limit_in_bytes
>> [root@bluextal kamezawa]# echo 1 > /cgroup/memory/A/memory.async_control
>> [root@bluextal kamezawa]# cat test/1G > /dev/null
>> [root@bluextal kamezawa]# cat /cgroup/memory/A/memory.reclaim_stat
>> recent_scan_success_ratio 83
>> limit_scan_pages 82
>> limit_freed_pages 49
>> limit_elapsed_ns 242507
>> soft_scan_pages 0
>> soft_freed_pages 0
>> soft_elapsed_ns 0
>> margin_scan_pages 218630
>> margin_freed_pages 181598
>> margin_elapsed_ns 117466604
>> [root@bluextal kamezawa]#
>> ==
>>
>> I'll turn off swapaccount and try again.
>>
>
> A bug found....I added memory.async_control file to memsw.....file set by mistake.
> Then, async_control cannot be enabled when swapaccount=0. I'll fix that.

Yes, i have that changed in my previous testing
>
> So, how do you enabled async_control ?

$ echo 1 >/dev/cgroup/memory/D/memory.async_control

?

--Ying
>
> Thanks,
> -Kame
>
>
>
>
