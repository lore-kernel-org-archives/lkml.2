Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0GFXDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:03:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59740 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab0GFXDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u2lSNGp/X/T8INaQ2aKqOZAHfjVGuB0FE9SytufZGNcM7zNtV01MzoPvJQUt56WvsA
         8xZkWU+TE/DyPO50NtN2DtcLIDxWuJV49YpxWv5V3ukuR5oW2kF20NS1a1fFQS+2QA4V
         F6sUm6ijuqaPaoNvFDYsx08EThb/zINC3s9AU=
MIME-Version: 1.0
In-Reply-To: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
References: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
Date: Tue, 6 Jul 2010 16:03:29 -0700
X-Google-Sender-Auth: 17ea3z5Ym3FSGIJimSOp88iRFfE
Message-ID: <AANLkTilE3sd7SSLVCN87rpJ5iSm-sYd-n6nJnzlByfRK@mail.gmail.com>
Subject: Re: [PATCH] time/fs - file's time race with vgettimeofday
From: john stultz <johnstul@us.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eric.dumazet@gmail.com,
       oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 12:41 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
>
> there's a race among calling gettimeofday(2) and a file's time
> updates.  Following test program expose the race.
>
> run it in the while loop
>        while [ 1 ]; do ./test1 || break; done
>
> --- SNIP ---
> #include <stdio.h>
> #include <stdlib.h>
> #include <fcntl.h>
>
> int main (void)
> {
>        struct stat st;
>        struct timeval tv;
>
>        unlink("./file");
>
>        gettimeofday(&tv, NULL);
>
>        if (-1 == creat("./file", O_RDWR)) {
>                perror("creat");
>                return -1;
>        }
>
>        if (stat("./file", &st) != 0) {
>                perror("stat");
>                return -1;
>        }
>
>        printf("USER gtod: %ld\n", (long)tv.tv_sec);
>        printf("USER file: %ld.%09u\n",
>                        (long) st.st_mtime,
>                        (unsigned) st.st_mtim.tv_nsec);
>
>        return tv.tv_sec <= st.st_mtime ? 0 : -1;
> }
> --- SNIP ---
>
>
> The point is that the stat call returns time that
> sometime precedes time from gettimeofday.
>
> The reason follows.
>
>        - inode's time is initialized by CURRENT_TIME_SEC macro,
>          which returns tv_sec portion of xtime variable
>        - the xtime is updated by update_wall_time being called
>          each tick (not that often for NO_HZ)
>        - vgettimeofday reads the actuall clocksource tick
>          and computes the time
>
> Thus while the inode's time is based on the xtime update
> by the update_wall_time function, the vgettimeofday computes
> the time correctly each time it's called.
>
> Thus the race is triggered within 2 update_wall_time updates,
> when in between the gettimeofday and creat calls happened.
>
>
>
> ticks                   CPU                   update_wall_time executed
> -------------------------------------------------------------------------------
>  t1
>                                                        update 1
>                                           (xtime is computed based on tick t1)
>
>
>  t2
>
>       |         gettimeofday           |
>       | (returns time based on tick 2) |
>       |                                |
>       |            creat               |
>       |   (set time based on tick 1)   |
>
>
>                                                        update 2
>                                           (xtime is computed based on tick t2)
>  t3
> -------------------------------------------------------------------------------
>
>
>
> This issue was described in the BZ 244697
>
>        Time goes backward - gettimeofday() vs. rename()
>        https://bugzilla.redhat.com/show_bug.cgi?id=244697
>
>
> It's not just issue of the creat but few others like rename.
>
>
> The following patch will prevent the race by adding the
> CURRENT_TIME_SEC_REAL macro, which will return seconds from
> the getnstimeofday call, ensuring it's computed on current tick.
> It fixes the 'creat' case for ext4.
>
>
> I'm not sure how much trouble is having this race unfixed compared
> to the performance impact the fix might have. Maybe there're
> better ways to fix this.

I do worry that your patch will have too much of a performance hit. I
think the right fix would be in vtime().

Test patch to follow shortly.

thanks
-john
