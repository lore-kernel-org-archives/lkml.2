Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab0CaGDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab0CaGC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:02:58 -0400
Message-ID: <4BB2E554.6030308@redhat.com>
Date: Wed, 31 Mar 2010 03:01:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com> <20091215203300.GL24406@elf.ucw.cz> <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com> <4BAB7659.1040408@redhat.com> <20100326112755.GB5387@hardeman.nu> <4BACC769.6020906@redhat.com> <20100326160150.GA28804@core.coreip.homeip.net> <4BAFE4B7.2030204@redhat.com> <4BAFF985.3090703@redhat.com> <20100330110138.GA6164@hardeman.nu>
In-Reply-To: <20100330110138.GA6164@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Härdeman wrote:
> On Sun, Mar 28, 2010 at 09:51:17PM -0300, Mauro Carvalho Chehab wrote:
>> I spoke too soon... removing the index causes a problem at the read ioctl: there's no way
>> to retrieve just the non-sparsed values.
>>
>> There's one solution that would allow both read/write and compat to work nicely,
>> but the API would become somewhat asymmetrical:
>>
>> At get (EVIOCGKEYCODEBIG):
>> 	use index/len as input and keycode/scancode as output;
>>
>> At set (EVIOCSKEYCODEBIG):
>> 	use scancode/keycode/len as input (and, optionally, index as output).
>>
> 
> This was exactly the approach I had in mind when I suggested using 
> indexes.

Doesn't work perfectly. The asymmetry has a side effect on the internal logic: 

EVIOCGKEYCODEBIG should be implemented with a pseudo-code like:
	kt_entry = getkeycodebig_from_index(index);

EVIOCSKEYCODEBIG should be implemented with a pseudo-code like:
	kt_entry = getkeycodebig_from_scan(scan, len);
	old_key = kt_entry->keycode;

	kt_entry->keycode = newkey;
	if (setkeycodebig(kt_entry) == 0)
		keyup(old_key);

As you see, the input parameters for the getkeycodebig*() are different.

So, this approach requires 3 ops instead of 2. Yet, as scancode->keycode is
needed anyway, this doesn't actually hurts.

I just added the patches that implement those two ioctls on my IR development tree.
I tested only the original EVIOCGKEYCODE/EVIOSGKEYCODE and calling a clear_table
function using EVIOCSKEYCODEBIG via emulation.

My next step is to test the remaining ir-keytable functions via emulation, and then
implement the *BIG ioctls at ir-core, for testing.

I haven't test yet the *keycode*default methods. 

After having it fully tested, I'll submit the complete input ioctl patch via ML.

-- 

Cheers,
Mauro
