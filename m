Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1H3Bzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:55:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39755 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1H3Bzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <1313975049.2393.8.camel@offbook>
References: <1313975049.2393.8.camel@offbook>
Date: Mon, 29 Aug 2011 21:55:46 -0400
Message-ID: <CACqU3MXup87LamKaNz1w8GXQdPvMedEjy_Y=TPsyLDYKQi4jwA@mail.gmail.com>
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

On Sun, Aug 21, 2011 at 9:04 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> I recently got bitten in the ass when pressing Ctrl-C and lost all my current configuration changes. This patch captures SIGINT and allows the user to save any changes.
> Some code refactoring was made in order to handle the exit behavior.
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/mconf.c |   86 ++++++++++++++++++++++++++++------------------
>  1 files changed, 52 insertions(+), 34 deletions(-)
>
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 820d2b6..19e200d 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -15,6 +15,7 @@
>  #include <stdarg.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <signal.h>
>  #include <unistd.h>
>  #include <locale.h>
>
> @@ -272,6 +273,7 @@ static struct menu *current_menu;
>  static int child_count;
>  static int single_menu_mode;
>  static int show_all_options;
> +static int saved_x, saved_y;
>
>  static void conf(struct menu *menu);
>  static void conf_choice(struct menu *menu);
> @@ -792,9 +794,54 @@ static void conf_save(void)
>        }
>  }
>
> +static int handle_exit(void)
> +{
> +       int res;
> +
> +       dialog_clear();
> +       if (conf_get_changed())
> +               res = dialog_yesno(NULL,
> +                                  _("Do you wish to save your new configuration ?\n"
> +                                    "<ESC><ESC> to continue."),
> +                                  6, 60);
> +       else
> +               res = -1;
> +
> +       end_dialog(saved_x, saved_y);
> +
> +       switch (res) {
> +       case 0:
> +               if (conf_write(filename)) {
> +                       fprintf(stderr, _("\n\n"
> +                                         "Error while writing of the configuration.\n"
> +                                         "Your configuration changes were NOT saved."
> +                                         "\n\n"));
> +                       return 1;
> +               }
> +               /* fall through */
> +       case -1:
> +               printf(_("\n\n"
> +                        "*** End of the configuration.\n"
> +                        "*** Execute 'make' to start the build or try 'make help'."
> +                        "\n\n"));
> +               res = 0;
> +               break;
> +       default:
> +               fprintf(stderr, _("\n\n"
> +                                 "Your configuration changes were NOT saved."
> +                                 "\n\n"));
> +       }
> +
> +       return res;
> +}
> +
> +static void sig_handler(int signo)
> +{
> +       exit(handle_exit());
> +}
> +
Actually, no matter what handle_exit() returns, the process will
return error code 130 and make will abort. I'd suggest to get rid of
the call to exit(), and only keep handle_exit().

any objection ?

 - Arnaud

>  int main(int ac, char **av)
>  {
> -       int saved_x, saved_y;
>        char *mode;
>        int res;
>
> @@ -802,6 +849,8 @@ int main(int ac, char **av)
>        bindtextdomain(PACKAGE, LOCALEDIR);
>        textdomain(PACKAGE);
>
> +       signal(SIGINT, sig_handler);
> +
>        conf_parse(av[1]);
>        conf_read(NULL);
>
> @@ -823,40 +872,9 @@ int main(int ac, char **av)
>        set_config_filename(conf_get_configname());
>        do {
>                conf(&rootmenu);
> -               dialog_clear();
> -               if (conf_get_changed())
> -                       res = dialog_yesno(NULL,
> -                                          _("Do you wish to save your "
> -                                            "new configuration?\n"
> -                                            "<ESC><ESC> to continue."),
> -                                          6, 60);
> -               else
> -                       res = -1;
> +               res = handle_exit();
>        } while (res == KEY_ESC);
> -       end_dialog(saved_x, saved_y);
> -
> -       switch (res) {
> -       case 0:
> -               if (conf_write(filename)) {
> -                       fprintf(stderr, _("\n\n"
> -                               "Error while writing of the configuration.\n"
> -                               "Your configuration changes were NOT saved."
> -                               "\n\n"));
> -                       return 1;
> -               }
> -               /* fall through */
> -       case -1:
> -               printf(_("\n\n"
> -                       "*** End of the configuration.\n"
> -                       "*** Execute 'make' to start the build or try 'make help'."
> -                       "\n\n"));
> -               break;
> -       default:
> -               fprintf(stderr, _("\n\n"
> -                       "Your configuration changes were NOT saved."
> -                       "\n\n"));
> -       }
>
> -       return 0;
> +       return res;
>  }
>
> --
> 1.7.4.1
>
>
>
>
