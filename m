Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0LATsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:48:17 -0500
Received: from kroah.org ([198.145.64.141]:51888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab0LATsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:48:16 -0500
Date: Wed, 1 Dec 2010 11:47:51 -0800
From: Greg KH <greg@kroah.com>
To: Sage Weil <sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
Message-ID: <20101201194751.GA1171@kroah.com>
References: <AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
 <20101118013002.GC8558@kroah.com>
 <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
 <20101119020820.GB18767@kroah.com>
 <AANLkTim4p=tpaQG_XDE5Vk0YAypYCegAguYNKRg-LeDF@mail.gmail.com>
 <20101123001410.GA31294@kroah.com>
 <AANLkTi=n9aJ_8VAcyOXQxxeprWzerZLf0H+ryHZs7O04@mail.gmail.com>
 <20101123005838.GB29289@kroah.com>
 <1290558233.1792.73.camel@yehudasa-desktop>
 <Pine.LNX.4.64.1012011117460.8183@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1012011117460.8183@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 11:25:16AM -0800, Sage Weil wrote:
> Hi Greg,
> 
> I'm sure you're busy and as tired of this thread as we are, but I think
> it's close and we have (I hope) just one remaining question.  The current
> patch (see below) gives us

Sorry, I got distracted by a snowstorm knocking out my power for a few
days and then a holliday :)

>  /sys/bus/rbd/{add,remove}
>  /sys/bus/rbd/devices/<devid>/                 <-- struct device
>  /sys/bus/rbd/devices/<devid>/{some dev attrs}
>  /sys/bus/rbd/devices/<devid>/snap_<snapid>/   <-- struct device
>  /sys/bus/rbd/devices/<devid>/snap_<snapid>/{some snap attrs}
> 
> This works, and I is (I hope) using struct device properly.  The only 
> problem, purely from a user interface standpoint, is that the snaps are 
> mixed in with attributes, so anybody wanting to iterate over snaps needs 
> to do something crufty like
> 
>  $ for snap in `ls /sys/bus/rbd/devices/$id | grep ^snap_ | cut -c 6-`; do ...

What's wrong with:
	for snap in `ls /sys/bus/rbd/devices/$id/snap_*`; do ...
instead?

And you would be using libudev ideally for a .c file, and iterating over
the devices is pretty trivial that way from what I have seen.

> Adding an intermediate snaps/ subdir would let them instead do
> 
>  $ for snap in `ls /sys/bus/rbd/devices/$id/snaps/`; do ...
> 
> without worrying about the (arbitrarily named) snaps from colliding with 
> device attributes.  Assuming that is a preferable interface, is the 
> "right" way to do that to make "snaps" a struct device?  Or is there a 
> good reason why that is not preferable?

It's not preferable as that "snaps" directory is a "blank" in the device
tree, not showing the heiarchy properly.  You can't walk the devices
back from the devices in snaps/ to the parent properly (i.e. you would
get stuck at the snaps/ directory as it's not a struct device, but a
random kobject.

Hope this helps,

greg k-h
