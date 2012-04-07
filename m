Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2DGVvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 17:51:47 -0400
Received: from outmail148093.authsmtp.net ([62.13.148.93]:24433 "EHLO
	outmail148093.authsmtp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab2DGVvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 17:51:45 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2012 17:51:45 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by>
	<4F78D0BA.9040709@zytor.com>
	<CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
	<4F7F1864.8090606@zytor.com>
Reply-To: Ben Pfaff <blp@cs.stanford.edu>
Date: Sat, 07 Apr 2012 14:21:24 -0700
In-Reply-To: <4F7F1864.8090606@zytor.com> (H. Peter Anvin's message of "Fri,
	06 Apr 2012 09:23:00 -0700")
Message-ID: <87r4vzjl0r.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: 6b39cbd2-80f7-11e1-80b9-0022640b883e
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AThCFzNJTwsiPBEK DBMeOw5HJEYITQBc chYbOAIMd3QEXxYD A2cJS1ZWWlx4U2Zx JQ1XcwRZfE5GQQdq UldLR1BXCwQmQB8G emRBD1pycgZAfXg+ Z0drWHAVWhZ5fBUv FkxJHW1QYnphaTUe TUhYJQpJcANIfBlB agJ3XHBYLwdSbGoL JyYPFBAEdTNSODhb TkFXbDoA
X-Authentic-SMTP: 61633331373532.1015:706
X-AuthFastPath: 0 (Was 255)
X-AuthVirus-Status: No virus detected - but ensure you scan with your own anti-virus system.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
>> 
>> Without proc knowledge about fdtable is gathered linearly and still unreliable.
>> With nextfd(2), even procful environments could lose several failure branches.
>> And they can keep old dumb fd++ or smart /proc/self/fd loops for a change.
>> 
>
> Incidentally, if we were to create a system call for this -- which I so
> far see no reason for -- I would make it return a select-style bitmask
> of file descriptors in use, not a "next fd" which would require a system
> call per iteration.

It's already possible to do something a little like that with the
existing "poll" system call:

#include <stdio.h>
#include <sys/poll.h>

int
main(void)
{
  enum { N_FDS = 1024 };
  struct pollfd fds[N_FDS];
  int error;
  int i;

  for (i = 0; i < N_FDS; i++)
    {
      fds[i].fd = i;
      fds[i].events = 0;
    }

  error = poll(fds, N_FDS, 0);
  if (error < 0)
    perror("poll");
  else
    {
      printf("valid fds:");
      for (i = 0; i < N_FDS; i++)
        if (!(fds[i].revents & POLLNVAL))
          printf(" %d", fds[i].fd);
      printf("\n");
    }

  return 0;
}

blp@blp:~/tmp(0)$ gcc tmp.c -Wall
blp@blp:~/tmp(0)$ ./a.out
valid fds: 0 1 2
blp@blp:~/tmp(0)$ ./a.out 5>/dev/null
valid fds: 0 1 2 5
blp@blp:~/tmp(0)$ ./a.out 5>/dev/null 3</dev/stdin
valid fds: 0 1 2 3 5
blp@blp:~/tmp(0)$ 

-- 
Ben Pfaff 
http://benpfaff.org
