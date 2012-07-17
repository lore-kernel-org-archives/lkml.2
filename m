Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2GQNla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:41:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54396 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2GQNl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <1342531849.2626.605.camel@edumazet-glaptop>
References: <CAMUfR_tzbEt0BTGwacHKQJQ13iGY8qLimNTFXM_dr5O-RwEgSA@mail.gmail.com>
	<1342531849.2626.605.camel@edumazet-glaptop>
Date: Tue, 17 Jul 2012 09:41:27 -0400
Message-ID: <CAMUfR_vpEJ=Spd+A5tunDxOttdVk_0RXWHX91HGUf9hGdEa10w@mail.gmail.com>
Subject: Re: PROBLEM: Can ping address, but traceroute gets ENETDOWN
From: Terry Phelps <tgphelps50@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 9:30 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2012-07-17 at 09:04 -0400, Terry Phelps wrote:
>> I'm seeing, to me, totally illogical behavior with my IPv4 networking.
>> Can someone please help me isolate the problem better?
>>
>> I have at least EIGHT servers with the same symptom. All are running
>> Oracle "Unbreakable Enterprise Kernel 2". Oracle numbers this kernel
>> 2.6.39.*, but it is "based on the 3.0.16 kernel". I don't know exactly
>> what patches might have been applied. The symptom I see is:
>>
>> I'm SSH'ed into the server from my desk another network. All is well.
>> Then either (1) SSH freezes, or (2) I exit SSH, and can't SHH to it
>> again.
>> Then I ping the server from my desk. It FAILS.
>> I ping the server from a second machine on my desk (same network). It works.
>> If I keep pinging from my desktop, where the SSH just failed, it will
>> NEVER get a response. I've let it ping for DAYS.
>> But if I stop pinging for 5 minutes or so, it'll work just fine again.
>> While things are "hosed", I am able to ping and ssh from my second
>> desktop to the server just fine.
>> If I SSH to the server, it CAN ping my desktop, but it CANNOT traceroute to it.
>> If I leave the ping going (and failing), and go to the server and "ip
>> route flush cache", the pings start working immediately.
>> I can get the problem from other desktops on other networks, but I
>> have never seen it from another server on the same network.
>>
>> It gets stranger. Here are some commands run on the server, while the
>> pings from my desktop are failing. The failing pings are coming from
>> 192.168.118.22. The machine right next that one is .23, and it works
>> fine.
>>
>> I have ONE NIC in the box, and I have no reason to think it isn't
>> configured properly.
>>
>> # ifconfig -a
>> eth0      Link encap:Ethernet  HWaddr 00:50:56:9A:00:17
>>           inet addr:172.16.2.95  Bcast:172.16.255.255  Mask:255.255.0.0
>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>           RX packets:246266059 errors:0 dropped:85001 overruns:0 frame:0
>>           TX packets:290982046 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000
>>           RX bytes:70745127855 (65.8 GiB)  TX bytes:27490797799 (25.6 GiB)
>>
>> lo        Link encap:Local Loopback
>>           inet addr:127.0.0.1  Mask:255.0.0.0
>>           UP LOOPBACK RUNNING  MTU:16436  Metric:1
>>           RX packets:258548668 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:258548668 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:0
>>           RX bytes:226377171068 (210.8 GiB)  TX bytes:226377171068 (210.8 GiB)
>>
>>
>> The server can ping my desktop just fine:
>>
>> # ping 192.168.118.22
>> PING 192.168.118.22 (192.168.118.22) 56(84) bytes of data.
>> 64 bytes from 192.168.118.22: icmp_seq=1 ttl=127 time=0.827 ms
>> 64 bytes from 192.168.118.22: icmp_seq=2 ttl=127 time=0.739 ms
>> 64 bytes from 192.168.118.22: icmp_seq=3 ttl=127 time=0.725 ms
>>
>>
>>
>> But a traceroute to the same destination says "network is down":
>>
>> # traceroute 192.168.118.22
>> traceroute to 192.168.118.22 (192.168.118.22), 30 hops max, 40 byte packets
>> send: Network is down
>>
>>
>>
>> A syscall trace of traceroute shows the sendto() call getting a
>> ENETDOWN response:
>>
>>
>> socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
>> setsockopt(3, SOL_IP, IP_MTU_DISCOVER, [0], 4) = 0
>> setsockopt(3, SOL_SOCKET, SO_TIMESTAMP, [1], 4) = 0
>> fcntl(3, F_SETFL, O_RDONLY|O_NONBLOCK)  = 0
>> setsockopt(3, SOL_IP, IP_TTL, [1], 4)   = 0
>> setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
>> connect(3, {sa_family=AF_INET, sin_port=htons(33434),
>> sin_addr=inet_addr("192.168.118.22")}, 28) = 0
>> sendto(3, "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"..., 40, 0, NULL, 0) = -1
>> ENETDOWN (Network is down)
>>
>>
>>
>> Yet traceroute (and ping) to a machine on the same network is fine:
>>
>> # traceroute 192.168.118.23
>> traceroute to 192.168.118.23 (192.168.118.23), 30 hops max, 40 byte packets
>>  1  172.16.16.253 (172.16.16.253)  1.304 ms  1.614 ms  1.886 ms
>>  2  192.168.118.23 (192.168.118.23)  0.521 ms  0.566 ms  0.562 ms
>>
>>
>>
>> I have a default route, and no other routes defined:
>>
>> # netstat -nr
>> Kernel IP routing table
>> Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
>> 0.0.0.0         172.16.0.5      0.0.0.0         UG        0 0          0 eth0
>> 169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth0
>> 172.16.0.0      0.0.0.0         255.255.0.0     U         0 0          0 eth0
>>
>>
>>
>> Here are my route cache entries for the network I'm trying to talk to:
>>
>> # netstat -nrC|grep 192.168.118
>> 172.16.2.95     192.168.118.22  172.16.70.101          1500 0        239 eth0
>> 192.168.118.23  172.16.2.95     172.16.2.95     l     16436 0          0 lo
>> 172.16.2.95     192.168.118.23  172.16.70.101          1500 0          0 eth0
>> 192.168.118.22  172.16.2.95     172.16.2.95     l     16436 0          0 lo
>> 172.16.2.95     192.168.118.22  172.16.70.101          1500 0        239 eth0
>> 172.16.2.95     192.168.118.23  172.16.70.101          1500 0          0 eth0
>> 172.16.2.95     192.168.118.22  172.16.70.101          1500 0        239 eth0
>> 172.16.2.95     192.168.118.23  172.16.70.101          1500 0          0 eth0
>> 172.16.2.95     192.168.118.23  172.16.70.101          1500 0          0 eth0
>>
>>
>>
>> And finally, tcpdump shows that the pings from my desktop ARE
>> arriving. They are simply
>> not being replied to:
>>
>> # tcpdump -np host 192.168.118.22
>> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
>> listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
>> 10:20:48.950240 IP 192.168.118.22 > 172.16.2.95: ICMP echo request, id
>> 2, seq 35155, length 40
>> 10:20:54.956584 IP 192.168.118.22 > 172.16.2.95: ICMP echo request, id
>> 2, seq 35158, length 40
>> 10:21:00.959048 IP 192.168.118.22 > 172.16.2.95: ICMP echo request, id
>> 2, seq 35161, length 40
>> 10:21:06.964326 IP 192.168.118.22 > 172.16.2.95: ICMP echo request, id
>> 2, seq 35164, length 40
>>
>>
>> If you could PLEASE advise me on where to go from here, I would
>> greatly appreciate it. I can't imagine what would cause these
>> symptoms.
>>
>> Here is the ver_linux output:
>>
>> Linux jidlam01.acbl.net 2.6.39-200.29.1.el5uek #1 SMP Fri Jul 6
>> 08:01:33 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Gnu C                  4.1.2
>> Gnu make               3.81
>> binutils               2.17.50.0.6
>> 8.3
>> util-linux             2.13-pre7
>> mount                  2.13-pre7
>> module-init-tools      3.3-pre2
>> e2fsprogs              1.39
>> pcmciautils            014
>> quota-tools            3.13.
>> PPP                    2.4.4
>> Linux C Library        2.5
>> Dynamic linker (ldd)   2.5
>> Procps                 3.2.7
>> Net-tools              1.60
>> Kbd                    1.12
>> Sh-utils               5.97
>> udev                   095
>> wireless-tools         28
>> Modules Loaded         autofs4 hidp rfcomm bluetooth rfkill lockd
>> sunrpc be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa
>> ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi
>> cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi video sbs sbshc
>> hed acpi_memhotplug acpi_ipmi ipmi_msghandler lp sg sr_mod cdrom
>> snd_seq_dummy serio_raw e1000 vmw_balloon snd_seq_oss
>> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
>> snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr parport_pc
>> i2c_piix4 i2c_core parport floppy pata_acpi ata_generic dm_snapshot
>> dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix shpchp mptspi
>> mptscsih mptbase scsi_transport_spi sd_mod crc_t10dif ext3 jbd mbcache
>>
>>
>> Terry Phelps
>> American Commercial Lines
>> Jeffersonville, IN
>
> Hi
>
> This looks like a firewall issue, check :
>
> iptables -nvL
>

Nope. No firewall running on ANY of the eight machines:

# iptables -nvL
Chain INPUT (policy ACCEPT 8402K packets, 1160M bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 7220K packets, 2950M bytes)
 pkts bytes target     prot opt in     out     source               destination

# chkconfig --list iptables
iptables        0:off   1:off   2:off   3:off   4:off   5:off   6:off
