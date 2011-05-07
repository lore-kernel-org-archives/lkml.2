Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1EGKJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 06:09:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44410 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1EGKJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 06:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lLJ1S02DiLP6kGCJaiGeqKwMufXmL6L4vbXHjbwCL3o0TD1iJFbPbYoch438nXs2Uf
         5x9aSZ8xzPzeT1RZGFexIToPNlBClcyNEd2vSJLrpRJNKdByI0XSuswFGfIZT93XkFmL
         6YNDYht4jYEIE5VpcNAySBFMfJkZojqAo9xhg=
MIME-Version: 1.0
In-Reply-To: <1304745945.2821.601.camel@edumazet-laptop>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com> <1304745945.2821.601.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 7 May 2011 18:09:22 +0800
Message-ID: <BANLkTinAT5Wa5-_N1HPST4dv7TM=m+NAfA@mail.gmail.com>
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 1:25 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 07 mai 2011 à 12:49 +0800, Changli Gao a écrit :
>> If FD_CLOFORK is 1, when a fork occurs, the corresponding file descriptor
>> will be closed for the child process. IOW, the file descriptor isn't
>> inheritable.
>>
>> FD_CLOFORK is used as IBM does.
>
> Is it part of a standard, and what could be the use for such thing ?
> Why had we wait 2011 to add it in linux ?
>

It isn't part of any standard. It can be used in multi-process
programs, which don't want the child processes inherit some file
descriptors. Here is a basic server program.

serv_sock = socket(...);
bind(serv_sock, ...);
listen(serv_sock, ...);
fcntl(serv_sock, F_SETFD, FD_CLOFORK);
while (1) {
   clnt_sock = accept(serv_sock);
   switch (fork()) {
   case 0:
      exit(do_serv(clnt_sock));
   default:
      break;
   }
}

This flag can also been used instead of FD_CLOEXEC in the exec(2)
after fork(2) environment. As no such file descriptors is duplicated
between fork(2) and exec(2), the later close(2) in kernel won't be
needed when exec(2). It can improve the performance.

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
