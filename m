Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2ENWlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:41:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36128 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2ENWlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAMLZHHTM6fojwcPAeyL07hz9U=7uNnxnwxm4kWY_-ffOtHm=vQ@mail.gmail.com>
References: <CAMLZHHTM6fojwcPAeyL07hz9U=7uNnxnwxm4kWY_-ffOtHm=vQ@mail.gmail.com>
Date: Mon, 14 May 2012 16:41:07 -0600
X-Google-Sender-Auth: dF50ufuoQ-iM_fG8OodZuKTxxHk
Message-ID: <CAMLZHHToiBUw-pTm6R=EZ5mHK5B55Y6arqdqDn-tzLicEdwMjA@mail.gmail.com>
Subject: Re: Hang while loading firmware when going into suspend
From: Daniel Drake <dsd@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 26, 2012 at 1:15 PM, Daniel Drake <dsd@laptop.org> wrote:
> I can easily reproduce a hang related to loading firmware
> (asynchronously) while going into suspend.
>
> This is running on kernel 3.3.3.
>
> I run:
>
> echo mem > /sys/power/state; echo mem > /sys/power/state
>
> i.e. I tell the system to suspend, and when I wake it up it will go
> very quickly into suspend again.
>
> After waking up, it will start to re-detect the libertas SDIO wifi
> card which was completely powered down during suspend.
> This triggers a firmware loading sequence.
> However, the system then immediately goes into suspend, and at this
> point the system becomes unhappy.

We're still suffering from this issue.

As far as I can see there are 2 items in question:

1. If a firmware load is in-progress as the system goes into suspend,
the relevant userspace processes get frozen and then we have to wait
for the timeout - the firmware loader in the kernel doesn't do
anything special on this important event.

2. There are no safety traps for if a new firmware load request
happens while the system is being suspended with userspace processes
already frozen. Then we have to wait for another timeout.


Do you have any suggested approaches to solve this?

I'm wondering if this is appropriate: firmware_class should add a
pm_notifier so that it is notified when the system is going into
suspend. It would set an internal flag noting that the system is
suspending, and then it can call fw_load_abort() on any active
firmware loads, making them fail immediately.
_request_firmware() would check the internal flag when it is called,
immediately returning failure -ENODATA (?) when the system is going
into suspend.

Does this sound reasonable or should I be looking for another approach?

Thanks,
Daniel
