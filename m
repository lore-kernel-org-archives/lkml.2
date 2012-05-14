Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2ENBC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 21:02:59 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:50328 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2ENBC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 21:02:58 -0400
Message-ID: <1336957376.4914.5.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Date: Mon, 14 May 2012 11:02:56 +1000
In-Reply-To: <4FB044A6.7090108@linux.vnet.ibm.com>
References: <1336515735.2097.23.camel@shrek.rexursive.com>
	 <4FAA2673.50007@linux.vnet.ibm.com>
	 <1336560579.2097.32.camel@shrek.rexursive.com>
	 <aba7b996-df0e-420c-b2eb-d32881660fe8@email.android.com>
	 <4FB044A6.7090108@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 05:02 +0530, Srivatsa S. Bhat wrote:
> This is the point where your patch gets scary - Suspend is not carried
> out in its fullest sense; instead you jump directly to
> suspend_devices_and_enter(). Luckily, most of the things that happen
> before this are common between suspend and hibernation. However, one
> thing that really stands out is the notifications: if you directly
> call suspend_devices_and_enter(), we end up missing the
> PM_SUSPEND_PREPARE notifications.

I'm guessing because at the point of suspend to RAM here, we are not
really doing the real, full suspend to RAM, things would be different.
At this point, not the whole system is alive - most of it is frozen.
Only devices required for image writing are alive. Or maybe I'm
misunderstanding the hibernation process...

> And there is no guarantee that everybody implements the same thing for
> both PM_SUSPEND_PREPARE and PM_HIBERNATION_PREPARE notifications. That
> is the reason I don't think it is safe.

OK.

So, you would do:

- prepare for hibernation (includes suspension of devices)
- resume devices involved in image writing
- write image
- prepare for suspend
- suspend to RAM
- resume from RAM
- post suspend from RAM
- unwind unsuccessful hibernation

Isn't that going to confuse devices involved in image writing even more
by essentially executing post-resume twice (once for suspend to RAM,
once for hibernation)?

-- 
Bojan

