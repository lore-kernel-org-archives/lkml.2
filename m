Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1HTWMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 18:12:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58291 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1HTWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 18:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <1313873432.2655.1.camel@offbook>
References: <1313873432.2655.1.camel@offbook>
Date: Sat, 20 Aug 2011 18:12:05 -0400
Message-ID: <CACqU3MX51UOt6b9uB=M+ak-qRwO74gUj6MBRgjNEv=dXf+sxKw@mail.gmail.com>
Subject: Re: [PATCH] kconfig: handle SIGINT in menuconfig
From: Arnaud Lacombe <lacombar@gmail.com>
To: dave@gnu.org
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd15316daed7c04aaf7222d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd15316daed7c04aaf7222d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Aug 20, 2011 at 4:50 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> I recently got bitten in the ass when pressing Ctrl-C and lost all my cur=
rent configuration changes. This patch captures SIGINT and allows the user =
to save any changes.
Pretty much all front-ends have that behavior.

> Some code refactoring was made in order to handle the exit behavior.
>
beside a few nits, that look good.

 - Arnaud

> CC: Roman Zippel <zippel@linux-m68k.org>
Roman has been reported MIA for more than 2 years now, I do not think
this is needed anylonger.

> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
> =A0scripts/kconfig/mconf.c | =A0 76 ++++++++++++++++++++++++++++++++-----=
----------
> =A01 files changed, 52 insertions(+), 24 deletions(-)
>
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 820d2b6..7ca3bb7 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -6,6 +6,7 @@
> =A0* 2002-11-06 Petr Baudis <pasky@ucw.cz>
> =A0*
> =A0* i18n, 2005, Arnaldo Carvalho de Melo <acme@conectiva.com.br>
> + * Handle SIGINT (Ctrl-C), 2011, Davidlohr Bueso <dave@gnu.org>
> =A0*/
>
FWIW, I do not really see the point of that, if you are looking for
code history git does a better job, as well as for who deserve
copyright on the code.

> =A0#include <ctype.h>
> @@ -15,6 +16,7 @@
> =A0#include <stdarg.h>
> =A0#include <stdlib.h>
> =A0#include <string.h>
> +#include <signal.h>
> =A0#include <unistd.h>
> =A0#include <locale.h>
>
> @@ -272,6 +274,7 @@ static struct menu *current_menu;
> =A0static int child_count;
> =A0static int single_menu_mode;
> =A0static int show_all_options;
> +static int saved_x, saved_y;
>
> =A0static void conf(struct menu *menu);
> =A0static void conf_choice(struct menu *menu);
> @@ -792,9 +795,54 @@ static void conf_save(void)
> =A0 =A0 =A0 =A0}
> =A0}
>
> +static int handle_exit(int res)
> +{
> + =A0 =A0 =A0 switch (res) {
> + =A0 =A0 =A0 case 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (conf_write(filename)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, _("\n\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "Error while writing of the configuration.\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "Your configuration changes were NOT saved."
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "\n\n"));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* fall through */
> + =A0 =A0 =A0 case -1:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_("\n\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"*** End of the configur=
ation.\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"*** Execute 'make' to s=
tart the build or try 'make help'."
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"\n\n"));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, _("\n\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Your c=
onfiguration changes were NOT saved."
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\n")=
);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void sig_handler(int signo __attribute__((__unused__)))
__attribute__(()) is useless here, it is not used once across the file
and gcc will not warn unless you ask it to be really verbose, which we
do not.

> +{
> + =A0 =A0 =A0 int res;
> +
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dialog_clear();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (conf_get_changed())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D dialog_yesno(NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0_("Do you wish to save your "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"new configuration?\n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A06, 60);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D -1;
> + =A0 =A0 =A0 } while (res =3D=3D KEY_ESC);
> +
I do not really see the point of the loop here.

I'd suggest to have a single termination handling path. How about the
attached patch ?

The message displayed might need tweaking.

Thanks,
 - Arnaud

> + =A0 =A0 =A0 end_dialog(saved_x, saved_y);
> + =A0 =A0 =A0 exit(handle_exit(res));
> +}
> +
> =A0int main(int ac, char **av)
> =A0{
> - =A0 =A0 =A0 int saved_x, saved_y;
> =A0 =A0 =A0 =A0char *mode;
> =A0 =A0 =A0 =A0int res;
>
> @@ -802,6 +850,8 @@ int main(int ac, char **av)
> =A0 =A0 =A0 =A0bindtextdomain(PACKAGE, LOCALEDIR);
> =A0 =A0 =A0 =A0textdomain(PACKAGE);
>
> + =A0 =A0 =A0 signal(SIGINT, sig_handler);
> +
> =A0 =A0 =A0 =A0conf_parse(av[1]);
> =A0 =A0 =A0 =A0conf_read(NULL);
>
> @@ -835,28 +885,6 @@ int main(int ac, char **av)
> =A0 =A0 =A0 =A0} while (res =3D=3D KEY_ESC);
> =A0 =A0 =A0 =A0end_dialog(saved_x, saved_y);
>
> - =A0 =A0 =A0 switch (res) {
> - =A0 =A0 =A0 case 0:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (conf_write(filename)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, _("\n\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Error whil=
e writing of the configuration.\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Your confi=
guration changes were NOT saved."
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\n"));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* fall through */
> - =A0 =A0 =A0 case -1:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_("\n\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "*** End of the configurati=
on.\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "*** Execute 'make' to star=
t the build or try 'make help'."
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\n"));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, _("\n\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Your configuration changes=
 were NOT saved."
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\n"));
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 return handle_exit(res);
> =A0}
>
> --
> 1.7.4.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--000e0cd15316daed7c04aaf7222d
Content-Type: text/x-patch; charset=US-ASCII; name="sigint.diff"
Content-Disposition: attachment; filename="sigint.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grl4w9fl0

ZGlmZiAtLWdpdCBhL3NjcmlwdHMva2NvbmZpZy9tY29uZi5jIGIvc2NyaXB0cy9rY29uZmlnL21j
b25mLmMKaW5kZXggN2NhM2JiNy4uOTBjN2IyZSAxMDA2NDQKLS0tIGEvc2NyaXB0cy9rY29uZmln
L21jb25mLmMKKysrIGIvc2NyaXB0cy9rY29uZmlnL21jb25mLmMKQEAgLTc5NSw4ICs3OTUsMjEg
QEAgc3RhdGljIHZvaWQgY29uZl9zYXZlKHZvaWQpCiAJfQogfQogCi1zdGF0aWMgaW50IGhhbmRs
ZV9leGl0KGludCByZXMpCitzdGF0aWMgaW50IGhhbmRsZV9leGl0KGludCBmYXRhbCkKIHsKKwlp
bnQgcmVzOworCisJZGlhbG9nX2NsZWFyKCk7CisJaWYgKGNvbmZfZ2V0X2NoYW5nZWQoKSkKKwkJ
cmVzID0gZGlhbG9nX3llc25vKE5VTEwsCisJCQkJICAgXygiRG8geW91IHdpc2ggdG8gc2F2ZSB5
b3VyIG5ldyBjb25maWd1cmF0aW9uID9cbiIKKwkJCQkgICAgICI8RVNDPjxFU0M+IHRvIGNvbnRp
bnVlLiIpLAorCQkJCSAgIDYsIDYwKTsKKwllbHNlCisJCXJlcyA9IC0xOworCisJZW5kX2RpYWxv
ZyhzYXZlZF94LCBzYXZlZF95KTsKKwogCXN3aXRjaCAocmVzKSB7CiAJY2FzZSAwOgogCQlpZiAo
Y29uZl93cml0ZShmaWxlbmFtZSkpIHsKQEAgLTgxMiw2ICs4MjUsNyBAQCBzdGF0aWMgaW50IGhh
bmRsZV9leGl0KGludCByZXMpCiAJCQkgIioqKiBFbmQgb2YgdGhlIGNvbmZpZ3VyYXRpb24uXG4i
CiAJCQkgIioqKiBFeGVjdXRlICdtYWtlJyB0byBzdGFydCB0aGUgYnVpbGQgb3IgdHJ5ICdtYWtl
IGhlbHAnLiIKIAkJCSAiXG5cbiIpKTsKKwkJcmVzID0gMDsKIAkJYnJlYWs7CiAJZGVmYXVsdDoK
IAkJZnByaW50ZihzdGRlcnIsIF8oIlxuXG4iCkBAIC04MTksMjYgKzgzMywxMyBAQCBzdGF0aWMg
aW50IGhhbmRsZV9leGl0KGludCByZXMpCiAJCQkJICAiXG5cbiIpKTsKIAl9CiAKLQlyZXR1cm4g
MDsKKwlyZXR1cm4gcmVzOwogfQogCiBzdGF0aWMgdm9pZCBzaWdfaGFuZGxlcihpbnQgc2lnbm8g
X19hdHRyaWJ1dGVfXygoX191bnVzZWRfXykpKQogewotCWludCByZXM7Ci0JCi0JZG8gewotCQlk
aWFsb2dfY2xlYXIoKTsKLQkJaWYgKGNvbmZfZ2V0X2NoYW5nZWQoKSkKLQkJCXJlcyA9IGRpYWxv
Z195ZXNubyhOVUxMLAotCQkJCQkgICBfKCJEbyB5b3Ugd2lzaCB0byBzYXZlIHlvdXIgIgotCQkJ
CQkgICAgICJuZXcgY29uZmlndXJhdGlvbj9cbiIpLAotCQkJCQkgICA2LCA2MCk7Ci0JCWVsc2UK
LQkJCXJlcyA9IC0xOwotCX0gd2hpbGUgKHJlcyA9PSBLRVlfRVNDKTsKIAotCWVuZF9kaWFsb2co
c2F2ZWRfeCwgc2F2ZWRfeSk7Ci0JZXhpdChoYW5kbGVfZXhpdChyZXMpKTsKKwlleGl0KGhhbmRs
ZV9leGl0KDEpKTsKIH0KIAogaW50IG1haW4oaW50IGFjLCBjaGFyICoqYXYpCkBAIC04NzMsMTgg
Kzg3NCw5IEBAIGludCBtYWluKGludCBhYywgY2hhciAqKmF2KQogCXNldF9jb25maWdfZmlsZW5h
bWUoY29uZl9nZXRfY29uZmlnbmFtZSgpKTsKIAlkbyB7CiAJCWNvbmYoJnJvb3RtZW51KTsKLQkJ
ZGlhbG9nX2NsZWFyKCk7Ci0JCWlmIChjb25mX2dldF9jaGFuZ2VkKCkpCi0JCQlyZXMgPSBkaWFs
b2dfeWVzbm8oTlVMTCwKLQkJCQkJICAgXygiRG8geW91IHdpc2ggdG8gc2F2ZSB5b3VyICIKLQkJ
CQkJICAgICAibmV3IGNvbmZpZ3VyYXRpb24/XG4iCi0JCQkJCSAgICAgIjxFU0M+PEVTQz4gdG8g
Y29udGludWUuIiksCi0JCQkJCSAgIDYsIDYwKTsKLQkJZWxzZQotCQkJcmVzID0gLTE7CisJCXJl
cyA9IGhhbmRsZV9leGl0KDApOwogCX0gd2hpbGUgKHJlcyA9PSBLRVlfRVNDKTsKLQllbmRfZGlh
bG9nKHNhdmVkX3gsIHNhdmVkX3kpOwogCi0JcmV0dXJuIGhhbmRsZV9leGl0KHJlcyk7CisJcmV0
dXJuIHJlczsKIH0KIAo=
--000e0cd15316daed7c04aaf7222d--
