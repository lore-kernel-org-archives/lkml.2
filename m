Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1CFHGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:06:47 -0500
Received: from lerlan.ru ([79.133.173.93]:37301 "EHLO servak.lerlan.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1CFHGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:06:43 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 02:06:42 EST
Subject: MPPE stateful mode problem and investigation
From: Alexey Osipov <simba@lerlan.ru>
To: linux-kernel@vger.kernel.org
Cc: pptpclient-devel@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
        Frank Cusack <fcusack@fcusack.com>, jdx@slackware.pl
Content-Type: multipart/mixed; boundary="=-VfsR5XcnRlE8LU8TF//G"
Date: Sun, 06 Mar 2011 13:00:32 +0600
Message-ID: <1299394832.2286.21.camel@dahari>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VfsR5XcnRlE8LU8TF//G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, All.

This message was originally sent to linux-ppp list only, but has no response 
in there for about a month. So I decided additionally post it in here. I'm not
a subscriber, so please CC me.

There is a message itself:

I have being recently configuring a small linux pppoe server on top of
pppd and pppoe-server and run into a problem with MPPE stateful mode.

If I state "require-mppe-128" in pppd options file, linux clients
connect to this server just perfectly. But Windows isn't. The log
analysis shown that the problem is in MPPE stateful mode. Windows PPPoE
client just can't use stateless mode (in contrast to linux PPPoE client
or Windows PPTP client). I have tested Windows XP, Windows 7 and Windows
2008 server. All of them can't use stateless MPPE mode when connecting
over PPPoE and all of them behave same way in scenarios described below.

If I add "mppe-stateful" in pppd options file, Windows clients connect
fine, IP configuration goes well and MPPE initialisation seems OK. The
linux kernel driver claims:

---------------
mppe_comp_init[6]: initialized with 128-bit stateful mode
mppe_decomp_init[6]: initialized with 128-bit stateful mode
---------------

But the connection doesn't work - no pings, no any other data can go
through it. The log looks like this:

---------------
pppd[4678]: rcvd [proto=0x41] f9 e0 ...
pppd[4678]: Unsupported protocol 'Cisco Systems' (0x41) received
pppd[4678]: sent [LCP ProtRej id=0x3 00 41 f9 ...]
kernel: [607845.560045] mppe_decompress[6]: ccount 0
pppd[4678]: rcvd [proto=0x1447] d5 e3 ...
pppd[4678]: Unsupported protocol 0x1447 received
pppd[4678]: sent [LCP ProtRej id=0x4 14 47 d5 e3 ...]
kernel: [607848.660046] mppe_decompress[6]: ccount 1
pppd[4678]: rcvd [proto=0xe610] f8 03 ...
pppd[4678]: Unsupported protocol 0xe610 received
pppd[4678]: sent [LCP ProtRej id=0x5 e6 10 f8 03 ...]
kernel: [607849.110031] mppe_decompress[6]: ccount 2
---------------

The unsupported protocol's number (id) is always different. This has
pointed me to the thought that linux MPPE module tries to decode
received packet with wrong session key and thus get an incorrect result.

After some kernel code digging (drivers/net/ppp_mppe.c mainly), RFC 3078
reading and packets sniffing, I found out that the first packet sent by 
Windows client has "Bit A" (MPPE_BIT_FLUSHED) set. Thus, the code in
mppe_decompress (ppp_mppe.c:597) that looks like

---------------
if (flushed)
    mppe_rekey(state, 0);
---------------

do session key change just BEFORE decryption of the first packet. So we
have first session key initialised in mppe_init (ppp_mppe.c:297) and
change it once again before decrypting the first packet. That was
looking strange for me and I supposed the problem was in here. So I
changed the code to:

---------------
if (flushed && ccount > 0)
    mppe_rekey(state, 0);
---------------

And after module recompilation I have got MPPE stateful working with
Windows client!

But... only for the first 256 packets. :) Then, as stated in section 7.2
of RFC 3078, the "flag" packet should be sent and session key must be
changed. That really happens, Windows sent the "flag" packet but WITHOUT
MPPE_BIT_FLUSHED set. So, the kernel MPPE module has complained about
that:

---------------
kernel: [ 3088.260282] mppe_decompress[6]: FLUSHED bit not set on flag
packet!
---------------

and return (at ppp_mppe.c:536) a DECOMP_ERROR, because of sanity check
failure. After that session keys are no more synchronised between server
and client, which leads to more "Unsupported protocol" claims.

I have modified the sanity check (at ppp_mppe.c:533) and set "flushed"
variable to non-zero value by hand on each "flag" packet like this:

---------------
if (state->stateful && ((ccount & 0xff) == 0xff) && !flushed) {
    printk(KERN_DEBUG "mppe_decompress[%d]: FLUSHED bit not set on "
           "flag packet!\n", state->unit);
    //state->sanity_errors += 100;
    //sanity = 1;
    flushed = 1;
}
---------------

After that change "flag" packet rekeying was successful and the
connection works well again!

Until... CCP ResetReq packet was received from Windows client. As stated
in section 8.2 of RFC 3078, the CCP ResetReq packet is used if packet
loss detected. The receiver of CCP ResetReq packet must then change the
session key silently and continue transfer data WITHOUT sending CCP
ResetAck packet. But linux MPPE implementation does SEND CCP ResetAck
packet, which leads to the following log:

---------------
kernel: [511970.080047] mppe_decompress[6]: ccount 633
kernel: [511970.080077] mppe_compress[6]: ccount 793
kernel: [511970.110035] mppe_decompress[6]: ccount 634
kernel: [511970.110062] mppe_compress[6]: ccount 794
pppd[17938]: rcvd [CCP ResetReq id=0x0]
pppd[17938]: sent [CCP ResetAck id=0x0]
pppd[17938]: rcvd [CCP CodeRej id=0xb 0f 00 00 04]
pppd[17938]: CCP: Rcvd Code-Reject for code 15, id 0
kernel: [511970.280040] mppe_decompress[6]: ccount 635
kernel: [511970.280077] mppe_compress[6]: ccount 795
kernel: [511970.280081] mppe_compress[6]: rekeying
kernel: [511970.810044] mppe_decompress[6]: ccount 636
kernel: [511970.810087] mppe_compress[6]: ccount 796
pppd[17938]: rcvd [LCP ProtRej id=0xc 9a 1f ...]
pppd[17938]: Protocol-Reject for unsupported protocol 0x9a1f
kernel: [511974.016241] mppe_compress[6]: ccount 797
kernel: [511974.016274] mppe_compress[6]: ccount 798
kernel: [511975.030048] mppe_decompress[6]: ccount 637
kernel: [511975.030065] mppe_decompress[6]: ccount 638
kernel: [511975.030105] mppe_compress[6]: ccount 799
kernel: [511975.030131] mppe_compress[6]: ccount 800
kernel: [511975.050036] mppe_decompress[6]: ccount 639
kernel: [511975.050060] mppe_compress[6]: ccount 801
kernel: [511975.520044] mppe_decompress[6]: ccount 640
kernel: [511975.520079] mppe_compress[6]: ccount 802
pppd[17938]: rcvd [LCP ProtRej id=0xd dc 02 ...]
pppd[17938]: Protocol-Reject for unsupported protocol 0xdc02
kernel: [511980.030047] mppe_decompress[6]: ccount 641
kernel: [511980.030092] mppe_compress[6]: ccount 803
kernel: [511980.051418] mppe_decompress[6]: ccount 642
---------------

Given to this log, rekeying done as expected - on the next mppe_compress
packet after the CCP ResetReq was received. But, it seems that:
1) The windows client don't like CCP ResetAck we sent (as it replies
with CCP CodeRej).
2) The windows client don't like our new session key (as we receive more
"Unsupported protocol"s).

The second may be the consequence of the first, or may not.

So, my questions to the linux-ppp guys are:

1) Does somebody successfully use stateful MPPE with MS Windows clients?
2) Does someone know how exactly MS implementation of MPPE works? In
particular, why rekeying in case of CCP ResetReq fails?

I attach the patch of modifications I made. It applies cleanly to 2.6.37
stable kernel.

Best regards,
Alexey Osipov. 


--=-VfsR5XcnRlE8LU8TF//G
Content-Disposition: attachment; filename="mppe_stateful_v1.patch"
Content-Type: text/x-patch; name="mppe_stateful_v1.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index 88f03c9..086b74e 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -527,8 +527,9 @@ mppe_decompress(void *arg, unsigned char *ibuf, int isize, unsigned char *obuf,
 	if (state->stateful && ((ccount & 0xff) == 0xff) && !flushed) {
 		printk(KERN_DEBUG "mppe_decompress[%d]: FLUSHED bit not set on "
 		       "flag packet!\n", state->unit);
-		state->sanity_errors += 100;
-		sanity = 1;
+		//state->sanity_errors += 100;
+		//sanity = 1;
+		flushed = 1;
 	}
 
 	if (sanity) {
@@ -594,7 +595,7 @@ mppe_decompress(void *arg, unsigned char *ibuf, int isize, unsigned char *obuf,
 				 */
 			}
 		}
-		if (flushed)
+		if (flushed && ccount > 0)
 			mppe_rekey(state, 0);
 	}
 

--=-VfsR5XcnRlE8LU8TF//G--

