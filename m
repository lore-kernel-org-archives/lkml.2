Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0EJGAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:00:53 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:33838 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0EJGAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:00:50 -0400
Date: Mon, 10 May 2010 08:00:47 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Deadlock between fbcon and fb_defio?
Message-ID: <20100510080047.5adade6f@pluto.restena.lu>
In-Reply-To: <AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
References: <20100509184911.3f136b77@neptune.home>
	<AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

On Mon, 10 May 2010 08:00:51 Jaya Kumar wrote:
> On Mon, May 10, 2010 at 12:49 AM, Bruno Prémont
> <bonbons@linux-vserver.org> wrote:
> >
> > Fix crash if we are the first framebuffer loaded as in that case
> > fbcon wants to flush framebuffer at the end of fb registration,
> > before we have setup fb_defio.
> 
> Bruno,
> 
> Please help me understand, how does this scenario occur? I'm
> interpreting what you've written above to mean that fbcon is accessing
> the framebuffer before you've called defio_init()? Is that correct?

That was the original state as I called defio_init after
register_framebuffer() and defio_cleanup() before
unregister_framebuffer(), the opposite to the typical sequence you
detail below. Fixed by the patch.

My deadlock issue, after applying the patch, is during set_par() when I
replace the framebuffer and wish defio to start using the new page(s)
instead of the old one(s).

I want to make sure that I won't be accessing the old framebuffer after
freeing it and also that defio monitors the new framebuffer.

For that reason I defio_cleanup(), replace framebuffer, defio_init().
All of this happens while do_fb_ioctl() holds lock on fb_info and
console_sem.

Thanks,
Bruno

> The typical defio use sequence is: defio_init(),
> register_framebuffer() and the typical remove sequence is in the
> reverse order unregister_framebuffer(), defio_cleanup(). So, I don't
> see how fbcon is accessing the framebuffer either before
> register_framebuffer() completes (at which point defio init is already
> done) or after unregister_framebuffer() completes.
> 
> Thanks,
> jaya
