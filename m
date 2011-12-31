Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1LaUPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 15:15:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45204 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1LaUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 15:15:47 -0500
Date: Sat, 31 Dec 2011 20:15:39 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: drahemmaps@gmx.net, davej@redhat.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, linux-usb@vger.kernel.org
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20111231201538.GA29758@srcf.ucam.org>
References: <20111231150133.280130@gmx.net>
 <CA+55aFyFuKVgzuOuszb+UyCh98R2TZ_QiS0TCWJjJX5zEwLSWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyFuKVgzuOuszb+UyCh98R2TZ_QiS0TCWJjJX5zEwLSWw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 31, 2011 at 11:29:56AM -0800, Linus Torvalds wrote:

> But what the driver *should* be doing is to load the firmware at
> device open time (NOT at "driver load time" - because that can and
> does happen too early too, for the case of built-in drivers!) and
> simply keep the firmware around in the case of a suspend/resume event,
> so that it doesn't have to re-load it off a disk (or network, or
> whatever) that hasn't been resumed yet!

That doesn't work for the isight firmware loader - there's nothing for 
userspace to open until the device has had the firmware loaded, at which 
point it detaches and reattaches as a UVC device. The code could be 
merged into the UVC driver and a fake v4l device exposed, but even then 
you'd still need to deal with the underlying usb_device suddenly 
changing under you.

So for this specific case, I'd like to track down why the behaviour has 
changed - if the device was previously maintaining state over suspend 
and now isn't then that's something that's broken, but if it's just that 
some ordering has changed and now it's losing a race, I'll need to fix 
it in the driver. One option would be to do away with the kernelspace 
loader entirely and push it out to a udev helper, or alternatively just 
have the driver stash the firmware all the time.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
