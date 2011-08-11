Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1HKFsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:48:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:52195 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1HKFsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:48:07 -0400
X-IronPort-AV: E=Sophos;i="4.67,355,1309762800"; 
   d="scan'208";a="569783138"
Message-ID: <4E436D89.6000201@netapp.com>
Date: Thu, 11 Aug 2011 11:20:01 +0530
From: Sreeram B S <sreeramb@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: UDP requires 2 reads to obtain vital information - Kindly comment
References: <4E42B886.4030607@netapp.com> <1312998648.2295.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1312998648.2295.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
    Thanks for all the replies.
    Yes, it worked wonderfully upon setting the msg_name to the address 
of the place-holder for peer-address!

Regards,
Sreeram

On 08/10/2011 11:20 PM, Eric Dumazet wrote:
> Le mercredi 10 août 2011 à 22:27 +0530, Sreeram B S a écrit :
>> Respected people,
>>      I am Sreeram. I work on TCP/IP network applications.
>>      This mail is regarding UDP.
>>      Whenever a UDP datagram arrives, the receiver may wish to know the
>> sender's IP address and also the destination address of that datagram.
>> The recvfrom() function will return the sender's IP address. If the
>> destination address of the datagram is required, then the user has to
>> set the IP_PKTINFO socket option for the UDP socket and get the
>> address as ancillary data in recvmsg(). So, the point here is that the
>> user has to issue 2 reads on the same datagram (with the flag MSG_PEEK
>> in first read call enabled) in order to obtain the sender's IP and the
>> destination IP of the datagram. I personally feel that there should be
>> a way provided to the user to obtain these values in a single read
>> call. By doing this I am sure that lot of time would be saved in
>> collecting the required information.
>>      I have written a simple UDP client program to show that we need 2
>> reads to obtain the above information. I have made it signal-driven
>> just to make it interesting and not for any other reason. I have
>> attached the client program along with this mail.
>>      Fortunately, as mentioned above, Linux provides the IP_PKTINFO
>> socket option, enabling which, will send in a structure 'struct
>> in_pktinfo' as ancillary data in recvmsg(). The structure is as
>> follows:
>>
>>                    struct in_pktinfo {
>>                        unsigned int   ipi_ifindex;  /* Interface index */
>>                        struct in_addr ipi_spec_dst; /* Local address */
>>                        struct in_addr ipi_addr;     /* Header Destination
>>                                                        address */
>>                    };
>>
>>      Would it be incorrect if I request the kernel coders to add the
>> sender's IP address as well in this structure, so that the user will
>> get both the sender's IP and the destination IP address of the
>> datagram in a single call to recvmsg()?
>>      I very well understand that my knowledge is very much diminished.
>> Hence I request you to kindly correct me if what I have
>> understood/suggested is incorrect.
>> Please suggest.
>>
>> Regards,
>> Sreeram
>
> Part of your program :
>
>   /* Now receive the destination address. */
>      iov[0].iov_base = mesg;
>      iov[0].iov_len = 1;
>      msg.msg_name = NULL;<<  HERE>>
>      msg.msg_namelen = 0;<<  HERE>>
>      msg.msg_control = calloc(1, 100);
>      msg.msg_controllen = 100;
>      msg.msg_iov =&iov[0];
>      msg.msg_iovlen = 1;
>
>
> Remove the MSG_PEEK not needed call, and use instead :
>
> msg.msg_name =&peer;
> msg.msg_namelen = sizeof(peer);
>
>
> It should solve your problem : one single system call to get the message
> payload and metainformation (your own IP in ancillary data, and peer IP
> in&peer)
>
>
>
>
