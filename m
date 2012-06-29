Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2F2SpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:45:11 -0400
Received: from nm17-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.21]:28736
	"HELO nm17-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755780Ab2F2SpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:45:09 -0400
X-Yahoo-Newman-Id: 325673.56252.bm@smtp107.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1nFvzq8VM1l6yRRKy9ZIyRRKzdPf23qKTlg8GFS_TBAwnEu
 Q_A0JksOo8YSdZBPg7y4f24wgJlpS7HJEDuXdh_u9WO6nxJQmU34bOKgVyji
 z.8A5xSS.FesBjbYZ2.ptlZ3F5nBcUobcHudoOoTFVsViNVRFXfFE11nnEGf
 RZxu32NmDGtEjz3VzWpgP63e0YlAkQdd9I3K_mE6FCdngkgxKHlQIHcJqDH.
 hWAvJ.l370bAoeyv0ZgvUz3olUmKS7QPLdHYdXQ2hAVxjBMTf5qw56U5slrg
 ZLEMKK1Eb4cqSDyBq85Wlas1zu4_2N56cjkYrv3X5zbzqE5YjhLblUo80xbs
 gZOTkPo0J.R_Mxf3AtE5NtawL0GSUFefleB9u7J0Li2jsdqo58EXbsXkiiOr
 4mgPnBcoKwLcLozFm2PFdz5UPt8GetvPpVlR4ttEXxytpP4rTfBeIwyUm11b
 MkwY.6wxUPsLbo21Oqw11LH1Dfoq7jo967vOdJABFqDrZKvb0c9WAHTgsxWy
 dwzkPzLOEDijRso9aiBvfjNGsQt_4ZCYe94SumrzkEgH10VSMc2UiY6dP.UA
 w7h0bcG3Gw6.PZp_fRbQSW0LHZJM9rNZ76WXsSPAFTki.MsKn.5jPM8TIo5m
 KOT7t9P5HVlG349cpasW3b5av9kKqYw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FEDF7B6.3020107@schaufler-ca.com>
Date: Fri, 29 Jun 2012 11:45:10 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: AF_BUS socket address family
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/2012 9:45 AM, Vincent Sanders wrote:
> This series adds the bus address family (AF_BUS) it is against
> net-next as of yesterday.
>  
> AF_BUS is a message oriented inter process communication system. 
>
> The principle features are:
>
>  - Reliable datagram based communication (all sockets are of type
>    SOCK_SEQPACKET)
>
>  - Multicast message delivery (one to many, unicast as a subset)
>
>  - Strict ordering (messages are delivered to every client in the same order)
>
>  - Ability to pass file descriptors
>
>  - Ability to pass credentials
>
> The basic concept is to provide a virtual bus on which multiple
> processes can communicate and policy is imposed by a "bus master".
>
> Introduction
> ------------
>
> AF_BUS is based upon AF_UNIX but extended for multicast operation and
> removes stream operation, responding to extensive feedback on previous
> approaches we have made the implementation as isolated as
> possible. There are opportunities in the future to integrate the
> socket garbage collector with that of the unix socket implementation.
>
> The impetus for creating this IPC mechanism is to replace the
> underlying transport for D-Bus. The D-Bus system currently emulates this
> IPC mechanism using AF_UNIX sockets in userspace and has numerous
> undesirable behaviours. D-Bus is now widely deployed in many areas and
> has become a de-facto IPC standard. Using this IPC mechanism as a
> transport gives a significant (100% or more) improvement to throughput
> with comparable improvement to latency.
>
> This work was undertaken by Collabora for the GENIVI Alliance and we
> are committed to responding to feedback promptly and intend to continue
> to support this feature into the future.
>
> Operation
> ---------
>
> A bus is created by processes connecting on an AF_BUS socket. The
> "bus master" binds itself instead of connecting to the NULL address.
>
> The socket address is made up of a path component and a numeric
> component. The path component is either a pathname or an abstract
> socket similar to a unix socket. The numeric component is used to
> uniquely identify each connection to the bus. Thus the path identifies
> a specific bus and the numeric component the attachment to that bus.
>
> The numeric component of the address is divided into two fixed parts a
> prefix to identify multicast groups and a suffix which identifies the
> attachment. The kernel allocates a single address in prefix 0 to each
> socket upon connection.
>
> Connections are initially limited to communicating with address the
> bus master (address 0) . The bus master is responsible for making all
> policy decisions around manipulating other attachments including
> building multicast groups. 
>
> It is expected that connecting clients use protocol specific messages
> to communicate with the bus master to negotiate differing
> configurations although a bus master might implement a fixed
> behaviour.
>
> AF_BUS itself is protocol agnostic and implements the configured
> policy between attachments which allows for a bus master to leave a
> bus and communication between clients to continue.
>
> Some test code has been written [1] which demonstrates the usage of
> AF_BUS.
>
> Use with BUS_PROTO_DBUS
> -----------------------
>
> The initial aim of AF_BUS is to provide a IPC mechanism suitable for
> use to provide the underlying transport for D-Bus. 
>
> A socket created using BUS_PROTO_DBUS indicates that the messages
> passed will be in the D-Bus format. The userspace libraries have been
> updated to use this transport with an updated D-Bus daemon [2] as a bus
> master.

Why don't you go whole hog and put all of D-Bus into the kernel?

>
> The D-Bus protocol allows for multicast groups to be filtered depending
> on message contents. These filters are configured by the bus master
> but need to be enforced on message delivery. 
>
> We have simply used the standard kernel netfilter mechanism to achieve
> this. This is used to filter delivery to clients that may be part of a
> multicast group where they are not receiving all messages according to
> policy. If a client wishes to further filter its input provision has
> been made to allow them to use BPF.
>
> The kernel based IPC has several benefits for D-Bus over the userspace
> emulation:
>
>  - Context switching between userspace processes is reduced.
>  - Message data copying is reduced.
>  - System call overheads are reduced.
>  - The userspace D-Bus daemon was subject to resource starvation,
>    client contention and priority inversion.
>  - Latency is reduced
>  - Throughput is increased.
>
> The tools for testing these assertions are available [3] and
> consistently show a doubling in throughput and better than halving of
> latency.

Please cross-post Patches 04/15 and 05/15 to the linux-security-module list.
Please cross-post Patch 05/15 to the selinux list.

Where is the analogous patch for the Smack LSM?



>
> [1] http://cgit.collabora.com/git/user/javier/check-unix-multicast.git/log/?h=af-bus
> [2] http://cgit.collabora.com/git/user/rodrigo/dbus.git/
>
> [3] git://github.com/kanchev/dbus-ping.git
>     https://github.com/kanchev/dbus-ping/blob/master/dbus-genivi-benchmarking.sh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


