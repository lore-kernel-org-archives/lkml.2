Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1IBQd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:33:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1IBQd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:33:58 -0400
Date: Fri, 2 Sep 2011 18:30:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Earl Chew <echew@ixiacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 1/1 v2]: coredump: use current->group_leader->comm
	instead of current->comm
Message-ID: <20110902163037.GA4808@redhat.com>
References: <4E5FBA73.2050108@ixiacom.com> <20110901195554.667c5e58@lxorguk.ukuu.org.uk> <4E5FD937.7050307@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5FD937.7050307@ixiacom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Earl Chew wrote:
>
> > In your view, but there is a better way to do this - add a new case and
> > letter for the behaviour you want. That way you don't break anyone elses
> > defaults and expectation and people can set a corepattern dependant upon
> > the group leader.
>
> Ok.
>
>
> The patterns %n or %N are the same as %e and %E except that they
> use current->group_leader->comm instead of current->comm.

I simply do not know what is better. Alan has a point imho, "might
break stuff" is true.

OTOH, %p always reports tgid, not tid...

But in fact I do not understand the "Using current->group_leader->comm
makes the name of the core file more consistent" part. Why ?

> A core dump can be triggered from any task in a group,

Indeed. The important case is the private/synchronous signals like
SIGSEGV, you can see the name of the thread which triggered the crash.


> -static int cn_print_exe_file(struct core_name *cn)
> +static int cn_print_exe_file(struct core_name *cn, const char *comm)
>  {
>  	struct file *exe_file;
>  	char *pathbuf, *path;
> @@ -1679,7 +1679,7 @@ static int cn_print_exe_file(struct core
>  	exe_file = get_mm_exe_file(current->mm);
>  	if (!exe_file) {
>  		char *commstart = cn->corename + cn->used;
> -		ret = cn_printf(cn, "%s (path unknown)", current->comm);
> +		ret = cn_printf(cn, "%s (path unknown)", comm);

Imho, this is overkill. This is only used if get_mm_exe_file() fails,
I don't think this deserves another option. And may be we can use
group_leader->comm, this is per-process thing anyway.

But I won't insist, I agree either way.

Oleg.

