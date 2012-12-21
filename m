Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2LUXgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:36:55 -0500
Received: from mx12.netapp.com ([216.240.18.77]:28415 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab2LUXgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:36:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,332,1355126400"; 
   d="scan'208";a="2499145"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "Adamson, Dros" <Weston.Adamson@netapp.com>
Subject: RE: nfsd oops on Linus' current tree.
Thread-Topic: nfsd oops on Linus' current tree.
Thread-Index: AQHN35CZ1gDHdp5O+Eehf/Br4MyqIpgkE1AAgAAJEYCAAErfgP//ego5gACKzoD//3sf0A==
Date: Fri, 21 Dec 2012 23:36:51 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA911972CA1@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121221153348.GA32151@redhat.com>
 <20121221180824.GA27729@fieldses.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA91197273D@SACEXCMBX04-PRD.hq.netapp.com>
 <20121221230849.GB29739@fieldses.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA911972C73@SACEXCMBX04-PRD.hq.netapp.com>,<20121221232609.GC29739@fieldses.org>
In-Reply-To: <20121221232609.GC29739@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please reread what I said. There was no obvious circular dependency, because nfsiod and rpciod are separate workqueues, both created with WQ_MEM_RECLAIM. Dros' experience shows, however that a call to rpc_shutdown_client in an nfsiod work item will deadlock with rpciod if the RPC task's work item has been assigned to the same CPU as the one running the rpc_shutdown_client work item.

I can't tell right now if that is intentional (in which case the WARN_ON in the rpc code is correct), or if it is a bug in the workqueue code. For now, we're assuming the former.

________________________________________
From: J. Bruce Fields [bfields@fieldses.org]
Sent: Friday, December 21, 2012 6:26 PM
To: Myklebust, Trond
Cc: Dave Jones; Linux Kernel; linux-nfs@vger.kernel.org; Adamson, Dros
Subject: Re: nfsd oops on Linus' current tree.

On Fri, Dec 21, 2012 at 11:15:40PM +0000, Myklebust, Trond wrote:
> Apologies for top-posting. The SSD on my laptop died, and so I'm stuck using webmail for this account...

Fun!  If that happens to me on this trip, I've got a week trying to hack
the kernel from my cell phone....

> Our experience with nfsiod is that the WQ_MEM_RECLAIM option still deadlocks despite the "rescuer thread". The CPU that is running the workqueue will deadlock with any rpciod task that is assigned to the same CPU. Interestingly enough, the WQ_UNBOUND option also appears able to deadlock in the same situation.
>
> Sorry, I have no explanation why...

As I said:

> there shouldn't be any deadlock as long as there's no circular
> dependency among the three.

There was a circular dependency (of rpciod on itself), so having a
dedicated rpciod rescuer thread wouldn't help--once the rescuer thread
is waiting for work queued to do the same queue you're asking for
trouble.

The last argument in

        alloc_workqueue("rpciod", WQ_MEM_RECLAIM, 1);

ensures that it will never allow more than 1 piece of work to run per
CPU, so the deadlock should be pretty easy to hit.

And with UNBOUND that's only one piece of work globally, so yeah all you
need is an rpc at shutdown time and it should deadlock every time.

--b.
