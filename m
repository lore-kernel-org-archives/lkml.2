Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1GJQSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:18:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42332 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1GJQSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAMT+=WY84jaattF+9zYK7oiJLmn8_oGLB-mnGbOpK_4Rt0vRZg@mail.gmail.com>
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
	<1310282825-14509-1-git-send-email-lacombar@gmail.com>
	<1310282825-14509-2-git-send-email-lacombar@gmail.com>
	<CAMT+=WY84jaattF+9zYK7oiJLmn8_oGLB-mnGbOpK_4Rt0vRZg@mail.gmail.com>
Date: Sun, 10 Jul 2011 12:18:13 -0400
Message-ID: <CACqU3MUB=CUx+a=8bji5Rk7-KUiGEao8Lypar+7hrG-faH360A@mail.gmail.com>
Subject: Re: [PATCH 2/2] kconfig/nconf: prevent segfault on empty menu
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrej Gelenberg <andrej.gelenberg@udo.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 10, 2011 at 6:32 AM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
> Hello.
>
> On Sun, Jul 10, 2011 at 10:27 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> nconf does not check the validity of the current menu when help is requested
>> (with either <F2>, '?' or 'h'). This leads to a NULL pointer dereference when an
>> empty menu is encountered.
>>
>> The following reduced testcase exposes the problem:
>>
>> config DEP
>>        bool
>>
>> menu "FOO"
>>
>> config BAR
>>        bool "BAR"
>>        depends on DEP
>>
>> endmenu
>>
>> Issue will happen when entering menu "FOO" and requesting help.
>>
>> nconf is the only front-end which do not filter the validity of the current
>> menu. Such filter can not really happen beforehand as other key which does not
>> deals with the current menu might be entered by the user, so just bails out
>> earlier if we encounter an invalid menu.
>
> I do not believe the correct solution is silently ignoring the user's
> key presses. I think the correct behavior would be to display a
> nohelp_text window.
>
> something like this (untested):
> show_scroll_win(main_window, nohelp_text);
>
This would be:

show_scroll_win(main_window, _(menu_get_prompt(menu)), nohelp_text);

but we would fall back on the original issue as requesting the prompt
of an invalid menu does not make sense, so the menu_get_prompt(menu)
would still have to be replaced with something valid. It would be nice
to come up with a solution valid at least for nconf and mconf.
Currently mconf just silently discard the key pressed.

To some extend I do not think any frontend should display a menu which
has no visible child, but that may require more changes and affect
performance...

 - Arnaud

> The other patches in the series seem gr8.
>
> Cheers.
>
>> Cc: Nir Tzachar <nir.tzachar@gmail.com>
>> Cc: Andrej Gelenberg <andrej.gelenberg@udo.edu>
>> Reported-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  scripts/kconfig/nconf.c |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
>> index 24fc79a..eb9e49d 100644
>> --- a/scripts/kconfig/nconf.c
>> +++ b/scripts/kconfig/nconf.c
>> @@ -1222,7 +1222,12 @@ static void conf_message_callback(const char *fmt, va_list ap)
>>
>>  static void show_help(struct menu *menu)
>>  {
>> -       struct gstr help = str_new();
>> +       struct gstr help;
>> +
>> +       if (!menu)
>> +               return;
>> +
>> +       help = str_new();
>>        menu_get_ext_help(menu, &help);
>>        show_scroll_win(main_window, _(menu_get_prompt(menu)), str_get(&help));
>>        str_free(&help);
>> --
>> 1.7.3.4.574.g608b.dirty
>>
>>
>
