Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab2FDVX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:23:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20029 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2FDVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:23:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6732"; a="197613589"
Message-ID: <4FCD276A.80505@codeaurora.org>
Date: Mon, 04 Jun 2012 14:23:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] remoteproc: block premature rproc booting
References: <1337687472-23009-1-git-send-email-ohad@wizery.com> <4FBDFC4A.1060602@codeaurora.org> <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
In-Reply-To: <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/12 13:11, Ohad Ben-Cohen wrote:
>
>> Would it suffice to
>> have some new rproc->state like RPROC_UNKNOWN that we set in
>> rproc_register() before adding it to the list of rprocs? If we find the
>> firmware then we set it to RPROC_READY or RPROC_REGISTERED? Then we
>> wait_for_completion() and check the state, failing if it's still in the
>> unknown state.
> That makes me think - what if we'll add the rproc to the list only
> after we find the firmware? This way we avoid this race completely.

I thought we wanted to allow both calls to proceed in parallel? If we
don't care about that then "announcing" it once the firmware is found
the first time sounds correct.

>
> Speaking of which, I was wondering whether you guys have some free
> cycles to try remoteproc out.

I want to try it out but I've not had enough free time to do so.

>
> The main reason we kept the get/put interface was to make it easier
> for you guys to adopt it, but I've been re-thinking lately whether we
> really want that interface. It's a problematic interface with
> non-negligible maintenance burden, and the code will be greatly
> simplified without it.

If nobody in the kernel is using it why keep it? If MSM needs we can add
it back when we move to rproc.

>
> Even if you guys won't be adopting virtio (of any other
> virtio-over-smd variant) - do you think you'll be able to adopt a
> similar model with which remoteproc registers, according to the fw
> capabilities, the relevant devices which then get bound to the
> relevant higher-level drivers (virtio drivers, smd drivers, etc..) ?
> That way these devices can point to the rproc context and we don't
> need any get_by_name interface.

I think we'll need to have some way to describe the resources in the
kernel when we register the rproc. We aren't going to be able to change
our firmware to have the resource section. It would probably just be one
device (the equivalent of the rpmsg device but for smd channels).
Everything else would build on top of the smd virtio device.

Getting to that point would require changing smd code to be more linux
device model friendly. We're exploring using virtio over smd (basically
virtqueues would replace smd APIs while we replace the vrings with smd
wire protocol). If that works out then we'll be able to attach the smd
virtio device to the remote proc via some in kernel resource list. Then
I imagine when the rproc registers we'll add the device directly. We
need to figure out some way to delay loading of the firmware at that
point. I guess it means we'll need to move both firmware requests to be
async and the first firmware request to get the resource table will be
skipped on MSM.

One sticking point has been the desire to shut down processors when
they're not in use and reclaim the memory. Also we would like to upgrade
the firmware without rebooting the phone. Do you have any plans for
that? It looks like the current design boots anything that is registered
and has a matching rpmsg driver. I suppose one solution is to use
modules but that looks like it disrupts other processors (I don't want
to rmmod all of rpmsg). We probably need some sort of shutdown/boot
mechanism that isn't driven entirely by the client drivers.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

