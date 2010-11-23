Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0KWAdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:33:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932359Ab0KWAdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:33:19 -0500
Date: Mon, 22 Nov 2010 16:32:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-Id: <20101122163234.5470e33e.akpm@linux-foundation.org>
In-Reply-To: <1290471649.2704.24.camel@edumazet-laptop>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
	<20101112120834.33062900.akpm@linux-foundation.org>
	<8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
	<20101114092533.GB5323@albatros>
	<20101114180643.593d19ac.akpm@linux-foundation.org>
	<1289848341.2607.125.camel@edumazet-laptop>
	<4CE268C8.5010203@panasas.com>
	<20101122155043.fbbb74f4.akpm@linux-foundation.org>
	<1290471649.2704.24.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 01:20:48 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le lundi 22 novembre 2010 __ 15:50 -0800, Andrew Morton a __crit :
> 
> > Well.  We certainly assume in many places that
> > 
> > 	struct foo {
> > 		int a;
> > 		int b;
> > 	} f = {
> > 		.a = 1,
> > 	};
> > 
> > will initialise b to zero.  But I doubt if much code at all assumes
> > that this initialisation patterm will reliably zero out *holes* in the
> > struct.
> > 
> 
> We did such assertions in the past, we were wrong.
> 
> Check commit 1c40be12f7d8ca1d387510d39787b12e512a7ce8 for an example
> (net sched: fix some kernel memory leaks)
> 
> I guess we must make a full audit of all C99 initializers or structures
> copied to userspace, giving a name to hidden holes, to force gcc to init
> them to 0.
> 
> # cat try.c
> struct s {
> 	char c;
> 	long l;
> 	};
> 
> void bar(void *v)
> {
> 	unsigned long *p = v;
> 
> 	printf("%lx %lx\n", p[0], p[1]);
> }
> 
> int main()
> {
> 	struct s s1 = {
> 		.c = 1,
> 		.l = 2,
> 	};
> 
> 	bar(&s1);
> 	return 0;
> }
> 
> # gcc -O2 -o try try.c
> # ./try
> 8049401 2

OK, thanks.  That rather settles it then.  memset() it is.

> Strangely, if we remove ".l = 2," line, gcc emits code to clear al the
> fields

Maybe a glitch, maybe a small optimisation?  That's the sort of thing
which will change over gcc versions too..


