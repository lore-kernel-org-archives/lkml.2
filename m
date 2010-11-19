Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0KSUmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:42:55 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:58864 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab0KSUmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:42:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=
	mime-version:in-reply-to:references:date:message-id:subject:from
	:to:cc:content-type:content-transfer-encoding; q=dns; s=drama; b=
	Z6ogQDdTChPbHzH3mixubtXfW2ub31d82WrAtCeeBXvJfmaEjNN9TO76IoAT/jb2
	mf/BUmMeFKKWGA/Yw8PrezBHdhOvOnyWMovMnTauUOn6b2DLlCLXXh3PCw+6VaX0
	zqq6F1fT4VeHg/v5ncaOw8IkxTKkj5uLaaVw1KMue3g=
MIME-Version: 1.0
In-Reply-To: <20101119020820.GB18767@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
	<20101117171924.GC12050@kroah.com>
	<AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
	<20101118013002.GC8558@kroah.com>
	<AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
	<20101119020820.GB18767@kroah.com>
Date: Fri, 19 Nov 2010 12:42:51 -0800
Message-ID: <AANLkTim4p=tpaQG_XDE5Vk0YAypYCegAguYNKRg-LeDF@mail.gmail.com>
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
From: Yehuda Sadeh Weinraub <yehuda@hq.newdream.net>
To: Greg KH <greg@kroah.com>
Cc: sage@newdream.net, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 6:08 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 18, 2010 at 02:53:35PM -0800, Yehuda Sadeh Weinraub wrote:
>> Yes, pretty much. One problem that I do see is that if we define the
>> snaps/ as a device (and not just as a kobj) as you suggested before,
>> it'll automatically create a 'uevent' entry under it which can be a
>> real issue in the case we have a snapshot named like that. Shouldn't
>> we just create it as a kobj in that case?
>
> No.  Just use the subdirectory option of an attribute group to handle
> that and you will not need to create any device or kobject with that
> name, the driver core will handle it all automatically for you.
>

One issue with using the groups name, is that it's not nested (unless
I'm missing something), so we can't have it done for the entire
planned hierarchy without holding a kobject on the way. Just a
reminder, the device-specific hierarchy would look like this:

1. /sys/bus/rbd/devices/<id>/
2. /sys/bus/rbd/devices/<id>/<device_attrs>
3. /sys/bus/rbd/devices/<id>/snaps/
4. /sys/bus/rbd/devices/<id>/snaps/<snap_name>/
5. /sys/bus/rbd/devices/<id>/snaps/<snap_name>/<snap_attrs>

One solution would be to create kobjects for (3) and for (4), without
using a group name. Another way, we can create groups for (2), and (3)
under (1), but that's about it, you can't create the snap specific
directory this way without resorting to some internal sysfs directory
creation, which will be horribly wrong. At that point we don't have
anything for 'snaps', and we don't really need to do any operations
under that directory, we just need it to exist so that it contains the
snapshot-specific directories.

Another way would be to create a group for (2) under (1) and create a
kobject for (3), for which you can create group per snapshot.

Am I missing something? We already have the first solution (kobjects
only) implemented, is there some real benefit for using the third
method? We'll have to manually add remove groups anyway, as snapshots
can be removed and new snapshots can be added.

Thanks,
Yehuda
