Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1F3Id2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:33:28 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:41606 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1F3IdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:33:25 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: possible bridge regression in "bridge: implement [add/del]_slave ops"?
Date: Thu, 30 Jun 2011 10:33:23 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
X-Length: 3303
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301033.23997.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried using the rstpd daemon from 
http://git.kernel.org/?p=linux/kernel/git/shemminger/rstp.git;a=summary which 
worked fine on my desktop.
I then tried doing the same on my embedded atom baord and failed.
It turned out the used kernel 2.6.38-gentoo-r6 had not the problem the kernel 
v2.6.39 used on atomboard had. After trying a 2.6.39 based kernel on my 
desktop the same problem occured.
After bisecting I ended up at commit 
afc6151a78a43bdca5f64a8bd3e3c13837580c54
"bridge: implement [add/del]_slave ops"

My /sbin/bridge-stp is the one from commit 
b27ab0efa4ecf7a839f750ec1e9b9092c577ebbb in the rstpd repository.

My steps to reproduce:
* start rstpd (I used rstpd -d -v2 from a different terminal to see the error 
messages)
* echo $(pgrep rstpd) > /var/run/rstpd.pid
* brctl addbr br1
* echo 1 > /sys/class/net/br1/bridge/stp_state
* brctl addif br1 eth1
* brctl addif br1 eth2
* ifconfig br1 up 192.168.0.20
* ifconfig eth1 up
* ifconfig eth2 up

Then I get the following output from rstpd:
7: br1 
2011-06-30 09:08:01 create_if: Add bridge br1
2011-06-30 09:08:01 CTL_enable_bridge_rstp: bridge 7, enable 1
3: eth1 master br1 
2011-06-30 09:08:01 stp_enabled: STP on br1 state 2
2011-06-30 09:08:01 set_br_up: br1 was up stp was down
2011-06-30 09:08:01 set_br_up: Set bridge br1 up stp up
2011-06-30 09:08:01 create_if: Add iface eth1 to bridge br1
2: eth2 master br1 
2011-06-30 09:08:01 create_if: Add iface eth2 to bridge br1
7: br1 
2011-06-30 09:08:01 Error in bridge_bpdu_rcv at bridge_track.c:585 verifying 
ifc->up. 
2: eth2 master br1 
2011-06-30 09:08:03 Error in bridge_bpdu_rcv at bridge_track.c:585 verifying 
ifc->up. 
2011-06-30 09:08:03 Error in bridge_bpdu_rcv at bridge_track.c:585 verifying 
ifc->up. 
2011-06-30 09:08:05 Error in bridge_bpdu_rcv at bridge_track.c:585 verifying 
ifc->up. 
2011-06-30 09:08:05 Error in bridge_bpdu_rcv at bridge_track.c:585 verifying 
ifc->up.

The last error messages are printed for each BPDU received at the bridge.

Reverting the named commit on v2.6.39.2 restores the old behavior and I get a 
working RSTP again.

BTW: I noticed that in 2.6.39.2 independently from this patch revert this 
bridge didn't show up RUNNING ifconfg. Is this intended? Another bridge I 
have, which doesn't use (R)STP, is shown as RUNNING like before.

Regards,
Alexander
