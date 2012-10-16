Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab2JPR6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:58:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36168 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JPR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <20121016145039.eizeigon@trusted.unix-scripts.info>
References: <20121015213522.kaiyahro@trusted.unix-scripts.info>
	<20121016090353.GB7428@liondog.tnic>
	<20121016112301.lavahnga@trusted.unix-scripts.info>
	<20121016124825.GA8509@x1.osrc.amd.com>
	<20121016145039.eizeigon@trusted.unix-scripts.info>
Date: Tue, 16 Oct 2012 10:58:49 -0700
X-Google-Sender-Auth: FPVQxpeNhGIAmt_XcPabJLWg6hM
Message-ID: <CAA9_cmf9XsQ7YPLfsvvjPjLxQGVde1yHqTanOjJxdjPcLRUK8g@mail.gmail.com>
Subject: Re: Strange crash on Dell R720xd
From: Dan Williams <djbw@fb.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 5:52 AM, Laurent CARON <lcaron@unix-scripts.info> wrote:
> On Tue, Oct 16, 2012 at 02:48:25PM +0200, Borislav Petkov wrote:
>> On Tue, Oct 16, 2012 at 11:26:01AM +0200, Laurent CARON wrote:
>> > On Tue, Oct 16, 2012 at 11:03:53AM +0200, Borislav Petkov wrote:
>> > > That's:
>> > >
>> > >                 BUG_ON(async_tx_test_ack(depend_tx) || txd_next(depend_tx) ||
>> > >                   txd_parent(tx));
>> > >
>> > > but probably the b0rkage happens up the stack. And this __raid_run_ops
>> > > is probably starting the whole TX so maybe we should add
>> > > linux-raid@vger.kernel.org to CC. Added.
>> >
>> >
>> > Hi,
>> >
>> > The machines seem stable after disabling I/O AT DMA at the BIOS level.
>>
>> That's a good point because the backtrace goes through I/O AT DMA so it
>> could very well be the culprit. Let's add some more people to Cc.
>>
>> Vinod/Dan, here's the BUG_ON Laurent is hitting:
>>
>> http://marc.info/?l=linux-kernel&m=135033064724794&w=2
>>
>> and it has ioat2_tx_submit_unlock in the backtrace. Disabling ioat dma
>> in the BIOS makes the issue disappear so ...
>>
>> > > What is that "r510" thing in the kernel version? You have your patches
>> > > ontop? If yes, please try reproducing this with a kernel.org kernel
>> > > without anything else ontop.
>> >
>> > My kernel is vanilla from Kernel.org. The -r510 string is because I
>> > tried it on a -r510 also.
>>
>> Ok, good.
>>
>> > > Also, it might be worth trying plain 3.6 to rule out a regression
>> > > introduced in the stable 3.6 series.
>> >
>> > I tried 3.5.x, 3.6, 3.6.1, 3.6.2 with exactly the same results.
>> >
>> > For now, I did create more volumes, rsync lors of data over the network
>> > to the disks with no crashs (after disabling I/O AT DMA).
>>
>> And when you do this with ioat dma enabled, you get the bug, right? So
>> it is reproducible...?
>
> It is 100% reproductible. The only "nondeterministic" point is the time
> it takes to have the machine crash.
>

I think this may be a bug in __raid_run_ops that is only possible when
raid offload and CONFIG_MULTICORE_RAID456 are enabled.  I'm thinking
the descriptor is completed and recycled to another requester in the
space between these two events:

                ops_run_compute();

                /* terminate the chain if reconstruct is not set to be run */
                if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
                        async_tx_ack(tx);

...don't use the experimental CONFIG_MULTICORE_RAID456 even if you
leave IOAT DMA disabled.  A rework of the raid operation dma chaining
is in progress, but may not be ready for a while.


--
Dan
