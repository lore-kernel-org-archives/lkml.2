Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0HZQhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:37:21 -0400
Received: from xenotime.net ([72.52.115.56]:48144 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753151Ab0HZQhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:37:20 -0400
Date: Thu, 26 Aug 2010 09:37:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Docbook: allow warning on unused documentation
Message-Id: <20100826093710.111b103e.rdunlap@xenotime.net>
In-Reply-To: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
References: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 15:09:27 +0200 Johannes Berg wrote:

> When you don't use !E or !I but only !F, then
> it's very easy to miss including some functions,
> structs etc. in documentation. To help finding
> which ones were missed, allow printing out the
> unused ones as warnings.

How do I test this?  Do I need to add !A to some source file?

> For example, using this on mac80211 yields a
> lot of warnings like this:
> 
>   Warning: didn't use docs for DOC: mac80211 workqueue
>   Warning: didn't use docs for ieee80211_max_queues
>   Warning: didn't use docs for ieee80211_bss_change
>   Warning: didn't use docs for ieee80211_bss_conf
> 
> when generating the documentation for it.

> ---
>  Documentation/kernel-doc-nano-HOWTO.txt |    5 +
>  scripts/basic/docproc.c                 |  130 +++++++++++++++++++++++++++++++-
>  scripts/kernel-doc                      |   52 ++++++++++++
>  3 files changed, 184 insertions(+), 3 deletions(-)
> 
> --- wireless-testing.orig/Documentation/kernel-doc-nano-HOWTO.txt	2010-08-18 14:54:25.000000000 +0200
> +++ wireless-testing/Documentation/kernel-doc-nano-HOWTO.txt	2010-08-18 14:57:12.000000000 +0200
> @@ -345,5 +345,10 @@ documentation, in <filename>, for the fu
>  section titled <section title> from <filename>.
>  Spaces are allowed in <section title>; do not quote the <section title>.
>  
> +!A<filename> is replaced by nothing, but makes the tools verify that
> +all DOC: sections and documented functions, symbols, etc. are used.
> +This makes sense to use when you use !F/!P only and want to verify
> +that all documentation is included.
> +
>  Tim.
>  */ <twaugh@redhat.com>
> --- wireless-testing.orig/scripts/basic/docproc.c	2010-08-18 14:54:26.000000000 +0200
> +++ wireless-testing/scripts/basic/docproc.c	2010-08-18 14:56:27.000000000 +0200
> @@ -34,12 +34,14 @@
>   *
>   */
>  
> +#define _GNU_SOURCE

Can you explain why that is needed?  (curious)

>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <ctype.h>
>  #include <unistd.h>
>  #include <limits.h>
> +#include <errno.h>
>  #include <sys/types.h>
>  #include <sys/wait.h>

> @@ -315,6 +346,85 @@ static void docsect(char *filename, char
>  	exec_kernel_doc(vec);
>  }
>  
> +static void find_all_symbols(char *filename)
> +{
> +	char *vec[4]; /* kerneldoc -docbook -function "section" file NULL */

incorrect comment??

> +	pid_t pid;
> +	int ret, i, count, start;
> +	char real_filename[PATH_MAX + 1];
> +	int pipefd[2];
> +	char *data, *str;
> +	size_t data_len = 0;
> +
> +	vec[0] = KERNELDOC;
> +	vec[1] = LIST;
> +	vec[2] = filename;
> +	vec[3] = NULL;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
