Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0LCLdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:33:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:60891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0LCLdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:33:03 -0500
Message-ID: <4CF8D56B.2010208@suse.cz>
Date: Fri, 03 Dec 2010 12:32:59 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
Cc: npalix.work@gmail.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] scripts/coccinelle: update for compatability with
 Coccinelle 0.2.4
References: <Pine.LNX.4.64.1011241539220.13402@pc-004.diku.dk> <Pine.LNX.4.64.1011241553510.13402@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1011241553510.13402@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.11.2010 15:54, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> For doubleinit.cocci, Coccinelle 0.2.4 requires a comma after ... in a
> field list.  Coccinelle also now behaves gracefully when a definition is
> provided for a virtual that doesn't exist, so there is no need for the
> semantic patch code to check for this case.
> 
> Updated the documentation to reflect the fact that the best results will
> now be obtained with Coccinelle version 0.2.4 or later.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied to kbuild-2.6.git#misc, thanks. BTW, please always CC lkml when
sending patches.

Michal
> 
> ---
>  Documentation/coccinelle.txt             |    4 +++
>  scripts/coccinelle/misc/doubleinit.cocci |    6 ++--
>  scripts/coccinelle/null/deref_null.cocci |   39 +++++++++++--------------------
>  3 files changed, 21 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 4a276ea..96b6903 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -36,6 +36,10 @@ as a regular user, and install it with
>  
>          sudo make install
>  
> +The semantic patches in the kernel will work best with Coccinelle version
> +0.2.4 or later.  Using earlier versions may incur some parse errors in the
> +semantic patch code, but any results that are obtained should still be
> +correct.
>  
>   Using Coccinelle on the Linux kernel
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diff --git a/scripts/coccinelle/misc/doubleinit.cocci b/scripts/coccinelle/misc/doubleinit.cocci
> index 55d7dc1..156b20a 100644
> --- a/scripts/coccinelle/misc/doubleinit.cocci
> +++ b/scripts/coccinelle/misc/doubleinit.cocci
> @@ -7,7 +7,7 @@
>  // Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
>  // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
>  // URL: http://coccinelle.lip6.fr/
> -// Comments:
> +// Comments: requires at least Coccinelle 0.2.4, lex or parse error otherwise
>  // Options: -no_includes -include_headers
>  
>  virtual org
> @@ -19,7 +19,7 @@ position p0,p;
>  expression E;
>  @@
>  
> -struct I s =@p0 { ... .fld@p = E, ...};
> +struct I s =@p0 { ..., .fld@p = E, ...};
>  
>  @s@
>  identifier I, s, r.fld;
> @@ -27,7 +27,7 @@ position r.p0,p;
>  expression E;
>  @@
>  
> -struct I s =@p0 { ... .fld@p = E, ...};
> +struct I s =@p0 { ..., .fld@p = E, ...};
>  
>  @script:python depends on org@
>  p0 << r.p0;
> diff --git a/scripts/coccinelle/null/deref_null.cocci b/scripts/coccinelle/null/deref_null.cocci
> index 9969d76..cdac6cf 100644
> --- a/scripts/coccinelle/null/deref_null.cocci
> +++ b/scripts/coccinelle/null/deref_null.cocci
> @@ -11,21 +11,10 @@
>  // Options:
>  
>  virtual context
> -virtual patch
>  virtual org
>  virtual report
>  
> -@initialize:python depends on !context && patch && !org && !report@
> -
> -import sys
> -print >> sys.stderr, "This semantic patch does not support the 'patch' mode."
> -
> -@depends on patch@
> -@@
> -
> -this_rule_should_never_matches();
> -
> -@ifm depends on !patch@
> +@ifm@
>  expression *E;
>  statement S1,S2;
>  position p1;
> @@ -35,7 +24,7 @@ if@p1 ((E == NULL && ...) || ...) S1 else S2
>  
>  // The following two rules are separate, because both can match a single
>  // expression in different ways
> -@pr1 depends on !patch expression@
> +@pr1 expression@
>  expression *ifm.E;
>  identifier f;
>  position p1;
> @@ -43,7 +32,7 @@ position p1;
>  
>   (E != NULL && ...) ? <+...E->f@p1...+> : ...
>  
> -@pr2 depends on !patch expression@
> +@pr2 expression@
>  expression *ifm.E;
>  identifier f;
>  position p2;
> @@ -59,7 +48,7 @@ position p2;
>  
>  // For org and report modes
>  
> -@r depends on !context && !patch && (org || report) exists@
> +@r depends on !context && (org || report) exists@
>  expression subE <= ifm.E;
>  expression *ifm.E;
>  expression E1,E2;
> @@ -99,7 +88,7 @@ if@p1 ((E == NULL && ...) || ...)
>  }
>  else S3
>  
> -@script:python depends on !context && !patch && !org && report@
> +@script:python depends on !context && !org && report@
>  p << r.p;
>  p1 << ifm.p1;
>  x << ifm.E;
> @@ -109,7 +98,7 @@ msg="ERROR: %s is NULL but dereferenced." % (x)
>  coccilib.report.print_report(p[0], msg)
>  cocci.include_match(False)
>  
> -@script:python depends on !context && !patch && org && !report@
> +@script:python depends on !context && org && !report@
>  p << r.p;
>  p1 << ifm.p1;
>  x << ifm.E;
> @@ -120,7 +109,7 @@ msg_safe=msg.replace("[","@(").replace("]",")")
>  cocci.print_main(msg_safe,p)
>  cocci.include_match(False)
>  
> -@s depends on !context && !patch && (org || report) exists@
> +@s depends on !context && (org || report) exists@
>  expression subE <= ifm.E;
>  expression *ifm.E;
>  expression E1,E2;
> @@ -159,7 +148,7 @@ if@p1 ((E == NULL && ...) || ...)
>  }
>  else S3
>  
> -@script:python depends on !context && !patch && !org && report@
> +@script:python depends on !context && !org && report@
>  p << s.p;
>  p1 << ifm.p1;
>  x << ifm.E;
> @@ -168,7 +157,7 @@ x << ifm.E;
>  msg="ERROR: %s is NULL but dereferenced." % (x)
>  coccilib.report.print_report(p[0], msg)
>  
> -@script:python depends on !context && !patch && org && !report@
> +@script:python depends on !context && org && !report@
>  p << s.p;
>  p1 << ifm.p1;
>  x << ifm.E;
> @@ -180,7 +169,7 @@ cocci.print_main(msg_safe,p)
>  
>  // For context mode
>  
> -@depends on context && !patch && !org && !report exists@
> +@depends on context && !org && !report exists@
>  expression subE <= ifm.E;
>  expression *ifm.E;
>  expression E1,E2;
> @@ -223,7 +212,7 @@ else S3
>  // The following three rules are duplicates of ifm, pr1 and pr2 respectively.
>  // It is need because the previous rule as already made a "change".
>  
> -@ifm1 depends on !patch@
> +@ifm1@
>  expression *E;
>  statement S1,S2;
>  position p1;
> @@ -231,7 +220,7 @@ position p1;
>  
>  if@p1 ((E == NULL && ...) || ...) S1 else S2
>  
> -@pr11 depends on !patch expression@
> +@pr11 expression@
>  expression *ifm1.E;
>  identifier f;
>  position p1;
> @@ -239,7 +228,7 @@ position p1;
>  
>   (E != NULL && ...) ? <+...E->f@p1...+> : ...
>  
> -@pr12 depends on !patch expression@
> +@pr12 expression@
>  expression *ifm1.E;
>  identifier f;
>  position p2;
> @@ -253,7 +242,7 @@ position p2;
>   sizeof(<+...E->f@p2...+>)
>  )
>  
> -@depends on context && !patch && !org && !report exists@
> +@depends on context && !org && !report exists@
>  expression subE <= ifm1.E;
>  expression *ifm1.E;
>  expression E1,E2;

