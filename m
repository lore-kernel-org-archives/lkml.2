Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1DLJJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:09:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42546 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab1DLJJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TAiKmvz9lZGZgm83Mz7vNjR8pcQssCqozEvRZ+e/XdUMgRAq0LY1F+WNuujEPxFHmW
         BPdhwzqoA9fjaE2q1dDgIlL0co8IlQxFqwgtC/8wV0zqeU00mkJjVURX4lShmh9b8vV8
         yX1e2Y6p37wisgv1uIAlD80Ze9+SG2qEaIhek=
MIME-Version: 1.0
In-Reply-To: <1526578879.12280.1302513088278.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <BANLkTi=DGfKuapLhvt62UVG_h7fzsRRo3g@mail.gmail.com>
	<1526578879.12280.1302513088278.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Date: Tue, 12 Apr 2011 10:09:12 +0100
Message-ID: <BANLkTim9jfB1fNq23n9FG4VuJJawTXj-6g@mail.gmail.com>
Subject: Re: [PATCH] virtio: decrement dev_index when device is unregistered
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Takuma Umeya <tumeya@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:11 AM, Takuma Umeya <tumeya@redhat.com> wrote:
> ----- Original Message -----
>> On Tue, Apr 5, 2011 at 5:49 AM, Takuma Umeya <tumeya@redhat.com>
>> wrote:
>> > When virtio device is removed, dev_index does not get decremented.
>> > The next device hotplug event results in consuming the next pci to
>> > the one that is suppose to be available.
>> >
>> > Signed-off-by: Takuma Umeya <tumeya@redhat.com>
>> >
>> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> > index efb35aa..67fe71d 100644
>> > --- a/drivers/virtio/virtio.c
>> > +++ b/drivers/virtio/virtio.c
>> > @@ -216,6 +216,7 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
>> >  void unregister_virtio_device(struct virtio_device *dev)
>> >  {
>> >        device_unregister(&dev->dev);
>> > + dev_index--;
>>
>> I don't think there is any guarantee that virtio devices are
>> added/removed in first-in-last-out order.
>>
>> That means I could add a virtio-net device (index 0) followed by a
>> virtio-blk device (index 1). Now I remove the virtio-net device
>> (index 0) which causes me to decrement dev_index and hand index 1 out
>> again to the next device. This leaves us with virtio-blk (index 1)
>> and the new device with index 1, which is not unique.
>>
>> Perhaps I missed a constraint which prevents this from occurring?
> I believe the address is assigned up to 1f so using u32 value
> to track use/free. This should make the code immune to the scenario.
> Would this be adequate?

This issue was also brought up by Jens Axboe on your other patch for
virtio block devices.  He suggested using idr.  I think that would be
a nicer solution than a u32 bitfield.

I'm not sure where you got 0x1f from but that seems like an artifical
limitation.  Nothing should stop us from having more virtio devices.

Stefan
