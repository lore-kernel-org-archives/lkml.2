Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab0KWAs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:48:59 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:47762 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab0KWAs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:48:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=
	mime-version:in-reply-to:references:date:message-id:subject:from
	:to:cc:content-type:content-transfer-encoding; q=dns; s=drama; b=
	ARQy9bTp8O5jQosTMyOrR6UJWKUFCFn29CdeIN03n/W2nz+vYUTuRLC0BoK+hVAO
	sbnIy5Zh2qqChNF9kdM+c+p1433HBDtTiIa/mBA4yFqlzSTzD9H1JM1R43IK4hdB
	VaaU35p0cxoVv4gBaoiqGT6KkvZ6ocOKS0b3ghHvB0o=
MIME-Version: 1.0
In-Reply-To: <20101123001410.GA31294@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
	<20101117171924.GC12050@kroah.com>
	<AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
	<20101118013002.GC8558@kroah.com>
	<AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
	<20101119020820.GB18767@kroah.com>
	<AANLkTim4p=tpaQG_XDE5Vk0YAypYCegAguYNKRg-LeDF@mail.gmail.com>
	<20101123001410.GA31294@kroah.com>
Date: Mon, 22 Nov 2010 16:48:54 -0800
Message-ID: <AANLkTi=n9aJ_8VAcyOXQxxeprWzerZLf0H+ryHZs7O04@mail.gmail.com>
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

On Mon, Nov 22, 2010 at 4:14 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 19, 2010 at 12:42:51PM -0800, Yehuda Sadeh Weinraub wrote:
>> On Thu, Nov 18, 2010 at 6:08 PM, Greg KH <greg@kroah.com> wrote:
>> > On Thu, Nov 18, 2010 at 02:53:35PM -0800, Yehuda Sadeh Weinraub wrote:
>> >> Yes, pretty much. One problem that I do see is that if we define the
>> >> snaps/ as a device (and not just as a kobj) as you suggested before,
>> >> it'll automatically create a 'uevent' entry under it which can be a
>> >> real issue in the case we have a snapshot named like that. Shouldn't
>> >> we just create it as a kobj in that case?
>> >
>> > No.  Just use the subdirectory option of an attribute group to handle
>> > that and you will not need to create any device or kobject with that
>> > name, the driver core will handle it all automatically for you.
>> >
>>
>> One issue with using the groups name, is that it's not nested (unless
>> I'm missing something), so we can't have it done for the entire
>> planned hierarchy without holding a kobject on the way. Just a
>> reminder, the device-specific hierarchy would look like this:
>>
>> 1. /sys/bus/rbd/devices/<id>/
>> 2. /sys/bus/rbd/devices/<id>/<device_attrs>
>> 3. /sys/bus/rbd/devices/<id>/snaps/
>> 4. /sys/bus/rbd/devices/<id>/snaps/<snap_name>/
>> 5. /sys/bus/rbd/devices/<id>/snaps/<snap_name>/<snap_attrs>
>>
>> One solution would be to create kobjects for (3) and for (4), without
>> using a group name.
>
> Ick, no.
>
>> Another way, we can create groups for (2), and (3)
>> under (1), but that's about it,
>
> attribute group for 2 is fine.
>
>> you can't create the snap specific directory this way without
>> resorting to some internal sysfs directory creation, which will be
>> horribly wrong. At that point we don't have anything for 'snaps', and
>> we don't really need to do any operations under that directory, we
>> just need it to exist so that it contains the snapshot-specific
>> directories.
>
> But you need to do something with those snapshots, right?  So, why even
> have "snaps" be a subdir?  Why not just make <snap_name> a struct device
> with <id> being the parent, and it living on the same bus_type, but
> being a different device_type (like partitions and block devices are),

The reason we keep snapshots in a separate subdirectory is that they
can have arbitrary name. So either we prefix them and put them in a
common namespace with the devices, or we put them down the hierarchy.
In any case we don't do any operations on them, we just have them for
informational use and we put them there so that we don't have one big
file that lists them all.

>
>> Another way would be to create a group for (2) under (1) and create a
>> kobject for (3), for which you can create group per snapshot.
>>
>> Am I missing something? We already have the first solution (kobjects
>> only) implemented, is there some real benefit for using the third
>> method? We'll have to manually add remove groups anyway, as snapshots
>> can be removed and new snapshots can be added.
>
> Never add kobjects to a struct device, that is showing you that
> something is wrong, and that userspace really will want to get that
> create/destroy event of the sub child.
>

But they're there as information device attributes, it's nothing like
partitions in block devices. So we want to just be able to list them
and their attributes easily (and nicely), without having to put them
in one big file.

Yehuda
