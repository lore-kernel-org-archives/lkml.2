Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2K2Nhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:37:51 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42009 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2K2Nhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:37:50 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAPXgP10OW_XuPMHn=KQzaESfpNhehkUx6=hKL2dHdGytZkGmng@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
 <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com>
 <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
 <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
 <1354125084.20578.1.camel@nja> <CAKgNAkiFKPf44Q+X76TSGbR2LuyrFSWP7FLq_YdD8Twd2_25Ew@mail.gmail.com>
 <CAPXgP10OW_XuPMHn=KQzaESfpNhehkUx6=hKL2dHdGytZkGmng@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 29 Nov 2012 14:37:29 +0100
Message-ID: <CAKgNAkhQuugAOChSroXFgSPQ_=zyfFOZHzL3PGfU2SdmJcmj4w@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 2:28 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Thu, Nov 29, 2012 at 2:18 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On Wed, Nov 28, 2012 at 6:51 PM, Kay Sievers <kay@vrfy.org> wrote:
>
>>> Before:
>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
>>>   syslog(SYSLOG_ACTION_READ_CLEAR, "<12>"..., 1000000) = 24000
>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
>>>
>>> After:
>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 90402
>>>   syslog(SYSLOG_ACTION_READ_CLEAR, "<5>"..., 1000000) = 90402
>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 0
>
>> I'm going to call my report yesterday bogus. Somewhere along the way,
>> I got confused while testing something, and my statement about 2.6.31
>> behavior is wrong: the 2.6.31 and 3.5 behaviors are the same. As such,
>> your patch is unneeded. Sorry for wasting your time.
>
> I think you have been right with your report. The above pasted
> before/after from the patch commit text is actually a result of real
> testing with current git. And your initial description sounds right,
> and the patch seems to produce the expected results here. I just
> confused the numbers in your report and wrongly parsed 2.6 > 3.6.
>
> Hmm, at least do far we did not blame anybody else than ourselves as
> confused. One of us at least is right, and it looks you have been, and
> I also think the patch is at least intended to be right. :)

Okay -- I'm pretty sure I am right about being wrong ;-).

Could you do some comparative testing please between 3.5 and pre-3.5.
I have a little test program below. When I rechecked 2.6.31 and 3.5
using this program I found the behavior was the same, which is why I
conclude my report is wrong. (And also, your proposed patch in
response to my bogus report produces different behavior from 2.6.31).

Thanks,

Michael

/*#* t_klogctl.c

  klogctl(3) is the glibc interface for syslog(2)

*/

#include <sys/klog.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#define errMsg(msg) 	do { perror(msg); } while (0)

#define errExit(msg) 	do { perror(msg); exit(EXIT_FAILURE); \
			} while (0)

#define fatal(msg) 	do { fprintf(stderr, "%s\n", msg); \
     			     exit(EXIT_FAILURE); } while (0)


/* Close the log.  Currently a NOP. */
#define SYSLOG_ACTION_CLOSE          0
/* Open the log. Currently a NOP. */
#define SYSLOG_ACTION_OPEN           1
/* Read from the log. */
#define SYSLOG_ACTION_READ           2
/* Read all messages remaining in the ring buffer. */
#define SYSLOG_ACTION_READ_ALL       3
/* Read and clear all messages remaining in the ring buffer */
#define SYSLOG_ACTION_READ_CLEAR     4
/* Clear ring buffer. */
#define SYSLOG_ACTION_CLEAR          5
/* Disable printk's to console */
#define SYSLOG_ACTION_CONSOLE_OFF    6
/* Enable printk's to console */
#define SYSLOG_ACTION_CONSOLE_ON     7
/* Set level of messages printed to console */
#define SYSLOG_ACTION_CONSOLE_LEVEL  8
/* Return number of unread characters in the log buffer */
#define SYSLOG_ACTION_SIZE_UNREAD    9
/* Return size of the log buffer */
#define SYSLOG_ACTION_SIZE_BUFFER   10


int
main(int argc, char *argv[])
{
    int s;
#define BSIZE 500000
    char buf[BSIZE];

    if (argc < 2) {
	fprintf(stderr, "Usage: %s command-num [arg]\n", argv[0]);
	exit(EXIT_FAILURE);
    }

    int cmd;

    cmd = atoi(argv[1]);

    switch (cmd) {

    case SYSLOG_ACTION_READ:		/* 2 */
	printf("SYSLOG_ACTION_READ\n");
        s = klogctl(SYSLOG_ACTION_READ, buf,
		(argc > 2) ? atoi(argv[2]) : BSIZE);
        if (s == -1)
	    errExit("klogctl-READ");
        printf("Return value: %d\n", s);

        if (write(2, buf, s) != s)
	    errMsg("write");
        break;

    case SYSLOG_ACTION_READ_ALL:	/* 3 */
    case SYSLOG_ACTION_READ_CLEAR:	/* 4 */
	if (cmd == SYSLOG_ACTION_READ_CLEAR)
	    printf("SYSLOG_ACTION_READ_CLEAR\n");
	else
	    printf("SYSLOG_ACTION_READ_ALL\n");


        s = klogctl(cmd, buf,
		(argc > 2) ? atoi(argv[2]) : BSIZE);
        if (s == -1)
	    errExit("klogctl-READ_ALL/READ_CLEAR");
        printf("Return value: %d\n", s);

        if (write(2, buf, s) != s)
	    errMsg("write");

	if (cmd == SYSLOG_ACTION_READ_CLEAR)
	    printf("Ring buffer cleared\n");
        break;

    case SYSLOG_ACTION_CLEAR:		/* 5 */
	printf("SYSLOG_ACTION_CLEAR\n");
        s = klogctl(SYSLOG_ACTION_CLEAR, NULL, 0);
        if (s == -1)
	    errExit("klogctl-CLEAR");
        printf("Return value: %d\n", s);
	printf("Ring buffer cleared\n");
	break;

    case SYSLOG_ACTION_SIZE_UNREAD:	/* 9 */
	printf("SYSLOG_ACTION_SIZE_UNREAD\n");
        s = klogctl(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0);
        if (s == -1)
	    errExit("klogctl-SIZE_UNREAD");
        printf("Number of unread bytes: %d\n", s);
	break;

    case SYSLOG_ACTION_SIZE_BUFFER:	/* 10 */
	printf("SYSLOG_ACTION_SIZE_BUFFER\n");
        s = klogctl(SYSLOG_ACTION_SIZE_BUFFER, NULL, 0);
        if (s == -1)
	    errExit("klogctl-SIZE_BUFFER");
        printf("Size of buffer: %d\n", s);
	break;

    default:
	fatal("Bad command");
	break;
    }

    exit(EXIT_SUCCESS);
}
