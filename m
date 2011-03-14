Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1CNWez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:34:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386Ab1CNWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:34:55 -0400
Date: Mon, 14 Mar 2011 15:34:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
        coda@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu
Subject: Re: [PATCH] fs, coda: Fix compile warning when CONFIG_SYSCTL=n.
Message-Id: <20110314153413.a8ec2093.akpm@linux-foundation.org>
In-Reply-To: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
References: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011 21:48:23 +0600
Rakib Mullick <rakib.mullick@gmail.com> wrote:

> When CONFIG_SYSCTL=n, we get the following warning:
> 
> fs/coda/sysctl.c:18: warning: ___coda_table___ defined but not used
> 
> Following patches fixes the above warning by making sure coda_table
> and it's callee
> function are in the same context. It also cleans up the code by
> removing extra #ifdef.
> 
> ...
>
> --- a/fs/coda/sysctl.c
> +++ b/fs/coda/sysctl.c
>
> ...
>
> +#else
> +
> +#define	coda_sysctl_init()		do { }  while (0);
> +#define	coda_sysctl_clean()		do { }	while (0);
> +
> +#endif

These do/while stubs should not have the trailing ";" - adding them
will cause breakage in some calling scenarios.

It is much better to implement such stubs in C rather than as macros.

But these stubs can't be doing anything useful anyway: they appear at
the end of a .c file which wasn't #included by anything.  Therefore:

--- a/fs/coda/sysctl.c~fs-coda-fix-compile-warning-when-config_sysctl=n-fix
+++ a/fs/coda/sysctl.c
@@ -61,9 +61,4 @@ void coda_sysctl_clean(void)
 		fs_table_header = NULL;
 	}
 }
-#else
-
-#define	coda_sysctl_init()		do { }  while (0);
-#define	coda_sysctl_clean()		do { }	while (0);
-
 #endif
_

