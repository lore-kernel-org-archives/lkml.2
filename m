Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0DQJG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:06:27 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4808 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253Ab0DQJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:06:26 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] Sound not transferred to docking station after resume from StR
Date: Sat, 17 Apr 2010 11:06:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-pm@lists.linux-foundation.org, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>
References: <201004162131.19171.elendil@planet.nl>
In-Reply-To: <201004162131.19171.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004171106.23787.elendil@planet.nl>
X-OriginalArrivalTime: 17 Apr 2010 09:06:23.0966 (UTC) FILETIME=[40FBB7E0:01CADE0D]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 April 2010, Frans Pop wrote:
> Scenario:
> - suspend laptop while *un*docked, i.e. with laptop speakers in use
> - dock laptop
> - resume
>
> With 2.6.33 and earlier the sound would always come from the external
> speakers connected to the docking station. But with 2.6.34-rc4 I get
> sound still coming from the laptop's internal speakers, which is not
> correct.

The problem is slightly different than I thought. Turns out *both* the
internal (laptop) and external (docking station) speakers are active after
the resume. So the problem is that the internal speakers are not switched off.

I have traced this to an ALSA merge: 524df55725217. Unfortunately I get
boot failures when I try to bisect down into that merge.

Here's the bisect log:
# bad: [0d0fb0f9c5fddef4a10242fe3337f00f528a3099] Linux 2.6.34-rc4
# good: [724e6d3fe8003c3f60bf404bf22e4e331327c596] Linux 2.6.33-rc8
git bisect start 'v2.6.34-rc4' 'v2.6.33-rc8'
# bad: [94468080220162f74dc6ce5c3e95e5fec8022902]
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6
git bisect bad 94468080220162f74dc6ce5c3e95e5fec8022902
# bad: [524df55725217b13d5a232fb5badb5846418ea0e] Merge branch 'for-linus'
  of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad 524df55725217b13d5a232fb5badb5846418ea0e
# good: [0f4533979473a456a8adb3869365e12c7a99cf65]
  Merge branches 'futexes-for-linus', 'irq-core-for-linus' and
  'bkl-drivers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 0f4533979473a456a8adb3869365e12c7a99cf65

Cheers,
FJP
