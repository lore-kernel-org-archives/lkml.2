Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1EJXmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:42:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab1EJXmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:42:54 -0400
Message-ID: <4DC9CD60.6010200@zytor.com>
Date: Tue, 10 May 2011 16:42:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hpa@linux.intel.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Linux 2.6.39-rc7
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com> <20110510035356.GA6954@dumpdata.com> <20110510233644.GA23858@dumpdata.com>
In-Reply-To: <20110510233644.GA23858@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 04:36 PM, Konrad Rzeszutek Wilk wrote:
>>
>> I was hoping that the rc6 could stretch out so that by the time hpa came back from
>> his travels he would have had a chance to look at: https://lkml.org/lkml/2011/5/5/226
>
> I had a chance to briefly talk on IRC with hpa and he mentioned I should
> send a note to Ingo about this since hpa won't be able to do anything until Friday.
>
> Ingo,
> Not sure how familiar you are with this issue, but let me briefly explain it.
> Yinghai provided a patch, which calls memblock_find_in_range(), then calls
> kernel_physical_mapping_init, which populates the pagetable between pgt_buf_start
> and pgt_buf_top and once it is done, calls memblock_x86_reserve_range with pgt_buf_start
> and pgt_buf_end (wherein pgt_buf_end<=  pgt_buf_top). The memory between pgt_buf_end
> and pgt_buf_top can be re-used later on and it is by other subsystems - NUMA for
> example uses it.
>
> Under Xen, the pagetables end up being marked RO, so what ends up happening is that
> some pages from pgt_buf_end through pgt_buf_top end up RO and the system crashes during
> bootup as NUMA subsystem tries to write to that area. The fix is to essentially mark the
> area from pgt_buf_end through pgt_buf_top to RW.
>
> Stefano posted a patch, which was Acked by Yinghai, but not so by hpa. The concerns
> were that the patch inserts a hook just for this single case and there should be a better
> way of doing this - where we either don't need a hook or provide an semantic explanation
> of the pagetable building and build the patch from there.
>
> Sadly there was/is not enough time in the 2.6.39 train to actually do it properly.
> So I provided another patch (which Linus merged) which crudely tries to mark the area from
> pgt_buf_end through pgt_buf_top to RW and all is done within the Xen MMU code. Sadly it
> does not work on all machines.
>
> Without a resolution to this, the Linux x86_64 kernel cannot boot under Xen. There are two
> options left right now:
>   a). Revert 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table high)
>   b). or revert the workaround that Linus merged and pick the one that Stefano came up with.
>       The patches are available in
>       git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc6
>
>       They touch the generic x86 MMU code.
>

At this point this does indeed seem to be the only reasonable solution. 
  I'm not happy about either the fix nor the fact that Xen is so fragile 
yet wants to piggy back on generic x86 code, but for .39 there really 
isn't much opportunity to fix it any other way.  Konrad has promised me 
to personally drive the work to get a better fix in.

Unfortunately as mentioned I am travelling at the moment and have 
limited ability to fix this; if I get a chance I'll look at it and pull 
it into tip, but under the circumstances I can't promise anything.

	-hpa
