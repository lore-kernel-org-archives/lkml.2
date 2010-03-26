Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0CZWhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:37:46 -0400
Received: from mail-qy0-f188.google.com ([209.85.221.188]:42404 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab0CZWho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b1yeyyOkKLmLwh0KUWibZYGUCuW29OWSuKNTNKmUizef7PZWYtryyNO2N+6+kRBFrZ
         9gshuT7/QMZZJvJQFL+R1cgeOt6XUxdLGeThhliCuvCO+W2324+f9/BP/wTlNbnBk3Lv
         36i09TbYh3+zT9+aC64mkfLETg/jzrSbi6Y8k=
MIME-Version: 1.0
In-Reply-To: <4BACED6B.9030409@redhat.com>
References: <20091215195859.GI24406@elf.ucw.cz>
	 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
	 <20091215203300.GL24406@elf.ucw.cz>
	 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com> <20100326112755.GB5387@hardeman.nu>
	 <4BACC769.6020906@redhat.com>
	 <20100326160150.GA28804@core.coreip.homeip.net>
	 <4BACED6B.9030409@redhat.com>
Date: Fri, 26 Mar 2010 18:37:41 -0400
Message-ID: <9e4733911003261537s770a66c8v92ab7384fde34839@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 1:22 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Dmitry Torokhov wrote:
>> On Fri, Mar 26, 2010 at 11:40:41AM -0300, Mauro Carvalho Chehab wrote:
>>> David Härdeman wrote:
>>>> On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
>>>>>>        10) extend keycode table replacement to support big/variable
>>>>>>        sized scancodes;
>>>>> Pending.
>>>>>
>>>>> The current limit here is the scancode ioctl's are defined as:
>>>>>
>>>>> #define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
>>>>> #define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */
>>>>>
>>>>> As int size is 32 bits, and we must pass both 64 (or even bigger) scancodes, associated
>>>>> with a keycode, there's not enough bits there for IR.
>>>>>
>>>>> The better approach seems to create an struct with an arbitrary long size, like:
>>>>>
>>>>> struct keycode_table_entry {
>>>>>    unsigned keycode;
>>>>>    char scancode[32];      /* 32 is just an arbitrary long array - maybe shorter */
>>>>>    int len;
>>>>> }
>>>>>
>>>>> and re-define the ioctls. For example we might be doing:
>>>>>
>>>>> #define EVIOCGKEYCODEBIG           _IOR('E', 0x04, struct keycode_table_entry)
>>>>> #define EVIOCSKEYCODEBIG           _IOW('E', 0x04, struct keycode_table_entry)
>>>>> #define EVIOCLEARKEYCODEBIG        _IOR('E', 0x04, void)
>>>>>
>>>>> Provided that the size for struct keycode_table_entry is different, _IO will generate
>>>>> a different magic number for those.
>>>>>
>>>>> Or, instead of using 0x04, just use another sequential number at the 'E' namespace.
>>>>>
>>>>> An specific function to clear the table is needed with big scancode space,
>>>>> as already discussed.
>>>>>
>>>> I'd suggest:
>>>>
>>>> struct keycode_table_entry {
>>>>     unsigned keycode;
>>>>     unsigned index;
>>>>     unsigned len;
>>>>     char scancode[];
>>>> };
>>>>
>>>> Use index in EVIOCGKEYCODEBIG to look up a keycode (all other fields are
>>>> ignored), that way no special function to clear the table is necessary,
>>>> instead you do a loop with:
>>>>
>>>> EVIOCGKEYCODEBIG (with index 0)
>>>> EVIOCSKEYCODEBIG (with the returned struct from EVIOCGKEYCODEBIG and
>>>>               keycode = KEY_RESERVED)
>>>>
>>>> until EVIOCGKEYCODEBIG returns an error.
>>> Makes sense.
>>
>> Yes, I think so too. Just need a nice way to handle transition, I'd
>> like in the end to have drivers implement only the improved methods and
>> map legacy methods in evdev.
>
> Ok. I'll prepare the patches for adding the new ioctl, in a way that it will
> also handle the legacy methods, and post for review.
>
>>>> On a related note, I really think the interface would benefit from
>>>> allowing more than one keytable per irrcv device with an input device
>>>> created per keytable. That way you can have one input device per remote
>>>> control. This implies that EVIOCLEARKEYCODEBIG is a bit misplaced as an
>>>> evdev IOCTL since there's an N-1 mapping between input devices and irrcv
>>>> devices.
>>> I don't think that an ioctl over one /dev/input/event should be the proper way
>>> to ask kernel to create another filtered /dev/input/event. As it were commented
>>> that the multimedia keys on some keyboards could benefit on having a filter
>>> capability, maybe we may have a sysfs node at class input that would allow
>>> the creation/removal of the filtered event interface.
>>
>> No, if you want separate event devices just create a new instance of
>> input device for every keymap and have driver/irrcv class route events
>> to proper input device.
>
> This don't solve the issue about how to signalize to kernel that more than one
> input device is needed.
>
> As the userspace will request the creation of those keymaps, we need some way
> to receive such requests from userspace.
>
> I can see a few ways for doing it:
>
> 1) create a control device for the irrcv device as a hole,
> that would handle such requests via ioctl (/dev/irctl[0-9]* ?)
>
> 2) create a read/write sysfs node that would indicate the number of event/keymaps
> associated with a given IR. By writing a bigger number, it would create new devices.
> By writing a smaller number, it will delete some maps. There's an issue though:
> what criteria would be used to delete? The newly created ones?

This is normally handled a sysfs node on the core, something like
'adddev'. You echo '1' to this node and a new interface is created.

Each interface has a sysfs node, make a 'remove' attribute in it. Echo
'1' to remove to make it disappear.

You have to implement the code behind these interfaces but this
convention is used in other subsubsystems.

BTW - you're recreating everything the configfs interface did. it
achieved the same results with mkdir/rmdir. I liked the configfs
scheme since there are no obscure commands to learn. Everybody can
make files and directories.


>
> 3) create a fixed number of event devices, and add a sysfs attribute to enable
> or disable it;
>
> 4) create a fixed number of sysfs attributes to represent the keymaps. For example:
> /sys/class/irrcv/irrcv0/keymap0/enabled
>        ...
> /sys/class/irrcv/irrcv0/keymap7/enabled
>
> The input/event node will be created only when the enabled=1.
>
> I don't like (2) or (3), because removing a table with (2) may end by removing the wrong
> table, and (3) will create more event interfaces than probably needed by the majority
> of IR users.
>
> maybe (4) is the better one.
>
> --
>
> Cheers,
> Mauro
>



-- 
Jon Smirl
jonsmirl@gmail.com
