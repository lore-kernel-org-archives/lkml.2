Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1LAVKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:10:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11114 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1LAVKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:10:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Dec 2011 13:09:59 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 1 Dec 2011 13:09:59 -0800
Subject: RE: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Thread-Topic: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Thread-Index: Acyv+prO/gCiG8ebSyGXcT5N6SkpIgAbwG6A
Message-ID: <1FC56210173BB445BD77F608D6FB8D034F3D1BB4C9@HQMAIL03.nvidia.com>
References: <1322685811-14060-1-git-send-email-riyer@nvidia.com>
 <20111130212022.GB3108@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D034F3D1BB4BD@HQMAIL03.nvidia.com>
 <20111201072649.GE16816@core.coreip.homeip.net>
In-Reply-To: <20111201072649.GE16816@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry.

Sorry for the wrap issue, my Outlook does not seem to obey the settings.

I wanted to explain the tegra system resume path implementation so I can justify 
why I am doing this complicated fix and why I feel it will guarantee the resume 
is due to keypress.

The tegra wake resume code is registered as a syscore ops.
When the system is resumed due to a wake event, the suspend_enter (after wakeup) 
routine will invoke the tegra syscoreops_resume method and that routine will propagate 
the wake event to the individual ISR's through genirq.
If kbc was wake source, kbc_isr will be invoked in this execution path.

If system is resumed due to other reason, the tegra_syscoreops_resume code will not 
find the event.

In the kbc we ignore all keypresses until kbc_resume re-enables the fifo interrupt.
So the only way to generate this key would be if the tegra_syscoreops_resume 
finds that kbc was wake source

Maybe my understanding is wrong. Please feel free to correct me.

Regards
Rakesh

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, November 30, 2011 11:27 PM
> To: Rakesh Iyer
> Cc: rydberg@euromail.se; Stephen Warren; Laxman Dewangan; linux-
> kernel@vger.kernel.org; linux-input@vger.kernel.org; linux-tegra@vger.kernel.org
> Subject: Re: [PATCH v1] Input: tegra-kbc - report wakeup key for some platforms.
> 
> On Wed, Nov 30, 2011 at 02:14:03PM -0800, Rakesh Iyer wrote:
> > Thanks Dmitry.
> >
> > Since there can be multiple wake causes I wanted to isolate wake key
> > generation to the case where keyboard actually generated the wake
> > interrupt.
> 
> I do not think you can guarantee this though because if user touches
> keyboard "too early", before your resume method had a chance to disable
> kbc interrupt as a wakeup source, you are still going to get that
> interrupt and deliver KEY_POWER even though KBC is not the actual wakeup
> source.
> 
> So don't over-complicate it. If hardware can't detect actual key pressed
> just emit KEY_POWER if a key was at any time between calls to
> tegra_kbc_suspend() and tegra_kbc_resume().
> 
> BTW, could you please have your MUA wrap long lines around 75 column or so?
> 
> Thanks.
> 
> --
> Dmitry
