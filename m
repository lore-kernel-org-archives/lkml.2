Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab0LNVNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:13:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53810 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760007Ab0LNVN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:13:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GDfnM1uMIdPEgIrljsp2W9/aOIIFCFt+aLl/1mmxvuBoI6RRn3Nw2XxTdgQM0cKTdp
         9KIARF4V6qsWDK5PgJTGoauU02XrmR8nvOrAXrC1/WcDfVWi6WkzRNMvCpIExULpzmpS
         32w7fQ3goDt/PgU2jEfykqs0lHR8apPAnyAmA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
References: <20101212131550.GA2608@darkstar>
	<AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
	<20101214003024.GA3575@hanuman.home.ifup.org>
	<AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
Date: Tue, 14 Dec 2010 22:13:11 +0100
Message-ID: <AANLkTimZ=cdu--GsVWotAir-2QpuXQQBg+7UtkVvKzO=@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 9:56 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> Using the card also still works, but I think I found out what was
> causing sporadic shutdown problems with 37-rc kernels: When I try to
> exit tvtime it gets stuck in an uninterruptible D state and can't be
> killed. And that seems to mess up the shutdown.
>
> But this happens independent with or without your patch and looks like
> different problem.
>
> SysRQ+W provided this stack trace, maybe someone seens an obvious bug...:
> [  274.772528]  ffff8800dec69680 0000000000000086 ffffffff81089d73
> ffff8800729d05a0
> [  274.778599]  0000000000011480 ffff8800df923fd8 0000000000011480
> ffff8800df922000
> [  274.778599]  ffff8800df923fd8 0000000000011480 ffff8800dec69680
> 0000000000011480
> [  274.778599] Call Trace:
> [  274.778599]  [<ffffffff81089d73>] ? free_pcppages_bulk+0x343/0x3b0
> [  274.778599]  [<ffffffff8156d0e1>] ? __mutex_lock_slowpath+0xe1/0x160
> [  274.778599]  [<ffffffff8156cd8a>] ? mutex_lock+0x1a/0x40
> [  274.778599]  [<ffffffff8141ab7f>] ? free_btres_lock.clone.19+0x3f/0x100
> [  274.778599]  [<ffffffff8141d311>] ? bttv_release+0x1c1/0x1e0
> [  274.778599]  [<ffffffff813fe4ba>] ? v4l2_release+0x4a/0x70
> [  274.778599]  [<ffffffff810c5291>] ? fput+0xe1/0x250
> [  274.778599]  [<ffffffff810c1d59>] ? filp_close+0x59/0x80
> [  274.778599]  [<ffffffff810c1e0b>] ? sys_close+0x8b/0xe0
> [  274.778599]  [<ffffffff8100253b>] ? system_call_fastpath+0x16/0x1b

Hmm:bttv_release() does mutex_lock(&btv->lock), then calls into
free_btres_lock(...) that also first does mutex_lock(&btv->lock);

The calls to lock btv->lock in bttv_release() where added as part of
the BKL removal, but I do not understand enough to fix this.
Can this be dropped from bttv_release() completely, or would an
unlocked version of free_btres_lock() be better?

Torsten
