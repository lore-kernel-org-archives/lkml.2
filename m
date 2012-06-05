Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab2FEK5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:57:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62171 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab2FEK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:57:38 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.31.133]
In-Reply-To: <4FCD276A.80505@codeaurora.org>
References: <1337687472-23009-1-git-send-email-ohad@wizery.com>
 <4FBDFC4A.1060602@codeaurora.org> <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
 <4FCD276A.80505@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 5 Jun 2012 13:57:17 +0300
Message-ID: <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 12:23 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> I thought we wanted to allow both calls to proceed in parallel? If we
> don't care about that

Yeah, I don't think we do.

> then "announcing" it once the firmware is found the first time sounds correct.

I agree. Though this patch may be moot very soon due to:

>> The main reason we kept the get/put interface was to make it easier
>> for you guys to adopt it, but I've been re-thinking lately whether we
>> really want that interface. It's a problematic interface with
>> non-negligible maintenance burden, and the code will be greatly
>> simplified without it.
>
> If nobody in the kernel is using it why keep it?

I was concerned that the non get/put interface might not suit
everyone, and I planned to wait for another user or two to show up
before I remove that interface.

Since MSM's PIL is based on a get/put interface, I actually hoped to
see if you guys can adopt the new interface before we ditch the
get/put one.

> If MSM needs we can add it back when we move to rproc.

Thanks - that's the kind of feedback I wanted to get.

> I think we'll need to have some way to describe the resources in the
> kernel when we register the rproc. We aren't going to be able to change
> our firmware to have the resource section.

What about using a separate file for the resource table ?

That should be very easy to support, and may make life easier for you
in the long term.

Resource tables tend to change in time, and hard coding it in the
kernel doesn't sound ideal (both in terms of development overhead, and
kernel-firmware backward and forward compatibility).

> Getting to that point would require changing smd code to be more linux
> device model friendly. We're exploring using virtio over smd (basically
> virtqueues would replace smd APIs while we replace the vrings with smd
> wire protocol).

That sounds good.

> If that works out then we'll be able to attach the smd
> virtio device to the remote proc via some in kernel resource list.

Please consider using an external file for the resource table. That
should give you more flexibility and less overhead.

> One sticking point has been the desire to shut down processors when
> they're not in use and reclaim the memory. Also we would like to upgrade
> the firmware without rebooting the phone. Do you have any plans for
> that? It looks like the current design boots anything that is registered
> and has a matching rpmsg driver. I suppose one solution is to use
> modules but that looks like it disrupts other processors (I don't want
> to rmmod all of rpmsg). We probably need some sort of shutdown/boot
> mechanism that isn't driven entirely by the client drivers.

Does the below work for you (sans the OMAP terminology ;) ?

root@omap4430-panda:/sys/bus/platform/drivers/omap-rproc# echo
omap-rproc.1 > unbind
[  471.376556] remoteproc remoteproc0: releasing ipu_c0
root@omap4430-panda:/sys/bus/platform/drivers/omap-rproc# echo
omap-rproc.1 > bind
[  478.219177] remoteproc remoteproc0: ipu_c0 is available
[  478.224639] remoteproc remoteproc0: Note: remoteproc is still under
development and considered experimental.
[  478.235015] remoteproc remoteproc0: THE BINARY FORMAT IS NOT YET
FINALIZED, and backward compatibility isn't yet guaranteed.
[  478.325347] remoteproc remoteproc0: registered virtio0 (type 7)
[  478.331848] remoteproc remoteproc0: registered virtio1 (type 3)

This way user space can unbind a specific remote processor (which will
also trigger unbinding the entire device hierarchy below it, i.e. all
rpmsg/virtio devices).

Thanks,
Ohad.
