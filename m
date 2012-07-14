Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2GNI1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 04:27:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44197 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab2GNI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 04:27:08 -0400
Subject: Re: resurrecting tcphealth
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Piotr Sawuk <a9702387@unet.univie.ac.at>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cc6495b92f1df180c1ad43057ceb0b98.squirrel@webmail.univie.ac.at>
References: <cc6495b92f1df180c1ad43057ceb0b98.squirrel@webmail.univie.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Jul 2012 10:27:03 +0200
Message-ID: <1342254423.3265.9028.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 09:56 +0200, Piotr Sawuk wrote:
> On Sa, 14.07.2012, 03:31, valdis.kletnieks@vt.edu wrote:
> > On Fri, 13 Jul 2012 16:55:44 -0700, Stephen Hemminger said:
> >
> >> >+			/* Course retransmit inefficiency- this packet has been received
> >> twice. */
> >> >+			tp->dup_pkts_recv++;
> >> I don't understand that comment, could you use a better sentence please?
> >
> > I think what was intended was:
> >
> > /* Curse you, retransmit inefficiency! This packet has been received at
> least twice */
> >
> 
> LOL, no. I think "course retransmit" is short for "course-grained timeout
> caused retransmit" but I can't be sure since I'm not the author of these
> lines. I'll replace that comment with the non-shorthand version though.
> however, I think the real comment here should be:
> 
> /*A perceived shortcoming of the standard TCP implementation: A
> TCP receiver can get duplicate packets from the sender because it cannot
> acknowledge packets that arrive out of order. These duplicates would happen
> when the sender mistakenly thinks some packets have been lost by the network
> because it does not receive acks for them but in reality they were
> successfully received out of order. Since the receiver has no way of letting
> the sender know about the receipt of these packets, they could potentially
> be re-sent and re-received at the receiver. Not only do duplicate packets
> waste precious Internet bandwidth but they hurt performance because the
> sender mistakenly detects congestion from packet losses. The SACK TCP
> extension specically addresses this issue. A large number of duplicate
> packets received would indicate a signicant benet to the wide adoption of
> SACK. The duplicatepacketsreceived metric is computed at the
> receiver and counts these packets on a per-connection basis.*/
> 
> as copied from his thesis at [1]. also in the thesis he writes:
> 
> In our limited experiment, the results indicated no duplicate packets were
> received on any connection in the 18 hour run. This leads us to several
> conclusions. Since duplicate ACKs were seen on many connections we know that
> some packets were lost or reordered, but unACKed reordered packets never
> caused a /coursegrainedtimeouts/ on our connections. Only these timeouts
> will cause duplicate packets to be received since less severe out-of-order
> conditions will be resolved with fast retransmits. The lack of course
> timeouts
> may be due to the quality of UCSD's ActiveWeb network or the paucity of
> large gaps between received packet groups. It should be noted that Linux 2.2
> implements fast retransmits for up to two packet gaps, thus reducing the
> need for course grained timeouts due to the lack of SACK.
> 
> [1] https://sacerdoti.org/tcphealth/tcphealth-paper.pdf

Not sure how pertinent is this paper today in 2012

I would prefer you add global counters, instead of per tcp counters that
most applications wont use at all.

Example of a more useful patch : add a counter of packets queued in Out
Of Order queue ( in tcp_data_queue_ofo() )

"netstat -s" will display the total count, without any changes in
userland tools/applications.



