Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab0FITL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:11:57 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:39517 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab0FITL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:11:56 -0400
Message-ID: <4C0FE779.8010603@msgid.tls.msk.ru>
Date: Wed, 09 Jun 2010 23:11:53 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs, aacraid
 2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608122919.GC7869@dastard> <4C0EA938.9000104@msgid.tls.msk.ru> <20100608231845.GG7869@dastard> <4C0F3819.4000409@msgid.tls.msk.ru> <20100609074741.GJ7869@dastard>
In-Reply-To: <20100609074741.GJ7869@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.06.2010 11:47, Dave Chinner wrote:
> On Wed, Jun 09, 2010 at 10:43:37AM +0400, Michael Tokarev wrote:
>> 09.06.2010 03:18, Dave Chinner wrote:
>>> On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
>> []
>>>> Simple test doing random reads or writes of 4k blocks in a 1Gb
>>>> file located on an xfs filesystem, Mb/sec:
>>>>
>>>>                       sync  direct
>>>>               read   write   write
>>>> 2.6.27 xfs   1.17    3.69    3.80
>>>> 2.6.32 xfs   1.26    0.52    5.10
>>>>                      ^^^^
>>>> 2.6.32 ext3  1.19    4.91    5.02
>
> Out of curiousity, what does 2.6.34 get on this workload?

2.6.34 works quite well:
      2.6.34 xfs    1.14   4.75    5.00

The same is with -o osyncisosync (in .34).  Actually,
osyncis[od]sync mount options does not change anything, not
in .32 nor in .34.

> Also, what happens if you test with noop or deadline scheduler,
> rather than cfq (or whichever one you are using)? i.e. is this a
> scheduler regression rather than a filesystem issue?

Using deadline.  Switching to noop makes no difference whatsoever.

> Also, a block trace of the sync write workload on both .27 and .32
> would be interesting to see what the difference in IO patterns is...

I see.  Will try to collect them.  With the limited timeframe I have
to do any testing.

[]
> Well, I normally just create a raid0 lun per disk in those cases,
> hence the luns present the storage to linux as a JBOD....

That's, um, somewhat ugly :)

>> I also experimented with both O_SYNC|O_DIRECT: it is as slow as
>> without O_DIRECT, i.e. O_SYNC makes whole thing slow regardless
>> of other options.
>
> So it's the inode writeback that is causing the slowdown. We've
> recently changed O_SYNC semantics to be real O_SYNC, not O_DSYNC
> as .27 is. I can't remember if that was in 2.6.32 or not, but
> there's definitely a recent change to O_SYNC behaviouri that would
> cause this...

But there are two mount options that seems to control this behavour:
osyncisosync and osyncisdsync.  Neither of which - seemingly - makes
no difference.

>> related to block devices or usage of barriers.  For XFS it always
>> mounts like this:
>>
>>   SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
>>   SGI XFS Quota Management subsystem
>>   XFS mounting filesystem sda6
>
> So barriers are being issued.

They _are_ being issued, I knew it from the start.  What I asked
several times is if there's a way to know if they're _hitting_ the
actual low-level device (disk or raid controller).  This is entirely
different story... ;)

>> and for the device in question, it is always like
>>
>>   Adaptec aacraid driver 1.1-5[2456]-ms
>>   aacraid 0000:03:01.0: PCI INT A ->  GSI 24 (level, low) ->  IRQ 24
>>   AAC0: kernel 5.1-0[8832] Feb  1 2006
>
> Old firmware. An update might help.

Well, it worked just fine in .27.  So far I see some problem in kernel,
not in controller [firmware]... ;)

Thank you !

/mjt
