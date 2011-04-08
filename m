Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab1DHPOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:14:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1DHPOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:14:21 -0400
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device
 names in Kernel.
From: James Bottomley <James.Bottomley@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4D9F1CD1.2020600@suse.de>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110405161400.GA885@kroah.com> <4D9F17DF.5030601@hitachi.com>
	 <4D9F1CD1.2020600@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 08:14:12 -0700
Message-ID: <1302275652.4090.10.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 07:33 -0700, Hannes Reinecke wrote:
> > The problem I would like to discuss here is that users can not identify
> > a disk from kernel messages when they DIRECTLY refer to these messages.
> > For example, a device name is used instead of a symbolic link names in
> > bootup messages, I/O devices errors and /proc/partitions …etc.
> > 
> > In particular, users can not identify an appropriate device from a
> > device name in syslog since different device name may be assigned to it
> > at each boot time.
> > 
> > My idea is able to fix this issue with small changes in scsi subsystem.
> > Also, it is implemented as an option. Therefore, it does not affect
> > users who do not select this option.
> > 
> We have been discussing this problem several times in the past, and
> indeed on these very mailing list.
> 
> The conclusion we arrived at is that the kernel-provided device node
> name is inherently unstable and impossible to fix within the existing
> 'sdX' naming scheme.
> So the choices have been to either move to a totally different naming
> scheme or keep the naming scheme and provide the required information
> by other means.
> We have decided on the latter, and agreed on using udev to provide
> persistent device names.
> We are fully aware that any kernel related messages are subject to
> chance after reboot, but then most kernel related messages are
> (PID number, timestamps, login tty etc).
> And also we are aware that any kernel messages need to be matched
> against the current system layout to figure out any hardware-related
> issue.
> 
> But then basically all products requiring to filter out information
> from kernel messages already do so I don't see a problem with that.
> 
> Just adding an in-kernel identifier to the LUN will only be an
> incomplete solution, as other identifiers will still be volatile.
> 
> So I would prefer by keeping the in-kernel information as small
> as possible to reduce memory consumption and rely on out-of-band
> programs to provide the required mapping.

So, while I agree totally with the above: udev and userspace is the way
to go, I'm not totally opposed to having a non-invasive mechanism for
indicating a user's preferred name for a device.  I think there are a
couple of ways to do this:

     1. Entirely in userspace: just have udev consult a preferred name
        file and create say /dev/disk/by-preferred.  Then have all the
        tools that normally output device information do the same (i.e.
        since real name to preferred name is 1:1, they could all do a
        reverse lookup).
     2. have a writeable sysfs preferred_name field, either in the
        generic device or just in SCSI.  The preferred name would be
        used by outbound only (i.e. kernel dev_printk messages and
        possibly /proc/partitions).  All inbound uses of the device
        would come via the standard udev mechanisms
        (i.e. /dev/disk/by-preferred would be the usual symlink).  This
        means from the kernel point of view, no renaming has happened.
        We'd just try to print out the preferred name in certain
        circumstances, which should solve most of the described problem.

James


