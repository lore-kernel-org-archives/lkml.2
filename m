Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1LUUFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:05:12 -0500
Received: from yuna.grokhost.net ([87.117.228.63]:56497 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1LUUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:05:10 -0500
Message-ID: <4EF23BF2.4000601@bootc.net>
Date: Wed, 21 Dec 2011 20:05:06 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in ipv6_select_ident
References: <4EF200BB.7000209@bootc.net>  <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4EF2117F.6000803@bootc.net>  <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/2011 18:00, Eric Dumazet wrote:
> Le mercredi 21 décembre 2011 à 18:36 +0100, Eric Dumazet a écrit :
>
>> Good point, thats a different problem then, since 3.1 is not supposed to
>> have this bug.
>>
>> It seems rt->rt6i_peer points to invalid memory in your crash.
>>
>> (RBX=00000000000001f4)
>>
>> 8b 83 a4 00 00 00       mov    0xa4(%rbx),%eax    p->refcnt
>> 1f4+a4 ->  CR2=0000000000000298
>>
> It would help if you can confirm latest linux tree can reproduce the
> bug.

Hi Eric,

I just built a v3.2-rc6-140-gb9e26df with the same config as the Debian 
3.1.0 kernel. I can reproduce the bug just as easily with this kernel as 
with the Debian kernel. Unfortunately I wasn't able to get an entire 
trace, for some reason it didn't appear to be printed to the serial port 
and hung after the (long) list of loaded kernel modules. The crash 
happens at the same offset:

[  356.683420] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000298
[  356.691438] IP: [<ffffffff812ea0da>] ipv6_select_ident+0x31/0xa7
[  356.697633] PGD 425060067 PUD 41de8d067 PMD 0
[  356.702123] Oops: 0000 [#1] SMP
[  356.705451] CPU 4
[  356.707366] Modules linked in: tun sha1_ssse3 sha1_generic hmac 
sha256_generic dlm configfs ebtable_nat ebtables acpi_cpufreq mperf 
cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_userspace 
microcode xt_NOTRACK ip_set_hash_net act_police cls_basic cls_flow 
cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq 
xt_realm xt_addrtype xt_connlimit iptable_raw ip_set_hash_ip xt_comment 
ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN 
ipt_ecn ipt_CLUSTERIP ipt_ah nf_nat_tftp nf_nat_snmp_basic 
nf_conntrack_snmp xt_recent nf_nat_sip nf_nat_pptp nf_nat_proto_gre 
nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ip6_queue xt_set ip_set 
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_sane 
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 
nf_conntrack_ftp ts_kmp xt_NFLOG nfnetlink_log nf_conntrack_amanda 
xt_TPROXY nf_tproxy_core xt_time xt_TCPMSS xt_tcpmss xt_sctp xt_policy 
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_multiport xt_mark xt_mac 
xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp 
xt_dccp xt_connmark ip6t_LOG xt_CLASSIFY ip6t_REJECT xt_AUDIT 
nf_conntrack_ipv6

I loaded the kernel in gdb to see where it thought that was:

(gdb) list *ipv6_select_ident+0x31/0xa7
0xffffffff812ea0a9 is in ipv6_select_ident (net/ipv6/ip6_output.c:602).
597
598             return offset;
599     }
600
601     void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
602     {
603             static atomic_t ipv6_fragmentation_id;
604             int old, new;
605
606             if (rt) {

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net

