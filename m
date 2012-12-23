Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab2LWOI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 09:08:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2LWOIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 09:08:55 -0500
Date: Sun, 23 Dec 2012 12:08:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [Regression w/ patch] Media commit causes user space to
 misbahave (was: Re: Linux 3.8-rc1)
Message-ID: <20121223120822.233282ba@redhat.com>
In-Reply-To: <2183382.xv2VGtqdUf@vostro.rjw.lan>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
	<2183382.xv2VGtqdUf@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 23 Dec 2012 14:39:32 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> escreveu:

> Hi Laurent,
> 
> Commit f0ed2ce ([media] uvcvideo: Set error_idx properly for extended
> controls API failures) of yours unfortunately causes user space to misbehave
> on one of my test systems.  Namely, there's no sound under KDE 4.9.4
> (Tumbleweed version using pulseaudio) and there's a knotify4 process occupying
> one of the CPU cores entirely 100% of the time.
> 
> I used the patch below to fix the problem for me.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: [media]: Revert part of commit f0ed2ce to fix user space breakage
> 
> Commit f0ed2ce ([media] uvcvideo: Set error_idx properly for extended
> controls API failures) causes user space to behave incorrectly on one
> of my test machines (there is no sound under KDE 4.9.4 using
> pulseaudio and there is a knotify4 process occupying one of the CPU
> cores 100% of the time).  Reverting that commit entirely fixes the
> problem for me.
> 
> However, commit f0ed2ce appears to do more than it follows from its
> changelog, because the changelog only says about the changes related
> to ctrls->error_idx, while the commit additionally changes error
> codes returned by various functions in uvc_ctrl.c and uvc_v4l2.c.  It
> turns out that the changes of the returned error codes confuse the
> user spce, so it is sufficient to revert the part of commit f0ed2ce
> not mentioned in its changelog to fix the problem.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c |   19 ++++++++-----------
>  drivers/media/usb/uvc/uvc_v4l2.c |   12 +++++-------
>  2 files changed, 13 insertions(+), 18 deletions(-)
> 
> Index: linux/drivers/media/usb/uvc/uvc_ctrl.c
> ===================================================================
> --- linux.orig/drivers/media/usb/uvc/uvc_ctrl.c
> +++ linux/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1061,7 +1061,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video
>  
>  	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
>  	if (ctrl == NULL) {
> -		ret = -ENOENT;
> +		ret = -EINVAL;
>  		goto done;
>  	}
...

Rafael,

Are you saying that pulseaudio is entering on some weird loop if the
returned value is not -EINVAL? That seems a bug at pulseaudio.

Btw, why pulseaudio is even trying to access a V4L2 control? 
I would expect an audio application to take care of its own audio
business, and to not try to access other random Kernel APIs.

In other words, only an application that handles video should be
using those controls, and as far as I know, pulseaudio is not a
such application. Or are it trying to do world domination?

So, on a first glance, this doesn't sound like a regression, 
but, instead, it looks tha pulseaudio/tumbleweed has some serious
bugs and/or regressions.

Regards,
Mauro
