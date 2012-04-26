Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2DZJhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:37:35 -0400
Received: from mx2.netapp.com ([216.240.18.37]:34166 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2DZJhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:37:33 -0400
X-IronPort-AV: E=Sophos;i="4.75,485,1330934400"; 
   d="scan'208";a="643564298"
From: "S, Sreeram" <Sreeram.S@netapp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@mit.edu>
CC: "S, Sreeram" <Sreeram.S@netapp.com>
Subject: IP options IP_RECVOPTS on Linux 2.6 - Kindly comment
Thread-Topic: IP options IP_RECVOPTS on Linux 2.6 - Kindly comment
Thread-Index: Ac0jjqxjoILH3aKGQFyeeZZJQ60udQ==
Date: Thu, 26 Apr 2012 09:37:31 +0000
Message-ID: <402249329CEF3E49AACD14423D8386EE03C6B35C@SACEXCMBX03-PRD.hq.netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.53]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3Q9bjP2012868

Hi, 
    I am Sreeram. I work on TCP/IP on personal interest. I was going through the man page of ip(7). 
In the man page, it is documented that there is an option called IP_RECVOPTS which returns the IP header options as a control message. 
Exact snippet from the man-page is as follows:


       IP_RECVOPTS (since Linux 2.2)
              Pass all incoming IP options to the user in a IP_OPTIONS
              control  message.   The routing header and other options
              are already filled in for the local host.  Not supported
              for SOCK_STREAM sockets.

I have written a program which uses recvmsg() to receive the UDP message and also the incoming ancillary/control data.
In that program, I had enabled this option. But I could not get any IP header options ancillary/control message. Initially, I
had defined a pointer to the ip_opts structure defined in bits/in.h . The structure and its documentation are as follows:

#if defined __USE_MISC || defined __USE_GNU
/* Structure used to describe IP options for IP_OPTIONS and IP_RETOPTS.
   The `ip_dst' field is used for the first-hop gateway when using a
   source route (this gets put into the header proper).  */
struct ip_opts
  {
    struct in_addr ip_dst;      /* First hop; zero without source route.  */
    char ip_opts[40];           /* Actually variable in size.  */
  };

   Since, I did not receive the IP header options message in recvmsg(), I removed the pointer variable for this structure and the associated typecasting to the CMSG_DATA(..) and 
Introduced a counter to count the number of ancillary packets received. The count was 3 (IP_TTL and IP_TOS and SO_TIMESTAMP, all which I had enabled using setsockopt())
The program is as follows:

[root@sreeramb-linux Server]# cat recvmsg.c 
/* This is a generic UDP server.                                        
 * This will return what it received from the client to the client.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 19000
#define SA struct sockaddr

int main(int argc, char **argv) {
    char data[128];
    int *ttlptr, count=0;
    int sock, retn, size, val=1;
    struct sockaddr_in peer;
    struct iovec iov;
    struct ip_opts *ipopts;
    struct msghdr msg;
    struct cmsghdr *cmsg;
    struct timeval *timeptr;
    
    /* Create a socket. */
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        perror("Socket");
        exit(-1);
    }
    printf("Socket created.\n");

    /* Set some options for this socket to get ancillary data. */
    setsockopt(sock, IPPROTO_IP, IP_RECVTTL, &val, sizeof(val));
    setsockopt(sock, IPPROTO_IP, IP_RECVTOS, &val, sizeof(val));
    setsockopt(sock, IPPROTO_IP, IP_RETOPTS, &val, sizeof(val));
    setsockopt(sock, SOL_SOCKET, SO_TIMESTAMP, &val, sizeof(val));

    /* Prepare the structure for 'bind'ing */
    memset(&peer, 0, sizeof(peer));
    peer.sin_family = AF_INET;
    peer.sin_port = htons(PORT);
    peer.sin_addr.s_addr = INADDR_ANY;

    /* Bind to an interface */
    retn = bind(sock, (SA *)&peer, sizeof(peer));    
    if (retn < 0) {
        perror("Bind");
        close(sock);
        exit(-1);
    }
    printf("Successfully bound to the interface.\n");

    /* Now, populate the msghdr to prepare it for use in recvmsg */
    memset(data, 0, sizeof(data));
    memset(&peer, 0, sizeof(peer));
    iov.iov_base = data;
    iov.iov_len = sizeof(data);
    msg.msg_name = &peer;
    msg.msg_namelen = sizeof(peer);
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;
    msg.msg_control = calloc(1, 1024);
    msg.msg_controllen = 1024;
    msg.msg_flags = 0;

    /* Now, call recvmsg() */
    size = sizeof(peer);
    retn = recvmsg(sock, &msg, 0);
    if (retn < 0) {
        perror("recvfrom");
        close(sock);
        exit(-2);
    }
    printf("Received some data:\n");
    printf("    Client: %s\n", inet_ntoa(peer.sin_addr));
    printf("      Data: %s\n", data);

    /* Print ancillary data */
    for(cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL; 
        cmsg = CMSG_NXTHDR(&msg, cmsg)) {

        /* Check for TTL in ancillary data. */
        if ((cmsg->cmsg_level == IPPROTO_IP)
         &&(cmsg->cmsg_type == IP_TTL)) {
            ttlptr = (int *) CMSG_DATA(cmsg);
            val = *ttlptr;
            printf("       TTL: %d\n", val);
        }

        /* Check for TOS in ancillary data. */
        if ((cmsg->cmsg_level == IPPROTO_IP)
         &&(cmsg->cmsg_type == IP_TOS)) {
            ttlptr = (int *) CMSG_DATA(cmsg);
            val = *ttlptr;
            printf("       TOS: %d\n", val);
        }

        /* Get the timestamp of the message. */
        if ((cmsg->cmsg_level == SOL_SOCKET)
         && (cmsg->cmsg_type == SO_TIMESTAMP)) {
            timeptr = (struct timeval *) CMSG_DATA(cmsg);
            printf(" Timestamp: %s", ctime(&timeptr->tv_sec));
        }

        count++;
    }

    printf("Total ancillary packets: %d\n", count);
    close(sock);
    return(0);
}
[root@sreeramb-linux Server]#
[root@sreeramb-linux Server]# uname -a
Linux sreeramb-linux 2.6.35.6-45.fc14.i686 #1 SMP Mon Oct 18 23:56:17 UTC 2010 i686 i686 i386 GNU/Linux
[root@sreeramb-linux Server]#

[ I am using Fedora Core 14]

   What could be the reason for not receiving the IP Options message? What should I enable to receive the same?

Kindly guide.

Regards,
Sreeram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
