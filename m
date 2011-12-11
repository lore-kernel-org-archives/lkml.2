Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab1LKFQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 00:16:47 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:56264 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab1LKFQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 00:16:44 -0500
Date: Sat, 10 Dec 2011 23:16:24 -0600
From: David Fries <david@fries.net>
To: padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arek Lichwa <arkadiusz.lichwa@tieto.com>, iliak@ti.com,
        ulrik.lauren@stericsson.com, peter@hurleysoftware.com
Subject: [REGRESSION] 3.2.0-rc3 Bluetooth L2CAP Linux to Linux rfcomm fails
Message-ID: <20111211051624.GA12050@spacedout.fries.net>
References: <1319621002-7122-1-git-send-email-arkadiusz.lichwa@tieto.com>
 <20111031190129.GA10164@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031190129.GA10164@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sat, 10 Dec 2011 23:16:27 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 05:01:29PM -0200, Gustavo Padovan wrote:
> Hi Arek,
> 
> * Arek Lichwa <arkadiusz.lichwa@tieto.com> [2011-10-26 11:23:21 +0200]:
> 
> > Hi
> > 
> > We found during testing problem when setting rfcomm (SPP) channel between
> > two 2.1 devices. 
> > The test case always failed mostly saying security block on l2cap level 
> > but sometimes the fail root cause was 'Command not understood' on l2cap 
> > as well.
> > Analyzing security block issue, I found that there's unencrypted link when
> > l2cap command 'connection request' is sent to remote.
> > The second issue with 'command not understood' has turn out to be related to 
> > expiration of l2cap timer and its implications.
> > 
> > Solution that I found to fix the problem seems to be related to old commit 
> > 330605423ca6eafafb8dcc27502bce1c585d1b06 made by Ilia Kolomisnky. When there's
> > authentication ongoing, 'encryption pending' should be turn on, otherwise 
> > there're situations when link stays unencrypted. 
> > The issue with timer expiration is related to Andrzej Kaczmarek's patch 
> > sent to community a couple days ago (~ 2011/10/20). 
> > This patch actually recalculates (repairs) timer values on l2cap which were 
> > wrongly converted before. 
> > With this patch the expiration issue disappears during the test case 
> > I've made, otherwise just reverting 330605423ca6eafafb8dcc27502bce1c585d1b06
> > is not enough, since timer issue blocks very often passing the test case.
> 
> Are you saying that Andrzej's patch together with revert of 330605423 fixes
> the problem? and are you sure that we are not creating any new regression?
> 
> 	Gustavo

I just found that I can't connect rfcomm any more from Linux (desktop)
to Linux (N900) with bluetooth.  On the desktop side, 3.2.0-rc2 works,
but 3.2.0-rc3 (and on) fails, I even merged in
git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next
master 5a13b09531420d230616bd524b68a5b0c23cd487 without any change.
Fortunately there were only three bluetooth patches between rc2 and rc3.
Reverting 4dff523a913197e3314c7b0d08734ab037709093 fixed the issue and
I can connect again.

Linux (desktop)
hci0:   Type: BR/EDR  Bus: USB
        BD Address: XX:XX:XX:XX:XX:XX  ACL MTU: 310:10  SCO MTU: 64:8
        UP RUNNING PSCAN ISCAN 
        RX bytes:1846 acl:16 sco:0 events:70 errors:0
        TX bytes:1223 acl:15 sco:0 commands:44 errors:0

Linux (N900)
hci0:   Type: UART
        BD Address: XX:XX:XX:XX:XX:XX ACL MTU: 1017:4 SCO MTU: 64:1
        UP RUNNING PSCAN 
        RX bytes:24972 acl:536 sco:0 events:784 errors:0
        TX bytes:32590 acl:520 sco:0 commands:217 errors:0

I'm trying to connect to N900 running Linux 2.6.28.10-power49+.  While
I can apply patches to the N900 kernel, and the community edition
power kernel is making bug releases, I have no expectation that the
stock Nokia kernel will have another release.  So I don't think this
can be fixed on the N900 side.

Here's a diff of a dump using both a working and not working kernel.
`rfcomm connect /dev/rfcomm0 XX:XX:XX:XX:XX:XX 1`
from the desktop side to the N900.  The connection is established with
3.2.0-rc2+ but not with 3.2.0-rc5+.

-Linux Pulsar 3.2.0-rc2+ #12 SMP Mon Nov 21 18:30:39 CST 2011 x86_64 GNU/Linux
+Linux Pulsar 3.2.0-rc5+ #16 SMP Sat Dec 10 20:09:18 CST 2011 x86_64 GNU/Linux

 hcidump -X

 HCI sniffer - Bluetooth packet analyzer ver 2.1
 device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
 < HCI Command: Create Connection (0x01|0x0005) plen 13
     bdaddr XX:XX:XX:XX:XX:XX ptype 0xcc18 rswitch 0x01 clkoffset 0x0000
     Packet type: DM1 DM3 DM5 DH1 DH3 DH5 
 > HCI Event: Command Status (0x0f) plen 4
     Create Connection (0x01|0x0005) status 0x00 ncmd 1
 > HCI Event: Role Change (0x12) plen 8
     status 0x00 bdaddr XX:XX:XX:XX:XX:XX role 0x01
     Role: Slave
 > HCI Event: Connect Complete (0x03) plen 11
     status 0x00 handle 38 bdaddr XX:XX:XX:XX:XX:XX type ACL encrypt 0x00
 < HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
     handle 38
 > HCI Event: Page Scan Repetition Mode Change (0x20) plen 7
     bdaddr XX:XX:XX:XX:XX:XX mode 0
 > HCI Event: Max Slots Change (0x1b) plen 3
     handle 38 slots 5
 > HCI Event: Command Status (0x0f) plen 4
     Read Remote Supported Features (0x01|0x001b) status 0x00 ncmd 1
 > HCI Event: Read Remote Supported Features (0x0b) plen 11
     status 0x00 handle 38
     Features: 0xbf 0xee 0x0f 0xc6 0x98 0x3d 0x59 0x82
 < HCI Command: Read Remote Extended Features (0x01|0x001c) plen 3
     handle 38 page 1
 > HCI Event: Command Status (0x0f) plen 4
     Read Remote Extended Features (0x01|0x001c) status 0x00 ncmd 1
 > HCI Event: Read Remote Extended Features (0x23) plen 13
     status 0x00 handle 38 page 1 max 1
     Features: 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00
 < HCI Command: Remote Name Request (0x01|0x0019) plen 10
     bdaddr XX:XX:XX:XX:XX:XX mode 2 clkoffset 0x0000
 > HCI Event: Command Status (0x0f) plen 4
     Remote Name Request (0x01|0x0019) status 0x00 ncmd 1
 > HCI Event: Remote Name Req Complete (0x07) plen 255
     status 0x00 bdaddr XX:XX:XX:XX:XX:XX name 'XXXXXXXXXXXXXX_900'
 < HCI Command: Authentication Requested (0x01|0x0011) plen 2
     handle 38
 > HCI Event: Command Status (0x0f) plen 4
     Authentication Requested (0x01|0x0011) status 0x00 ncmd 1
 > HCI Event: Link Key Request (0x17) plen 6
     bdaddr XX:XX:XX:XX:XX:XX
 < HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
     bdaddr XX:XX:XX:XX:XX:XX key XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 > HCI Event: Command Complete (0x0e) plen 10
     Link Key Request Reply (0x01|0x000b) ncmd 1
     status 0x00 bdaddr XX:XX:XX:XX:XX:XX
 > HCI Event: Auth Complete (0x06) plen 3
     status 0x00 handle 38
 < HCI Command: Set Connection Encryption (0x01|0x0013) plen 3
     handle 38 encrypt 0x01
 > HCI Event: Command Status (0x0f) plen 4
     Set Connection Encryption (0x01|0x0013) status 0x00 ncmd 1
 > HCI Event: Encrypt Change (0x08) plen 4
     status 0x00 handle 38 encrypt 0x01
 < ACL data: handle 38 flags 0x00 dlen 10
     L2CAP(s): Info req: type 2
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 16
     L2CAP(s): Info rsp: type 2 result 0
       Extended feature mask 0x0000
 < ACL data: handle 38 flags 0x00 dlen 12
     L2CAP(s): Connect req: psm 3 scid 0x0040
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 16
     L2CAP(s): Connect rsp: dcid 0x0040 scid 0x0040 result 1 status 0
       Connection pending - No futher information available
 > ACL data: handle 38 flags 0x02 dlen 10
     L2CAP(s): Info req: type 2
 < ACL data: handle 38 flags 0x00 dlen 16
     L2CAP(s): Info rsp: type 2 result 0
       Extended feature mask 0x00b8
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 10
     L2CAP(s): Info req: type 3
 < ACL data: handle 38 flags 0x00 dlen 20
     L2CAP(s): Info rsp: type 3 result 0
       Fixed channel list
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 16
     L2CAP(s): Connect rsp: dcid 0x0040 scid 0x0040 result 0 status 0
       Connection successful
 < ACL data: handle 38 flags 0x00 dlen 16
     L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
       MTU 1013 
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 18
     L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 4
       MTU 1013 
 > ACL data: handle 38 flags 0x02 dlen 16
     L2CAP(s): Config req: dcid 0x0040 flags 0x00 clen 4
       MTU 1013 
 < ACL data: handle 38 flags 0x00 dlen 18
     L2CAP(s): Config rsp: scid 0x0040 flags 0x00 result 0 clen 4
       MTU 1013 
 < ACL data: handle 38 flags 0x00 dlen 8
     L2CAP(d): cid 0x0040 len 4 [psm 3]
       RFCOMM(s): SABM: cr 1 dlci 0 pf 1 ilen 0 fcs 0x1c 
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 8
     L2CAP(d): cid 0x0040 len 4 [psm 3]
       RFCOMM(s): UA: cr 1 dlci 0 pf 1 ilen 0 fcs 0xd7 
-< ACL data: handle 38 flags 0x00 dlen 18
-    L2CAP(d): cid 0x0040 len 14 [psm 3]
-      RFCOMM(s): PN CMD: cr 1 dlci 0 pf 0 ilen 10 fcs 0x70 mcc_len 8
-      dlci 2 frame_type 0 credit_flow 15 pri 7 ack_timer 0
-      frame_size 1008 max_retrans 0 credits 7
-> HCI Event: Number of Completed Packets (0x13) plen 5
-    handle 38 packets 1
-> ACL data: handle 38 flags 0x02 dlen 18
-    L2CAP(d): cid 0x0040 len 14 [psm 3]
-      RFCOMM(s): PN RSP: cr 0 dlci 0 pf 0 ilen 10 fcs 0xaa mcc_len 8
-      dlci 2 frame_type 0 credit_flow 14 pri 7 ack_timer 0
-      frame_size 1008 max_retrans 0 credits 7
-< ACL data: handle 38 flags 0x00 dlen 8
-    L2CAP(d): cid 0x0040 len 4 [psm 3]
-      RFCOMM(s): SABM: cr 1 dlci 2 pf 1 ilen 0 fcs 0x59 
-> HCI Event: Number of Completed Packets (0x13) plen 5
-    handle 38 packets 1
-> ACL data: handle 38 flags 0x02 dlen 8
-    L2CAP(d): cid 0x0040 len 4 [psm 3]
-      RFCOMM(s): UA: cr 1 dlci 2 pf 1 ilen 0 fcs 0x92 
-< ACL data: handle 38 flags 0x00 dlen 12
-    L2CAP(d): cid 0x0040 len 8 [psm 3]
-      RFCOMM(s): MSC CMD: cr 1 dlci 0 pf 0 ilen 4 fcs 0x70 mcc_len 2
-      dlci 2 fc 0 rtc 1 rtr 1 ic 0 dv 1 b1 1 b2 1 b3 0 len 0
-> ACL data: handle 38 flags 0x02 dlen 12
-    L2CAP(d): cid 0x0040 len 8 [psm 3]
-      RFCOMM(s): MSC CMD: cr 0 dlci 0 pf 0 ilen 4 fcs 0xaa mcc_len 2
-      dlci 2 fc 0 rtc 1 rtr 1 ic 0 dv 1 b1 1 b2 1 b3 0 len 0
-< ACL data: handle 38 flags 0x00 dlen 12
-    L2CAP(d): cid 0x0040 len 8 [psm 3]
-      RFCOMM(s): MSC RSP: cr 1 dlci 0 pf 0 ilen 4 fcs 0x70 mcc_len 2
-      dlci 2 fc 0 rtc 1 rtr 1 ic 0 dv 1 b1 1 b2 1 b3 0 len 0
-> HCI Event: Number of Completed Packets (0x13) plen 5
-    handle 38 packets 1
-> ACL data: handle 38 flags 0x02 dlen 12
-    L2CAP(d): cid 0x0040 len 8 [psm 3]
-      RFCOMM(s): MSC RSP: cr 0 dlci 0 pf 0 ilen 4 fcs 0xaa mcc_len 2
-      dlci 2 fc 0 rtc 1 rtr 1 ic 0 dv 1 b1 1 b2 1 b3 0 len 0
-< ACL data: handle 38 flags 0x00 dlen 9
-    L2CAP(d): cid 0x0040 len 5 [psm 3]
-      RFCOMM(d): UIH: cr 1 dlci 2 pf 1 ilen 0 fcs 0x86 credits 33
-> HCI Event: Number of Completed Packets (0x13) plen 5
-    handle 38 packets 1
-> HCI Event: Number of Completed Packets (0x13) plen 5
-    handle 38 packets 1
-> ACL data: handle 38 flags 0x02 dlen 9
-    L2CAP(d): cid 0x0040 len 5 [psm 3]
-      RFCOMM(d): UIH: cr 0 dlci 2 pf 1 ilen 0 fcs 0x5c credits 33
-
 
 < ACL data: handle 38 flags 0x00 dlen 8
     L2CAP(d): cid 0x0040 len 4 [psm 3]
       RFCOMM(s): DISC: cr 1 dlci 2 pf 1 ilen 0 fcs 0xb8 
 > HCI Event: Number of Completed Packets (0x13) plen 5
     handle 38 packets 1
 > ACL data: handle 38 flags 0x02 dlen 8
     L2CAP(d): cid 0x0040 len 4 [psm 3]
-      RFCOMM(s): UA: cr 1 dlci 2 pf 1 ilen 0 fcs 0x92 
+      RFCOMM(s): DM: cr 1 dlci 2 pf 1 ilen 0 fcs 0x73 

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
