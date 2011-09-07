Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1IGRDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:03:18 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42674 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1IGRDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:03:14 -0400
MIME-Version: 1.0
In-Reply-To: <1315402251.3124.0.camel@offbook>
References: <1313975049.2393.8.camel@offbook>
	<1315402251.3124.0.camel@offbook>
Date: Wed, 7 Sep 2011 10:18:21 -0400
Message-ID: <CACqU3MU5_VyG6urMwkDnf3h5bOP-Mbv+vkhNzf_1zyR2KL5v7g@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig: handle SIGINT in menuconfig
From: Arnaud Lacombe <lacombar@gmail.com>
To: dave@gnu.org
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 7, 2011 at 9:30 AM, Davidlohr Bueso <dave@gnu.org> wrote:
> Hi Michal
>
> If you have no objections, can you pick this one up?
>
I picked up in my tree while Michal was in vacation, he then merged
that in his tree. I should have notified you.

 - Arnaud

> Thanks.
> Davidlohr
>
> On Sun, 2011-08-21 at 22:04 -0300, Davidlohr Bueso wrote:
>> From: Davidlohr Bueso <dave@gnu.org>
>>
>> I recently got bitten in the ass when pressing Ctrl-C and lost all my current configuration changes. This patch captures SIGINT and allows the user to save any changes.
>> Some code refactoring was made in order to handle the exit behavior.
>>
>> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  scripts/kconfig/mconf.c |   86 ++++++++++++++++++++++++++++------------------
>>  1 files changed, 52 insertions(+), 34 deletions(-)
>>
>> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
>> index 820d2b6..19e200d 100644
>> --- a/scripts/kconfig/mconf.c
>> +++ b/scripts/kconfig/mconf.c
>> @@ -15,6 +15,7 @@
>>  #include <stdarg.h>
>>  #include <stdlib.h>
>>  #include <string.h>
>> +#include <signal.h>
>>  #include <unistd.h>
>>  #include <locale.h>
>>
>> @@ -272,6 +273,7 @@ static struct menu *current_menu;
>>  static int child_count;
>>  static int single_menu_mode;
>>  static int show_all_options;
>> +static int saved_x, saved_y;
>>
>>  static void conf(struct menu *menu);
>>  static void conf_choice(struct menu *menu);
>> @@ -792,9 +794,54 @@ static void conf_save(void)
>>       }
>>  }
>>
>> +static int handle_exit(void)
>> +{
>> +     int res;
>> +
>> +     dialog_clear();
>> +     if (conf_get_changed())
>> +             res = dialog_yesno(NULL,
>> +                                _("Do you wish to save your new configuration ?\n"
>> +                                  "<ESC><ESC> to continue."),
>> +                                6, 60);
>> +     else
>> +             res = -1;
>> +
>> +     end_dialog(saved_x, saved_y);
>> +
>> +     switch (res) {
>> +     case 0:
>> +             if (conf_write(filename)) {
>> +                     fprintf(stderr, _("\n\n"
>> +                                       "Error while writing of the configuration.\n"
>> +                                       "Your configuration changes were NOT saved."
>> +                                       "\n\n"));
>> +                     return 1;
>> +             }
>> +             /* fall through */
>> +     case -1:
>> +             printf(_("\n\n"
>> +                      "*** End of the configuration.\n"
>> +                      "*** Execute 'make' to start the build or try 'make help'."
>> +                      "\n\n"));
>> +             res = 0;
>> +             break;
>> +     default:
>> +             fprintf(stderr, _("\n\n"
>> +                               "Your configuration changes were NOT saved."
>> +                               "\n\n"));
>> +     }
>> +
>> +     return res;
>> +}
>> +
>> +static void sig_handler(int signo)
>> +{
>> +     exit(handle_exit());
>> +}
>> +
>>  int main(int ac, char **av)
>>  {
>> -     int saved_x, saved_y;
>>       char *mode;
>>       int res;
>>
>> @@ -802,6 +849,8 @@ int main(int ac, char **av)
>>       bindtextdomain(PACKAGE, LOCALEDIR);
>>       textdomain(PACKAGE);
>>
>> +     signal(SIGINT, sig_handler);
>> +
>>       conf_parse(av[1]);
>>       conf_read(NULL);
>>
>> @@ -823,40 +872,9 @@ int main(int ac, char **av)
>>       set_config_filename(conf_get_configname());
>>       do {
>>               conf(&rootmenu);
>> -             dialog_clear();
>> -             if (conf_get_changed())
>> -                     res = dialog_yesno(NULL,
>> -                                        _("Do you wish to save your "
>> -                                          "new configuration?\n"
>> -                                          "<ESC><ESC> to continue."),
>> -                                        6, 60);
>> -             else
>> -                     res = -1;
>> +             res = handle_exit();
>>       } while (res == KEY_ESC);
>> -     end_dialog(saved_x, saved_y);
>> -
>> -     switch (res) {
>> -     case 0:
>> -             if (conf_write(filename)) {
>> -                     fprintf(stderr, _("\n\n"
>> -                             "Error while writing of the configuration.\n"
>> -                             "Your configuration changes were NOT saved."
>> -                             "\n\n"));
>> -                     return 1;
>> -             }
>> -             /* fall through */
>> -     case -1:
>> -             printf(_("\n\n"
>> -                     "*** End of the configuration.\n"
>> -                     "*** Execute 'make' to start the build or try 'make help'."
>> -                     "\n\n"));
>> -             break;
>> -     default:
>> -             fprintf(stderr, _("\n\n"
>> -                     "Your configuration changes were NOT saved."
>> -                     "\n\n"));
>> -     }
>>
>> -     return 0;
>> +     return res;
>>  }
>>
>
>
>
