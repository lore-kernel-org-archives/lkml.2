Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0FFT6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:58:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7135 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0FFT6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:58:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=CWU4LoyM+T0E+3dgMxzDomJDuxBAMCNwvK4bjMrONDrvydaiwzzvuJDeuIH7xjlmC
	Rzx4BqiPRMz3Fj9DxiUzA==
MIME-Version: 1.0
In-Reply-To: <20100606192405.GA7559@infradead.org>
References: <1275834706.7227.545.camel@mulgrave.site>
	<alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
	<1275844114.7227.552.camel@mulgrave.site>
	<20100606190525.GA20517@infradead.org>
	<AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
	<20100606192405.GA7559@infradead.org>
Date: Sun, 6 Jun 2010 12:58:10 -0700
Message-ID: <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Brian Swetland <swetland@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, "Arve Hj?nnev?g" <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 12:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
>
> Yes.  That's what makes me wonder about some parts of the discussion
> here.  Getting the drivers for one or more of the android plattforms
> in is not a problem.  I'd say it could have easily been done with the
> manweeks spent arguing in this and related threads.
>
> The much bigger issues is to get android userspace running on a more
> or less vanilla kernel, that is withoutthe  binder, without the rather
> interesting group ID based security hack^H^H^H^Hmodel, without the
> suspend blocker userspace API and so on, and so on.

Somebody will have to broker a deal with the frameworks/apps folks to
get rid of the binder.  They like it a lot.  Of course if somebody
built a drop-in replacement for the userspace side that didn't require
a kernel driver, had the same performance characteristics, solved the
same problems, etc, they could probably make an argument for it (or
just provide it as a drop-in replacement for people who want a more
"pure" linux underneath Android, even if we didn't pick it up).

The group ID stuff works incredibly well for gating device access --
we ensure that devices that need access from various processes end up
with perms like 0660 root audio (say for a raw audio interface), and
then we assure that processes which have the "may use audio hardware"
permission are executed with audio as an additional group.  We ended
up using the same model to control socket, raw socket, and bt socket
access because at the time we could not find a reasonable way to grant
or exclude such permissions on a process by process basis.
Maintaining about 20-30 lines of diffs to make that work was not a bad
tradeoff (and we don't expect those patches to go upstream).  If
there's a way to accomplish this without patching the kernel, we're
all ears.

While we do maintain some assorted patches to core code (like the
permissions thing), we strongly prefer to keep our work localized to
drivers (generic to android or specific to hardware), and try to
migrate to common kernel features when possible, submit patches (like
work Mike Chan is doing around cpufreq and power measurement), etc.
Patches to core code cause more headaches when we rebase up to new
kernel versions, after all.

> So for people who really care about running a mainline kernel on their
> android device doing that part first on a generic ARM board in qemu
> might be much better first step work.

> On the other hand I've heard
> that various hardware vendors or parties closed to them are rather
> annoyed by their drivers beeing stuck in the android tree - but that
> can be easily solved by getting removing the suspend blockers (at least
> temporarily), cleaning up a few bits here and there and getting them in.

This continues to baffle me.  If we (Google) are such a headache, why
not just route around us.  The drivers we've written are GPLv2, the
source is out there for anyone who wants it, etc.  The drivers other
people have written we have no control over at all. From my point of
view it'd be an annoyance if somebody took the code we wrote, modified
it heavily, and pushed it upstream, but fundamentally I can't stop
that from happening other than by pushing it upstream myself, first.

Blaming me because you want me to send your drivers upstream and I'm
not doing it or not doing it fast enough or not doing it the way you
like does not seem very productive.  I'm not a gatekeeper for patch
submission to the mainline kernel.

Brian
