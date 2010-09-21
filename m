Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0IUHC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:02:59 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:40282 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0IUHC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:02:57 -0400
Date: Tue, 21 Sep 2010 09:02:55 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
Message-ID: <20100921090255.410da2d7@pluto.restena.lu>
In-Reply-To: <4C985309.5020205@gmx.de>
References: <20100919172833.14bf291e@neptune.home>
	<4C963E99.9080207@gmx.de>
	<20100919190240.65762511@neptune.home>
	<4C97B079.8050707@gmx.de>
	<20100920213258.1218b284@neptune.home>
	<4C97BF40.6030708@gmx.de>
	<20100920223608.19b4d177@neptune.home>
	<4C97E00B.6090103@gmx.de>
	<20100921075610.1c016c12@pluto.restena.lu>
	<4C985309.5020205@gmx.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 08:39:05 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> Bruno Prémont schrieb:
> > On Tue, 21 Sep 2010 00:28:27 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> >>> Tracking if/how often framebuffer is opened as such is a separate thing (though
> >>> all users that have the framebuffer opened hold a reference to fb_info).
> >> That's what I said. So as long as refcount <= 1 it does not matter whether you 
> >> just count on open/release or additionally on every framebuffer operation, just 
> >> that the later produces more noise.
> > 
> > Hm, I don't count on every framebuffer operation... in most cases
> > fb_info is provided as function argument, in which case no further
> > counting is needed as the caller has a valid reference.
> > 
> > With my patch applied refcount for registered but unsed framebuffer was
> > 2 (once for the driver, once for registered_fb entry) and went up to 3
> > when userspace opened framebuffer. fbcon's usage only incremented
> > refcount for very short timeframes when effectively using fb_info.
> > 
> > When starting with the FB minor I have to take a new reference.
> > (though I maybe should check if file's private data is set and use
> > that reference instead of looking up fb_info by minor as is currently
> > done)
> > 
> > For fbcon all the references are taken by FB minor (I wondered why
> > fbcon only remembers index into registered_fb aka minor instead of
> > fb_info itself)
> 
> True, I guess fb infrastructure and fbcon both could use a lot of work. At the 
> moment I am more at fixing my driver but once that's done to an acceptable level 
> I think I'll give it a try, too.

This year someone said he/she would look at making it possible to have
multiple concurrently active consoles on distinct framebuffers.
Hopefully something is happening on that front (that would certainly
also include some fbcon cleanup)

Maybe I should first change fbcon to stop using indexes into
registered_fb but use fb_info right away (this would also make it
possible to soften/drop the max_fb limit of 15 at a later time, e.g. by
using dynamic major/minors)
This way fbcon would not by affected (or at least much less affected)
by the refcounting of fb_info.

> >> So I still don't see any advantage in counting users + uses.
> >> Please note that I do not object the idea of the patch itself, it's only that I 
> >> have a different preference on what to count. I only want to express that your 
> >> way is more complicated than what I would recommend.
> > 
> > I don't think I see how you would do the refcounting... would you just
> > drop the changes in fb_open() and fb_release()?
> > Could you describe your approach (with pseudo-code) or the differences
> > to mine?
> 
> No, quite the opposite.
> I would increase the refcount in fb_open in fbmem.c and in fbcon.c where 
> fbops->fb_open is called; decrease the refcount on fb_release in fbmem.c and in 
> fbcon.c where fbops->fb_release is called. This would be only 6 places in total 
> which need to be changed and would be the same as what you said is currently used.
> As we agree (I hope) that for framebuffer operations an already open framebuffer 
> is required this would not change when the framebuffer will be freed (compared 
> to your counting) so the part changing how a framebuffer is shut down can be 
> changed just as you proposed. The advantage is that it does not require changes 
> to framebuffer ioctls/read/write/mmap and probably also much less changes in 
> fbcon. And if this is also what drivers want and there is no conflict with what 
> you want, I don't see any reason to not provide this service but force them to 
> do this kind of refcounting on their own.

Ok, will see if I can do it that way. But from Guennadi's reply it
seems users that can be synchronously notified of fb-changes would need
to be accounted for separately from the others (maybe they don't need
to be accounted for at all)

Though I definitely don't like current access to registered_fb
array which looks racy (I've seen nothing that prevents two
register_framebuffer() calls to race for the same minor or even
unregister_framebuffer to race with register_framebuffer())
fbcon's access should be safe enough though via the notification events
that are serialized with console sem.

Thanks,
Bruno


> Thanks,
> 
> Florian Tobias Schandinat
> 
