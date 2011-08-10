Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab1HJRut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:50:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45995 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1HJRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:50:48 -0400
Subject: Re: UDP requires 2 reads to obtain vital information - Kindly
 comment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sreeram B S <sreeramb@netapp.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E42B886.4030607@netapp.com>
References: <4E42B886.4030607@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 19:50:48 +0200
Message-ID: <1312998648.2295.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 10 août 2011 à 22:27 +0530, Sreeram B S a écrit :
> Respected people,
>     I am Sreeram. I work on TCP/IP network applications.
>     This mail is regarding UDP.
>     Whenever a UDP datagram arrives, the receiver may wish to know the
> sender's IP address and also the destination address of that datagram.
> The recvfrom() function will return the sender's IP address. If the
> destination address of the datagram is required, then the user has to
> set the IP_PKTINFO socket option for the UDP socket and get the
> address as ancillary data in recvmsg(). So, the point here is that the
> user has to issue 2 reads on the same datagram (with the flag MSG_PEEK
> in first read call enabled) in order to obtain the sender's IP and the
> destination IP of the datagram. I personally feel that there should be
> a way provided to the user to obtain these values in a single read
> call. By doing this I am sure that lot of time would be saved in
> collecting the required information.
>     I have written a simple UDP client program to show that we need 2
> reads to obtain the above information. I have made it signal-driven
> just to make it interesting and not for any other reason. I have
> attached the client program along with this mail.
>     Fortunately, as mentioned above, Linux provides the IP_PKTINFO
> socket option, enabling which, will send in a structure 'struct
> in_pktinfo' as ancillary data in recvmsg(). The structure is as
> follows:
> 
>                   struct in_pktinfo {
>                       unsigned int   ipi_ifindex;  /* Interface index */
>                       struct in_addr ipi_spec_dst; /* Local address */
>                       struct in_addr ipi_addr;     /* Header Destination
>                                                       address */
>                   };
> 
>     Would it be incorrect if I request the kernel coders to add the
> sender's IP address as well in this structure, so that the user will
> get both the sender's IP and the destination IP address of the
> datagram in a single call to recvmsg()?
>     I very well understand that my knowledge is very much diminished.
> Hence I request you to kindly correct me if what I have
> understood/suggested is incorrect.
> Please suggest.
> 
> Regards,
> Sreeram


Part of your program :

 /* Now receive the destination address. */
    iov[0].iov_base = mesg;
    iov[0].iov_len = 1;
    msg.msg_name = NULL;     << HERE >>
    msg.msg_namelen = 0;     << HERE >>
    msg.msg_control = calloc(1, 100);
    msg.msg_controllen = 100;
    msg.msg_iov = &iov[0];
    msg.msg_iovlen = 1;


Remove the MSG_PEEK not needed call, and use instead :

msg.msg_name = &peer;
msg.msg_namelen = sizeof(peer);


It should solve your problem : one single system call to get the message
payload and metainformation (your own IP in ancillary data, and peer IP
in &peer)




