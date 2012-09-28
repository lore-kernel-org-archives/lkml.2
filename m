Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab2I1Udi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:33:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56440 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032866Ab2I1UbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Weiping Pan <wpan@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 180/218] rds: set correct msg_namelen
Date: Fri, 28 Sep 2012 13:16:37 -0700
Message-Id: <20120928201522.159423339@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiping Pan <wpan@redhat.com>

commit 06b6a1cf6e776426766298d055bb3991957d90a7 upstream.

Jay Fenlason (fenlason@redhat.com) found a bug,
that recvfrom() on an RDS socket can return the contents of random kernel
memory to userspace if it was called with a address length larger than
sizeof(struct sockaddr_in).
rds_recvmsg() also fails to set the addr_len paramater properly before
returning, but that's just a bug.
There are also a number of cases wher recvfrom() can return an entirely bogus
address. Anything in rds_recvmsg() that returns a non-negative value but does
not go through the "sin = (struct sockaddr_in *)msg->msg_name;" code path
at the end of the while(1) loop will return up to 128 bytes of kernel memory
to userspace.

And I write two test programs to reproduce this bug, you will see that in
rds_server, fromAddr will be overwritten and the following sock_fd will be
destroyed.
Yes, it is the programmer's fault to set msg_namelen incorrectly, but it is
better to make the kernel copy the real length of address to user space in
such case.

How to run the test programs ?
I test them on 32bit x86 system, 3.5.0-rc7.

1 compile
gcc -o rds_client rds_client.c
gcc -o rds_server rds_server.c

2 run ./rds_server on one console

3 run ./rds_client on another console

4 you will see something like:
server is waiting to receive data...
old socket fd=3
server received data from client:data from client
msg.msg_namelen=32
new socket fd=-1067277685
sendmsg()
: Bad file descriptor

/***************** rds_client.c ********************/

int main(void)
{
	int sock_fd;
	struct sockaddr_in serverAddr;
	struct sockaddr_in toAddr;
	char recvBuffer[128] = "data from client";
	struct msghdr msg;
	struct iovec iov;

	sock_fd = socket(AF_RDS, SOCK_SEQPACKET, 0);
	if (sock_fd < 0) {
		perror("create socket error\n");
		exit(1);
	}

	memset(&serverAddr, 0, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
	serverAddr.sin_port = htons(4001);

	if (bind(sock_fd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
		perror("bind() error\n");
		close(sock_fd);
		exit(1);
	}

	memset(&toAddr, 0, sizeof(toAddr));
	toAddr.sin_family = AF_INET;
	toAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
	toAddr.sin_port = htons(4000);
	msg.msg_name = &toAddr;
	msg.msg_namelen = sizeof(toAddr);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;
	msg.msg_iov->iov_base = recvBuffer;
	msg.msg_iov->iov_len = strlen(recvBuffer) + 1;
	msg.msg_control = 0;
	msg.msg_controllen = 0;
	msg.msg_flags = 0;

	if (sendmsg(sock_fd, &msg, 0) == -1) {
		perror("sendto() error\n");
		close(sock_fd);
		exit(1);
	}

	printf("client send data:%s\n", recvBuffer);

	memset(recvBuffer, '\0', 128);

	msg.msg_name = &toAddr;
	msg.msg_namelen = sizeof(toAddr);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;
	msg.msg_iov->iov_base = recvBuffer;
	msg.msg_iov->iov_len = 128;
	msg.msg_control = 0;
	msg.msg_controllen = 0;
	msg.msg_flags = 0;
	if (recvmsg(sock_fd, &msg, 0) == -1) {
		perror("recvmsg() error\n");
		close(sock_fd);
		exit(1);
	}

	printf("receive data from server:%s\n", recvBuffer);

	close(sock_fd);

	return 0;
}

/***************** rds_server.c ********************/

int main(void)
{
	struct sockaddr_in fromAddr;
	int sock_fd;
	struct sockaddr_in serverAddr;
	unsigned int addrLen;
	char recvBuffer[128];
	struct msghdr msg;
	struct iovec iov;

	sock_fd = socket(AF_RDS, SOCK_SEQPACKET, 0);
	if(sock_fd < 0) {
		perror("create socket error\n");
		exit(0);
	}

	memset(&serverAddr, 0, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
	serverAddr.sin_port = htons(4000);
	if (bind(sock_fd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
		perror("bind error\n");
		close(sock_fd);
		exit(1);
	}

	printf("server is waiting to receive data...\n");
	msg.msg_name = &fromAddr;

	/*
	 * I add 16 to sizeof(fromAddr), ie 32,
	 * and pay attention to the definition of fromAddr,
	 * recvmsg() will overwrite sock_fd,
	 * since kernel will copy 32 bytes to userspace.
	 *
	 * If you just use sizeof(fromAddr), it works fine.
	 * */
	msg.msg_namelen = sizeof(fromAddr) + 16;
	/* msg.msg_namelen = sizeof(fromAddr); */
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;
	msg.msg_iov->iov_base = recvBuffer;
	msg.msg_iov->iov_len = 128;
	msg.msg_control = 0;
	msg.msg_controllen = 0;
	msg.msg_flags = 0;

	while (1) {
		printf("old socket fd=%d\n", sock_fd);
		if (recvmsg(sock_fd, &msg, 0) == -1) {
			perror("recvmsg() error\n");
			close(sock_fd);
			exit(1);
		}
		printf("server received data from client:%s\n", recvBuffer);
		printf("msg.msg_namelen=%d\n", msg.msg_namelen);
		printf("new socket fd=%d\n", sock_fd);
		strcat(recvBuffer, "--data from server");
		if (sendmsg(sock_fd, &msg, 0) == -1) {
			perror("sendmsg()\n");
			close(sock_fd);
			exit(1);
		}
	}

	close(sock_fd);
	return 0;
}

Signed-off-by: Weiping Pan <wpan@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rds/recv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -410,6 +410,8 @@ int rds_recvmsg(struct kiocb *iocb, stru
 
 	rdsdebug("size %zu flags 0x%x timeo %ld\n", size, msg_flags, timeo);
 
+	msg->msg_namelen = 0;
+
 	if (msg_flags & MSG_OOB)
 		goto out;
 
@@ -485,6 +487,7 @@ int rds_recvmsg(struct kiocb *iocb, stru
 			sin->sin_port = inc->i_hdr.h_sport;
 			sin->sin_addr.s_addr = inc->i_saddr;
 			memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+			msg->msg_namelen = sizeof(*sin);
 		}
 		break;
 	}


