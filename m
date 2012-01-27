Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2A0SSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:18:04 -0500
Received: from mx2.parallels.com ([64.131.90.16]:39492 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab2A0SSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:18:03 -0500
Message-ID: <4F22EA24.3030901@parallels.com>
Date: Fri, 27 Jan 2012 22:17:08 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Nick Mathewson <nickm@freehaven.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexey Moiseytsev <himeraster@gmail.com>
Subject: Re: [BUG] Regression on behavior of EPOLLET | EPOLLIN for AF_UNIX
 sockets in 3.2
References: <CAKDKvuzH14AZjDG3WSdrf5VtmiUgG0Y+EaC83qqSd0VFKzyitg@mail.gmail.com> <1327686822.3159.3.camel@edumazet-laptop>
In-Reply-To: <1327686822.3159.3.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 09:53 PM, Eric Dumazet wrote:
> Le vendredi 27 janvier 2012 à 12:05 -0500, Nick Mathewson a écrit :
>> [1.] One line summary of the problem:
>>
>> EPOLLET doesn't give edge-triggered behavior for AF_UNIX sockets in 3.2
>>
>> [2.] Full description of the problem/report:
>>
>> When epoll is told to listen to a readable socket with the flags
>> EPOLLIN|EPOLLET, it is supposed to report the event once, and then
>> not report the event again until the socket has first become
>> non-readable and then become readable again.  (This behavior is part
>> of the definition of edge-triggered events, IIUC.)
>>
>> But with AF_UNIX sockets on Linux 3.2, a call to read() on a socket
>> that does not drain the socket's buffer completely can apparently
>> cause epoll to think that the socket has generated another event,
>> even if no further data has actually arrived at the socket.
>>
>> This behavior did not occur in 3.1, and does not occur in 3.2 with
>> AF_INET sockets or with pipes.
>>
>> [3.] Keywords:
>>
>> networking, AF_UNIX, epoll, socket
>>
>> [4.] Kernel version (from /proc/version):
>>
>> First found in:
>>
>> Linux version 3.2.1-3.fc16.x86_64
>> (mockbuild@x86-13.phx2.fedoraproject.org) (gcc version 4.6.2 20111027
>> (Red Hat 4.6.2-1) (GCC) ) #1 SMP Mon Jan 23 15:36:17 UTC 2012
>>
>> Another user has reproduced this with:
>>
>> Linux version 3.2.0-1-686-pae (Debian 3.2.1-1) (ben@decadent.org.uk)
>> (gcc version 4.6.2 (Debian 4.6.2-11) ) #1 SMP Thu Jan 19 10:56:51 UTC
>> 2012
>>
>> [6.] A small shell script or example program which triggers the
>>       problem (if possible)
>>
>> #include<sys/epoll.h>
>> #include<sys/types.h>
>> #include<sys/socket.h>
>> #include<unistd.h>
>> #include<fcntl.h>
>>
>> #include<stdio.h>
>> #include<errno.h>
>> #include<string.h>
>>
>> int
>> main(int argc, const char **argv)
>> {
>>          int epfd;
>>          int pair[2];
>>          struct epoll_event epev;
>>          int n, r, n_reads;
>>
>>          if ((epfd = epoll_create(32))<  0) {
>>                  perror("epoll_create()");
>>                  return 2;
>>          }
>>          if (socketpair(AF_UNIX, SOCK_STREAM, 0, pair)<  0) {
>>                  perror("socketpair()");
>>                  return 2;
>>          }
>>
>>          if (fcntl(pair[0], F_SETFL, O_NONBLOCK)<  0) {
>>                  perror("fcntl()");
>>                  return 2;
>>          }
>>
>>          memset(&epev, 0, sizeof(epev));
>>          epev.events = EPOLLIN | EPOLLET;
>>          epev.data.fd = pair[0];
>>          if (epoll_ctl(epfd, EPOLL_CTL_ADD, pair[0],&epev)<  0) {
>>                  perror("epoll_ctl()");
>>                  return 2;
>>          }
>>
>>          if ((n = write(pair[1], "A 21-character string", 21))<  0) {
>>                  perror("write()");
>>                  return 2;
>>          }
>>
>>          /* pair[0] should now be readable. EPOLLET above has said that we
>>           * want edge-triggered behavior, so we should only get a single
>>           * EPOLLIN event on the socket.  But on Linux 3.2, for some reason,
>>           * reading a single byte from the socket causes us to get another
>>           * EPOLLIN event.
>>           */
>>          n_reads = 0;
>>          while ((r = epoll_wait(epfd,&epev, 1, 500)) == 1) {
>>                  char byte[1];
>>                  printf("epoll_wait() said: events=%d, fd=%d\n",
>>                         epev.events, epev.data.fd);
>>                  n = read(pair[0], byte, 1);
>>                  if (n<  0&&  errno == EAGAIN) {
>>                          puts("read() reported EAGAIN.");
>>                  } else if (n<  0) {
>>                          perror("read()");
>>                  } else if (n == 0) {
>>                          puts("read() reported EOF.");
>>                  } else {
>>                          printf("Read %d byte(s)\n", n);
>>                          ++n_reads;
>>                  }
>>          }
>>          if (r == 0) {
>>                  puts("Timeout without event.");
>>          } else {
>>                  perror("epoll_wait()");
>>          }
>>
>>          close(pair[0]);
>>          close(pair[1]);
>>          close(epfd);
>>
>>          if (n_reads == 1) {
>>                  puts("Exactly one read event. Good.");
>>          } else {
>>                  printf("Got %d read events. That's not right!\n", n_reads);
>>          }
>>          return (n_reads == 1) ? 0 : 1;
>> }
>> --
>
> Hi
>
> Probably coming from commit 0884d7aa24e15e72b3c07f7da910a13bb7df3592
> (AF_UNIX: Fix poll blocking problem when reading from a stream socket)
>
> When we requeue skb because not completely eaten, we call again
>
> sk->sk_data_ready(sk, skb->len);
>
For the record, I just confirmed this to be the case.
