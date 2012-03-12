Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2CLHvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:51:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57769 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2CLHvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <4F5DA722.3090806@codeaurora.org>
References: <1331524397-19783-1-git-send-email-hamo.by@gmail.com>
 <4F5D9BCF.3030302@codeaurora.org> <CAO_0yfPR3cvrpuOS68pYJFSHFQdfu0C=PzAA5iRu01otQTNaNg@mail.gmail.com>
 <4F5DA722.3090806@codeaurora.org>
From: Yang Bai <hamo.by@gmail.com>
Date: Mon, 12 Mar 2012 15:50:56 +0800
Message-ID: <CAO_0yfMGR=W+ocKER8EyKOB5ZKddOfbwnVb_Za_FDbPrZRaWBA@mail.gmail.com>
Subject: Re: [PATCH] Makefile: fix error when gen TAGS
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: mmarek@suse.cz, rostedt@goodmis.org, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 3:34 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
> Ah ok. How about this patch instead? Then we don't duplicate the sed
> statement.
>
> ---->8-------
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 833813a..b390096 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -168,7 +168,7 @@ exuberant()
>
>        --regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
>
>        # Remove structure forward declarations.
> -       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
> \1;.*\$\/;"\tx$/d' tags
> +       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
> \1;.*\$\/;"\tx$/d' $2
>  }
>
>  emacs()
> @@ -213,9 +213,9 @@ emacs()
>  xtags()
>  {
>        if $1 --version 2>&1 | grep -iq exuberant; then
> -               exuberant $1
> +               exuberant $1 $2
>        elif $1 --version 2>&1 | grep -iq emacs; then
> -               emacs $1
> +               emacs $1 $2
>        else
>                all_sources | xargs $1 -a
>         fi
> @@ -244,11 +244,11 @@ case "$1" in
>
>        "tags")
>                rm -f tags
> -               xtags ctags
> +               xtags ctags $1
>                ;;
>
>        "TAGS")
>                rm -f TAGS
> -               xtags etags
> +               xtags etags $1
>                ;;
>  esac
>
>
> But then with your next patch maybe it would be better to just have a flag?
>
> ----8<-----
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 833813a..4b1755d 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -166,9 +166,6 @@ exuberant()
>        all_defconfigs | xargs -r $1 -a                         \
>        --langdef=dotconfig --language-force=dotconfig          \
>
>        --regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
> -
> -       # Remove structure forward declarations.
>
> -       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
> \1;.*\$\/;"\tx$/d' tags
>  }
>
>  emacs()
> @@ -233,6 +230,7 @@ if [ "${ARCH}" = "um" ]; then
>        fi
>  fi
>
> +remove_structs=
>  case "$1" in
>        "cscope")
>                docscope
> @@ -244,11 +242,18 @@ case "$1" in
>
>        "tags")
>                rm -f tags
> -               xtags ctags
> +               xtags ctags $1

Why we need a $1 here??
> +               remove_structs=y
>                ;;
>
>        "TAGS")
>                rm -f TAGS
> -               xtags etags
> +               xtags etags $1
The same.
> +               remove_structs=y
>                ;;
>  esac
> +
> +# Remove structure forward declarations.
> +if [ -n $remove_structs ]; then
> +       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
> \1;.*\$\/;"\tx$/d' $1
> +fi
>

This way is better but I don't understand why a $1 is there.
I think it is useless and if you agree with me, i will send a fine patch to you.
