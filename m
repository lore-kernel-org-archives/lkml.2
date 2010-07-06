Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0GFCKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:10:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40406 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab0GFCKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=C1Oy0lDt2HCp8MSIBaDPptcZwERtNO7vNMTc14Xko4SrCLlRe/SAWuSJ3BYsUj3Wii
         cWp67AbzafKGhSxFpuEaJQHCu2DDF0EeeFUZpXAp6wgwxuXGvNtHGDJtWHzfoIFI1OTf
         Qr4udRmGMgrCPZ3o1Q9NCjMDlKz3qPFdolJWg=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <201007050712.o657CpjO028121@turbo.physics.adelaide.edu.au>
References: <1278061453.15256.1.camel@mola> <201007050712.o657CpjO028121@turbo.physics.adelaide.edu.au>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 6 Jul 2010 10:09:45 +0800
Message-ID: <AANLkTikVhgjsUrC472itOVlyZuBNXlpkJR5ATu4Eh6AV@mail.gmail.com>
Subject: Re: [PATCH] compal-laptop/fujitsu-laptop/msi-laptop: make 
	dmi_check_cb
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Richard Purdie <rpurdie@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Lee Chun-Yi <jlee@novell.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/5 Jonathan Woithe <jwoithe@physics.adelaide.edu.au>:
> Is there no possibility of some other matching function existing after ours
> in the tree which might need to also be called?  If so, this change would
> prevent that.

hi Jonathan,

I checked the implementation of dmi_check_system() and the useage cases in
compal-laptop/fujitsu-laptop/msi-laptop, it should be no problem with
this change.

In compal-laptop and msi-laptop, we call dmi_check_system() to
identify the laptop model.
(The callback simply print the identified laptop model)
It should have zero or exactly one successful match.

In fujitsu-laptop, we call dmi_check_system() to identify the laptop
model and set parameters accordingly.
The callback print the identified laptop model and set parameters
(use_alt_lcd_levels / fujitsu->keycode[1|2|3|4|5] ).
It should have zero or exactly one successful match.
If it has some other matching function with successful match, then
current implementation
is buggy anyway because new successful matches will override the
fujitsu->keycode[1|2|3|4|5]
parameters.

Regards,
Axel

>
> Regards
>  jonathan
>
>> dmi_check_system() walks the table running matching functions until someone
>> returns non zero or we hit the end.
>>
>> This patch makes dmi_check_cb to return 1 so dmi_check_system() return
>> immediately when a match is found.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/platform/x86/compal-laptop.c  |    2 +-
>>  drivers/platform/x86/fujitsu-laptop.c |    6 +++---
>>  drivers/platform/x86/msi-laptop.c     |    2 +-
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
>> index 71ff154..dc31a08 100644
>> --- a/drivers/platform/x86/compal-laptop.c
>> +++ b/drivers/platform/x86/compal-laptop.c
>> @@ -190,7 +190,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
>>       printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
>>               id->ident);
>>
>> -     return 0;
>> +     return 1;
>>  }
>>
>>  static struct dmi_system_id __initdata compal_dmi_table[] = {
>> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
>> index dab1a0e..1859d7f 100644
>> --- a/drivers/platform/x86/fujitsu-laptop.c
>> +++ b/drivers/platform/x86/fujitsu-laptop.c
>> @@ -603,7 +603,7 @@ static int dmi_check_cb_s6410(const struct dmi_system_id *id)
>>       dmi_check_cb_common(id);
>>       fujitsu->keycode1 = KEY_SCREENLOCK;     /* "Lock" */
>>       fujitsu->keycode2 = KEY_HELP;   /* "Mobility Center" */
>> -     return 0;
>> +     return 1;
>>  }
>>
>>  static int dmi_check_cb_s6420(const struct dmi_system_id *id)
>> @@ -611,7 +611,7 @@ static int dmi_check_cb_s6420(const struct dmi_system_id *id)
>>       dmi_check_cb_common(id);
>>       fujitsu->keycode1 = KEY_SCREENLOCK;     /* "Lock" */
>>       fujitsu->keycode2 = KEY_HELP;   /* "Mobility Center" */
>> -     return 0;
>> +     return 1;
>>  }
>>
>>  static int dmi_check_cb_p8010(const struct dmi_system_id *id)
>> @@ -620,7 +620,7 @@ static int dmi_check_cb_p8010(const struct dmi_system_id *id)
>>       fujitsu->keycode1 = KEY_HELP;   /* "Support" */
>>       fujitsu->keycode3 = KEY_SWITCHVIDEOMODE;        /* "Presentation" */
>>       fujitsu->keycode4 = KEY_WWW;    /* "Internet" */
>> -     return 0;
>> +     return 1;
>>  }
>>
>>  static struct dmi_system_id fujitsu_dmi_table[] = {
>> diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
>> index afd762b..c67a74c 100644
>> --- a/drivers/platform/x86/msi-laptop.c
>> +++ b/drivers/platform/x86/msi-laptop.c
>> @@ -434,7 +434,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
>>  {
>>       printk(KERN_INFO "msi-laptop: Identified laptop model '%s'.\n",
>>              id->ident);
>> -     return 0;
>> +     return 1;
>>  }
>>
>>  static struct dmi_system_id __initdata msi_dmi_table[] = {
>> --
>> 1.5.4.3
>>
>>
>>
>
>
> --
> * Jonathan Woithe    jwoithe@physics.adelaide.edu.au                        *
> *                    http://www.physics.adelaide.edu.au/~jwoithe            *
> ***-----------------------------------------------------------------------***
> ** "Time is an illusion; lunchtime doubly so"                              **
> *  "...you wouldn't recognize a subtle plan if it painted itself purple and *
> *   danced naked on a harpsichord singing 'subtle plans are here again'"    *
>
