Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab2EYWPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:15:37 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:26653
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756213Ab2EYWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:15:35 -0400
X-Forefront-Antispam-Report: CIP:157.56.240.117;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0610HT005.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzzz2fh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FC0047E.9070907@ixiacom.com>
Date: Fri, 25 May 2012 15:15:26 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>
Subject: Inadvertently sending a Christmas Tree TCP packet
In-Reply-To: <4FBFCFCA.2090501@ixiacom.com>
References: <4FBFCFCA.2090501@ixiacom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: BL2PRD0610HT005.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BL2PRD0610HT005.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had previously observed the following behaviour captured from WireShark:

16220	111.075627	10.64.33.43	10.128.163.100	TCP	59253 > exec [SYN] Seq=0 Win=65535 Len=0 MSS=1460 WS=2
16222	0.203210	10.128.163.100	10.64.33.43	TCP	exec > 59253 [SYN, ACK] Seq=0 Ack=1 Win=5840 Len=0 MSS=1250 WS=7
16223	0.000032	10.64.33.43	10.128.163.100	TCP	59253 > exec [ACK] Seq=1 Ack=1 Win=65532 Len=0
... snip ...
16237	0.000319	10.128.163.100	10.64.33.43	TCP	exec > 59253 [FIN, PSH, ACK, URG] Seq=31 Ack=30 Win=5888 Urg=1 Len=1
16240	1.114085	10.128.163.100	10.64.33.43	TCP	[TCP Retransmission] exec > 59253 [FIN, PSH, ACK, URG] Seq=31 Ack=30 Win=5888 Urg=1 Len=1


These packets were sent from an application running on Linux 2.6.18. 

The receiver has become confused, and the so the Linux sender retransmits at packet 16240,
and continues retransmitting. In this case, the application code at the receiver is blocked
indefinitely trying to read a socket that seemingly has (URG) data and yet at the same time
doesn't have any more data (FIN).

Looking at the 2.6.18 source code for tcp_output.c, I see code at tcp_send_fin()
that is attaching FIN to the packet.

The code in 3.4 seems fairly much the same:


/* Send a fin.  The caller locks the socket for us.  This cannot be
 * allowed to fail queueing a FIN frame under any circumstances.
 */
void tcp_send_fin(struct sock *sk)
{
	struct tcp_sock *tp = tcp_sk(sk);
	struct sk_buff *skb = tcp_write_queue_tail(sk);
	int mss_now;

	/* Optimization, tack on the FIN if we have a queue of
	 * unsent frames.  But be careful about outgoing SACKS
	 * and IP options.
	 */
	mss_now = tcp_current_mss(sk);

	if (tcp_send_head(sk) != NULL) {
		TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_FIN;
		TCP_SKB_CB(skb)->end_seq++;
		tp->write_seq++;
	} else {



The comment block says to be careful about IP options, but
the code doesn't appear to worry too much.

Is something like:

	if (tcp_send_head(sk) != NULL &&
		TCP_SKB_CB(skb)->tcp_flags == 0)

more appropriate ?


Earl

