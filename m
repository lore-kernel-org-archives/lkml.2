Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab1CDV7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:59:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34258 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757Ab1CDV7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:59:18 -0500
Date: Fri, 4 Mar 2011 21:59:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304215915.18199ce1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110304212851.GB28680@kroah.com>
References: <20110303204749.GY3663@linux.intel.com>
	<20110303211336.GA32645@kroah.com>
	<20110303214104.GZ3663@linux.intel.com>
	<20110303215155.GA30451@kroah.com>
	<20110303220735.GA3663@linux.intel.com>
	<20110303222226.GA30966@kroah.com>
	<20110304124348.6419c661@lxorguk.ukuu.org.uk>
	<20110304212851.GB28680@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And non-automated loading of firmware as well.  Dell uses this for
> updating their BIOSes just fine, with a userspace tool that initiates
> the loading of the firmware.

Try using the Dell tool with namespaces.

> How does Dell do it?

How do most other apps do it.

> So, what could be changed in the current firmware interface to fix this
> problem in a manner which would solve these perceived issues?

I'm not sure it can. The basis of the interface is driver requests
firmware. That is done by using a pathname which in a namespaced
environment isn't global and has races

(Several things break quite spectacularly if you request_firmware while
updating a package, but of course nobody considered such details even for
automatic stuff in many cases. Really there is some locking needed).

For manual updating of a block of firmware the interface most stuff wants
is

	copy_from_user()

or if you wanted to wrap it up nicely

	x = vmalloc_from_user(void __user *ptr, ssize_t len);

The app knows which firmware it is talking about and can inspect and
compare it while holding an open file handle on the deivce. That protects
against hotplug races and getting the wrong device second access, and
ensures that the firmware, device and userspace are all talking about
exactly the same thing.

It would nice to say "its an obscure corner case that will just error",
but far too much hardware still gets semi permanently (or permanently)
converted into junk if you goof a permanent flash firmware update.

