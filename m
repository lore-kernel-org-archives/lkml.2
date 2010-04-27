Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0D0Lr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:47:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:45765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab0D0Lr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:47:26 -0400
Message-ID: <4BD6CECC.9080507@suse.cz>
Date: Tue, 27 Apr 2010 13:47:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.9 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       =?ISO-8859-2?Q?Am=E9rico_?= =?ISO-8859-2?Q?Wang?= 
	<xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Correctly deal with make that has an argument which contains
 an "s"
References: <1272315374-11951-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1272315374-11951-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.4.2010 22:56, Jason Wessel wrote:
> When using remake, which is based on gnumake, if you invoke
> an example build as shown below, the build will become silent
> due to the top level make file incorrectly guessing that
> the end user wants a silent build because an argument that
> contained an "s" was used.
> 
> remake --no-extended-errors

BTW, make --warn-undefined-variables also triggers this (although no one
will use this option on the kernel makefiles).


> Fix up the top level Makefile to use filter with a list of
> options that mean silent with the various revisions of gnumake,
> instead of findstring.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Michal Marek <mmarek@suse.cz>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-kbuild@vger.kernel.org
> ---
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index fa1db90..91ae299 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -294,7 +294,7 @@ endif
>  # If the user is running make -s (silent mode), suppress echoing of
>  # commands
>  
> -ifneq ($(findstring s,$(MAKEFLAGS)),)
> +ifneq ($(filter s% -s% --silent --quiet,$(MAKEFLAGS)),)

I played a bit with GNU make 3.81. Checking for --silent and --quiet is
not necessary, because make always stores the short option if available.
Now I was wondering if the 's' option is always at the beginning,
looking at make-3.81/main.c, it turns out that the order in which the
options appear in $(MAKEFLAGS) is the reverse order of the switches
array, where 's' is near the end of the array:

    { 's', flag, (char *) &silent_flag, 1, 1, 0, 0, 0, "silent" },
                                           ^ store in $(MAKEFLAGS)?
    { 'S', flag_off, (char *) &keep_going_flag, 1, 1, 0, 0,
      (char *) &default_keep_going_flag, "no-keep-going" },
    { 't', flag, (char *) &touch_flag, 1, 1, 1, 0, 0, "touch" },
    { 'v', flag, (char *) &print_version_flag, 1, 1, 0, 0, 0, "version" },
    { 'w', flag, (char *) &print_directory_flag, 1, 1, 0, 0, 0,
      "print-directory" },
    { CHAR_MAX+3, flag, (char *) &inhibit_print_directory_flag, 1, 1, 0,
0, 0,
      "no-print-directory" },
    { 'W', string, (char *) &new_files, 0, 0, 0, 0, 0, "what-if" },
    { CHAR_MAX+4, flag, (char *) &warn_undefined_variables_flag, 1, 1,
0, 0, 0,
      "warn-undefined-variables" },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0 }


The only other single-letter options that come after 's' (before 's' in
the $(MAKEFLAGS) variable) are 't', which doesn't work with the kernel,
and 'w', which doesn't work either (the Makefile adds
--no-print-directory). So we can indeed get away with s% and -s% (until
the next make version changes the sort order, that is ;)).

Michal
