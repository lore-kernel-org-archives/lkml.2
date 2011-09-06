Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1IFMdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:33:55 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:33480 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754191Ab1IFMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:33:51 -0400
Subject: Re: [PATCH v2] kconfig: handle SIGINT in menuconfig
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <CACqU3MUOxLYEsuVv5d=LSjNio5ZHg3E8K+i2ztQshttUfemsdA@mail.gmail.com>
References: <1313975049.2393.8.camel@offbook>
	 <CACqU3MXup87LamKaNz1w8GXQdPvMedEjy_Y=TPsyLDYKQi4jwA@mail.gmail.com>
	 <CACqU3MUOxLYEsuVv5d=LSjNio5ZHg3E8K+i2ztQshttUfemsdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Tue, 06 Sep 2011 09:33:37 -0300
Message-ID: <1315312417.2532.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 22:12 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Aug 29, 2011 at 9:55 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > Hi,
> >
> > On Sun, Aug 21, 2011 at 9:04 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> >> From: Davidlohr Bueso <dave@gnu.org>
> >>
> >> I recently got bitten in the ass when pressing Ctrl-C and lost all my current configuration changes. This patch captures SIGINT and allows the user to save any changes.
> >> Some code refactoring was made in order to handle the exit behavior.
> >>
> >> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> >> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> >> ---
> >>  scripts/kconfig/mconf.c |   86 ++++++++++++++++++++++++++++------------------
> >>  1 files changed, 52 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> >> index 820d2b6..19e200d 100644
> >> --- a/scripts/kconfig/mconf.c
> >> +++ b/scripts/kconfig/mconf.c
> >> @@ -15,6 +15,7 @@
> >>  #include <stdarg.h>
> >>  #include <stdlib.h>
> >>  #include <string.h>
> >> +#include <signal.h>
> >>  #include <unistd.h>
> >>  #include <locale.h>
> >>
> >> @@ -272,6 +273,7 @@ static struct menu *current_menu;
> >>  static int child_count;
> >>  static int single_menu_mode;
> >>  static int show_all_options;
> >> +static int saved_x, saved_y;
> >>
> >>  static void conf(struct menu *menu);
> >>  static void conf_choice(struct menu *menu);
> >> @@ -792,9 +794,54 @@ static void conf_save(void)
> >>        }
> >>  }
> >>
> >> +static int handle_exit(void)
> >> +{
> >> +       int res;
> >> +
> >> +       dialog_clear();
> >> +       if (conf_get_changed())
> >> +               res = dialog_yesno(NULL,
> >> +                                  _("Do you wish to save your new configuration ?\n"
> >> +                                    "<ESC><ESC> to continue."),
> >> +                                  6, 60);
> >> +       else
> >> +               res = -1;
> >> +
> >> +       end_dialog(saved_x, saved_y);
> >> +
> >> +       switch (res) {
> >> +       case 0:
> >> +               if (conf_write(filename)) {
> >> +                       fprintf(stderr, _("\n\n"
> >> +                                         "Error while writing of the configuration.\n"
> >> +                                         "Your configuration changes were NOT saved."
> >> +                                         "\n\n"));
> >> +                       return 1;
> >> +               }
> >> +               /* fall through */
> >> +       case -1:
> >> +               printf(_("\n\n"
> >> +                        "*** End of the configuration.\n"
> >> +                        "*** Execute 'make' to start the build or try 'make help'."
> >> +                        "\n\n"));
> >> +               res = 0;
> >> +               break;
> >> +       default:
> >> +               fprintf(stderr, _("\n\n"
> >> +                                 "Your configuration changes were NOT saved."
> >> +                                 "\n\n"));
> >> +       }
> >> +
> >> +       return res;
> >> +}
> >> +
> >> +static void sig_handler(int signo)
> >> +{
> >> +       exit(handle_exit());
> >> +}
> >> +
> > Actually, no matter what handle_exit() returns, the process will
> > return error code 130 and make will abort. I'd suggest to get rid of
> > the call to exit(), and only keep handle_exit().
> >
> > any objection ?
> >
> stupid me... we need the call to exit(2), but its argument do not seem
> to be used.

Right otherwise we can't quit the program. The 130 exit code occurs
because we're aborting the make process, nothing we can do about that, I
think.

Thanks,
Davidlohr

