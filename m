Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1FTXDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:03:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1FTXDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jVVnrppxk7l1PH0cckccyrmszrBIaYyzrwqIq1F35mM5QRmLd++3KsIvoshMIoZ/xK
         cYNguPWx+vJNnz0BCxlQ==
Date: Mon, 20 Jun 2011 16:03:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: Dave Airlie <airlied@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Olof Johansson <olofj@chromium.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Chris Fowler <cfowler@opsdc.com>
Subject: Re: Regression in panic
In-Reply-To: <BANLkTingstCoWk0H20nN1J7t3H=mndSdnL2YpeW2R46fhL2kpA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106201601220.15259@chino.kir.corp.google.com>
References: <BANLkTingstCoWk0H20nN1J7t3H=mndSdnL2YpeW2R46fhL2kpA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Mandeep Singh Baines wrote:

> Hi Dave,
> 
> I think this change is causing a regression I'm seeing in panic.
> Before this change, I'd get a
> reboot on panic (we've configured as such).
> 
> With this change, my machine gets wedged if the machine is running in
> X when the panic occurs.
> 
> I traced the code flow to this:
> 
> bust_spinlocks(0);
>  ->unblank_screen();
>    ->do_unblank_screen(0);
>      ->vc->vc_sw->con_blank(vc, 0, 0);
>        ->fbcon_blank(vc, 0, 0);
>          ->update_screen(vc);
>            ->redraw_screen(vc, 0);
>              ->vc->vc_sw->con_switch(vc);
>                ->fbcon_switch(vc);
>                  ->ops->update_start(info);
>                    ->bit_update_start(info);
>                     ->fb_pan_display(info, &ops->var);
>                       ->info->fbops->fb_pan_display(var, info);
>                         ->drm_fb_helper_pan_display(var, info);
>                           ->mutex_lock(&dev->mode_config.mutex); *this blocks*
> 
> With this change, there is now a lot going on in the panic path. Stuff
> that I'm not sure is safe when panicking. In addition to the
> mutex_lock, there is also a del_timer_sync()
> now happening in the context of panic().
> 
> I see this bug with a 2.6.38 kernel but did a quick scan of a newer
> kernels and did not see anything that changed in this path so I
> suspect its still there.
> 
> Reverting this change fixes the regression.
> 

Chris Fowler reports something similar when running 2.6.38 by inducing a 
kernel panic via the oom killer -- see 
http://marc.info/?l=linux-kernel&m=130805985022791.  I've added him to the 
cc so he can participate in the thread and cherry-pick any fixes (last 
status update was that he was going to be trying 2.6.38.8).
