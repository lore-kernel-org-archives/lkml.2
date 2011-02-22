Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1BVJQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:16:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51409 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1BVJQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:16:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=LLSsXgSHZ4yPkuD413eFKkV88yZAZ3tq5flEsavEABFm5CsCMk3Lxu4E7Re8YSEOa5
         240fo9aTvEzmPYLnRFwM6LG9SnDJ2R4EzR61dLprN5aFFOUFc1MsTX0ikstwaQoYLkdz
         G249lFeV39o0Fddd+dZEzjoixrMCzgxwlXvIc=
References: <4D62CE9C.7090806@versanet.de> <20110222081752.GP31267@htj.dyndns.org> <20110222085223.GC11681@core.coreip.homeip.net> <20110222090255.GR31267@htj.dyndns.org>
In-Reply-To: <20110222090255.GR31267@htj.dyndns.org>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
Cc: "pantherchen@versanet.de" <pantherchen@versanet.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Date: Tue, 22 Feb 2011 01:15:54 -0800
To: Tejun Heo <tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 22, 2011, at 1:02 AM, Tejun Heo <tj@kernel.org> wrote:

> On Tue, Feb 22, 2011 at 12:52:23AM -0800, Dmitry Torokhov wrote:
>>> 1. kworker/0:1's uninterruptible sleeps start later than kserio's.
>>> 
>>>   It could be that cpu 0 was busy running other stuff and thus cmwq
>>>   delayed executing serio_event_work; however, if we look at the CPU
>>>   usage, that doesn't seem likely.  The CPU is not busy at all and if
>>>   the CPU isn't busy, cmwq wouldn't introduce any noticeable delay in
>>>   work item execution.
>>> 
>>>   Another possibility is the rescuer concurrency depletion bug is
>>>   delaying execution of queued work items early during boot.  This
>>>   was fixed recently.  Can you please give a shot at 2.6.38-rc6 and
>>>   see whether anything is different?
>>> 
>>> 2. Most of the delay is caused by xorg starting up much later.  xorg
>>>   seems to start up in parallel with the kseriod sleeps in 2.6.37 but
>>>   on 2.6.38 it seems to wait for the serio_event_work to finish.
>>> 
>>>   I have no idea what xorg is waiting for.  Dmitry, any clue?
>>> 
>> 
>> It looks like it is not X is waiting but plymouth not being told to
>> quit... I will have to look at waht triggers plymouth->X/GDM transition.
>> 
>> Also, serio jobs (mouse probe) is quite lengthtly. Should it be using
>> unbound workqueue instead?
> 
> How long it works doesn't matter at all.  If you look at the boot
> chart, as soon as those uninterruptible sleeps start, kworker/0:2 is
> created to serve other work items, so it doesn't really affect anyone
> else.  Unbound ones are mostly helpful for cases where the work items
> involved may consume large amount of cpu cycles (not true here) over
> long period of time.  That said, something definitely seems wrong
> here.  Eh well, let's find out. :-)

Ok, so here on Fedora 14 Plymouth is being told to exit once all rc scripts are finished running, as part of prefdm task. If serio hogs kworkers and for some reason mount or similar has to wait that would explain boot delay. I'd like to see rc6 tried. 

Thanks. 

-- 
Dmitry

