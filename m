Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1KAQkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:40:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1KAQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:40:16 -0400
Date: Tue, 1 Nov 2011 12:40:10 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH pm 1/2] usb_storage: don't use set_freezable_with_signal()
Message-ID: <20111101164010.GA19686@thinkpad-t410>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20111101003726.GM18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101003726.GM18855@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 05:37:26PM -0700, Tejun Heo wrote:
> The current implementation of set_freezable_with_signal() is buggy and
> tricky to get right.  usb-storage is the only user and its use can be
> avoided trivially.
> 
> All usb-storage wants is to be able to sleep with timeout and get
> woken up if freezing() becomes true.  This can be trivially
> implemented by doing interruptible wait w/ freezing() included in the
> wait condition.  There's no reason to use set_freezable_with_signal().
> 
> Perform interruptible wait on freezing() instead of using
> set_freezable_with_signal(), which is scheduled for removal.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> 
> These two patches are on top of "freezer: fix various bugs and
> simplify implementation, take#2" patchset[1] and are also available in
> the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-kill-freezable_with_signal
> 
> If usb-storage ppl are okay with it, I think routing this through pm
> would be the easiest.  Oh, and this definitely is for the next merge
> window.
> 
> Thank you.
> 
> [1] http://thread.gmane.org/gmane.linux.kernel/1209247
> 
>  drivers/usb/storage/usb.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index c325e69..aa84b3d 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -831,7 +831,8 @@ static int usb_stor_scan_thread(void * __us)
>  
>  	dev_dbg(dev, "device found\n");
>  
> -	set_freezable_with_signal();
> +	set_freezable();
> +
>  	/*
>  	 * Wait for the timeout to expire or for a disconnect
>  	 *
> @@ -839,16 +840,16 @@ static int usb_stor_scan_thread(void * __us)
>  	 * fail to freeze, but we can't be non-freezable either. Nor can
>  	 * khubd freeze while waiting for scanning to complete as it may
>  	 * hold the device lock, causing a hang when suspending devices.
> -	 * So we request a fake signal when freezing and use
> -	 * interruptible sleep to kick us out of our wait early when
> -	 * freezing happens.
> +	 * So instead of using wait_event_freezable(), explicitly test
> +	 * for (DONT_SCAN || freezing) in interruptible wait and proceed
> +	 * if any of DONT_SCAN, freezing or timeout has happened.
>  	 */
>  	if (delay_use > 0) {
>  		dev_dbg(dev, "waiting for device to settle "
>  				"before scanning\n");
>  		wait_event_interruptible_timeout(us->delay_wait,
> -				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
> -				delay_use * HZ);
> +				test_bit(US_FLIDX_DONT_SCAN, &us->dflags) ||
> +				freezing(current), delay_use * HZ);
>  	}
>  
>  	/* If the device is still connected, perform the scanning */

That looks like it ought to work, and it's definitely less convoluted
than what's there now.  I'd be happy to test it next week when I'm back
home and have access to the machine that prompted the original change.

Seth
