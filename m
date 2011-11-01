Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1KALZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 07:25:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:59989 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1KALZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 07:25:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,437,1315206000"; 
   d="scan'208";a="84763983"
Date: Tue, 1 Nov 2011 11:36:07 +0000
From: Alan Cox <alan@linux.intel.com>
To: Andrew Worsley <amworsley@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix Corruption issue in USB ftdi driver
 drivers/usb/serial/ftdi_sio.c
Message-ID: <20111101113607.15b254c6@bob.linux.org.uk>
In-Reply-To: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
References: <CA+Y=x3=xEa6XVspsodhbKOArtZ7VMYSMLhpF4WZ1sFNfaJ_E9g@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know why it repeatedly tries to set this all the time - it
> would appear to be quite a lot of work so perhaps there is something
> else that could be cleaned up. This was the simplest safe change that
> fixed my problem. It appears this code hasn't changed very much since
> the first history information in git that I could see - so perhaps
> nobody else is really noticing this issue for some reason?

It could be a problem specific to some firmware or revision. We've had
a similar quirk with a different USB adapter. The actual calls to keep
changing it are coming from your application however.

>         cflag = termios->c_cflag;
> 
> -       /* FIXME -For this cut I don't care if the line is really
> changing or
> -          not  - so just do the change regardless  - should be able
> to
> -          compare old_termios and tty->termios */
> +       /* compare old_termios and tty->termios */
> +    if (old_termios->c_cflag == termios->c_cflag)
> +        goto no_c_cflag_changes;

You can't do it this way because the speed data is not entirely within
c_cflag. Check c_ispeed and c_ospeed match and for the parity if you want to skip
that check if the parity bits change specifically.

Alan
