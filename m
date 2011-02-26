Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914Ab1BZB3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:29:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52641 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1BZB3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lyFt5u2hOccZxSXNKJ7bmNpLamEBMz/arUFB2VfL7sai3/Kg3qH7qwpvgXzx6BtE9m
         6ovqnGLNcvYeFQnAzCObDiLQlaY/wapaGyxEmS5hZ+yJ73hpVUEeFnnuuzkWREi9iDbD
         J+IpJPsI1b4cfrhLWe6N8gQRieY85UcfCynDw=
MIME-Version: 1.0
In-Reply-To: <4D684CF5.2060206@suse.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<4D684CF5.2060206@suse.com>
Date: Fri, 25 Feb 2011 20:28:58 -0500
Message-ID: <AANLkTikD2EiTbqMTCK7GUCTkTig3C5H2fMHbgodMfA4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] kconfig: add support for type handlers
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 25, 2011 at 7:44 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>  This patch adds type handlers for compressed config files. Initial
>  support provides callouts for gzip and bzip2, but there's no reason
>  others could be added if demand is there.
>
>  This is intended to allow /proc/config.gz be a configuration source
>  for 'make oldconfig' when .config is absent.
>
this can be trivially scripted, any reason it _has_ to be done within kconfig ?

 - Arnaud

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>
>  scripts/kconfig/zconf.l |   50 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 48 insertions(+), 2 deletions(-)
>
> --- a/scripts/kconfig/zconf.l
> +++ b/scripts/kconfig/zconf.l
> @@ -256,6 +256,44 @@ static void zconf_endhelp(void)
>        BEGIN(INITIAL);
>  }
>
> +static const struct type_handler {
> +       const char *suffix;
> +       const char *command;
> +} type_handlers[] = {
> +       {
> +               .suffix = ".gz",
> +               .command = "zcat",
> +       },
> +       {
> +               .suffix = ".bz2",
> +               .command = "bzcat",
> +       },
> +       /* Whatever other algorithms you like */
> +       {}
> +};
> +
> +static const struct type_handler *get_type_handler(const char *name)
> +{
> +       char *p = rindex(name, '.');
> +       if (p) {
> +               const struct type_handler *ops = type_handlers;
> +               for (ops = type_handlers; ops->suffix; ops++) {
> +                       if (!strcasecmp(ops->suffix, p))
> +                               break;
> +               }
> +               if (!ops->suffix)
> +                       return NULL;
> +               return ops;
> +       }
> +       return NULL;
> +}
> +
> +static FILE *zconf_popen(const char *command, const char *name)
> +{
> +       char cmdbuf[PATH_MAX + strlen(command) + 2];
> +       snprintf(cmdbuf, sizeof(cmdbuf), "%s %s", command, name);
> +       return popen(cmdbuf, "r");
> +}
>
>  /*
>  * Try to open specified file with following names:
> @@ -267,15 +305,23 @@ static void zconf_endhelp(void)
>  */
>  FILE *zconf_fopen(const char *name)
>  {
> +       const struct type_handler *handler = get_type_handler(name);
>        char *env, fullname[PATH_MAX+1];
>        FILE *f;
>
> -       f = fopen(name, "r");
> +       if (handler)
> +               f = zconf_popen(handler->command, name);
> +       else
> +               f = fopen(name, "r");
> +
>        if (!f && name != NULL && name[0] != '/') {
>                env = getenv(SRCTREE);
>                if (env) {
>                        sprintf(fullname, "%s/%s", env, name);
> -                       f = fopen(fullname, "r");
> +                       if (handler)
> +                               f = zconf_popen(handler->command, fullname);
> +                       else
> +                               f = fopen(fullname, "r");
>                }
>        }
>        return f;
>
> --
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
