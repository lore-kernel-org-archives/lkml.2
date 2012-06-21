Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2FUTff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:35:35 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:39174 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab2FUTfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:35:34 -0400
Message-ID: <4FE37783.9000409@akamai.com>
Date: Thu, 21 Jun 2012 14:35:31 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>
CC: Debabrata Banerjee <dbavatar@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pekkas@netcore.fi" <pekkas@netcore.fi>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
References: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com>
In-Reply-To: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 12:22 PM, Debabrata Banerjee wrote:
> Looks like commit 2bec5a369ee79576a3eea2c23863325089785a2c "ipv6: fib:
> fix crash when changing large fib while dumping" is the culprit. The
> result of this code is that if there is a tree addition while a dump
> has suspended because the netlink skb is full, it will simply go back
> to the top of the tree and you end up with duplicate/triplicate/etc
> routes. It looks like the code attempts to count nodes, but it's a
> linear count and the data structure is a tree so that's a big problem.
> The net result is potentially DOSable, since if route table updates
> happen often enough in proportion to table size, a dump will attempt
> to return an infinite amount of routes (observed). So this commit
> should be reverted. However I am interested in the problem that commit
> tried to solve, if anyone has more information on that. My assumption
> is the fib tree gets corrupted and eventually it crashes in
> fib6_dump_table(), which I assume can still happen.
> 
> I can easily demonstrate the bug by adding cloned/cache routes while I
> check the results of fib6_dump_table:
> 
> root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
> show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
> 593
> 189
> root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
> show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
> 884
> 16
> root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
> show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
> 888
> 78
> root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
> show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
> 507
> 507
> root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
> show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
> 533
> 533
> root@a172-25-43-12.deploy.akamaitechnologies.com:~# ip -6 -o route
> show table cache |tee tmp | wc -l; sort tmp | uniq -u | wc -l
> 571
> 571
> 
> Thanks,
> Debabrata

Ping?

Can anyone provide details of the crash which was intended to be fixed
by 2bec5a369ee79576a3eea2c23863325089785a2c? With this patch in and
doing concurrent adds/deletes and dumping the table via netlink causes
duplicate entries to be reported. Reverting this patch causes those
problems to go away. We can provide a more detailed test if that is
needed, but so far our testing has been unable to reproduce the crash
mentioned in the above commit with it reverted.

Thanks
Josh
