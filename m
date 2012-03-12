Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2CLHfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:35:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2CLHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:34:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="169261568"
Message-ID: <4F5DA722.3090806@codeaurora.org>
Date: Mon, 12 Mar 2012 00:34:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>
CC: mmarek@suse.cz, rostedt@goodmis.org, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Makefile: fix error when gen TAGS
References: <1331524397-19783-1-git-send-email-hamo.by@gmail.com> <4F5D9BCF.3030302@codeaurora.org> <CAO_0yfPR3cvrpuOS68pYJFSHFQdfu0C=PzAA5iRu01otQTNaNg@mail.gmail.com>
In-Reply-To: <CAO_0yfPR3cvrpuOS68pYJFSHFQdfu0C=PzAA5iRu01otQTNaNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 12:06 AM, Yang Bai wrote:
> On Mon, Mar 12, 2012 at 2:46 PM, Stephen Boyd<sboyd@codeaurora.org>  wrote:
>>
>> What does ctags --version print out for you? I'm not aware of exuberant tags
>> outputting files called TAGS (although etags would do that and then this
>> patch wouldn't make sense).
> hamo@trinity ~ $ ctags --version
> Exuberant Ctags 5.9~svn20110310, Copyright (C) 1996-2009 Darren Hiebert
>    Compiled: Nov  9 2011, 03:17:31
>    Addresses:<dhiebert@users.sourceforge.net>, http://ctags.sourceforge.net
>    Optional compiled features: +wildcards, +regex
>
> hamo@trinity ~ $ etags --version
> Exuberant Ctags 5.9~svn20110310, Copyright (C) 1996-2009 Darren Hiebert
>    Compiled: Nov  9 2011, 03:17:31
>    Addresses:<dhiebert@users.sourceforge.net>, http://ctags.sourceforge.net
>    Optional compiled features: +wildcards, +regex
>
> hamo@trinity ~ $ ls -l /usr/bin/etags
> lrwxrwxrwx 1 root root 23 Feb  8 17:48 /usr/bin/etags ->  /etc/alternatives/etags
> hamo@trinity ~ $ ls -l /etc/alternatives/etags
> lrwxrwxrwx 1 root root 24 Feb 15 10:06 /etc/alternatives/etags ->
> /usr/bin/ctags-exuberant
>
> So I think which kind of name Exuberant Ctags generates depends on argv[0].
>

Ah ok. How about this patch instead? Then we don't duplicate the sed 
statement.

---->8-------

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 833813a..b390096 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -168,7 +168,7 @@ exuberant()
         --regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'

         # Remove structure forward declarations.
-       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
+       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $2
  }

  emacs()
@@ -213,9 +213,9 @@ emacs()
  xtags()
  {
         if $1 --version 2>&1 | grep -iq exuberant; then
-               exuberant $1
+               exuberant $1 $2
         elif $1 --version 2>&1 | grep -iq emacs; then
-               emacs $1
+               emacs $1 $2
         else
                 all_sources | xargs $1 -a
          fi
@@ -244,11 +244,11 @@ case "$1" in

         "tags")
                 rm -f tags
-               xtags ctags
+               xtags ctags $1
                 ;;

         "TAGS")
                 rm -f TAGS
-               xtags etags
+               xtags etags $1
                 ;;
  esac


But then with your next patch maybe it would be better to just have a flag?

----8<-----

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 833813a..4b1755d 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -166,9 +166,6 @@ exuberant()
         all_defconfigs | xargs -r $1 -a                         \
         --langdef=dotconfig --language-force=dotconfig          \
         --regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
-
-       # Remove structure forward declarations.
-       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
  }

  emacs()
@@ -233,6 +230,7 @@ if [ "${ARCH}" = "um" ]; then
         fi
  fi

+remove_structs=
  case "$1" in
         "cscope")
                 docscope
@@ -244,11 +242,18 @@ case "$1" in

         "tags")
                 rm -f tags
-               xtags ctags
+               xtags ctags $1
+               remove_structs=y
                 ;;

         "TAGS")
                 rm -f TAGS
-               xtags etags
+               xtags etags $1
+               remove_structs=y
                 ;;
  esac
+
+# Remove structure forward declarations.
+if [ -n $remove_structs ]; then
+       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
+fi


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

