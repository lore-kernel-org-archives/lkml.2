Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab0HZF4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 01:56:15 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47331 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0HZF4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 01:56:13 -0400
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] powerpc: Wire up direct socket system calls
From: Ian Munsie <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Christoph Hellwig <hch@lst.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-reply-to: <1282798228-340-1-git-send-email-imunsie@au1.ibm.com>
References: <1282798228-340-1-git-send-email-imunsie@au1.ibm.com>
Date: Thu, 26 Aug 2010 15:56:07 +1000
Message-Id: <1282801975-sup-2217@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Ian Munsie's message of Thu Aug 26 14:50:28 +1000 2010:
> This patch wires up the various socket system calls on PowerPC so that
> userspace can call them directly, rather than by going through the
> multiplexed socketcall system call.

I should have mentioned that the base is ppc/next

Also, I've included a simple library below suitable for use with
LD_PRELOAD to allow this to be tested on existing programs.


Cheers,
-Ian


#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>

/* PPC syscall numbers from /arch/powerpc/include/asm/unistd.h */
#define __NR_socket		326
#define __NR_bind		327
#define __NR_connect		328
#define __NR_listen		329
#define __NR_accept		330
#define __NR_getsockname	331
#define __NR_getpeername	332
#define __NR_socketpair		333
#define __NR_send		334
#define __NR_sendto		335
#define __NR_recv		336
#define __NR_recvfrom		337
#define __NR_shutdown		338
#define __NR_setsockopt		339
#define __NR_getsockopt		340
#define __NR_sendmsg		341
#define __NR_recvmsg		342
#define __NR_recvmmsg		343
#define __NR_accept4		344


#define DEBUG 0

#if DEBUG
#define DEBUGsyscall(name, ...)						\
	int __ret;							\
	__ret = syscall(__NR_##name, __VA_ARGS__);			\
	fprintf(stderr, "--"#name": %i", __ret);			\
	if (__ret == -1) {						\
		fprintf(stderr, ", %s (%i)", strerror(errno), errno);	\
	}								\
	fprintf(stderr, "--\n");					\
	return __ret;
#else
#define DEBUGsyscall(name, ...)						\
	return syscall(__NR_##name, __VA_ARGS__);
#endif


int socket(int domain, int type, int protocol)
{
	DEBUGsyscall(socket, domain, type, protocol);
}

int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
{
	DEBUGsyscall(bind, sockfd, addr, addrlen);
}

int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
{
	DEBUGsyscall(connect, sockfd, addr, addrlen);
}

int listen(int sockfd, int backlog)
{
	DEBUGsyscall(listen, sockfd, backlog);
}

int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
{
	DEBUGsyscall(accept, sockfd, addr, addrlen);
}

int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
{
	DEBUGsyscall(getsockname, sockfd, addr, addrlen);
}

int getpeername(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
{
	DEBUGsyscall(getpeername, sockfd, addr, addrlen);
}

int socketpair(int domain, int type, int protocol, int sv[2])
{
	DEBUGsyscall(socketpair, domain, type, protocol, sv);
}

int send(int sockfd, const void *buf, size_t len, int flags)
{
	DEBUGsyscall(send, sockfd, buf, len, flags);
}

int sendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen)
{
	DEBUGsyscall(sendto, sockfd, buf, len, flags, dest_addr, addrlen);
}

int recv(int sockfd, void *buf, size_t len, int flags)
{
	DEBUGsyscall(recv, sockfd, buf, len, flags);
}

int recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen)
{
	DEBUGsyscall(recvfrom, sockfd, buf, len, flags, src_addr, addrlen);
}

int shutdown(int sockfd, int how)
{
	DEBUGsyscall(shutdown, sockfd, how);
}

int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen)
{
	DEBUGsyscall(setsockopt, sockfd, level, optname, optval, optlen);
}

int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen)
{
	DEBUGsyscall(getsockopt, sockfd, level, optname, optval, optlen);
}

int sendmsg(int sockfd, const struct msghdr *msg, int flags)
{
	DEBUGsyscall(sendmsg, sockfd, msg, flags);
}

int recvmsg(int sockfd, struct msghdr *msg, int flags)
{
	DEBUGsyscall(recvmsg, sockfd, msg, flags);
}

/* Debian squeeze libc doesn't support recvmmsg yet, not much point intercepting it */

int accept4(int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags)
{
	DEBUGsyscall(accept4, sockfd, addr, addrlen, flags);
}
