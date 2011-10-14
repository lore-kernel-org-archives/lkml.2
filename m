Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1JNQSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:18:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64903 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1JNQR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110141137460.2036-100000@iolanthe.rowland.org>
References: <20111013182827.GL18574@ponder.secretlab.ca> <Pine.LNX.4.44L0.1110141137460.2036-100000@iolanthe.rowland.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Oct 2011 10:17:38 -0600
X-Google-Sender-Auth: 4x-F6zKQ8UZ3avaU5eyItlJZ8mU
Message-ID: <CACxGe6vF6em0-PnJ7UuH0CQ0_StJTfmFKBsktvb9O+ccCx6E8A@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 9:37 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 13 Oct 2011, Grant Likely wrote:
>
>> For the deferred case; here is an example of the additional
>> constraint.  Consider the following hierarchy:
>>
>> -A
>>  +-B
>>  | +-C
>>  | +-D
>>  |
>>  +-E
>>    +-F
>>    +-G
>>
>> dpm_list could be ordered in at least the following ways (depending on
>> exactly when devices get registered).  There are many permutation, but
>> children are always be listed after its direct parent.
>>
>> 1) ABECDFG (breadth first)
>> 2) AEBFGCD (breadth first)
>> 3) ABCDEFG (depth first)
>> 4) AEFGBCD (depth first)
>>
>> Now, assume that device B depends on device F, and also assume that
>> there is no way either to express that in the hierarchy or even for
>> the constraint to be known at device registration time (the is exactly
>> the situation we're dealing with on embedded platforms).  Only the
>> driver for B knows that it needs a resource provided by F's driver.
>> So, the situation becomes that the ordering of dpm_list must now also
>> be sorted so that non-tree dependencies are also accounted for.  Of
>> the list above, only sort order 4 meets the new constraint.
>>
>> The question then becomes, how can the dpm_list get resorted
>> dynamically at runtime to ensure that the new constraints are always
>> met without breaking old ones.  Here are some options I can think of:
>>
>> 1) When a deferred probe succeeds, move the deferred device to the
>> end of the dpm_list.  Then the new sort order might be one of:
>>
>>       1) AECDFGB
>>       2) AEFGCDB
>>       3) ACDEFGB
>>       4) AEFGCDB
>>
>> However, that approach breaks the guarantee that children appear after
>> their parents (C & D appear before B in all cases above)
>
> How can a device acquire children before it has a driver?

There are a few potential situations in embedded systems (or at least
nothing currently prevents it) where platform setup code constructs a
device hierarchy without the aid of device drivers, and it is still
possible for a parent device to be attached to a driver.  IIUC, SPARC
creates an entire hierarchy of platform_devices from all the nodes in
the OpenFirmware device tree, and any of those devices can be bound to
a driver.  I don't like that approach, but at the very least it needs
to be guarded against.

On Fri, Oct 14, 2011 at 9:39 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 13 Oct 2011, Grant Likely wrote:
>> I saw those.  I also notice that they are only used by device_move()
>> when reparenting a device (which is another wrinkle I hadn't though
>> about).  Reparenting a device becomes problematic if the probe order
>> is also represented in the list.  If device_move() gets called, then
>> any implicit probe-order sorting for that device would be lost.
>>
>> I also notice that device_move disregards any children when moving a
>> device, which could also be a problem.
>>
>> Although it looks like the only users of device_move are:
>>
>> drivers/media/video/pvrusb2/pvrusb2-v4l2.c
>> drivers/s390/cio/device.c
>> net/bluetooth/hci_sysfs.c
>> net/bluetooth/rfcomm/tty.c
>>
>> So it may not be significant to adapt.
>
> I trust that very little will be needed.  I haven't checked the
> existing callers, but it's reasonable to require that a device being
> moved not have any children.

Yes, that does indeed simplify the issue considerably.  Let's do that.
 So, for this patch, there will be two bits added.  First, don't allow
deferral on devices with children, and second a successful probe
(deferred or otherwise) should always move a device to the end of the
dap_list if it doesn't have children to guarantee that the list order
satisfies both the hierarchical and probe order.  Manjunath, do you
think you can prototype this?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
