Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1GLRW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:22:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29850 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1GLRW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:22:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Sgs2b0t8nTveGuFUyIDW8TZgaMnvaLGSYvjwqTTs5LkJ/FqrMJiAZtxwyu/SDAbD7
	CUU7ws0cBbrxeuM1Srg6A==
MIME-Version: 1.0
In-Reply-To: <4E15D67B.2080405@draigBrady.com>
References: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
 <20110706160936.4002.1846.stgit@bhelgaas.mtv.corp.google.com>
 <12164.1310053141@turing-police.cc.vt.edu> <4E15D67B.2080405@draigBrady.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Jul 2011 11:22:33 -0600
Message-ID: <CAErSpo51_q9nB+eU8VFmz-LJf16KFeKxKR_TWRWDQ4P9gOnP6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] watchdog: iTCO_wdt: optionally leave watchdog enabled
 during restart
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: Valdis.Kletnieks@vt.edu, Wim Van Sebroeck <wim@iguana.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 9:53 AM, Pádraig Brady <P@draigbrady.com> wrote:
> On 07/07/11 16:39, Valdis.Kletnieks@vt.edu wrote:
>> On Wed, 06 Jul 2011 10:09:36 MDT, Bjorn Helgaas said:
>>
>>> If we reboot via BIOS, BIOS should disable the watchdog itself, so this
>>> shouldn't cause unintended resets, even if the user interrupts the boot.
>>
>> Yes, but didn't Linus say something about BIOS code authors being
>> crack-addicted monkeys? :)

I shouldn't have written anything about what BIOS "should" do.  That's
not very useful because, as you suggest, there is room for variation
there.

The risk I was alluding to was this:
  - User boots with "reboot_timeout=X"
  - User reboots normally (non-kexec)
  - BIOS does some reinitialization
  - Machine doesn't autoboot, e.g., because user interrupted boot
  - Watchdog resets machine -- this may be unexpected by the user

On the machines I tested, the unexpected reset doesn't happen because
the BIOS reinit includes disabling the watchdog.  But obviously, that
depends on BIOS details, so there's no guarantee.

I should have just written something along the lines of:

  The reboot_timeout option is intended for kexec reboots, which do
not involve BIOS.
  In this case, the reboot_timeout covers the interval between shutdown of the
  watchdog driver in the old kernel and startup of the driver in the new kernel.

  For normal reboots (via the BIOS), the behavior depends on the BIOS
implementation.
  Some BIOSes disable the watchdog timer, so the reboot_timeout only covers the
  interval until the BIOS disable.  Others leave the timer running, so
the reboot_timeout
  may cause a reset if the machine doesn't autoboot, e.g., if the user
interrupts the boot.

I think the *option* of using a reboot_timeout is still useful,
especially in clusters of unattended machines where it's expensive to
deal with boot failures.

> Yes as I said in a round about way in another mail,
> one can't depend on that at all.
> Some reset, some don't, some behave weirdly,
> iTCO is unusual as kernel resets early at boot, ...

You mentioned an unexplained iTCO reset in your other mail.  That
sounds like a kernel or iTCO_wdt bug, but I think it's unrelated to
this patch.

> If using this, one would have to set the timeout large enough,
> to encompass a full reboot

Right.  In the case of iTCO, I think the range is up to about 10
minutes, which is enough in my case (things like fsck may take longer,
but that's OK as long as the watchdog driver is built in statically).

Bjorn
