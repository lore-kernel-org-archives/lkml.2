Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1JHPzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 11:55:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54327 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1JHPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 11:55:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=LNwmNFGPpfu654FaRwe646vzV7/h6EEnVVIg1Xk4ThL5Z3WfZCUTOAGoHtfXow3uw
	irmAeRCWmU/iyvFolb3WQ==
MIME-Version: 1.0
In-Reply-To: <4E900E9E.2070604@gmail.com>
References: <1318024753-15336-1-git-send-email-dianders@chromium.org>
	<4E900E9E.2070604@gmail.com>
Date: Sat, 8 Oct 2011 08:55:32 -0700
X-Google-Sender-Auth: foOXc157nE2gkgKP_RnMQKhnuKw
Message-ID: <CAD=FV=U2H08ohbgmDxWNPkh8bm8uBPt-2_H2B4cSb9LvEFWdHA@mail.gmail.com>
Subject: Re: [PATCH] TTY: serial_core: Fix crash if agetty() run on
 non-console serial port
From: Doug Anderson <dianders@chromium.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 1:49 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> I cannot reproduce this. What uart driver is this with? And where does
> it call uart_suspend_port from? Basically, it would mean that it calls
> uart_suspend_port while userspace is still running? Or who HUPs the port
> (the second point in your list)?

Thank you for testing!  I am working with the 8250 driver controlling
the onboard UART on an nVidia Tegra T25 (ARM).

You raise very good questions, and I'm happy to keep tracking down to
continue to look for a deeper root cause.  I continued to do some more
testing of this patch (with the help of a few others) after posting
the list.  We tried the same setup on an x86-based board and the HUP
doesn't show up.  ...so my patch wasn't needed on that board (although
my patch didn't hurt).  ...that means, as you already pointed out,
that the HUP must _not_ be coming from userspace.

Probably the true bug in my system is that a spurious HUP is being
generated as a result of the suspend.  That is probably platform
dependent and would explain why this hasn't been a bigger problem for
others.


...however, even though my patch shouldn't be needed for any hardware
that doesn't generate the spurious HUP, it might still be worthwhile
to consider including it?  ...or perhaps changing it to a BUG_ON or
WARN_ON to at least detect the case of running the shutdown code after
the suspend code?  Definitely the case that I ran into (shutdown after
suspend) will definitely cause a crash during resume.


I will spend time on Monday digging into the source of the HUP and
will post a followup.

-Doug
