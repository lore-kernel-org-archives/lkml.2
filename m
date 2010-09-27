Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab0I0NRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:17:51 -0400
Received: from daytona.panasas.com ([67.152.220.89]:47387 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753744Ab0I0NRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:17:50 -0400
Message-ID: <4CA09977.80506@panasas.com>
Date: Mon, 27 Sep 2010 15:17:43 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Stephen Hemminger <shemminger@vyatta.com>
Subject: {painfully BISECTED} Please revert f25c80a4b2:  arch/um/drivers:
 remove duplicate structure field initialization
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 13:17:46.0804 (UTC) FILETIME=[60636740:01CB5E46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[bharrosh@fs2 ~/dev/git/pub/scsi-misc] 1115$ git bisect good
f25c80a4b2bf93c99820f470573626557db35202 is the first bad commit
commit f25c80a4b2bf93c99820f470573626557db35202
Author: Julia Lawall <julia@diku.dk>
Date:   Tue Jul 20 12:25:17 2010 +0000

    arch/um/drivers: remove duplicate structure field initialization
    
    There are two initializations of ndo_set_mac_address, one to a local
    function that is not used otherwise and one to a function that is defined
    elsewhere.
    
    The semantic match that finds this problem is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r@
    identifier I, s, fld;
    position p0,p;
    expression E;
    @@
    
    struct I s =@p0 { ... .fld@p = E, ...};
    
    @s@
    identifier I, s, r.fld;
    position r.p0,p;
    expression E;
    @@
    
    struct I s =@p0 { ... .fld@p = E, ...};
    
    @script:python@
    p0 << r.p0;
    fld << r.fld;
    ps << s.p;
    pr << r.p;
    @@
    
    if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
      cocci.print_main(fld,p0)
    // </smpl>
    
    akpm:
    
    - Use the standard eth_mac_addr() in uml_net_set_mac()
    
    - Remove unneeded and racy local set_ether_mac()
    
    - Remove duplicated (and incorrect)
      uml_netdev_ops.ndo_set_mac_address initializer.
    
    Fixes 8bb95b39a16ed55226810596f92216c53329d2fe ("uml: convert network
    device to netdevice ops").
    
    [akpm@linux-foundation.org: rework as above]
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Cc: Stephen Hemminger <shemminger@vyatta.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 b3ff18738a5de659b97ff6ad7ba3c23eb2736263 241657298557b14317378fbb08ad664cf6f59ad3 M      arch

When this patch is applied my UML's networking works less then 50% of the times.
Then 30% of the times I see ethX where  1 < X < enf. Only 20% of boots will come up
with the regular eth0.

At 50% of the times when the nic fails to show up I get:
* Bringing up interface eth0:  RTNETLINK answers: Cannot assign requested address
  Failed to bring up eth0.

When I get the funny ethX I get:
* Bringing up interface eth0:  Device eth0 does not seem to be present,
  delaying initialization. [FAILED]

The patch Reverts cleanly on top of 2.6.36-rc5 and after Revert works perfectly as
before.

If indeed this is a cleanup. It can be included (fixed) again in next Kernel.
I can try any patches until this is fixed.

<RANT A HEAD CAN BE IGNORED>

It has become extremely hard to bisect a simple problem in latest Kernels!

Most mainline merges during a merge window are based on an rc1 of the previous
Kernel. In the last 5 Kernels there was a 90% chance of a BAD bug in systems
I use, at rc1. If a bug is found that needs bisecting. The other bugs creep
up during bisect and mask out the possibility to bisect.

For instance I found the bug I see was already present in 2.6.36-rc2
and that a good point was 2.6.35. Bisecting two bad(s) quickly took me
to some 2.6.35-rc1 Kernel that did not boot at all. So I was clever I
decided to merge in 2.6.35 at each bisect point. Then reset and continue.
But for some reason the bisect got mixed up and complained about an impossible
merge common bases. So out of desperation I did a very very^ stupid thing.
[]$ git rebase -i v2.6.35 v2.6.36-rc1
After endless merge conflicts, at about 3700/7100 I realised that I know
what is the patch that makes my UML refuse to boot. I have actually bisect
a problem with it's absence 2 Kernels ago. So I was again at my bisecting
manually cherry-picking the offending patch. Making sure to reset it before
every git bisect XXX step. But clearly I got lucky.

In short I wish at some 2.6.XX-rc[45] of every Kernel cycle. Maintainers
would rebase their next's tree of [XX+1] to a some what more stable rc.
Sure re-run all the tests. They still have time for the new tree in next
to be tested and verified before the next merge window.
(Hell one of my bisect points took me as back as 2.6.34)

Please remind me why maintainers should not rebase their trees once
committed, to the point that they don't rebase even for buggy patches
that are already in next, and apply fix patches, all within the same
merge window. The same is also done with merge conflicts with the
rc-cycle of their own code, instead of rebasing.

So in short this is a call for, possibly, cleaner History in main Kernel.
Please remind me why re-writing history is a bad thing.

</RANT A HEAD CAN BE IGNORED>

Thanks
Boaz
