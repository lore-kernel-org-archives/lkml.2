Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab2EDEI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 00:08:56 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40241 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750738Ab2EDEIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 00:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120503170101.GF2592@linux.vnet.ibm.com>
References: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com>
 <20120503154140.GA2592@linux.vnet.ibm.com> <CA+1xoqepggR4YRzDXFz=Hk9EeXACMRyeXorQm7rE3r5MQyY6Fw@mail.gmail.com>
 <20120503170101.GF2592@linux.vnet.ibm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 4 May 2012 06:08:34 +0200
Message-ID: <CA+1xoqcXMVG0J4r8XhtzcxxDqLuyR30x5a3o8BsrBqDakDdHgg@mail.gmail.com>
Subject: Re: rcu: BUG on exit_group
To: paulmck@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, yinghan@google.com,
        kosaki.motohiro@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 7:01 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, May 03, 2012 at 05:55:14PM +0200, Sasha Levin wrote:
>> On Thu, May 3, 2012 at 5:41 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Thu, May 03, 2012 at 10:57:19AM +0200, Sasha Levin wrote:
>> >> Hi Paul,
>> >>
>> >> I've hit a BUG similar to the schedule_tail() one when. It happened
>> >> when I've started fuzzing exit_group() syscalls, and all of the traces
>> >> are starting with exit_group() (there's a flood of them).
>> >>
>> >> I've verified that it indeed BUGs due to the rcu preempt count.
>> >
>> > Hello, Sasha,
>> >
>> > Which version of -next are you using?  I did some surgery on this
>> > yesterday based on some bugs Hugh Dickins tracked down, so if you
>> > are using something older, please move to the current -next.
>>
>> I'm using -next from today (3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty).
>
> Hmmm...  Looking at this more closely, it looks like there really is
> an attempt to acquire a mutex within an RCU read-side critical section,
> which is illegal.  Could you please bisect this?

Right, the issue is as you described, taking a mutex inside rcu_read_lock().

The offending commit is (I've cc'ed all parties from it):

commit adf79cc03092ee4aec70da10e91b05fb8116ac7b
Author: Ying Han <yinghan@google.com>
Date:   Thu May 3 15:44:01 2012 +1000

    memcg: add mlock statistic in memory.stat

With the issue there being is that in munlock_vma_page(), it now does
a mem_cgroup_begin_update_page_stat() which takes the rcu_read_lock(),
so when the older code that was there previously will try taking a
mutex you'll get a BUG.

Thanks.
