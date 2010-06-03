Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab0FCJz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:55:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58382 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758097Ab0FCJz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:55:56 -0400
Date: Thu, 3 Jun 2010 11:03:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Gross, Mark" <mark.gross@intel.com>
Cc: Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603110312.48a508dc@lxorguk.ukuu.org.uk>
In-Reply-To: <CA1BBBBC9359F04AA639128AC0D5D1E9692ABC92@orsmsx502.amr.corp.intel.com>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	<1275451342.21962.1777.camel@mulgrave.site>
	<AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
	<1275491111.2799.110.camel@mulgrave.site>
	<20100602214748.7742e3ae@schatten.dmk.lab>
	<1275511271.2799.516.camel@mulgrave.site>
	<20100603010607.5baf82a6@schatten.dmk.lab>
	<CA1BBBBC9359F04AA639128AC0D5D1E9692ABC92@orsmsx502.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [mtg: ] This has been a pain point for the PM_QOS implementation.  They change the constrain back and forth at the transaction level of the i2c driver.  The pm_qos code really wasn't made to deal with such hot path use, as each such change triggers a re-computation of what the aggregate qos request is.

That should be trivial in the usual case because 99% of the time you can
hot path

	the QoS entry changing is the latest one
	there have been no other changes
	If it is valid I can use the cached previous aggregate I cunningly
		saved in the top QoS entry when I computed the new one

(ie most of the time from the kernel side you have a QoS stack)

> We've had a number of attempts at fixing this, but I think the proper fix is to bolt a "disable C-states > x" interface into cpu_idle that bypases pm_qos altogether.  Or, perhaps add a new pm_qos API that does the equivalent operation, overriding whatever constraint is active.

We need some of this anyway for deep power saving because there is
hardware which can't wake from soem states, which in turn means if that
device is active we need to be above the state in question.

