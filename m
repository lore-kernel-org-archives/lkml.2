Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1GLQZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:25:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1GLQZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:25:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CsWMdwjOqKfFTGRONZqcX+tvsrFltrXQF9IL5+nqV1GeAk80SC2XMdCIWM0hhRBqU
	egjZceccIVPAJpIoKdh9g==
MIME-Version: 1.0
In-Reply-To: <4E15B9FD.8080003@draigBrady.com>
References: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com> <4E15B9FD.8080003@draigBrady.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Jul 2011 10:25:24 -0600
Message-ID: <CAErSpo5=TQm9SLM9dE2-Sm7ZLvaSXAZOorE1z9SK9kEh9CUbNQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] [RFC] watchdog reboot timeout
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 7:51 AM, Pádraig Brady <P@draigbrady.com> wrote:
> On 06/07/11 17:09, Bjorn Helgaas wrote:
>> I'm looking for comments on these patches.  I'm not really happy with
>> them because they add basically identical code in each driver.  I also
>> don't like the fact that the parameter is not generic, so I have to know
>> which driver will be used on my machine.
>
> Hmm, so this is protecting the window between watchdog_stop and machine_reset.

That's part of it, but I'm really interested in reboots using kexec,
and in that case, there is no machine reset, and BIOS isn't involved
at all.  If the kexec fails or the new kernel hangs for some reason,
I'd like the watchdog to reset the machine.

Currently, we call all the driver .shutdown methods() on the way down,
and the watchdog shutdown methods turn off the watchdog, so we have no
protection after that.

> It would be nice to have this as generic code that did WDIOC_SETTIMEOUT
> immediately after (or instead of) shutdown.

Yes.  I'd prefer this to be more generic.  I've skimmed the new
generic watchdog code a bit, hoping for a nice way to do this, but the
actual .shutdown() method is still in each driver, so making it
generic doesn't seem trivial.  So consider this a plea for future
development.

> Leaving a watchdog enabled across boot does have issues on some systems.
> It was OK for winboond based watchdogs I tested, but for some IBM
> server systems, "weird stuff" happened if the watchdog was left enabled
> across boot.

Point taken: it's unwise to assume consistency across all BIOSes, so
it was a mistake to write the last paragraph ("If we reboot via BIOS,
BIOS should disable the watchdog ...").

My reboot_timeout is disabled by default and is only enabled if the
user specifies the module option.  I don't think it's possible to
enable something like this by default, because in general we don't
know anything about the new kernel.  It may not have a watchdog driver
at all.

But in many cases, we *do* know the machine doesn't do "weird stuff,"
the new kernel has a driver, and we can bound the expected boot time.
In those cases, I think this option provides useful protection.

> Just to mention the other watchdog boot scenario I often use
> (which does _not_ protect your window above), which is to enable the
> watchdog in the BIOS.  This is more general protection for the
> boot _up_ process.

Yes, that makes good sense.  In my case, I'm interested in kexec, so
the BIOS isn't involved, so enabling it in the BIOS wouldn't help.

> A related issue I noticed with iTCO_wdt is that something
> else in the kernel disables the iTCO watchdog (which my BIOS had started).
> This is undesirable for obvious reasons.

This sounds related to iTCO, but unrelated to my patch.  Right?

Thanks a lot for your comments!

Bjorn
