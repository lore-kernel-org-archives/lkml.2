Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1FTXUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:20:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1FTXU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MMNBLa5pRYRZ1GFAFdQA1jjQG7szFfjxsei5eAPtwMeI057UaogafCHweFQYYzRnnC
         cxbxwgNN29dAk3Izs48A==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106201601220.15259@chino.kir.corp.google.com>
References: <BANLkTingstCoWk0H20nN1J7t3H=mndSdnL2YpeW2R46fhL2kpA@mail.gmail.com>
	<alpine.DEB.2.00.1106201601220.15259@chino.kir.corp.google.com>
Date: Mon, 20 Jun 2011 16:20:16 -0700
X-Google-Sender-Auth: W-MdBxDr3nEj_36pB6X7sF6uwzs
Message-ID: <BANLkTimVL-PyOc31J5A54A=4gFggM91PDB3g79bxSxn92-Es8Q@mail.gmail.com>
Subject: Re: Regression in panic
From: Mandeep Singh Baines <msb@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Olof Johansson <olofj@chromium.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Chris Fowler <cfowler@opsdc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 4:03 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 20 Jun 2011, Mandeep Singh Baines wrote:
>
>> Hi Dave,
>>
>> I think this change is causing a regression I'm seeing in panic.
>> Before this change, I'd get a
>> reboot on panic (we've configured as such).
>>
>> With this change, my machine gets wedged if the machine is running in
>> X when the panic occurs.
>>
>> I traced the code flow to this:
>>
>> bust_spinlocks(0);
>>  ->unblank_screen();
>>    ->do_unblank_screen(0);
>>      ->vc->vc_sw->con_blank(vc, 0, 0);
>>        ->fbcon_blank(vc, 0, 0);
>>          ->update_screen(vc);
>>            ->redraw_screen(vc, 0);
>>              ->vc->vc_sw->con_switch(vc);
>>                ->fbcon_switch(vc);
>>                  ->ops->update_start(info);
>>                    ->bit_update_start(info);
>>                     ->fb_pan_display(info, &ops->var);
>>                       ->info->fbops->fb_pan_display(var, info);
>>                         ->drm_fb_helper_pan_display(var, info);
>>                           ->mutex_lock(&dev->mode_config.mutex); *this blocks*
>>
>> With this change, there is now a lot going on in the panic path. Stuff
>> that I'm not sure is safe when panicking. In addition to the
>> mutex_lock, there is also a del_timer_sync()
>> now happening in the context of panic().
>>
>> I see this bug with a 2.6.38 kernel but did a quick scan of a newer
>> kernels and did not see anything that changed in this path so I
>> suspect its still there.
>>
>> Reverting this change fixes the regression.
>>
>
> Chris Fowler reports something similar when running 2.6.38 by inducing a
> kernel panic via the oom killer -- see
> http://marc.info/?l=linux-kernel&m=130805985022791.  I've added him to the
> cc so he can participate in the thread and cherry-pick any fixes (last
> status update was that he was going to be trying 2.6.38.8).
>

One potential fix might be to convert the mutex_lock to a try if
oops_in_progress but
I suspect oops_in_progress checks may be needed in a bunch of other places in
the screen_unblank code path.
