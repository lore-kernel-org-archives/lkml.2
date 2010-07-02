Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0GBXm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 19:42:29 -0400
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:38104 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0GBXm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 19:42:27 -0400
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2010 19:42:27 EDT
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle D Moffett <kyle@moffetthome.net>
Date: Fri, 2 Jul 2010 18:30:47 -0500
Subject: [P2020] "Processor 1 is stuck" (introduced by 8b27f0b61)
Thread-Topic: [P2020] "Processor 1 is stuck" (introduced by 8b27f0b61)
Thread-Index: AcsaPpzeRs62FSfETumPyMsY8YLdrA==
Message-ID: <BAD2EBFA-91F7-478B-8BA8-F7A099050A2F@boeing.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on a new board port to a P2020-based system (e500v2) and I appear to be hitting a regression which causes the second core to fail to come up at boot with a "Processor 1 is stuck" message.

In the successful case (my board support patches on top of v2.6.32):
> smp_85xx_kick_cpu: kick CPU #1
> smp_85xx_kick_cpu: cpu-release-addr: 0x7ffff280
> smp_85xx_kick_cpu: got virt addr:    0xf1014280
> waited 1 msecs for CPU #1
> Processor 1 found.
> Brought up 2 CPUs

In the failing case (with board support patches on top of either 8b27f0b61 or v2.6.34):
> smp_85xx_kick_cpu: kick CPU #1
> smp_85xx_kick_cpu: cpu-release-addr: 0x7ffff280
> smp_85xx_kick_cpu: got virt addr:    0xf1014280
> waited 1 msecs for CPU #1
> [...5 second delay here...]
> Processor 1 is stuck.
> Brought up 1 CPUs

I believe I've bisected a bug to this commit:

> Commit: 8b27f0b61db57f5555fc2d3fc95c3ea9fd1a9d6c
> Author: Kumar Gala <galak@kernel.crashing.org>
> 
> powerpc/fsl-booke: Rework TLB CAM code
> * Bump'd # of CAM entries to 64 to support e500mc
> * Make the code handle MAS7 properly
> * Use pr_cont instead of creating a string as we go

If I revert 8b27f0b61 on top of v2.6.34 (I fixed the conflicts by deleting the extra hunks), both CPUs come up properly.  My current board support files can be browsed via gitweb or cloned via smart-http or natively from here:
  http://opensource.exmeritus.com/git/hww-1u-1a/linux.git
  git://opensource.exmeritus.com/hww-1u-1a/linux.git

The "latest-v2.6.34" branch is based on v2.6.34 and does not work (Processor 1 is stuck), the "latest-v2.6.32" branch is based on v2.6.32.15 and works correctly.

Our U-Boot port can be browsed here:
  http://opensource.exmeritus.com/git/hww-1u-1a/u-boot.git
  git://opensource.exmeritus.com/hww-1u-1a/u-boot.git

Any help you can provide would be greatly appreciated.

Cheers,
Kyle Moffett

