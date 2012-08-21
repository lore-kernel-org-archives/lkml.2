Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab2HUNTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:19:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42080 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2HUNTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <1345531207-24926-1-git-send-email-airlied@redhat.com>
References: <1345531207-24926-1-git-send-email-airlied@redhat.com>
Date: Tue, 21 Aug 2012 09:19:04 -0400
Message-ID: <CA+5PVA5sbks_5_G_nWmfjV0Xns93sSr8R+p1jLpQJ8ZBCvOcyA@mail.gmail.com>
Subject: Re: [PATCH] fbcon: fix race condition between console lock and cursor timer
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, kernel-team@fedoraproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 2:40 AM, Dave Airlie <airlied@redhat.com> wrote:
> So we've had a fair few reports of fbcon handover breakage between
> efi/vesafb and i915 surface recently, so I dedicated a couple of
> days to finding the problem.
>
> Essentially the last thing we saw was the conflicting framebuffer
> message and that was all.
>
> So after much tracing with direct netconsole writes (printks
> under console_lock not so useful), I think I found the race.
>
> Thread A (driver load)    Thread B (timer thread)
>   unbind_con_driver ->              |
>   bind_con_driver ->                |
>   vc->vc_sw->con_deinit ->          |
>   fbcon_deinit ->                   |
>   console_lock()                    |
>       |                             |
>       |                       fbcon_flashcursor timer fires
>       |                       console_lock() <- blocked for A
>       |
>       |
> fbcon_del_cursor_timer ->
>   del_timer_sync
>   (BOOM)
>
> Of course because all of this is under the console lock,
> we never see anything, also since we also just unbound the active
> console guess what we never see anything.
>
> Hopefully this fixes the problem for anyone seeing vesafb->kms
> driver handoff.
>
> Signed-off-by: David Airlie <airlied@redhat.com>
> ---
>  drivers/video/console/fbcon.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index 2e471c2..f8a79fc 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -372,8 +372,12 @@ static void fb_flashcursor(struct work_struct *work)
>         struct vc_data *vc = NULL;
>         int c;
>         int mode;
> +       int ret;
> +
> +       ret = console_trylock();
> +       if (ret == 0)
> +               return;
>
> -       console_lock();
>         if (ops && ops->currcon != -1)
>                 vc = vc_cons[ops->currcon].d;
>

I have a Dell XPS 8300 machine with a Radeon card in it that started
showing this problem yesterday with 3.6-rc2 kernels.  I tested this
patch on top of v3.6-rc2-206-g10c63c9 this morning and the problem
seems to have been cleared up for me.  That includes making sure the
grub2 file has the gfxterm set, etc.

I know we've been seeing this quite a bit more on Fedora 17, so we'll
want to have some people test a 3.5 build with it but things are
looking better.

josh
