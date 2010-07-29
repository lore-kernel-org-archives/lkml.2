Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0G2QHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:07:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49180 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab0G2QHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <20100729145827.GB1981@nb.net.home>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 
	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 
	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> 
	<20100729145827.GB1981@nb.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 29 Jul 2010 18:07:31 +0200
Message-ID: <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com>
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 16:58, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Jul 29, 2010 at 04:22:50PM +0200, Kay Sievers wrote:
>> On Thu, Jul 29, 2010 at 16:06, Milan Broz <mbroz@redhat.com> wrote:
>> > On 07/29/2010 03:47 PM, Kay Sievers wrote:
>> >> On Thu, Jul 29, 2010 at 15:33, Milan Broz <mbroz@redhat.com> wrote:
>> >>> Create /sys/block/loopX/loop directory and provide these attributes:
>> >>>  - backing_file
>> >>>  - autoclear
>> >>>  - offset
>> >>>  - sizelimit
>> >>>
>> >>> To be used in util-linux-ng (and possibly elsewhere like udev rules)
>> >>> where code need to get loop attributes from kernel (and not store
>> >>> duplicate info in userspace).
>> >>
>> >> Isn't it that the loop attributes are created _after_ the loopdev is
>> >> registered? That would make it hard to use these attributes from udev,
>> >> as the event is already running while they are created.
>> >
>> > First 8 loop devices are registered always (without backing file),
>> > so you have wait for change event initiated from fd set ioctl anyway...
>> > (backing file attribute is empty in that case)
>>
>> Ah, so we are sure, we always get a 'change' event, and before that,
>> none of these values are ever useful to read? I mean, there will not
>> be attributes that are interesting during an 'add' event?
>
> I think the patch does not change the current behavior. It exports
> details about loopdevs to userspace by /sys. This is the primary goal
> of the patch.

Sure it does. Sysfs attributes need to be created _before_ uevents are
sent out. The current behavior is that all blockdev attributes are
safely created before the event is sent. These loop attributes are
created _after_ the event is sent.

The question is if we can rely on the fact, that 'add' events never
want to look at any of these attributes, and all can be deferred to
later 'change' events. If we can't be fully certain about this, this
stuff must be changed to happen before the event for the blockdev is
sent out.

Kay
