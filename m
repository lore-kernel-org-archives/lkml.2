Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2DURKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 13:10:24 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33197 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2DURKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 13:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <402249329CEF3E49AACD14423D8386EE03C68E4B@SACEXCMBX03-PRD.hq.netapp.com>
References: <402249329CEF3E49AACD14423D8386EE03C68E13@SACEXCMBX03-PRD.hq.netapp.com>
	<402249329CEF3E49AACD14423D8386EE03C68E31@SACEXCMBX03-PRD.hq.netapp.com>
	<402249329CEF3E49AACD14423D8386EE03C68E4B@SACEXCMBX03-PRD.hq.netapp.com>
Date: Sat, 21 Apr 2012 22:40:21 +0530
Message-ID: <CAObZ-RViLdNBjO_gW+TkvooNkQUOvU_PybWyaWwzRXvAZsWf5Q@mail.gmail.com>
Subject: Fwd: FW: UDP socket bound using SO_BINDTODEVICE not receiving
 broadcast messages
From: Sreeram BS <sreeramabs@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sreeramb@netapp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I am Sreeram. I work on TCP/IP applications.
    I was going through the DHCP RFC and always wanted to write my own
DHCP sequence of messages (for practice purpose). However, in this
endeavor, I have hit a blocker and seek your kind help in this regard.
    I was able to form a DHCPDISCOVER message and broadcast it. The
message was broadcasted successfully. The DHCP server also accepted it
and returned a DHCPOFFER message. But my application is not able to
receive it. I am able to see the transmission of DHCPDISCOVER and
DHCPOFFER messages using wireshark.

The sequence of steps are as follows:


1.      Ensured that 'eth0' device is up and does not possess an IP address.

2.      Opened a UDP socket.

3.      Enabled the broadcast flag of this socket.

4.      Bound the socket to port 68.

5.      Bound the socket to eth0 device by using SO_BINDTODEVICE socket option.

6.      Formulated the DHCPDISCOVER message and broadcasted it to
255.255.255.255 and port 67.

7.      Called 'recvfrom' on the same socket.

8.      Wireshark shows the arrival of DHCPOFFER, but the application
is still blocked on 'recvfrom' message.

I also flushed off the iptables just to make sure that no firewall
rules are acting on (although wireshark showed clearly that the
DHCPOFFER has arrived).

I am pasting the 'iptables -list' command output, the source code of
my program here. May I request you to kindly suggest as to what is
wrong here and what addition/modification should I do to this program
to make it accept the DHCPOFFER message?


----------------------------------------------
--------------- Output of 'iptables --list' command ---
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

---------------- Source Program -------------------------

/* This is a test program to bind a socket to an interface
* instead of to an IP address(which is done normally).
* Also, broadcasting is enabled for this socket so that
* any broadcast packet is sent over this socket.
*/

#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>

#define SA struct sockaddr
#define IFC "eth0"
#define PORT 67
#define IFCSZ sizeof(IFC)

struct dhcp_header {
    unsigned char op;
    unsigned char htype;
    unsigned char hlen;
    unsigned char hops;
    int xid;
    short secs;
    short flags;
    struct in_addr ciaddr;
    struct in_addr yiaddr;
    struct in_addr siaddr;
    struct in_addr giaddr;
    unsigned char chaddr[16];
    unsigned char sname[64];
    unsigned char file[128];
    unsigned char opts[128];
};

int main(int argc, char **argv) {
    int sock, retn;
    struct sockaddr_in peer, addr;
    char mesg[] = "Hello World!";
    int val=1, size = sizeof(val);

    /* Create an UDP socket first. */
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        perror("Socket");
        exit(-1);
    }
    printf("Created socket successfully.\n");

    /* Now, set the SO_REUSEADDR flag for this socket. */
    retn = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &val, size);
    if (retn < 0) {
        perror("SO_REUSEADDR");
        close(sock);
        exit(-1);
    }
    printf("Successfully set the SO_REUSEADDR flag to this socket.\n");

    /* Set the structure to send to the broadcast address. */
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(68);
    retn = bind(sock, (SA *)&addr, sizeof(SA));
    if (retn < 0) {
        perror("BIND_TO_PORT");
        close(sock);
        exit(-3);
    }
    printf("Successfully bound to port 68 also.\n");

    /* Now, bind to device, eth0 */
    retn = setsockopt(sock, SOL_SOCKET, SO_BINDTODEVICE, IFC, IFCSZ);
    if (retn < 0) {
        perror("SO_BINDTODEVICE:eth0");
        close(sock);
        exit(-1);
    }
    printf("Successfully bound to device '%s'\n", IFC);

    /* Now, set the broadcast flag for this socket. */
    retn = setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &val, size);
    if (retn < 0) {
        perror("SO_BROADCAST");
        close(sock);
        exit(-1);
    }
    printf("Successfully set the broadcast flag to this socket.\n");

    /* Set the structure to send to the broadcast address. */
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    inet_aton("255.255.255.255", &addr.sin_addr);

    send_dhcp_discover(sock, addr);
    recv_dhcp_offer(sock);
}

int send_dhcp_discover(int sock, struct sockaddr_in addr) {
    int retn, i = 0;
    struct dhcp_header hdr;

    memset(&hdr, 0, sizeof(hdr));
    hdr.op = 1;
    hdr.htype = 1;
    hdr.hlen = 6;
    hdr.xid = 1;
    hdr.flags = 128;
    hdr.chaddr[0] = 0x08;
    hdr.chaddr[1] = 0x00;
    hdr.chaddr[2] = 0x27;
    hdr.chaddr[3] = 0x7C;
    hdr.chaddr[4] = 0xBC;
    hdr.chaddr[5] = 0x38;


    /* The first four octets are supposed to be magic number. */
    hdr.opts[i++] = 99;
    hdr.opts[i++] = 130;
    hdr.opts[i++] = 83;
    hdr.opts[i++] = 99;

    /* The next option depicts the message type. */
    hdr.opts[i++] = 53;  // DHCP message type.
    hdr.opts[i++] = 1;   // Length = 1
    hdr.opts[i++] = 1;   // DHCP Discover message.

    /* Let the client make a wish that it be assigned 192.168.1.25 */
    hdr.opts[i++] = 50;  // Preferred IP address
    hdr.opts[i++] = 4;   // Length = 4
    inet_aton("192.168.1.25", (struct in_addr *)&hdr.opts[i]);
    i += 4;

    hdr.opts[i++] = 255; // End of options.

    /* Now, broadcast the message. */
    retn = sendto(sock, &hdr, sizeof(hdr), 0, (SA *)&addr, sizeof(SA));
    if (retn < 0) {
        perror("sendto");
        close(sock);
        exit(-2);
    }
    printf("Successfully broadcasted the message.\n");

    printf("IFC size is %d\n", IFCSZ);
    return 0;
}

/* This program will receive the DHCP offer message */
int recv_dhcp_offer(int sock) {
    int retn, size = sizeof(SA);
    struct sockaddr_in server;
    unsigned char mesg[sizeof(struct dhcp_header)];

    /* Receive the message */
    retn = recvfrom(sock, mesg, sizeof(mesg), 0, (SA *)&server, &size);
    if (retn < 0) {
        perror("recvfrom");
        exit(-1);
    }

    printf("Received message: DHCP OFFER\n");
    return 0;
}

-------------- Output of 'ifconfig eth0' command -----------------
eth0      Link encap:Ethernet  HWaddr 08:00:27:7C:BC:38
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:38699 errors:0 dropped:0 overruns:0 frame:0
          TX packets:17892 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:44941898 (42.8 MiB)  TX bytes:1301745 (1.2 MiB)

[sreeramb@home-linux DHCP]$
-----------------------------------------------------

   Also, I would like to know as to what is the approach to debug such
issues. I have seen that there is a socket option called SO_DEBUG. But
I am not aware of its usage after it is enabled. I tried to skim
through the web, but failed to comprehend the usage of the same. I
would also request you to kindly guide me with hints for debugging
such issues.

Kindly help.

Regards,
Sreeram
