Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1J0Out (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:50:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1J0Our convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:50:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hVb9FZASP7oOfqODnn9uVavxVa25+jzbB04EuPFVKu70t811/aUP+0I0Ej5qunmeG
	o4pIl6b5P3mkcwNQDKWqA==
MIME-Version: 1.0
In-Reply-To: <CAB8Rdaq2r4Uc-WZK-k=wiEW8DKdixn+9dB7E4_XDL7k8jCMwSw@mail.gmail.com>
References: <20111027053007.GA32765@phenom.dumpdata.com>
	<20111027054806.GA1377@suse.de>
	<CAB8Rdaq2r4Uc-WZK-k=wiEW8DKdixn+9dB7E4_XDL7k8jCMwSw@mail.gmail.com>
Date: Thu, 27 Oct 2011 07:50:44 -0700
Message-ID: <CAB8Rdapo4gfEKOd2Xez7kqPHJR-1+emDvGpCq+Kv8yTtG9XYdg@mail.gmail.com>
Subject: Fwd: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
From: Miche Baker-Harvey <miche@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<plain text forwarding>

Bummer.  Sorry about that.
Konrad, could you give me a hand figuring out what's up with this -
I'm not running Zen here.  (If there's a test suite I could have run,
mea culpa, and please point me in the right direction.)

The "console [hvc0] enabled" message is coming from register_console()
in printk.c, and it doesn't have any loops.
It's called from hvc_console_init(), hvc_instantiate(), and
hvc_alloc(), none of which have loops.  The call in hvc_alloc() is the
one I added, so either I've inadvertently made one of the other two
repeat (I'm guestting hvc_instantiate() is the one you're using), or
you're infinitely calling hvc_alloc().  There's a calls to hvc_alloc()
in hvc_xen.c::xen_hvc_init(), and in init_port_console() in
virtio_console.c, but again, no loops.  Similarly for
hvc_instantiate().

So, could I trouble you to put a breakpoint in register_console() and
send me the stack?

Thanks,
Miche

On Wed, Oct 26, 2011 at 10:48 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Thu, Oct 27, 2011 at 01:30:08AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Miche.
> >
> > The git commit 361162459f62dc0826b82c9690a741a940f457f0:
> >
> >     hvc_console: display printk messages on console.
> >
> > is causing an infinite loop when booting Linux under Xen, as so:
> >
> > [    2.382984] console [hvc0] enabled
> > [    2.382984] console [hvc0] enabled
> > [    2.382984] console [hvc0] enabled
> > [    2.382984] console [hvc0] enabled
> > [    2.382984] console [hvc0] enabled
> > [    2.382984] console [hvc0] enabled
> > ..
> >
> > (see attached file titled bad.log)
> >
> > If I use Linus's latest git tree and revert your patch I get the kernel
> > to bootup (see good.log file),
>
> Ick, not good, thanks for letting us know.
>
> Miche, want me to just revert this, or do you think you can fix it?
>
> thanks,
>
> greg k-h
