Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1AXN3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:29:18 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:34023 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1AXN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:29:17 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2011 08:29:16 EST
From: Lasse Collin <lasse.collin@tukaani.org>
To: Andreas Schwab <schwab@linux-m68k.org>, Jesper Juhl <jj@chaosbits.net>
Subject: Re: Possible array overrun in lzma_reset()
Date: Mon, 24 Jan 2011 15:19:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-ARCH; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1101222124360.7746@swampdragon.chaosbits.net> <m2bp38r33j.fsf@igel.home>
In-Reply-To: <m2bp38r33j.fsf@igel.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241519.07547.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-23 Andreas Schwab wrote:
> Jesper Juhl <jj@chaosbits.net> writes:
>
> > 787           probs = s->lzma.is_match[0];
> > At conditional (1): "i < 14134UL" taking true path
> > At conditional (2): "i < 14134UL" taking true path
> > At conditional (3): "i < 14134UL" taking true path
> > 788           for (i = 0; i < PROBS_TOTAL; ++i)
> > Event overrun-local: Overrunning static array of size 32 bytes at byte position 28266 by indexing pointer "probs" with index variable "i".
> > Event overrun-local: Note: These bugs are often difficult to see at first glance. Coverity recommends a close inspection of the events leading to this overrun.
> > 789                   probs[i] = RC_BIT_MODEL_TOTAL / 2;
> > ...
> >
> > I looked into the report and found that 's->lzma.is_match' is
> >       uint16_t is_match[STATES][POS_STATES_MAX]
> > where 'STATES' is '#define STATES 12' and 'POS_STATES_MAX' is '#define POS_STATES_MAX (1 << 4)'.
> >
> > So I think the checker has a point.
>
> The loop treats the part of the structure from is_match to the end as
> a single array of PROBS_TOTAL uint16_t (which it is, in effect).

Correct. The comment in the code tries to say it too:

    * All probabilities are initialized to the same value. This hack
    * makes the code smaller by avoiding a separate loop for each
    * probability array.

So there is no bug.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
