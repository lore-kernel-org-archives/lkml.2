Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1LMRdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 12:33:33 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54752 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755087Ab1LMRdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 12:33:08 -0500
X-Sasl-enc: RrsXN8sIos/VcZSc9oh8GozmrijmxsEZEKDSWFsCAtht 1323797587
Date: Tue, 13 Dec 2011 09:31:35 -0800
From: Greg KH <greg@kroah.com>
To: DONG-DONG YANG <gdb746@motorola.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kroah-Hartman <gregkh@suse.de>, Yi-wei Zhao <gbjc64@motorola.com>,
        TAO HU <taohu@motorola.com>, David Ding <dding@motorola.com>,
        Jeffrey Carlyle <jeff.carlyle@motorola.com>,
        zhiming YUAN <a14194@motorola.com>
Subject: Re: [PATCH 1/1] firmware_loading_store: fix firmware loading
 use-after-free oops
Message-ID: <20111213173135.GC17096@kroah.com>
References: <CACo43CLUiVxLof1k+Z4zL8B+mg9Giob6NhMeZn8WWGSqMc97wg@mail.gmail.com>
 <20111209235732.GB6680@kroah.com>
 <CACo43CKhoqvskCrqFfg9mo17OpegnSr84V3ZHEwSrCmp=ZmLcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACo43CKhoqvskCrqFfg9mo17OpegnSr84V3ZHEwSrCmp=ZmLcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, Dec 13, 2011 at 01:31:32PM +0800, DONG-DONG YANG wrote:
> If we do the check for fw in the fw_load_abort call, I concern whether it would
> limit FW_STATUS_ABORT scope, which would presume any fw_abort occur after fw
> instance generation.

Are you sure this really fixes anything?  What happens if the fw pointer
becomes null after the check happens but before the call?  What is
protecting that from happening here?

> The issue was introduced when the webtop components are integrated into the
> Linux Android platform.
> The webtop firmware loading performs udev configuration files (under /lib/udev/
> *) by default, however,
> ueventd is in charge of such loading task on android framework. The conflict
> causes the weird things happen.
>
> 50-firmware.rules, one of udev default rules, forks a sub-process, named
> "firmware", which sends "-1" to "loading" fw ctrl file on receiving "add"
> event. Such firmware loading failure should bring on APP processes exit or
> error report, but it causes use-after-free oops due to we have no check for fw
> in firmware_loading_store.

Sounds like this is a major userspace configuration error.  Not that
this means we shouldn't be applying the kernel patch, just that you need
to fix up your system first :)

Hm, so, you have two different processes trying to write to the firmware
file at the same time?  And when one finishes, the other one tries to
abort things?

Ok, I can understand that, it's a very messed up userspace, but I
understand.

But, your patch needs to properly hold the lock when this is being
checked, otherwise it will still race and could still oops.

And, your check needs to be done in a different place, again, what's to
keep that pointer from going away later, in the middle of that call you
just made?

Care to fix this up properly?

> The patch and log analysis are attached.

Please don't attach patches, it's not easy to apply them when they are
in base64 mode.

Also, your patch can't be applied as you made it against a very wierd
patch "rbase"?

thanks,

greg k-h
