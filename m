Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab2EJWvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:51:48 -0400
Received: from tex.lwn.net ([70.33.254.29]:36758 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab2EJWvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:51:46 -0400
Date: Thu, 10 May 2012 16:51:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120510165144.57a96941@lwn.net>
In-Reply-To: <20120502222724.GB2215@srcf.ucam.org>
References: <20120501110156.2b6e0561@lwn.net>
	<20120501171901.GA26006@srcf.ucam.org>
	<20120501120145.21f65ae2@lwn.net>
	<20120501183149.GA28536@srcf.ucam.org>
	<20120501123923.01ac1138@lwn.net>
	<20120501185455.GA29060@srcf.ucam.org>
	<20120501192736.GA29770@srcf.ucam.org>
	<20120501172454.0e811379@lwn.net>
	<20120502215034.GA622@srcf.ucam.org>
	<20120502160437.5f355fa3@lwn.net>
	<20120502222724.GB2215@srcf.ucam.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012 23:27:24 +0100
Matthew Garrett <mjg@redhat.com> wrote:

> Hm. Well, easiest thing to do would just to be to delete that for the 
> moment and make sure that things work again - beyond that it's me trying 
> to figure out how to write a udev file to do the right thing when I 
> don't have hardware that has this layout. I'll see if I can mock it up.

I get the implied hint there ... :)

Every time I delve into udev I have to learn it all over again.  I've just
done a bit of that.  Looking at the 42-usb-hid-pm-rules file you sent me,
I see this at the end:

ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="removable", GOTO "usb_hid_pm_end"
ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="unknown", GOTO "usb_hid_pm_end"

ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTRS{removable}=="fixed", TEST=="../power/control", ATTR{../power/control}="auto"

LABEL="usb_hid_pm_end"

The two GOTO rules are the ones you've added over what Rawhide provided
me.  By a laborious path I figured out that they were not working as
expected, while if I instead just commented out the final rule my keyboard
was happy again.

Then I looked closer and noticed that they read:

	GOTO "usb_hid_pm_end"

GOTO considered harmful indeed, at least when it's written as above,
instead of:

	GOTO="usb_hid_pm_end"

Once I dug up a couple of spare equals signs and stuffed them in there,
things worked.  Sure was nice of udev to tell me about the problem...

Sorry it took me so long to figure that out, and thanks for the help.  Can
you get the fixed rules into rawhide, or should I go bug somebody?

Thanks,

jon

