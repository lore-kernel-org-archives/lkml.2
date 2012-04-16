Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab2DPGkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:40:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47298 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2DPGky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:40:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 16 Apr 2012 15:40:30 +0900 (JST)
Message-Id: <20120416.154030.310066043.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
Subject: Re: [PATCH 0/2] kdump: Enter 2nd kernel with BSP for enabling
 multiple CPUs
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <beaa8ade-b7af-4e71-b4e0-a418ceb83f1e@email.android.com>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
	<beaa8ade-b7af-4e71-b4e0-a418ceb83f1e@email.android.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/2] kdump: Enter 2nd kernel with BSP for enabling multiple CPUs
Date: Sun, 15 Apr 2012 19:59:52 -0700

> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
> 
>>Currently, booting up 2nd kernel with multiple CPUs fails in most
>>cases since it enters 2nd kernel with AP if the crash happens on the
>>AP. The problem is to signal startup IPI from AP to BSP.
> 
> If so, then we need to fix our code that sends startupIPIs.
> And perhaps the code that attempts to shutdown the other cpus.
> 

Now maxcpus=1 is set at default, in which configuration, 2nd kernel
doesn't try to wake up secondary and later CPUs. So there's no startup
IPI on the 2nd kernel now.

> It is not ok to switch cpus during kdump (reducing the reliability) just so you can write crash dumps faster.  Better would be to cope with secondary cpus not booting.

Even the current implememntation uses NMI to stop other CPUs. The
reliability you are concerned about here is the possibility where the
non-crashing BSP doesn't go into machine_kexec() due to some failures
of interrupt processing, right?

Alternative idea is:
  1) try to go into 2nd kernel with BSP,
  2) after some seconds, then try to go into 2nd kernel with crashing
  CPU. Then, think of CPUs except for the crashing cpu as abnormal,
  and use crashing cpu only on the 2nd kernel.

This seems as reliable as the current one.

> 
> I do like the direction of pounding on things so we can get multiple cpus going in large configurations.  Although I am surprised you are cpu bound and not disk bound in the time to write your crash dumps.
> 

What do you indicate in the 1st sentence? I don't understand around
``pounding on thing'', sorry.

For the 2nd, it depends on data. If data is sparse enough, the data
size is significantly reduced, and so IO size is also reduced. If data
is randomized enough, compression takes much time and the data remains
the same size, resulting in cpu bound processing.

Thanks.
HATAYAMA, Daisuke

