Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0GBX6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 19:58:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0GBX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 19:58:44 -0400
Date: Sat, 3 Jul 2010 01:58:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eric.dumazet@gmail.com,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] time/fs - file's time race with vgettimeofday
Message-ID: <20100702235836.GA1948@jolsa.Belkin>
References: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
 <20100702161422.GA31733@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702161422.GA31733@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 06:14:22PM +0200, Oleg Nesterov wrote:
> In no way I can review this patch, but I am curious and have the questions.
> Also, I think it makes sense to cc the fs/ developers, I've added Al.

thanks

> 
> On 07/02, Jiri Olsa wrote:
> >
> > there's a race among calling gettimeofday(2) and a file's time
> > updates.  Following test program expose the race.
> >
> > run it in the while loop
> > 	while [ 1 ]; do ./test1 || break; done
> >
> > --- SNIP ---
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <fcntl.h>
> >
> > int main (void)
> > {
> > 	struct stat st;
> > 	struct timeval tv;
> >
> > 	unlink("./file");
> >
> > 	gettimeofday(&tv, NULL);
> >
> > 	if (-1 == creat("./file", O_RDWR)) {
> > 		perror("creat");
> > 		return -1;
> > 	}
> >
> > 	if (stat("./file", &st) != 0) {
> > 		perror("stat");
> > 		return -1;
> > 	}
> >
> > 	printf("USER gtod: %ld\n", (long)tv.tv_sec);
> > 	printf("USER file: %ld.%09u\n",
> > 			(long) st.st_mtime,
> > 			(unsigned) st.st_mtim.tv_nsec);
> >
> > 	return tv.tv_sec <= st.st_mtime ? 0 : -1;
> > }
> 
> Interesting. To the point, I actually compiled this code and yes,
> it triggers the problem on ext3 ;)
> 
> > The following patch will prevent the race by adding the
> > CURRENT_TIME_SEC_REAL macro, which will return seconds from
> > the getnstimeofday call, ensuring it's computed on current tick.
> > It fixes the 'creat' case for ext4.
> 
> What about other filesystems? Perhaps it makes sense to change
> CURRENT_TIME_SEC instead of adding CURRENT_TIME_SEC_REAL?
> 
> Once again, I am asking. It is not that I suggest to change your patch.

well, the patch is more or less to prove the problem exists and
it could be fixed :) also I'm not sure that all the places using
CURRENT_TIME_SEC suffer the same issue.. 

I'm currenty looking to the code and trying to come up with better
solution.. any ideas are welcome :)


jirka
