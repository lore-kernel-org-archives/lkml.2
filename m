Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1BVHno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:43:44 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:58205 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1BVHnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aaZNrQvX27VIe00Hkyl7uHRMr2Soe7By1f/C9MEgiSeuIAolQzM6Fqp8laY/7mfRbI
         ihqh1hXSkgJZKO7orKK3Bv/AkBEjKtct5ToeQQnluGamkcZi943YXA2fmHOvBlsxwviC
         EfTrhALbGu1MD8LnqnRPOecp9H4GThltcNNmQ=
Message-ID: <4D6367B3.9050306@googlemail.com>
Date: Tue, 22 Feb 2011 08:37:23 +0100
From: Clemens Ladisch <cladisch@googlemail.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arthur Marsh <arthur.marsh@internode.on.net>
CC: Andrea Arcangeli <aarcange@redhat.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
In-Reply-To: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arthur Marsh wrote:
> I'm experiencing MIDI playback slow-downs when I'm observing kswapd0 
> active (a few percent of cpu in top output) in recent kernels.
> 
> I git-bisected the problem down to:
> 
> commit 5a03b051ed87e72b959f32a86054e1142ac4cf55
> Author: Andrea Arcangeli <aarcange@redhat.com>
> Date:   Thu Jan 13 15:47:11 2011 -0800
> 
>      thp: use compaction in kswapd for GFP_ATOMIC order > 0
> 
>      This takes advantage of memory compaction to properly generate pages of
>      order > 0 if regular page reclaim fails and priority level becomes more
>      severe and we don't reach the proper watermarks.
> 
>      Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> I ran git-bisect over the weekend, building and installing ALSA 1.0.24 
> with each kernel. After identifying the above commit, I rebuilt the 2.6 
> head with that commit reverted and verified that the problem was no 
> longer present.

Apparently, huge page compaction disables interrupts for much too long.

> MIDI playback was via aplaymidi -p 17:0 to a Soundblaster Audigy 2 ZS 
> (SB0350) wavetable.

The ALSA sequencer uses either the system timer or an HR timer at 1 kHz
to deliver MIDI commands (notes); the wavetable driver requires its own
interrupts in regular 5.3 ms intervals.


Regards,
Clemens
