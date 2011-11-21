Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1KUOiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:38:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1KUOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:38:12 -0500
Message-ID: <1321886286.10470.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [bug] af_unix: Reading from a stream socket may lock the
 concurrent poll() call
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Moiseytsev <himeraster@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mtk.manpages@gmail.com, linux-man@vger.kernel.org
Date: Mon, 21 Nov 2011 15:38:06 +0100
In-Reply-To: <CAHjqzy7dhqi22yPJX=DP4x916hVXDY2WaDbdmnTEQ54n6qpMXw@mail.gmail.com>
References: <CAHjqzy7dhqi22yPJX=DP4x916hVXDY2WaDbdmnTEQ54n6qpMXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 novembre 2011 à 00:19 +0400, Alexey Moiseytsev a écrit :
> Hello,
> 
> The following program shows how the poll() call hangs on a non-empty
> stream socket.
> 
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <poll.h>
> 
> int sockets[2];
> 
> int poll_socket(void) {
>     struct pollfd pfd = {
>         .fd = sockets[1],
>         .events = POLLIN
>     };
>     return poll(&pfd, 1, -1);
> }
> 
> 
> /* observer routine doesn't modify amount of data available in the
> socket buffer */
> void* observer(void* arg) {
>     char buffer;
>     for (int j = 0; j < 2000; j++) {
>         recv(sockets[1], &buffer, sizeof(buffer), MSG_PEEK);
>         sched_yield();
>     }
>     return NULL;
> }
> 
> int main(void) {
>     if (socketpair(PF_UNIX, SOCK_STREAM, 0, sockets) == -1)
>         return 1;
>     int rc, data[250] = {0};
>     if ((rc = send(sockets[0], &data, sizeof(data), MSG_DONTWAIT)) <= 0)
>         return 2;
>     poll_socket();
> /* If the first poll_socket() call didn't hang then the following
> message will be printed */
>     fprintf(stderr, "%d bytes available in input buffer\n", rc);
>     pthread_t observer_thread;
>     pthread_create(&observer_thread, NULL, observer, NULL);
>     for (int j = 0; j < 20000; j++) {
> /* If the first poll_socket() call didn't hang then all the following
> calls should do the same */
>         poll_socket();
>     }
>     fprintf(stderr, "Well done\n");
>     pthread_join(observer_thread, NULL);
>     close(sockets[0]);
>     close(sockets[1]);
>     return 0;
> }
> 
> 
> Expected output: two lines or nothing (in case of error).
> Observed output: only the first line (and the process never exits).
> 
> So the first poll() said that there is some data available in the
> socket. And one of the following poll() said that there is no data
> available in the socket. But this is false because the observer thread
> didn't actually consume any data from then socket.
> 
> I assume that this bug can be eliminated by adding
> sk->sk_data_ready(...) call right after each call to
> skb_queue_head(..) in the unix_stream_recvmsg(...) routine
> (net/unix/af_unix.c)
> 
> Other info:
> $ uname -srmo
> Linux 2.6.32-5-amd64 x86_64 GNU/Linux
> 

Hi Alexy

I believe you found a bug and your suggested fix should be just fine.

(Or maybe testing in unix_poll() that at least one thread is currently
handling one skb from sk->receive_queue)

Could you submit an official patch on top of current Linus tree or do
you prefer us to take care of this ?



