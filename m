Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0KDDTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab0KDDTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:19:20 -0400
Message-ID: <4CD22627.2000607@redhat.com>
Date: Wed, 03 Nov 2010 23:19:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <20101009224041.GA901@sepie.suse.cz>	<4CD1E232.30406@redhat.com> <AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
In-Reply-To: <AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-11-2010 22:31, Arnaud Lacombe escreveu:
> Hi,
> 
> On Wed, Nov 3, 2010 at 6:29 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 09-10-2010 18:40, Michal Marek escreveu:
>>>
>>> Arnaud Lacombe (1):
>>>       kconfig: delay symbol direct dependency initialization
>>
>> This patch generated a regression with V4L build. After applying it,
>> some Kconfig dependencies that used to work with V4L Kconfig broke.
>>
> of course, but they were all-likely buggy. If a compiler version N
> outputs a new legitimate warning because of a bug in the code, you do
> not switch back to the previous version because the warning wasn't
> there, you fix the code.
> 
> That said, please point me to a false positive, eventually with a
> minimal testcase, and I'll be happy to fix the issue.

Arnaud,

In the case of V4L and DVB drivers, what happens is that the same 
USB (or PCI) bridge driver can be attached to lots of
different chipsets that do analog/digital/audio decoding/encoding.

A normal user won't need to open his USB TV stick just to see TV on it.
It just needs to select a bridge driver, and all possible options for encoders
and decoders are auto-selected.

If you're an advanced user (or are developing an embedded hardware), you
know exactly what are the components inside the board/stick. So, the
Kconfig allows to disable the automatic auto-selection, doing manual
selection.

The logic basically implements it, using Kconfig way, on a logic like:

	auto = ask_user_if_ancillary_drivers_should_be_auto_selected();
	driver_foo = ask_user_if_driver_foo_should_be_selected();
	if (driver_foo && auto) {
		select(bar1);
		select(bar2);
		select(bar3);
		select(bar4);
	}
...
	if (!auto) {
		open_menu()
		ask_user_if_bar1_should_be_selected();
		ask_user_if_bar2_should_be_selected();
		ask_user_if_bar3_should_be_selected();
		ask_user_if_bar4_should_be_selected();
...
		close_menu()
	}

Or, on Kconfig language:

>> config VIDEO_HELPER_CHIPS_AUTO
>>        bool "Autoselect pertinent encoders/decoders and other helper chips"
>>
>> config VIDEO_IVTV
>>        select VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO
>>
>> menu "Encoders/decoders and other helper chips"
>>        depends on !VIDEO_HELPER_CHIPS_AUTO
>>
>> config VIDEO_WM8739
>>        tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
>>

I don't see anything wrong on such logic. It is valid in C, and it is also valid
(and works properly) at Kconfig language.

So, the warning is a false positive.

If you want to see the real logic, just look at drivers/media/.../Kconfig stuff.
You'll see it at almost all Kconfig files. There are hundreds of dependencies
using this kind of logic. This is used by all tuners (21 Kconfig items, at
drivers/media/common/Kconfig), by several I2C devices (40+ Kconfig items at
drivers/media/video/Kconfig), and by almost all bridge drivers.

Mauro.

