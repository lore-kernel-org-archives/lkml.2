Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab2EWGTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:19:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40295 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab2EWGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:19:06 -0400
Date: Wed, 23 May 2012 09:18:56 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: <linux-mtd@lists.infradead.org>, <dedekind1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <Heinz.Egger@linutronix.de>,
        <tim.bird@am.sony.com>, <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
Message-ID: <20120523091856.4e9217a2@pixies.home.jungo.com>
In-Reply-To: <2423212898cfc1c21343bff32e776dbd@radon2.swed.at>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
	<1337608916-49771-2-git-send-email-richard@nod.at>
	<20120522180119.2c2a10a8@pixies.home.jungo.com>
	<4FBBC4EE.4040802@nod.at>
	<20120522211809.53bd6444@halley>
	<2423212898cfc1c21343bff32e776dbd@radon2.swed.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, 22 May 2012 20:57:25 +0200 Richard Weinberger <richard@nod.at> wrote:
> > Care to elaborate how come 'ubi->lookuptbl[pnum]' is NULL? What's the
> > exact flow leading to it?
> 
> PEBs used by the fastmap sub-system are not known by the WL and EBA
> sub-system.
> A PEB used by fastmap contains mostly raw data. (It does not have any
> LEBs).
> E.g. If PEBs 0,1 and 2 are used by fastmap they are not in
> ubi->lookuptbl.
> So, right after attaching from a fastmap ubi->lookuptbl[0|1|2] is NULL.
> By writing a new fastmap 0, 1 and 2 will be put back to the WL
> sub-system and they appear in
> ubi->lookuptbl.

Thanks. Understood.

> > 'ubi_wl_get_fm_peb' doesn't clear the 'ubi_wl_entry' from the lookuptbl.
> > It does not free the 'ubi_wl_entry' either (seems like it should, no?)
> 
> It removes a PEB from the free rb-tree.
> ubi->lookuptbl[pnum] does not matter at this time.

For practical matters, you are correct.
Design wise, it is bit inconsistent and confusing.

On one hand, you claim above that 'ubi->lookuptbl' holds the WL entries
known to WL subsystem - that is, lookuptbl is a data structure used and
maintained by the WL subsystem.
OTOH, when a PEB is removed from hands of WL (by a ubi_wl_get_fm_peb
call), you keep its WL entry assigned in ubi->lookuptbl.

I'll rethink this, see if there's a potential trouble here.

> > However 'ubi_wl_put_fm_peb' creates a 'ubi_wl_entry' if not found in
> > the lookuptbl.
> 
> Yeah, but only in one corner case.
> See my comment:
>         /* This can happen if we recovered from a fastmap the very
>          * frist time and writing now a new one. In this case the wl
> system
>          * has never seen any PEB used by the original fastmap.
>          */
> 
> > Formerly, wl_init was responsible for correctly populating
> > 'ubi->lookuptbl'. Can we somehow preserve this for FM pebs as well?
> > 
> 
> Currently fastmap "fixes" ubi->lookuptbl on demand. Is this a problem?

I guess not.

The only problem, as previously noted, is the failure to create a new
'ubi_wl_entry' when the PEB needs to be returned to WL subsystem.

If all relevant wl entries are created during 'wl_init' (including those
currently associated to the fastmap), then we are fine, as internal
failures within 'wl_init' propagate back to the attach code.

I'll give it some more thought.

Regards,
Shmulik
