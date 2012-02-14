Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab2BNCHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:07:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64744 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2BNCH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:07:27 -0500
MIME-Version: 1.0
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
Date: Mon, 13 Feb 2012 18:07:26 -0800
Message-ID: <CAMP5XgeqXJroKtHZO18SESFxg1iGP=wHAa+CU1zEEXQqUEQwTA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 5:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...
> All in all, it's not as much code as I thought it would be and it seems to be
> relatively simple (which rises the question why the Android people didn't
> even _try_ to do something like this instead of slapping the "real" wakelocks
> onto the kernel FWIW).  IMHO it doesn't add anything really new to the kernel,
> except for the user space interfaces that should be maintainable.  At least I
> think I should be able to maintain them. :-)
>

Replacing a working solution with an untested one takes time. That
said, I have recently tried replacing all our kernel wake-locks with a
thin wrapper around wake-sources. This appears to mostly work, but the
wake-source timeout feature has some bugs or incompatible apis. An
init api would also be useful for embedding wake-sources in other data
structures without adding another memory allocation. Your patch to
move the spinlock init to wakeup_source_add still require the struct
to be zero initialized and the name set manually.

I needed to use two wake-sources per wake-lock since calling
__pm_stay_awake after __pm_wakeup_event on a wake-source does not
cancel the timeout. Unless there is a reason to keep this behavior I
would like __pm_stay_awake to cancel any active timeout.

Destroying a wake-source also has some problems. If you call
wakeup_source_destroy it will spin forever if the wake-source is
active without a timeout. And, if you call __pm_relax then
wakeup_source_destroy it could free the wake-source memory while the
timer function is still running. It also looks as if the wake_source
can be immediately deactivated if you call __pm_wakeup_event at the
same time as the previous timeout expired.

-- 
Arve Hjønnevåg
