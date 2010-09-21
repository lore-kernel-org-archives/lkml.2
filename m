Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab0IUGjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:39:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56489 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751205Ab0IUGjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:39:10 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+PjBdXW6+POM6XNDjegMojsoaDOsTxNORrj4qlBq
	zaskb038szlBig
Message-ID: <4C985309.5020205@gmx.de>
Date: Tue, 21 Sep 2010 08:39:05 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
References: <20100919172833.14bf291e@neptune.home>	<4C963E99.9080207@gmx.de>	<20100919190240.65762511@neptune.home>	<4C97B079.8050707@gmx.de>	<20100920213258.1218b284@neptune.home>	<4C97BF40.6030708@gmx.de>	<20100920223608.19b4d177@neptune.home>	<4C97E00B.6090103@gmx.de> <20100921075610.1c016c12@pluto.restena.lu>
In-Reply-To: <20100921075610.1c016c12@pluto.restena.lu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont schrieb:
> On Tue, 21 Sep 2010 00:28:27 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>>> Tracking if/how often framebuffer is opened as such is a separate thing (though
>>> all users that have the framebuffer opened hold a reference to fb_info).
>> That's what I said. So as long as refcount <= 1 it does not matter whether you 
>> just count on open/release or additionally on every framebuffer operation, just 
>> that the later produces more noise.
> 
> Hm, I don't count on every framebuffer operation... in most cases
> fb_info is provided as function argument, in which case no further
> counting is needed as the caller has a valid reference.
> 
> With my patch applied refcount for registered but unsed framebuffer was
> 2 (once for the driver, once for registered_fb entry) and went up to 3
> when userspace opened framebuffer. fbcon's usage only incremented
> refcount for very short timeframes when effectively using fb_info.
> 
> When starting with the FB minor I have to take a new reference.
> (though I maybe should check if file's private data is set and use
> that reference instead of looking up fb_info by minor as is currently
> done)
> 
> For fbcon all the references are taken by FB minor (I wondered why
> fbcon only remembers index into registered_fb aka minor instead of
> fb_info itself)

True, I guess fb infrastructure and fbcon both could use a lot of work. At the 
moment I am more at fixing my driver but once that's done to an acceptable level 
I think I'll give it a try, too.

>> So I still don't see any advantage in counting users + uses.
>> Please note that I do not object the idea of the patch itself, it's only that I 
>> have a different preference on what to count. I only want to express that your 
>> way is more complicated than what I would recommend.
> 
> I don't think I see how you would do the refcounting... would you just
> drop the changes in fb_open() and fb_release()?
> Could you describe your approach (with pseudo-code) or the differences
> to mine?

No, quite the opposite.
I would increase the refcount in fb_open in fbmem.c and in fbcon.c where 
fbops->fb_open is called; decrease the refcount on fb_release in fbmem.c and in 
fbcon.c where fbops->fb_release is called. This would be only 6 places in total 
which need to be changed and would be the same as what you said is currently used.
As we agree (I hope) that for framebuffer operations an already open framebuffer 
is required this would not change when the framebuffer will be freed (compared 
to your counting) so the part changing how a framebuffer is shut down can be 
changed just as you proposed. The advantage is that it does not require changes 
to framebuffer ioctls/read/write/mmap and probably also much less changes in 
fbcon. And if this is also what drivers want and there is no conflict with what 
you want, I don't see any reason to not provide this service but force them to 
do this kind of refcounting on their own.


Thanks,

Florian Tobias Schandinat

