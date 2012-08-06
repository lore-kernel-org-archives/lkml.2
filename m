Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2HFIDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 04:03:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab2HFIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 04:03:15 -0400
Message-ID: <501F7A3F.808@canonical.com>
Date: Mon, 06 Aug 2012 10:03:11 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: linaro-mm-sig@lists.linaro.org, rob.clark@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] dma-fence: dma-buf synchronization (v5)
References: <20120727133952.2036.61330.stgit@patser.local> <CAO_48GGBdb4D+YMS4NYVPxxhUrHLcQdZEpi_rmypoGPXYtAyrg@mail.gmail.com>
In-Reply-To: <CAO_48GGBdb4D+YMS4NYVPxxhUrHLcQdZEpi_rmypoGPXYtAyrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Sumit,

Op 06-08-12 08:41, Sumit Semwal schreef:
> Hi Maarten,
> On 27 July 2012 19:09, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> A dma-fence can be attached to a buffer which is being filled or consumed
>> by hw, to allow userspace to pass the buffer without waiting to another
>> device.  For example, userspace can call page_flip ioctl to display the
>> next frame of graphics after kicking the GPU but while the GPU is still
>> rendering.  The display device sharing the buffer with the GPU would
>> attach a callback to get notified when the GPU's rendering-complete IRQ
>> fires, to update the scan-out address of the display, without having to
>> wake up userspace.
> Since Rob is the original author of this (and I the next?), may I
> request you to re-submit with his "From:" bit?
>
> Rob / Daniel: comments on this series will help me line it up in
> for-next, and maybe even for 3.7-rc.
>
It's a bit of a collaboration actually, I have done a few minor tweaks
on top of the version I sent out for RFC, making it v6. I will send it
somewhere this week, but I wanted to be sure that it worked with the
Xorg server first, instead of just my minor testsuit:

v6: [ Maarten Lankhorst ] I removed dma_fence_cancel_callback and some comments
    about checking if fence fired or not. This is broken by design.
    waitqueue_active during destruction is now fatal, since the signaller
    should be holding a reference in enable_signalling until it signalled
    the fence. Pass the original dma_fence_cb along, and call __remove_wait
    in the dma_fence_callback handler, so that no cleanup needs to be
    performed.

I have created a few minor testcases that seemed to have shown that the i915 parts
work. It also shows that a race-free remove wait early is hard, and should
preferably not be done unless a fatal hardware error occurred.

Tree is currently at:
http://cgit.freedesktop.org/~mlankhorst/linux/log/

And is based on drm-next + some fixes from nouveau. The reason why is that I
need some patches from drm-intel-next for flushing list removal.

It will likely also interact with the deferred fput if it's still in the -next
tree, however it should hopefully not be a problem, since the best thing about
it is that deferred fput will fix a few deadlocks. :)

I want to test it some more first to see that no deadlocks occur, but the
final version for the nouveau series will have to be rewritten, since the
maintainer dropped a massive 'rewrite everything' patch series. However,
when I finish testing later this week against real Xorg instead of my,
smaller testcases, I'll be more confident that nothing major will break
and that the base and intel parts are ready for -next.
 
Cheers,
~Maarten

