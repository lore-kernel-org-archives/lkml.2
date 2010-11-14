Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0KNVtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:49:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55139 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0KNVtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lxUAP0xp5HYgxkGLa5vR0lWyYCnb54lBMImZLslD1p+zj/WkpL5hOjNyJFgz7VqBVZ
         Xkfu1JwmQUnshd+mfN+shKmRyDDds/RHP0d0r+W0rM0CHR8Foqgb4jFQhB8Razp7VbS4
         CnFcN5oyWUG0GMm4oNpQJM00j19FLGImyd6Po=
MIME-Version: 1.0
In-Reply-To: <20101114205925.GA20451@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
	<4CD6B7FA.3050005@redhat.com>
	<AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
	<AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
	<20101107194547.GA12521@basil.fritz.box>
	<4CD71C8B.1050604@redhat.com>
	<20101107230508.GB17592@basil.fritz.box>
	<20101108145809.GD29714@redhat.com>
	<1289238930-sup-9765@think>
	<20101114205925.GA20451@redhat.com>
Date: Sun, 14 Nov 2010 22:49:12 +0100
Message-ID: <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
Subject: Re: dm-crypt barrier support is effective (was: Re: DM-CRYPT: Scale
 to multiple CPUs v3 on 2.6.37-rc* ?)
From: Matt <jackdachef@gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 9:59 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, Nov 08 2010 at 12:59pm -0500,
> Chris Mason <chris.mason@oracle.com> wrote:
>
>> Excerpts from Mike Snitzer's message of 2010-11-08 09:58:09 -0500:
>> > On Sun, Nov 07 2010 at  6:05pm -0500,
>> > Andi Kleen <andi@firstfloor.org> wrote:
>> >
>> > > On Sun, Nov 07, 2010 at 10:39:23PM +0100, Milan Broz wrote:
>> > > > On 11/07/2010 08:45 PM, Andi Kleen wrote:
>> > > > >> I read about barrier-problems and data getting to the partition when
>> > > > >> using dm-crypt and several layers so I don't know if that could be
>> > > > >> related
>> > > > >
>> > > > > Barriers seem to be totally broken on dm-crypt currently.
>> > > >
>> > > > Can you explain it?
>> > >
>> > > e.g. the btrfs mailing list is full of corruption reports
>> > > on dm-crypt and most of the symptoms point to broken barriers.
>> >
>> > [cc'ing linux-btrfs, hopefully in the future dm-devel will get cc'd when
>> > concerns about DM come up on linux-btrfs (or other lists)]
>> >
>> > I spoke with Josef Bacik and these corruption reports are apparently
>> > against older kernels (e.g. <= 2.6.33).  I say <= 2.6.33 because:
>>
>> We've consistently seen reports about corruptions on power hits with
>> dm-crypt.  The logs didn't have any messages about barriers failing, but
>> the corruptions were still there.  The most likely cause is that
>> barriers just aren't getting through somehow.
>
> Can't blame anyone for assuming as much (although it does create FUD)
> but in practice (testing dm-crypt with ext4 using your barrier-test
> script) I have not been able to see any evidence that dm-crypt's barrier
> support is ineffective.
>
> Could be that the barrier-test script isn't able to reproduce the unique
> failure case that btrfs does (on power failure)?
>
>> > > > Barriers/flush change should work, if it is broken, it is not only dm-crypt.
>> > > > (dm-crypt simply relies on dm-core implementation, when barrier/flush
>> > > > request come to dmcrypt, all previous IO must be already finished).
>> > >
>> > > Possibly, at least it doesn't seem to work.
>> >
>> > Can you please be more specific?  What test(s)?  What kernel(s)?
>> >
>> > Any pointers to previous (and preferably: recent) reports would be
>> > appreciated.
>
> I still think we need specific bug reports that detail workloads and if
> possible reproducers.
>
>> > The DM barrier code has seen considerable change recently (via flush+fua
>> > changes in 2.6.37).  Those changes have been tested quite a bit
>> > (including ext4 consistency after a crash).
>> >
>> > But even prior to those flush+fua changes DM's support for barriers
>> > (Linux >= 2.6.31) was held to be robust.  No known (at least no
>> > reported) issues with DM's barrier support.
>>
>> I think it would be best to move forward with just hammering on the
>> dm-crypt barriers:
>>
>> http://oss.oracle.com/~mason/barrier-test
>>
>> This script is the best I've found so far to reliably trigger
>> corruptions with barriers off.  I'd start with ext3 + barriers off just
>> to prove it corrupts things, then move to ext3 + barriers on.
>
> I started with ext4 + barrier=0,journal_async_commit and could reliably
> cause directory corruption (~75% of the time).  I then switched to
> barrier=1 and could not cause corruption.
>
> I then added dm-crypt and got the same results: with barrier=1 I could
> not cause directory corruption.  barrier=0 resulted in directory
> corruption (again ~75% of the time), no corruption occurred with
> barrier=1.
>
> Both 2.6.36 (original barrier code) and latest 2.6.37-rc1+ (new
> flush+fua code) were tested.  6 iterations of barrier=0 and 10
> iterations of barrier=1.
>
> So my hope is we can now put this general dm-crypt barrier doubt to one
> side and work together on identifying the cause of corruption when
> dm-crypt is paired with btrfs.
>
> Thanks,
> Mike
>

Hi Mike,

I'm pretty sure that dm-crypt is rockstable :)

My report wasn't meant to be / cause FUD sorry if it got picked up that way:

with the vanilla dm-crypt implementation I saw *NO* corruption at all
in the small testing amount of time I ran it
however as soon as I applied the

[dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
and
[PATCH] Fix double free and use generic private pointer in per-cpu

patches, recompiled the kernel and rebooted into that new environment

it seemingly caused corruptions right from the start (the mentioned
corruption /etc/env.d/02opengl to be the most obvious candidate and
probably even more)
with those corruptions being anticipated over longer uptime and heavy
use-patterns (such as re-compiling the whole system).

I don't know if the new multi-cpu scaling patch for dm-crypt makes a
change (since I can't test it right now due to a busy schedule)

[PATCH v5] dm crypt: scale to multiple CPUs

I however have a request:

could you guys please take this patch through a "battery of heavy
tests" until it's included in mainline ?

so that you can spot any issues (races, BUGs, etc.) which might be
inherent/triggered in current dm-crypt so that my reported corruptions
might be prevented in the future ?

Again:

the vanilla kernel and dm-crypt are perfectly stable !

only with the dm-crypt scaling patch I could observe the data-corruption


Thanks !

Matt
