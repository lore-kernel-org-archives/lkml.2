Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2FLRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:22:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54628 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2FLRWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:22:30 -0400
MIME-Version: 1.0
Date: Tue, 12 Jun 2012 13:22:29 -0400
Message-ID: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com>
Subject: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
From: Debabrata Banerjee <dbavatar@gmail.com>
To: netdev@vger.kernel.org, davem@davemloft.net, kaber@trash.net,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, pekkas@netcore.fi,
        kuznet@ms2.inr.ac.ru
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        Joshua Hunt <johunt@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like commit 2bec5a369ee79576a3eea2c23863325089785a2c "ipv6: fib:
fix crash when changing large fib while dumping" is the culprit. The
result of this code is that if there is a tree addition while a dump
has suspended because the netlink skb is full, it will simply go back
to the top of the tree and you end up with duplicate/triplicate/etc
routes. It looks like the code attempts to count nodes, but it's a
linear count and the data structure is a tree so that's a big problem.
The net result is potentially DOSable, since if route table updates
happen often enough in proportion to table size, a dump will attempt
to return an infinite amount of routes (observed). So this commit
should be reverted. However I am interested in the problem that commit
tried to solve, if anyone has more information on that. My assumption
is the fib tree gets corrupted and eventually it crashes in
fib6_dump_table(), which I assume can still happen.

I can easily demonstrate the bug by adding cloned/cache routes while I
check the results of fib6_dump_table:

root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
593
189
root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
884
16
root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
888
78
root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
507
507
root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
533
533
root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
571
571

Thanks,
Debabrata
