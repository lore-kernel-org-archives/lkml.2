Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab2EVS5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:57:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2EVS53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:57:29 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 22 May 2012 20:57:25 +0200
From: Richard Weinberger <richard@nod.at>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: <linux-mtd@lists.infradead.org>, <dedekind1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <Heinz.Egger@linutronix.de>,
        <tim.bird@am.sony.com>, <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
In-Reply-To: <20120522211809.53bd6444@halley>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
 <1337608916-49771-2-git-send-email-richard@nod.at>
 <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at>
 <20120522211809.53bd6444@halley>
Message-ID: <2423212898cfc1c21343bff32e776dbd@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shmulik,

On Tue, 22 May 2012 21:18:09 +0300, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
>> If the fastmap is not written complete the CRC check will fail next time
>> and we fall back to scanning mode.
> 
> There are many fail-points within 'ubi_update_fastmap' where an error
> code is returned, long before it attempts writing to the media.
> If 'ubi_update_fastmap' fails due to those, then the old on-flash
> fastmap is still valid.
> However we know a volume has been just changed.
> Will the system be coherent after a sudden reboot (that occurs prior
> next successful fastmap update)?

In this case fastmap will detect that the pool contains LEB this an
unknown volume ID.
But maybe it would be better to kill the current fastmap as in the very
first step to
avoid any unknown corner cases.
I have to think about this. :-)

>> >> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
>> >> index 5275632..299a601 100644
>> >> --- a/drivers/mtd/ubi/ubi.h
>> >> +++ b/drivers/mtd/ubi/ubi.h
>> >> @@ -202,6 +202,39 @@ struct ubi_rename_entry {
>> >>   struct ubi_volume_desc;
>> >>
>> >>   /**
>> >> + * struct ubi_fastmap - in-memory fastmap data structure.
>> >> + * @peb: PEBs used by the current fastamp
>> >
>> > s/fastamp/fastmap/
>> >
>> >> + * @ec: the erase counter of each used PEB
>> >> + * @size: size of the fastmap in bytes
>> >> + * @used_blocks: number of used PEBs
>> >> + */
>> >> +struct ubi_fastmap {
>> >
>> > Suggestion: maybe ubi_fastmap_location / ubi_fastmap_layout /
>> > ubi_fastmap_position ? slightly more explanatory than 'ubi_fastmap'.
>>
>> Good idea. ubi_fastmap_position seems good to me.
> 
> Sounds good. You could amend the comments above the struct as well.
> 
>> >> + * @root: the RB-tree where to look for
>> >> + * @max_pnum: highest possible pnum
>> >> + *
>> >> + * This function looks for a wear leveling entry containing a eb which
>> >> + * is in front of the memory.
>> >
>> > IMO can remove the last comment.
>>
>> Documentation is like sex: when it is good, it is very, very good; and
>> when it is bad, it is better than nothing.
>> - Dick Brandon
> 
> :-)
> 
> BTW what is "in front of the memory"? ;)

I'll rephrase the comment. :D
I meant "in front of the NAND memory" IOW a PEB with a low number.

>> >> +		if (!e) {
>> >> +			spin_unlock(&ubi->wl_lock);
>> >> +			return -ENOMEM;
>> >
>> > This is traumatic; you must return the PEB back to WL, but fail to do so
>> > due to an internal error.
>>
>> This is not easy. In the !e case I need memory.
> 
> Yes, I noticed this is far from trivial ;)
> What troubles me, is that the system is unaware of the fault, acts
> business as usual, with one less PEB.
> 
> Care to elaborate how come 'ubi->lookuptbl[pnum]' is NULL? What's the
> exact flow leading to it?

PEBs used by the fastmap sub-system are not known by the WL and EBA
sub-system.
A PEB used by fastmap contains mostly raw data. (It does not have any
LEBs).
E.g. If PEBs 0,1 and 2 are used by fastmap they are not in
ubi->lookuptbl.
So, right after attaching from a fastmap ubi->lookuptbl[0|1|2] is NULL.
By writing a new fastmap 0, 1 and 2 will be put back to the WL
sub-system and they appear in
ubi->lookuptbl.

>> > (BTW the return value of ubi_wl_put_fm_peb is not tested at the call
>> > sites)
>> > The system is left with a missing PEB.
>> > Can't we guarantee ubi_wl_put_fm_peb is called only after wl_init is
>> > completed?
>>
>> Why would that help?
> 
> I tried to asses why 'ubi->lookuptbl[pnum]' gets NULL, I was
> probably mistaken in my analysis.
> 
> There's a bit of assymetry here.

Keeping the fastmap PEBs away from the WL sub-system is tricky, yes.

> 'ubi_wl_get_fm_peb' doesn't clear the 'ubi_wl_entry' from the lookuptbl.
> It does not free the 'ubi_wl_entry' either (seems like it should, no?)

It removes a PEB from the free rb-tree.
ubi->lookuptbl[pnum] does not matter at this time.

> However 'ubi_wl_put_fm_peb' creates a 'ubi_wl_entry' if not found in
> the lookuptbl.

Yeah, but only in one corner case.
See my comment:
        /* This can happen if we recovered from a fastmap the very
         * frist time and writing now a new one. In this case the wl
system
         * has never seen any PEB used by the original fastmap.
         */

> Formerly, wl_init was responsible for correctly populating
> 'ubi->lookuptbl'. Can we somehow preserve this for FM pebs as well?
> 

Currently fastmap "fixes" ubi->lookuptbl on demand. Is this a problem?

Thanks,
//richard
