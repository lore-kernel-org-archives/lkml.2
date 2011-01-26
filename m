Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1AZL12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:27:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1AZL1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:27:25 -0500
Message-ID: <4D4004F9.6090200@redhat.com>
Date: Wed, 26 Jan 2011 09:26:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net>
In-Reply-To: <20110126020003.GA23085@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Em 26-01-2011 00:00, Dmitry Torokhov escreveu:
> On Tue, Jan 25, 2011 at 03:29:14PM -0800, Dmitry Torokhov wrote:
>> On Tue, Jan 25, 2011 at 05:22:09PM -0500, Mark Lord wrote:
>>> On 11-01-25 05:00 PM, Mauro Carvalho Chehab wrote:
>>>> Em 25-01-2011 18:54, Dmitry Torokhov escreveu:
>>>>> On Wed, Jan 26, 2011 at 06:09:45AM +1000, Linus Torvalds wrote:
>>>>>> On Wed, Jan 26, 2011 at 2:48 AM, Dmitry Torokhov
>>>>>> <dmitry.torokhov@gmail.com> wrote:
>>>>>>>
>>>>>>> We should be able to handle the case where scancode is valid even though
>>>>>>> it might be unmapped yet. This is regardless of what version of
>>>>>>> EVIOCGKEYCODE we use, 1 or 2, and whether it is sparse keymap or not.
>>>>>>>
>>>>>>> Is it possible to validate the scancode by driver?
>>>>>>
>>>>>> More appropriately, why not just revert the thing? The version change
>>>>
>>>> Reverting the version increment is a bad thing. I agree with Dmitry that
>>>> an application that fails just because the API version were incremented
>>>> is buggy.
>>>>
>>>>> Well, then we'll break Ubuntu again as they recompiled their input-utils
>>>>> package (without fixing the check). And the rest of distros do not seem
>>>>> to be using that package...
>>>>
>>>> Reverting it will also break the ir-keytable userspace program that it is
>>>> meant to be used by the Remote Controller devices, and uses it to adjust
>>>> its behaviour to support RC's with more than 16 bits of scancodes.
>>>>
>>>> I agree that it is bad that the ABI broke, but reverting it will cause even
>>>> more damage.
>>>
>>> There we disagree.  Sure it's a very poorly thought out interface,
>>> but the way to fix it is to put a new one along side the old,
>>> and put the old back the way it was before it got broken.
>>>
>>> I'm not making a fuss here for myself -- I'm more than capable of working
>>> around new kernel bugs like these, but for every person like me there are
>>> likely hundreds of others who simply get frustrated and give up.
>>>
>>> If you're worried about Ubuntu's adaptation to the buggy regression,
>>> then email their developers (kernel and input-utils packagers) explaining
>>> the revert, and they can coordination their kernel and input-utils updates
>>> to do the Right Thing.
>>>
>>> But for all of the rest of us, our systems are broken by this change.
>>>
>>> ...
>>>
>>>
>>>>>> As Mark said, breaking user space simply isn't acceptable. And since
>>>>>> breaking user space isn't acceptable, then incrementing the version is
>>>>>> stupid too.
>>>>>
>>>>> It might not have been the best idea to increment, however I maintain
>>>>> that if there exists version is can be changed. Otherwise there is no
>>>>> point in having version at all.
>>>>
>>>> Not arguing in favor of the version numbering, but it is easy to read
>>>> the version increment at the beginning of the application, and adjust
>>>> if the code will use EVIOCGKEYCODE or EVIOCGKEYCODE_V2 of the ioctl's,
>>>> depending on what kernel provides.
>>>>
>>>> Ok, we might be just calling the new ioctl and check for -ENOSYS at
>>>> the beginning, using some fake arguments.
>>>>
>>>>> As I said, reverting the version bump will cause yet another wave of
>>>>> breakages so I propose leaving version as is.
>>>>>
>>>>>>
>>>>>> The way we add new ioctl's is not by incrementing some "ABI version"
>>>>>> crap. It's by adding new ioctl's or system calls or whatever that
>>>>>> simply used to return -ENOSYS or other error before, while preserving
>>>>>> the old ABI. That way old binaries don't break (for _ANY_ reason), and
>>>>>> new binaries can see "oh, this doesn't support the new thing".
>>>>>
>>>>> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
>>>
>>> That's the problem: you did NOT keep the two old ioctls().
>>> Those got changed too.. so now we have four NEW ioctls(),
>>> none of which backward compatible with userspace.
>>>
>>
>> Please calm down. This, in fact, is not new vs old ioctl problem but
>> rather particular driver (or rather set of drivers) implementation
>> issue. Even if we drop the new ioctls and convert the RC code to use the
>> old ones you'd be observing the same breakage as RC code responds with
>> -EINVAL to not-yet-established mappings.
>>
>> I'll see what can be done for these drivers; I guess we could supply a
>> fake KEY_RESERVED entry for not mapped scancodes if there are mapped
>> scancodes "above" current one. That should result in the same behavior
>> for RCs as before.
>>
> 
> I wonder if the patch below is all that is needed...
>
> Input: ir-keymap - return KEY_RESERVED for unknown mappings
> 
> Do not respond with -EINVAL to EVIOCGKEYCODE for not-yet-mapped scancodes,
> but rather return KEY_RESERVED.
> 
> This fixes breakage with Ubuntu's input-kbd utility that stopped returning
> full keymaps for remote controls.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

I tested your patch with both ir-keytable and the input-kbd (with the
version check fixed) on the top of a vanilla 2.6.37 kernel. It works
with both tools.

Feel free to add:

Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-

Btw, I took some time to take analyse the input-kbd stuff.
As said at the README:

	This is a small collection of input layer utilities.  I wrote them
	mainly for testing and debugging, but maybe others find them useful
	too :-)
	...
	Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]

This is an old testing tool written by Gerd Hoffmann probably used for him
to test the V4L early Remote Controller implementations. I think he never
meant to use it for anything else. So that's probably the reason why he 
added a check for a specific input version.

The last "official" version seems to be this one:
	http://dl.bytesex.org/cvs-snapshots/input-20081014-101501.tar.gz

I don't think that Gerd is still maintaining it. On a quick search,
it seems that most distros don't ship it (Debian being an exception).

Gerd, if you're still maintaining it, it is a good idea to apply Dmitry's
patch:
	http://www.spinics.net/lists/linux-input/msg13728.html
Otherwise, the tool won't work for NEC-extended and RC-6 tables.

Most of the tools found on Gerd's input package can be replaced with gains
by ir-keytable [1][2].
[1] http://git.linuxtv.org/v4l-utils.git
[2] http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.2.tar.bz2

The output format for input-kbd is compatible with the input format of
ir-keytable.

So, people that are using input-kbd to work with a remote controller at
/dev/input/event2 can read the existent RC tables with:
	# input-kbd 2 >input_kbd_rc_map
or:
	# ir-keytable -r >ir_keytable_rc_map

In order to replace the table, people can use:
	# input-kbd -f some_rc_map 2
or:
	# ir-keytable -cw input_kbd_rc_map
	# ir-keytable -cw ir_keytable_rc_map

To list Remote Controller input devices:
	$ ir-keytable
		(somewhat similar to what lsinput does)

To test input events:
	# input-events 2
	# ir-keytable -t

However, as said previously in this thread, input-kbd won't work with any
RC table that uses NEC extended (and there are several devices on the
current Kernels with those tables), since it only reads up to 16 bits.

ir-keytable works with all RC tables, if you use a kernel equal or upper to
2.6.36, due to the usage of the new ioctl's.

ir-keytable also gets some additional data from the remote controllers,
available via sysfs (/sys/class/rc).

Thanks,
Mauro
