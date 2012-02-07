Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2BGQZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:25:21 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62476 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2BGQZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:25:19 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120206222517.GD24840@quack.suse.cz>
References: <1328536531-19034-1-git-send-email-jack@suse.cz>
	<4F2FF4EC.1000104@linux.vnet.ibm.com>
	<20120206164732.GH6890@quack.suse.cz>
	<20120206131717.c4346f72.akpm@linux-foundation.org>
	<20120206222517.GD24840@quack.suse.cz>
Date: Tue, 7 Feb 2012 18:25:18 +0200
Message-ID: <CAOtvUMcWOfkn401qEUgBMV=R-vCbWG3sus6=yV9kQjRhheXV4A@mail.gmail.com>
Subject: Re: [PATCH] vfs: Avoid IPI storm due to bh LRU invalidation
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        hare@suse.de, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 12:25 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 06-02-12 13:17:17, Andrew Morton wrote:
>> On Mon, 6 Feb 2012 17:47:32 +0100
>> Jan Kara <jack@suse.cz> wrote:
>>
>> > On Mon 06-02-12 21:12:36, Srivatsa S. Bhat wrote:
>> > > On 02/06/2012 07:25 PM, Jan Kara wrote:
>> > >
>> > > > When discovery of lots of disks happen in parallel, we call
>> > > > invalidate_bh_lrus() once for each disk from partitioning code resulting in a
>> > > > storm of IPIs and causing a softlockup detection to fire (it takes several
>> > > > *minutes* for a machine to execute all the invalidate_bh_lrus() calls).
>>
>> Gad.  How many disks are we talking about here?
>  I think something around hundred scsi disks in this case (number of
> physical drives is actually lower but multipathing blows it up). I actually
> saw machines with close to thousand scsi disks (yes, they had names like
> sdabc ;).

LOL. Is that a huge SCSI disk array in your server or your are just
happy to see me... ? :-)
>
...
>> > >
>> > > Something related that you might be interested in:
>> > > https://lkml.org/lkml/2012/2/5/109
>> > >
>> > > (This is part of Gilad's patchset that tries to reduce cross-CPU IPI
>> > > interference.)
>> >   Thanks for the pointer. I didn't know about it. As Hannes wrote, this
>> > need not be enough for our use case as there might indeed be some bhs in
>> > the LRU. But I'd be interested how well the patchset works anyway. Maybe it
>> > would be enough because after all when we invalidate LRUs subsequent
>> > callers will see them empty and not issue IPI? Hannes, can you give a try
>> > to the patches?

I think its worth a shot since the mutex just delays the IPIs instead
of canceling them
altogether.

A somewhat similar issue in the direct reclaim path of the buddy
allocator trying
to reclaim per cpu pages was causing a massive storm of IPIs during OOM with
concurrent work loads and the IPI noise patches mitigate 85% of the
IPIs sent just by checking to see if there are any per cpu pages on the CPU you
are about to IPI, so maybe the same kind of logic applies here as well.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
