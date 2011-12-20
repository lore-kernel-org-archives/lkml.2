Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1LTTs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:48:27 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:54954
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab1LTTsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:48:19 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EF0E67B.5080002@freescale.com>
Date: Tue, 20 Dec 2011 13:48:11 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Li Yang <leoli@freescale.com>
CC: <dedekind1@gmail.com>, <dwmw2@infradead.org>,
        LiuShuo <b35362@freescale.com>, <linux-kernel@vger.kernel.org>,
        <shuo.liu@freescale.com>, <linux-mtd@lists.infradead.org>,
        <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala> <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala> <4EE6725C.3050706@freescale.com> <4EE6BC9B.4000602@freescale.com> <4EE8612C.9050104@freescale.com> <4EE903CE.1010903@freescale.com> <4EEAB076.30000@freescale.com> <4EEB8704.8030201@freescale.com> <CADRPPNT-akj5KBQKdRaFrA2XpLU6-xtuRduzDYEWjv_dzVmTAA@mail.gmail.com> <4EEF6AAA.3030806@freescale.com> <CADRPPNQtuuh5yR1WVNccoFhnQZnMenaFkFnHmFKWicSBoj35JQ@mail.gmail.com>
In-Reply-To: <CADRPPNQtuuh5yR1WVNccoFhnQZnMenaFkFnHmFKWicSBoj35JQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 03:08 AM, Li Yang wrote:
> On Tue, Dec 20, 2011 at 12:47 AM, Scott Wood <scottwood@freescale.com> wrote:
>> On 12/19/2011 05:05 AM, Li Yang wrote:
>>> On Sat, Dec 17, 2011 at 1:59 AM, Scott Wood <scottwood@freescale.com> wrote:
>>>> On 12/15/2011 08:44 PM, LiuShuo wrote:
>>>>> hi Artem,
>>>>> Could this patch be applied now and we make a independent patch for  bad
>>>>> block information
>>>>> migration later?
>>>>
>>>> This patch is not safe to use without migration.
>>>
>>> Hi Scott,
>>>
>>> We agree it's not entirely safe without migrating the bad block flag.
>>> But let's consider two sides of the situation.
>>>
>>> Firstly, it's only unsafe when there is a need to re-built the Bad
>>> Block Table from scratch(old BBT broken).
>>
>> No, it's unsafe in the presence of bad blocks.
>>
> 
> Instead of migrating the factory bad block markers I proposed to
> modify the code of building BBT to make it different for 4K page, so
> that the default BBT can correctly covers the factory bad blocks.  It
> is the easiest way with nearly no harm to the functionality.

Even if we were to agree to that (I disagree with "nearly no harm"),
this patch doesn't implement that.  As is, this patch simply ignores the
issue.

Note that besides possibly tossing away bad block information during
development, the BBT-only approach will not work for booting from NAND,
as we don't use the BBT in that case (need to keep the code minimal to
fit the 4k boot block).  Yes, this ignores blocks that were marked bad
by software, but that's usually OK since that part of the chip isn't
managed by a software layer such as jffs2 that will mark blocks as bad.

>> The BBT erasure issue relates to how me mark the flash as migrated, not
>> whether we migrate in the first place.
> 
> It is connected to whether we do the migration at all.  I mentioned in
> earlier mail that if we are doing the migration, we need to make sure
> the migration only happens once.  And it need to be done before the
> flash is used for the first time and before BBT is created.  If we
> can't guarantee these condition, we are marking good blocks as bad by
> doing the migration.  Even worse than doing nothing.

You also can't do the special BBT scan once the flash has been written
to with normal data.  This patch does not implement the special BBT scan.

>>>  But currently there is no
>>> easy way to do that(re-build BBT on demand),
>>
>> You scrub the blocks with U-Boot.  It's not supposed to be *easy*, it's
>> a developer recovery mechanism.
> 
> Scrub clears the factory bad block markers also.  

Only if you scrub bad blocks.  I was talking about scrubbing the BBT
specifically, not the entire chip.

>>> Secondly, even if the previous said problem happens(BBT broken).  We
>>> can still recover all the data if we overrule the bad block flag.
>>
>> How so?  The bad block markers -- including ones legitimately written to
>> the BBT after the fact -- are used for block skipping with certain types
>> of writes.  Without the knowledge of which blocks were marked bad, how
>> do we know which blocks were skipped?
> 
> This is not supposed to be *easy*.  We might get more information in
> the file system level.  Or we check the content of the blocks.

If you need to take special, non-automatic steps to recover the data,
that counts as data loss.

>>> however, it can be used
>>> if we take the risk of losing data from errors that ECC can't
>>> notice(low possibility too).
>>
>> Can you quantify "low possibility" here?
>>
>> Note that any block that *was* marked bad will have a multi-bit error
>> from the marker itself, since it will be embedded in the main data area.
> 
> I found the definition of bad block from one NAND chip manual: Bad
> Blocks are blocks that contain one or more invalid bits whose
> reliability is not guaranteed.
> 
> There is no mentioning that the bad block has to have multi-bit error.

"It's not guaranteed to fail" is rather different from "low possibility
of failure".

>  Although the factory bad blocks might have worse error than wear-off
> bad blocks, it's not what I can tell.

Why would they have such a mechanism to mark blocks bad, if it's not needed?

>> Why is it so critical that it be merged now, and not in a few weeks (or
>> next merge window) when I have a chance to do the migration code
>> (assuming nobody else does it first) and add a suitable check for the
>> migration marker in the Linux driver?
> 
> A few weeks might be ok.  But I feared that the merge can be further
> delayed and might finally goes no where.

And I fear that the bad block handling will be forgotten about if enough
gets merged for this to sort-of work.

> And as I argued above, I'm not sure if migrating is necessary in the first place.
> 
> In general.  We are not trying to get unqualified code merged.  But I
> also don't agree we need to perfect all things before any of the code
> can be merged.

I'm not asking for it to be perfect -- this just seems like a difficult
thing to fix once people start using the feature (similar to getting a
userspace API merged, we want to get it right first), and I'm not
comfortable with the risks of people using it without bad block handling.

> My understanding is that even if certain code is not
> complete in feature or have certain drawbacks, if the current chunk
> provided some useful features and the drawbacks are acceptable,

Whether "the drawbacks are acceptable" is the issue.

-Scott

