Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0KDLK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 07:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0KDLK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:10:57 -0400
Message-ID: <4CD29493.5020101@redhat.com>
Date: Thu, 04 Nov 2010 07:10:11 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <20101009224041.GA901@sepie.suse.cz>	<4CD1E232.30406@redhat.com>	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>	<4CD22627.2000607@redhat.com> <AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>
In-Reply-To: <AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-11-2010 00:15, Arnaud Lacombe escreveu:
> Hi,
> 
> On Wed, Nov 3, 2010 at 11:19 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 03-11-2010 22:31, Arnaud Lacombe escreveu:
>>> Hi,
>>>
>>> On Wed, Nov 3, 2010 at 6:29 PM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Em 09-10-2010 18:40, Michal Marek escreveu:
>>>>>
>>>>> Arnaud Lacombe (1):
>>>>>       kconfig: delay symbol direct dependency initialization
>>>>
>>>> This patch generated a regression with V4L build. After applying it,
>>>> some Kconfig dependencies that used to work with V4L Kconfig broke.
>>>>
>>> of course, but they were all-likely buggy. If a compiler version N
>>> outputs a new legitimate warning because of a bug in the code, you do
>>> not switch back to the previous version because the warning wasn't
>>> there, you fix the code.
>>>
>>> That said, please point me to a false positive, eventually with a
>>> minimal testcase, and I'll be happy to fix the issue.
>>
>> Arnaud,
>>
>> In the case of V4L and DVB drivers, what happens is that the same
>> USB (or PCI) bridge driver can be attached to lots of
>> different chipsets that do analog/digital/audio decoding/encoding.
>>
>> A normal user won't need to open his USB TV stick just to see TV on it.
>> It just needs to select a bridge driver, and all possible options for encoders
>> and decoders are auto-selected.
>>
>> If you're an advanced user (or are developing an embedded hardware), you
>> know exactly what are the components inside the board/stick. So, the
>> Kconfig allows to disable the automatic auto-selection, doing manual
>> selection.
>>
>> The logic basically implements it, using Kconfig way, on a logic like:
>>
>>        auto = ask_user_if_ancillary_drivers_should_be_auto_selected();
>>        driver_foo = ask_user_if_driver_foo_should_be_selected();
>>        if (driver_foo && auto) {
>>                select(bar1);
>>                select(bar2);
>>                select(bar3);
>>                select(bar4);
>>        }
>> ...
>>        if (!auto) {
>>                open_menu()
>>                ask_user_if_bar1_should_be_selected();
>>                ask_user_if_bar2_should_be_selected();
>>                ask_user_if_bar3_should_be_selected();
>>                ask_user_if_bar4_should_be_selected();
>> ...
>>                close_menu()
>>        }
>>
> no, you are hijacking Kconfig for something "illegal". 

It is not a new code that added this logic. The code is there
at least since 2006. It were added on this commit:

commit 1450e6bedc58c731617d99b4670070ed3ccc91b4
Author: Mauro Carvalho Chehab <mchehab@infradead.org>
Date:   Wed Aug 23 10:08:41 2006 -0300

> Note that this
> last word is not mine, it is the word used in the language
> description:
> 
>   Note:
>         select should be used with care. select will force
>         a symbol to a value without visiting the dependencies.
>         By abusing select you are able to select a symbol FOO even
>         if FOO depends on BAR that is not set.
>         In general use select only for non-visible symbols
>         (no prompts anywhere) and for symbols with no dependencies.
>         That will limit the usefulness but on the other hand avoid
>         the illegal configurations all over.
>         kconfig should one day warn about such things.
> 
> I guess the last line will need to be dropped, as this day has come.

All dependencies required by the selected symbols are satisfied. For example,
the simplest case is likely cafe_ccic, as, currently, there's just one possible
driver that can be attached dynamically at runtime to cafe_ccic. We have:

menu "Encoders/decoders and other helper chips"
	depends on !VIDEO_HELPER_CHIPS_AUTO

...
config VIDEO_OV7670
        tristate "OmniVision OV7670 sensor support"
        depends on I2C && VIDEO_V4L2
...
endmenu

config VIDEO_CAFE_CCIC
        tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
        depends on PCI && I2C && VIDEO_V4L2
        select VIDEO_OV7670

The dependencies needed by ov7670 (I2C and VIDEO_V4L2) are also dependencies of 
cafe_ccic. So, it shouldn't have any problem for it to work (and it doesn't have,
really. This is working as-is during the last 4 years).

It should be noticed that, even if we replace the menu dependencies by an
If, won't solve. I tried the enclosed patch, to see if it would produce something
that the new Kconfig behavior accepts. The same errors apply.

It is fine for me if you want/need to change the way Kconfig works, provided
that it won't break (or produce those annoying warnings) the existing logic, and
won't open the manual select menu, if the user selects the auto mode.
Just send us a patch changing it to some other way of doing it.

Thanks,
Mauro

---
Test patch, replacing depends on by if's. It doesn't really work, as Kconfig
seems to be internally converting if's into depends. So, no warning is removed.

--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -111,8 +111,8 @@ config VIDEO_IR_I2C
 # Encoder / Decoder module configuration
 #
 
+if !VIDEO_HELPER_CHIPS_AUTO
 menu "Encoders/decoders and other helper chips"
-	depends on !VIDEO_HELPER_CHIPS_AUTO
 
 comment "Audio decoders"
 
@@ -516,6 +516,7 @@ config VIDEO_UPD64083
 	  module will be called upd64083.
 
 endmenu # encoder / decoder chips
+endif
 
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"

