Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab2EXUL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:11:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51905 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab2EXULz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:11:55 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.77.34]
In-Reply-To: <4FBDFC4A.1060602@codeaurora.org>
References: <1337687472-23009-1-git-send-email-ohad@wizery.com> <4FBDFC4A.1060602@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 24 May 2012 23:11:34 +0300
Message-ID: <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, May 24, 2012 at 12:15 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> The request_firmware timeout is defaulted to 60 seconds but not
> necessarily 60 if the user has changed the timeout in sysfs.
..
> Why does this need to be a timeout at all? Presumably
> request_firmware_nowait() in rproc_register() will timeout and complete
> the firmware_loading_complete completion variable.

Very good points, thanks for pointing them out!

> Would it suffice to
> have some new rproc->state like RPROC_UNKNOWN that we set in
> rproc_register() before adding it to the list of rprocs? If we find the
> firmware then we set it to RPROC_READY or RPROC_REGISTERED? Then we
> wait_for_completion() and check the state, failing if it's still in the
> unknown state.

That makes me think - what if we'll add the rproc to the list only
after we find the firmware? This way we avoid this race completely.

Speaking of which, I was wondering whether you guys have some free
cycles to try remoteproc out.

The main reason we kept the get/put interface was to make it easier
for you guys to adopt it, but I've been re-thinking lately whether we
really want that interface. It's a problematic interface with
non-negligible maintenance burden, and the code will be greatly
simplified without it.

Even if you guys won't be adopting virtio (of any other
virtio-over-smd variant) - do you think you'll be able to adopt a
similar model with which remoteproc registers, according to the fw
capabilities, the relevant devices which then get bound to the
relevant higher-level drivers (virtio drivers, smd drivers, etc..) ?
That way these devices can point to the rproc context and we don't
need any get_by_name interface.

Thanks,
Ohad.
