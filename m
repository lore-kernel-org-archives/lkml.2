Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab1LTJIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:08:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40322 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1LTJIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:08:44 -0500
MIME-Version: 1.0
In-Reply-To: <4EEF6AAA.3030806@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	<1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	<4EDEAEB9.6020703@freescale.com>
	<1323724195.2297.11.camel@koala>
	<4EE66EFE.1050608@freescale.com>
	<1323724784.2297.20.camel@koala>
	<4EE6725C.3050706@freescale.com>
	<4EE6BC9B.4000602@freescale.com>
	<4EE8612C.9050104@freescale.com>
	<4EE903CE.1010903@freescale.com>
	<4EEAB076.30000@freescale.com>
	<4EEB8704.8030201@freescale.com>
	<CADRPPNT-akj5KBQKdRaFrA2XpLU6-xtuRduzDYEWjv_dzVmTAA@mail.gmail.com>
	<4EEF6AAA.3030806@freescale.com>
Date: Tue, 20 Dec 2011 17:08:42 +0800
X-Google-Sender-Auth: zUhtvKjutIbT4bbdk7rVKiVllQg
Message-ID: <CADRPPNQtuuh5yR1WVNccoFhnQZnMenaFkFnHmFKWicSBoj35JQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Li Yang <leoli@freescale.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Artem.Bityutskiy@nokia.com, dedekind1@gmail.com,
        linuxppc-dev@lists.ozlabs.org, LiuShuo <b35362@freescale.com>,
        linux-kernel@vger.kernel.org, shuo.liu@freescale.com,
        linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        dwmw2@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 12:47 AM, Scott Wood <scottwood@freescale.com> wrote:
> On 12/19/2011 05:05 AM, Li Yang wrote:
>> On Sat, Dec 17, 2011 at 1:59 AM, Scott Wood <scottwood@freescale.com> wrote:
>>> On 12/15/2011 08:44 PM, LiuShuo wrote:
>>>> hi Artem,
>>>> Could this patch be applied now and we make a independent patch for  bad
>>>> block information
>>>> migration later?
>>>
>>> This patch is not safe to use without migration.
>>
>> Hi Scott,
>>
>> We agree it's not entirely safe without migrating the bad block flag.
>> But let's consider two sides of the situation.
>>
>> Firstly, it's only unsafe when there is a need to re-built the Bad
>> Block Table from scratch(old BBT broken).
>
> No, it's unsafe in the presence of bad blocks.
>

Instead of migrating the factory bad block markers I proposed to
modify the code of building BBT to make it different for 4K page, so
that the default BBT can correctly covers the factory bad blocks.  It
is the easiest way with nearly no harm to the functionality.

If you look at nand_default_block_markbad() in current implementation
of Linux MTD.  If we have set NAND_BBT_USE_FLASH option, which we did,
the bad block information in only updated in BBT not the oob area of
the first two pages of the bad block.  That means we are currently
only relies on the BBT for bad blocks.  If the BBT is created, the
factory bad block markers can be ignored, IMO.

> The BBT erasure issue relates to how me mark the flash as migrated, not
> whether we migrate in the first place.

It is connected to whether we do the migration at all.  I mentioned in
earlier mail that if we are doing the migration, we need to make sure
the migration only happens once.  And it need to be done before the
flash is used for the first time and before BBT is created.  If we
can't guarantee these condition, we are marking good blocks as bad by
doing the migration.  Even worse than doing nothing.

>
>>  But currently there is no
>> easy way to do that(re-build BBT on demand),
>
> You scrub the blocks with U-Boot.  It's not supposed to be *easy*, it's
> a developer recovery mechanism.

Scrub clears the factory bad block markers also.  It is the same
result after scrub whether or not we migrated the factory bad block
markers.

>
>> Secondly, even if the previous said problem happens(BBT broken).  We
>> can still recover all the data if we overrule the bad block flag.
>
> How so?  The bad block markers -- including ones legitimately written to
> the BBT after the fact -- are used for block skipping with certain types
> of writes.  Without the knowledge of which blocks were marked bad, how
> do we know which blocks were skipped?

This is not supposed to be *easy*.  We might get more information in
the file system level.  Or we check the content of the blocks.

>
>> Only the card is not so good to be used again,
>
> That's a pretty crappy thing to happen every time you hit a bug during
> development.
>
> But again, that's irrelevant to whether this patch should be applied
> as-is, because we currently don't have any bad block migration at all.
>
>> however, it can be used
>> if we take the risk of losing data from errors that ECC can't
>> notice(low possibility too).
>
> Can you quantify "low possibility" here?
>
> Note that any block that *was* marked bad will have a multi-bit error
> from the marker itself, since it will be embedded in the main data area.

I found the definition of bad block from one NAND chip manual: Bad
Blocks are blocks that contain one or more invalid bits whose
reliability is not guaranteed.

There is no mentioning that the bad block has to have multi-bit error.
 Although the factory bad blocks might have worse error than wear-off
bad blocks, it's not what I can tell.

>
>> Finally, I don't think this is a blocker issue but a better to have enhancement.
>
> No, it is not an enhancement.  Processing bad block markers correctly is
> a fundamental requirement.  And if anyone *does* start using it right
> away, then we'll have to deal with their complaints if we start checking
> for a migration marker later.

I agree in some extend.  I suggested to have the code of creating
correct BBT for 4k page on first use, but not doing the migration.
Given the code we have right now.   We don't take more risk than
before, and take no functionality lose.

>
> Why is it so critical that it be merged now, and not in a few weeks (or
> next merge window) when I have a chance to do the migration code
> (assuming nobody else does it first) and add a suitable check for the
> migration marker in the Linux driver?

A few weeks might be ok.  But I feared that the merge can be further
delayed and might finally goes no where.  And as I argued above, I'm
not sure if migrating is necessary in the first place.

In general.  We are not trying to get unqualified code merged.  But I
also don't agree we need to perfect all things before any of the code
can be merged.  My understanding is that even if certain code is not
complete in feature or have certain drawbacks, if the current chunk
provided some useful features and the drawbacks are acceptable, we
should merge them and add more enhancements incrementally in the
future.  Some people don't have the luck to work on one thing for a
long time, and can't possibly finish all the enhancements in one go.
It's beneficial to merge part of the whole picture if it is acceptable
rather than wait for an uncertain time for all to be finished.

- Leo
