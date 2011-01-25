Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1AYWBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:01:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab1AYWBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:01:45 -0500
Message-ID: <4D3F4804.6070508@redhat.com>
Date: Tue, 25 Jan 2011 20:00:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net>
In-Reply-To: <20110125205453.GA19896@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-01-2011 18:54, Dmitry Torokhov escreveu:
> On Wed, Jan 26, 2011 at 06:09:45AM +1000, Linus Torvalds wrote:
>> On Wed, Jan 26, 2011 at 2:48 AM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>>>
>>> We should be able to handle the case where scancode is valid even though
>>> it might be unmapped yet. This is regardless of what version of
>>> EVIOCGKEYCODE we use, 1 or 2, and whether it is sparse keymap or not.
>>>
>>> Is it possible to validate the scancode by driver?
>>
>> More appropriately, why not just revert the thing? The version change

Reverting the version increment is a bad thing. I agree with Dmitry that
an application that fails just because the API version were incremented
is buggy.

> Well, then we'll break Ubuntu again as they recompiled their input-utils
> package (without fixing the check). And the rest of distros do not seem
> to be using that package...

Reverting it will also break the ir-keytable userspace program that it is
meant to be used by the Remote Controller devices, and uses it to adjust
its behaviour to support RC's with more than 16 bits of scancodes.

I agree that it is bad that the ABI broke, but reverting it will cause even
more damage.

>> and the buggy EINVAL return both.
> 
> I believe that -EINVAL thing only affects RC devices that Mauro switched
> to the new rc-core; input core in itself should be ABI compatible. Thus
> I'll leave the decision to him whether he wants to revert or fix
> compatibility issue.

The Remote Controller keycode tables are very sparse. In general,
they contain up to 100 entries, and the scan codes typically have 16
bits. Some newer devices have 24 or 32 bits. With version 1, as the table
index is the scancode, in order to read all keytables with EVIOCGKEYCODE,
the userspace needs to do 2^16 reads (or 2^32 for RC-6 remotes).
I don't need to say that this is highly ineffective. So, using V1
doesn't work fine anyway for Remote Controllers.

Btw, ir-keycodestool don't work with V1 and more than 16 bits, because it
doesn't scale. I didn't actually checked, but based on Dmitry's patch
for input-kbd, it is clear to me that the old version only supports 16
bits scancodes:

Em 25-01-2011 04:52, Dmitry Torokhov escreveu:
> From c22c85c0b675422a23e3d853ed06fedc36805774 Mon Sep 17 00:00:00 2001
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date: Mon, 24 Jan 2011 22:49:59 -0800
> Subject: [PATCH] input-kbd - switch to using EVIOCGKEYCODE2 when available
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  input-kbd.c |  118 ++++++++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 80 insertions(+), 38 deletions(-)
> 
> diff --git a/input-kbd.c b/input-kbd.c
> index e94529d..5d93d54 100644
> --- a/input-kbd.c
> +++ b/input-kbd.c
<snip>
> @@ -23,7 +41,7 @@ struct kbd_map {
>  
>  /* ------------------------------------------------------------------ */
>  
> -static struct kbd_map* kbd_map_read(int fd)
> +static struct kbd_map* kbd_map_read(int fd, unsigned int version)
>  {
>  	struct kbd_entry entry;
>  	struct kbd_map *map;
> @@ -32,16 +50,37 @@ static struct kbd_map* kbd_map_read(int fd)
>  	map = malloc(sizeof(*map));
>  	memset(map,0,sizeof(*map));
>  	for (map->size = 0; map->size < 65536; map->size++) {

See, it will only look into the 16-bits scancode space. There are several remote
controllers with 24 bits and 32 bits, so the tool is already broken anyway.

On the tests I did here with an ir-keytable version made before such change,
with a Fedora rawhide kernel (2.6.37), I didn't notice any breakage at
EVIOCGKEYCODE. I'll do more tests tomorrow with a vanilla Kernel. I'll
compile a vanilla 2.6.37 kernel tomorrow and, if needed, write a patch.

> 
>>
>> As Mark said, breaking user space simply isn't acceptable. And since
>> breaking user space isn't acceptable, then incrementing the version is
>> stupid too.
> 
> It might not have been the best idea to increment, however I maintain
> that if there exists version is can be changed. Otherwise there is no
> point in having version at all.

Not arguing in favor of the version numbering, but it is easy to read
the version increment at the beginning of the application, and adjust
if the code will use EVIOCGKEYCODE or EVIOCGKEYCODE_V2 of the ioctl's,
depending on what kernel provides.

Ok, we might be just calling the new ioctl and check for -ENOSYS at
the beginning, using some fake arguments.

> As I said, reverting the version bump will cause yet another wave of
> breakages so I propose leaving version as is.
> 
>>
>> The way we add new ioctl's is not by incrementing some "ABI version"
>> crap. It's by adding new ioctl's or system calls or whatever that
>> simply used to return -ENOSYS or other error before, while preserving
>> the old ABI. That way old binaries don't break (for _ANY_ reason), and
>> new binaries can see "oh, this doesn't support the new thing".
> 
> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
> 

Regards,
Mauro.
