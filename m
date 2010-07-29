Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0G2XvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:51:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52585 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0G2XvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=QcFlSQRGw0LtNC6bu3wi8nn6XsgcbGxt3ojTDlhJQ8H6TmEKAB8PdLDzfmmG0i46IY
         gD6ffqy25pe1TrLJOL3QNxAR491tXQMcdpir6r9YADL/kAUXeZYZQFgX+2fFMfVaJNw3
         HeN9aedmXZvr1mb7UBJtd0ZvQ5gsFAENBA1dk=
Message-ID: <4C521408.3040506@gmail.com>
Date: Fri, 30 Jul 2010 03:51:36 +0400
From: "Guram Z. Savinov" <savinov.guram@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Get interface MAC address in sys_accept4() syscall
References: <4C5211D6.3000406@gmail.com>
In-Reply-To: <4C5211D6.3000406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

30.07.2010 03:42, Guram Z. Savinov пишет:
> Hi all,
>
> in net/socket.c is syscall sys_accept4(). In it syscall I need to get 
> MAC address of interface, from connection is come.
> For example it is two interfaces eth0 and eth1. I want to know, from 
> what interface connection is come to sys_accept4().
> Please help me, how I can do it.
>
> Thank's for attention for my question.
I forget tell: kernel version: 2.6.28
Here is code of sys_accept4() syscall, in it I need get MAC address of 
interface:

/*
  *    For accept, we attempt to create a new socket, set up the link
  *    with the client, wake up the client, then return the new
  *    connected fd. We collect the address of the connector in kernel
  *    space and move it to user at the very end. This is unclean because
  *    we open the socket then return an error.
  *
  *    1003.1g adds the ability to recvmsg() to query connection pending
  *    status to recvmsg. We need to add that support in a way thats
  *    clean when we restucture accept also.
  */

asmlinkage long sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
                 int __user *upeer_addrlen, int flags)
{
     struct socket *sock, *newsock;
     struct file *newfile;
     int err, len, newfd, fput_needed;
     struct sockaddr_storage address;

     if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
         return -EINVAL;

     if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
         flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;

     sock = sockfd_lookup_light(fd, &err, &fput_needed);
     if (!sock)
         goto out;

     err = -ENFILE;
     if (!(newsock = sock_alloc()))
         goto out_put;

     newsock->type = sock->type;
     newsock->ops = sock->ops;

     /*
      * We don't need try_module_get here, as the listening socket (sock)
      * has the protocol module (sock->ops->owner) held.
      */
     __module_get(newsock->ops->owner);

     newfd = sock_alloc_fd(&newfile, flags & O_CLOEXEC);
     if (unlikely(newfd < 0)) {
         err = newfd;
         sock_release(newsock);
         goto out_put;
     }

     err = sock_attach_fd(newsock, newfile, flags & O_NONBLOCK);
     if (err < 0)
         goto out_fd_simple;

     err = security_socket_accept(sock, newsock);
     if (err)
         goto out_fd;

     err = sock->ops->accept(sock, newsock, sock->file->f_flags);
     if (err < 0)
         goto out_fd;

     if (upeer_sockaddr) {
         if (newsock->ops->getname(newsock, (struct sockaddr *)&address,
&len, 2) < 0) {
             err = -ECONNABORTED;
             goto out_fd;
         }
         err = move_addr_to_user((struct sockaddr *)&address,
                     len, upeer_sockaddr, upeer_addrlen);
         if (err < 0)
             goto out_fd;
     }

     /* File flags are not inherited via accept() unlike another OSes. */

     fd_install(newfd, newfile);
     err = newfd;

     security_socket_post_accept(sock, newsock);

out_put:
     fput_light(sock->file, fput_needed);
out:
     return err;
out_fd_simple:
     sock_release(newsock);
     put_filp(newfile);
     put_unused_fd(newfd);
     goto out_put;
out_fd:
     fput(newfile);
     put_unused_fd(newfd);
     goto out_put;
}
