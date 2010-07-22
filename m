Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0GVM0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:26:40 -0400
Received: from p01c11o147.mxlogic.net ([208.65.144.70]:54257 "EHLO
	p01c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0GVM0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:26:38 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 08:26:38 EDT
X-MXL-Hash: 4c4838fe1f697e1a-bbd9b51e8fe1291ea1156dc60fbce7fe4c3cf381
X-MXL-Hash: 4c48373c209faef6-660ab4c966cef6ab8d0490578b840f48513716d3
From: Andy Chittenden <andyc@bluearc.com>
To: "Linux Kernel Mailing List (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Date: Thu, 22 Jul 2010 13:19:02 +0100
Subject: nfs client hang
Thread-Topic: nfs client hang
Thread-Index: AcspmBJWFkc0Kk81ShScwTGIcgxdig==
Message-ID: <ABFC24E4C13D81489F7F624E14891C860310E10D51@uk-ex-mbx1.terastack.bluearc.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: vIY= AETA AMX7 BGGr BefI Bpcc CxA6 DSCY D4pn F8fm GIcH
 Iobj I8ki JUIn KFTf
 KP/+;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{796940BE-8EA9-4FDA-87C8-32B18EC8694B};YQBuAGQAeQBjAEAAYgBsAHUAZQBhAHIAYwAuAGMAbwBtAA==;Thu,
 22 Jul 2010 12:19:02 GMT;bgBmAHMAIABjAGwAaQBlAG4AdAAgAGgAYQBuAGcA
x-cr-puzzleid: {796940BE-8EA9-4FDA-87C8-32B18EC8694B}
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [213.121.168.131]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10 a=sIqM7rbIUs]
X-AnalysisOut: [2FIam8obyq6w==:17 a=xNf9USuDAAAA:8 a=E5qr9jTlAAAA:8 a=d1pB]
X-AnalysisOut: [CrdQi-3Y1-MhxaAA:9 a=YbkQyj9Ez6gjwZGbtQAA:7 a=Dx6wz8KPykXg]
X-AnalysisOut: [Ty8RnVc7y-dR50EA:4 a=CjuIK1q_8ugA:10 a=CqgoUNhENt8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're encountering a bug similar to http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578152 but that claims to be fixed in the version we're running:

# dpkg --status linux-image-2.6.32-5-amd64 | grep Version:
Version: 2.6.32-17

If I do this in 4 different xterm windows having cd to the same NFS mounted directory:

xterm1: rm -rf *
xterm2: while true; do     let iter+=1;     echo $iter;     dd if=/dev/zero of=$$ bs=1M count=1000; done
xterm3: while true; do     let iter+=1;     echo $iter;     dd if=/dev/zero of=$$ bs=1M count=1000; done
xterm4: while true; do     let iter+=1;     echo $iter;     dd if=/dev/zero of=$$ bs=1M count=1000; done

then it normally hangs before the 3rd iteration starts. The directory contains loads of information (eg 5 linux source trees).

When it gets into this hang state, here's the packets from the client to server:

4	42.909478	172.18.0.39	10.1.6.102	TCP	1013 > nfs [SYN] Seq=0 Win=5840 Len=0 MSS=1460 TSV=108490 TSER=0 WS=0
5	42.909577	10.1.6.102	172.18.0.39	TCP	nfs > 1013 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460
6	42.909610	172.18.0.39	10.1.6.102	TCP	1013 > nfs [ACK] Seq=1 Ack=1 Win=5840 Len=0
7	42.909672	172.18.0.39	10.1.6.102	TCP	1013 > nfs [FIN, ACK] Seq=1 Ack=1 Win=5840 Len=0
8	42.909767	10.1.6.102	172.18.0.39	TCP	nfs > 1013 [ACK] Seq=1 Ack=2 Win=64240 Len=0
9	43.660083	10.1.6.102	172.18.0.39	TCP	nfs > 1013 [FIN, ACK] Seq=1 Ack=2 Win=64240 Len=0
10	43.660100	172.18.0.39	10.1.6.102	TCP	1013 > nfs [ACK] Seq=2 Ack=2 Win=5840 Len=0

and then repeats after a while.

IE the client starts a connection and then closes it again without sending data.

FWIW I've found it easier to reproduce this problem if Ethernet flow control is off but it still happens with it on as well. This happens with different types of Ethernet hardware too. The rm -rf isn't necessary either but makes the problem easier to reproduce (for me anyway).

The mount options are:

# mount | grep u15
sweet.dev.bluearc.com:/u15 on /u/u15 type nfs (rw,noatime,nodiratime,hard,intr,rsize=32768,wsize=32768,proto=tcp,hard,intr,rsize=32768,wsize=32768,sloppy,addr=10.1.6.102)

I've generated a 2.6.34.1 kernel and that also has the same problem.

So, why would the linux NFS client get into this "non-transmitting data" state? NB 2.6.26 doesn't exhibit this problem.

-- 
Andy, BlueArc Engineering


