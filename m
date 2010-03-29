Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0C2AwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 20:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab0C2AwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 20:52:08 -0400
Message-ID: <4BAFF985.3090703@redhat.com>
Date: Sun, 28 Mar 2010 21:51:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <20091215195859.GI24406@elf.ucw.cz> <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com> <20091215201933.GK24406@elf.ucw.cz> <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com> <20091215203300.GL24406@elf.ucw.cz> <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com> <4BAB7659.1040408@redhat.com> <20100326112755.GB5387@hardeman.nu> <4BACC769.6020906@redhat.com> <20100326160150.GA28804@core.coreip.homeip.net> <4BAFE4B7.2030204@redhat.com>
In-Reply-To: <4BAFE4B7.2030204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
>> On Fri, Mar 26, 2010 at 11:40:41AM -0300, Mauro Carvalho Chehab wrote:
>>> David Härdeman wrote:
>>>> On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
>>>>>>        10) extend keycode table replacement to support big/variable 
>>>>>>        sized scancodes;
>>>>> Pending.
>>>>>
>>>>> The current limit here is the scancode ioctl's are defined as:
>>>>>
>>>>> #define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
>>>>> #define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */
>>>>>
>>>>> As int size is 32 bits, and we must pass both 64 (or even bigger) scancodes, associated
>>>>> with a keycode, there's not enough bits there for IR.
>>>>>
>>>>> The better approach seems to create an struct with an arbitrary long size, like:
>>>>>
>>>>> struct keycode_table_entry {
>>>>> 	unsigned keycode;
>>>>> 	char scancode[32];	/* 32 is just an arbitrary long array - maybe shorter */
>>>>> 	int len;
>>>>> }
>>>>>
>>>>> and re-define the ioctls. For example we might be doing:
>>>>>
>>>>> #define EVIOCGKEYCODEBIG           _IOR('E', 0x04, struct keycode_table_entry)
>>>>> #define EVIOCSKEYCODEBIG           _IOW('E', 0x04, struct keycode_table_entry)
>>>>> #define EVIOCLEARKEYCODEBIG        _IOR('E', 0x04, void)
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
>>>> 	unsigned keycode;
>>>> 	unsigned index;
>>>> 	unsigned len;
>>>> 	char scancode[];
>>>> };
>>>>
>>>> Use index in EVIOCGKEYCODEBIG to look up a keycode (all other fields are 
>>>> ignored), that way no special function to clear the table is necessary, 
>>>> instead you do a loop with:
>>>>
>>>> EVIOCGKEYCODEBIG (with index 0)
>>>> EVIOCSKEYCODEBIG (with the returned struct from EVIOCGKEYCODEBIG and
>>>> 		  keycode = KEY_RESERVED)
>>>>
>>>> until EVIOCGKEYCODEBIG returns an error.
>>> Makes sense.
>> Yes, I think so too. Just need a nice way to handle transition, I'd
>> like in the end to have drivers implement only the improved methods and
>> map legacy methods in evdev.
> 
> See the attached RFC barely tested patch. 
> 
> On this patch, I'm using the following definitions for the ioctl:
> 
> struct keycode_table_entry {
> 	__u32 keycode;		/* e.g. KEY_A */
> 	__u32 index;		/* Index for the given scan/key table */
> 	__u32 len;		/* Lenght of the scancode */
> 	__u32 reserved[2];	/* Reserved for future usage */
> 	char *scancode;		/* scancode, in machine-endian */
> };
> 
> #define EVIOCGKEYCODEBIG	_IOR('E', 0x04, struct keycode_table_entry) /* get keycode */
> #define EVIOCSKEYCODEBIG	_IOW('E', 0x04, struct keycode_table_entry) /* set keycode */
> 
> 
> I tried to do the compat backport on a nice way, on both directions, e. g.:
> 
> 1) an userspace app using EVIO[CS]GKEYCODEBIG to work with a legacy driver.
> 2) a driver implementing the new methods to accept the legacy EVIO[CS]GKEYCODE;
> 
> For the test of (1), I implemented the following clear keytable code:
> 
> 	struct keycode_table_entry      kt;
>         uint32_t                        scancode, i;
> 
>         memset(&kt, 0, sizeof(kt));
>         kt.len = sizeof(scancode);
>         kt.scancode = (char *)&scancode;
> 
>         for (i = 0; rc == 0; i++) {
>         	kt.index = i;
>         	kt.keycode = KEY_RESERVED;
>                 rc = ioctl(fd, EVIOCSKEYCODEBIG, &kt);
>         }
>         fprintf(stderr, "Cleaned %i keycode(s)\n", i - 1);
> 
> It worked properly. I didn't test (2) yet.
> 
> The read keytable would also be trivial. However, there are some troubles when
> implementing the code to add/replace a value at the table, in a way that it
> would allow the legacy drivers to work:
> 
> - With a real CODEBIG support, the index number will be different than the
> scancode number. So, let's say that this is the driver table:
> 
> index	scancode keycode
> ------------------------
> 0	0x1e00	 KEY_0
> 1	0x1e01	 KEY_1
> 2	0x1e02	 KEY_2
> 3	0x1e03	 KEY_3
> 4	0x1e04	 KEY_4
> 5	0x1e05	 KEY_5
> 6	0x1e06	 KEY_6
> 7	0x1e07	 KEY_7
> 8	0x1e08	 KEY_8
> 9	0x1e09	 KEY_9
> 
> Let's suppose that the user wants to overwrite the entry 5, attributing a new scancode/keycode
> to entry 5 (for example, associating 0x1e0a with KEY-A).
> 
> A valid EVIOCSKEYCODEBIG call to change this code would be:
> 
> 	kt->index = 5;
> 	*(uint32_t *)kt->scancode = 0x1e0a;
> 	*(uint32_t *)kt->keycode = KEY_A;
> 	rc = ioctl(fd, EVIOCSKEYCODEBIG, &kt);
> 
> With EVIOCSKEYCODE, this requires two separate operations:
> 
> 	int codes[2];
> 	code[0] = 0x1e05;
> 	code[1] = KEY_RESERVED;
> 	rc = ioctl(fd, EVIOCSKEYCODE, &codes];
> 
> 	code[0] = 0x1e0a;
> 	code[1] = KEY_A;
> 	rc = ioctl(fd, EVIOCSKEYCODE, &codes];
> 
> 
> In the case of EVIOCSKEYCODEBIG call, the driver will need to:
> 
> 1) Check If the scancode is not being used yet on any entry different than index=5.
> If it is in use, it should return an error. 
> If not, replace the scancode/keycode.
> 
> 2) Check if index is equal to the length of the array + 1. If so, create a new entry.
> 
> 3) check if the index is bigger than length + 1 and return an error, if so.
> 
> For the EVIOSKEYCODE emulation by an EVIOCSKEYCODEBIG driver, index=5 won't work.
> The driver will need to use the scancode. However, if we do this way, the
> cleanup logic will break, as scancode is equal to zero.
> 
> So, I think that having an index here is not a good idea: it will just create some
> implementation troubles. We can archive the same result without the index, and having
> a fast clean_table code by just reading the used scancodes and associating them
> with KEY_RESERVED.

I spoke too soon... removing the index causes a problem at the read ioctl: there's no way
to retrieve just the non-sparsed values.

There's one solution that would allow both read/write and compat to work nicely,
but the API would become somewhat asymmetrical:

At get (EVIOCGKEYCODEBIG):
	use index/len as input and keycode/scancode as output;

At set (EVIOCSKEYCODEBIG):
	use scancode/keycode/len as input (and, optionally, index as output).

Having it asymmetrical doesn't sound good, but, on the other hand, using index for
the set function also doesn't seem good, as the driver may reorder the entries after
setting, for example to work with a binary tree or with hashes.

I'll think a little more about it and do some experiments.

Cheers,
Mauro
