Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1HUWsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:48:20 -0400
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:33065 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753894Ab1HUWsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:48:19 -0400
X-Greylist: delayed 93454 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Aug 2011 18:48:19 EDT
Subject: Re: [PATCH] kconfig: handle SIGINT in menuconfig
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <CACqU3MX51UOt6b9uB=M+ak-qRwO74gUj6MBRgjNEv=dXf+sxKw@mail.gmail.com>
References: <1313873432.2655.1.camel@offbook>
	 <CACqU3MX51UOt6b9uB=M+ak-qRwO74gUj6MBRgjNEv=dXf+sxKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sun, 21 Aug 2011 19:48:02 -0300
Message-ID: <1313966882.2393.2.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-20 at 18:12 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Sat, Aug 20, 2011 at 4:50 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> >
> > I recently got bitten in the ass when pressing Ctrl-C and lost all my current configuration changes. This patch captures SIGINT and allows the user to save any changes.
> Pretty much all front-ends have that behavior.
> 
> > Some code refactoring was made in order to handle the exit behavior.
> >
> beside a few nits, that look good.

Thanks for reviewing.

> 
>  - Arnaud
> 
> > CC: Roman Zippel <zippel@linux-m68k.org>
> Roman has been reported MIA for more than 2 years now, I do not think
> this is needed anylonger.
> 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  scripts/kconfig/mconf.c |   76 ++++++++++++++++++++++++++++++++---------------
> >  1 files changed, 52 insertions(+), 24 deletions(-)
> >
> > diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> > index 820d2b6..7ca3bb7 100644
> > --- a/scripts/kconfig/mconf.c
> > +++ b/scripts/kconfig/mconf.c
> > @@ -6,6 +6,7 @@
> >  * 2002-11-06 Petr Baudis <pasky@ucw.cz>
> >  *
> >  * i18n, 2005, Arnaldo Carvalho de Melo <acme@conectiva.com.br>
> > + * Handle SIGINT (Ctrl-C), 2011, Davidlohr Bueso <dave@gnu.org>
> >  */
> >
> FWIW, I do not really see the point of that, if you are looking for
> code history git does a better job, as well as for who deserve
> copyright on the code.
> 
> >  #include <ctype.h>
> > @@ -15,6 +16,7 @@
> >  #include <stdarg.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > +#include <signal.h>
> >  #include <unistd.h>
> >  #include <locale.h>
> >
> > @@ -272,6 +274,7 @@ static struct menu *current_menu;
> >  static int child_count;
> >  static int single_menu_mode;
> >  static int show_all_options;
> > +static int saved_x, saved_y;
> >
> >  static void conf(struct menu *menu);
> >  static void conf_choice(struct menu *menu);
> > @@ -792,9 +795,54 @@ static void conf_save(void)
> >        }
> >  }
> >
> > +static int handle_exit(int res)
> > +{
> > +       switch (res) {
> > +       case 0:
> > +               if (conf_write(filename)) {
> > +                       fprintf(stderr, _("\n\n"
> > +                                         "Error while writing of the configuration.\n"
> > +                                         "Your configuration changes were NOT saved."
> > +                                         "\n\n"));
> > +                       return 1;
> > +               }
> > +               /* fall through */
> > +       case -1:
> > +               printf(_("\n\n"
> > +                        "*** End of the configuration.\n"
> > +                        "*** Execute 'make' to start the build or try 'make help'."
> > +                        "\n\n"));
> > +               break;
> > +       default:
> > +               fprintf(stderr, _("\n\n"
> > +                                 "Your configuration changes were NOT saved."
> > +                                 "\n\n"));
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void sig_handler(int signo __attribute__((__unused__)))
> __attribute__(()) is useless here, it is not used once across the file
> and gcc will not warn unless you ask it to be really verbose, which we
> do not.
> 
> > +{
> > +       int res;
> > +
> > +       do {
> > +               dialog_clear();
> > +               if (conf_get_changed())
> > +                       res = dialog_yesno(NULL,
> > +                                          _("Do you wish to save your "
> > +                                            "new configuration?\n"),
> > +                                          6, 60);
> > +               else
> > +                       res = -1;
> > +       } while (res == KEY_ESC);
> > +
> I do not really see the point of the loop here.

Because I didn't want to allow the user the ESC+ESC option when exiting
with Ctrl-C.

> 
> I'd suggest to have a single termination handling path. How about the
> attached patch ?

Makes sense, no objections here. I'll send a new version of the patch
with your changes.

Thanks,
Davidlohr

