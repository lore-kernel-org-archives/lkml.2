Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1HJQzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:55:52 -0400
Received: from mx2.netapp.com ([216.240.18.37]:52948 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab1HJQzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:55:50 -0400
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="c'?scan'208";a="569627523"
Message-ID: <4E42B886.4030607@netapp.com>
Date: Wed, 10 Aug 2011 22:27:42 +0530
From: Sreeram B S <sreeramb@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: UDP requires 2 reads to obtain vital information - Kindly comment
Content-Type: multipart/mixed;
 boundary="------------080407060409030308080906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080407060409030308080906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Respected people,
    I am Sreeram. I work on TCP/IP network applications.
    This mail is regarding UDP.
    Whenever a UDP datagram arrives, the receiver may wish to know the
sender's IP address and also the destination address of that datagram.
The recvfrom() function will return the sender's IP address. If the
destination address of the datagram is required, then the user has to
set the IP_PKTINFO socket option for the UDP socket and get the
address as ancillary data in recvmsg(). So, the point here is that the
user has to issue 2 reads on the same datagram (with the flag MSG_PEEK
in first read call enabled) in order to obtain the sender's IP and the
destination IP of the datagram. I personally feel that there should be
a way provided to the user to obtain these values in a single read
call. By doing this I am sure that lot of time would be saved in
collecting the required information.
    I have written a simple UDP client program to show that we need 2
reads to obtain the above information. I have made it signal-driven
just to make it interesting and not for any other reason. I have
attached the client program along with this mail.
    Fortunately, as mentioned above, Linux provides the IP_PKTINFO
socket option, enabling which, will send in a structure 'struct
in_pktinfo' as ancillary data in recvmsg(). The structure is as
follows:

                  struct in_pktinfo {
                      unsigned int   ipi_ifindex;  /* Interface index */
                      struct in_addr ipi_spec_dst; /* Local address */
                      struct in_addr ipi_addr;     /* Header Destination
                                                      address */
                  };

    Would it be incorrect if I request the kernel coders to add the
sender's IP address as well in this structure, so that the user will
get both the sender's IP and the destination IP address of the
datagram in a single call to recvmsg()?
    I very well understand that my knowledge is very much diminished.
Hence I request you to kindly correct me if what I have
understood/suggested is incorrect.
Please suggest.

Regards,
Sreeram

--------------080407060409030308080906
Content-Type: text/plain;
 name="sigioserv.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sigioserv.c"

/* This is an UDP server which deals with the clients upon receiving a SIGIO
   signal. The signal is generated whenever a datagram arrives.

   For this kind of client handling, three steps have to be done:
	1. Establish signal handler for SIGIO
	2. Set the owner for receiving SIGIO using fcntl()
	3. Set the O_ASYNC flag for socket using fcntl() or use ioctl()
*/

#include <fcntl.h>
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 9000
#define SA struct sockaddr
#ifdef __linux__
#define IP_RECVDSTADDR IP_PKTINFO
struct in_pktinfo *ip_pkt;
#elif __FreeBSD__
struct in_addr *ip_addr;
#endif

void handle_incoming_data(void);

int sock; /* Global member. */

void handle_sigio(int signo) {
    printf("In handle_sigio() function.\n");
    handle_incoming_data();
    return;
}

void handle_sigaction(int signo, siginfo_t *details, void *addr) {
    printf("In handle_sigaction() function.\n");
    if (details->si_code == SI_SIGIO)
    	printf("File handle: %d; sock = %d\n", details->si_fd, sock);
    else	
	printf("si_code = %d\n", details->si_code);
    handle_incoming_data();
    return;
}

int main(int argc, char **argv) {
    int retn, temp, flags;
    struct sockaddr_in addr;
    char buf[128];
    int optval, optlen;
    struct sigaction act;

    /* Create a socket. */
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
	perror("socket");
	exit(-1);
    }
    printf("Created socket.\n");

    /* Set the socket to return destination address as ancillary data. */
    optval = 1, optlen = sizeof(optval);
    retn = setsockopt(sock, IPPROTO_IP, IP_RECVDSTADDR, &optval, optlen);
    if (retn < 0) {
	perror("IP_PKTINFO");
	close(sock);
	exit(-1);
    }
    printf("Successfully set the option to receive destination address.\n");

    /* 1. Establish signal handler. */
    act.sa_sigaction = &handle_sigaction;
    act.sa_flags = SA_SIGINFO;
    printf("PID: %d\n", getpid());
    sigaction(SIGIO, &act, NULL);
    
    /* 2. Set the SIGIO owner */
    retn = fcntl(sock, F_SETOWN, getpid());
    if (retn < 0) {
	perror("fcntl:F_SETOWN");
	close(sock);
	exit(-3);
    }
    printf("Successfully set the signal handler for SIGIO signal.\n");

    /* 3. Set the ASYNC flag for socket. */
    flags = fcntl(sock, F_GETFL);
    retn = fcntl(sock, F_SETFL, flags | O_ASYNC);
    if (retn < 0) {
	perror("fcntl:F_SETFL");
	close(sock);
	exit(-1);
    }
    printf("Set the O_ASYNC flag for the socket to facilitate SIGIO.\n");

    /* Fill in the address to bind. */
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr.s_addr = htons(INADDR_ANY);

    /* Bind the socket. */
    retn = bind(sock, (SA *)&addr, sizeof(SA));
    if (retn < 0) {
	perror("Bind");
	close(sock);
	exit(-2);
    }
    printf("Bound the socket successfully.\n");

    /* Wait for signal and its processing. */
    pause(); 

    close(sock);
    return(0);
}

/* Routine to handle incoming data. */
void handle_incoming_data(void) {
    struct sockaddr_in peer;
    int retn, len;
    char ip[20], mesg[128];
    struct iovec iov[1];
    struct msghdr msg;
    struct cmsghdr *cmsg;

    /* Obtain the client address. Data is also received here. */
    len = sizeof(SA);
    memset(mesg, 0, sizeof(mesg));
    retn = recvfrom(sock, mesg, 128, MSG_PEEK, (SA *)&peer, &len);
    if (retn < 0) {
	perror("recvfrom");
	return;
    }
    printf("Received message from a client.\n");
    printf("  Client-address: %s\n", inet_ntoa(peer.sin_addr));

    /* Now receive the destination address. */
    iov[0].iov_base = mesg;
    iov[0].iov_len = 1;
    msg.msg_name = NULL;
    msg.msg_namelen = 0;
    msg.msg_control = calloc(1, 100);
    msg.msg_controllen = 100;
    msg.msg_iov = &iov[0];
    msg.msg_iovlen = 1;

    /* Now issue the recvmsg() */
    retn = recvmsg(sock, &msg, 0);
    if (retn < 0) {
	perror("recvmsg");
	return;
    }
    if (! msg.msg_controllen) {
    	printf("  Message: %s\n", mesg);
	printf("No ancillary data present. Returning.\n");
	return;
    }
    
    /* Get the ancillary data using CMSG_* defines. 
	The code becomes platform specific from hereon. */
    cmsg = CMSG_FIRSTHDR(&msg);
    for(;cmsg != NULL; cmsg = CMSG_NXTHDR(&msg, cmsg)) {
	if ((cmsg->cmsg_level == IPPROTO_IP)
	  &&(cmsg->cmsg_type == IP_RECVDSTADDR)) {
#ifdef __linux__
	    ip_pkt = (struct in_pktinfo *)CMSG_DATA(cmsg);
	    printf("  Destination address: %s\n", inet_ntoa(ip_pkt->ipi_addr));
#elif __FreeBSD__
	    ip_addr = (struct in_addr *)CMSG_DATA(cmsg);
	    printf("  Destination address: %s\n", inet_ntoa(*ip_addr));
#endif
	}
    }
    printf("  Message: %s\n", mesg);

    return;
}

--------------080407060409030308080906--
