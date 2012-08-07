Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab2HGPO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:14:26 -0400
Received: from mx2.netapp.com ([216.240.18.37]:63302 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2HGPOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:14:24 -0400
X-IronPort-AV: E=Sophos;i="4.77,727,1336374000"; 
   d="scan'208";a="674178154"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>
CC: Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Topic: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Index: AQHNdKJvypEw9t3CEUmeaLKAlM+spZdO1J0AgAAFvwCAAAB9gIAAAqyAgAACoYCAAAqOAA==
Date: Tue, 7 Aug 2012 15:14:22 +0000
Message-ID: <1344352458.5781.8.camel@lade.trondhjem.org>
References: <20120807134156.GP1996@amd.com> <50211E42.6040808@netapp.com>
	 <20120807141548.GG1917@8bytes.org> <5021237D.1010107@netapp.com>
	 <20120807142707.GH1917@8bytes.org> <502127EF.3030209@netapp.com>
In-Reply-To: <502127EF.3030209@netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <43611456F413BA489CE8E3B105FAE4D9@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q77FEU6B012932

On Tue, 2012-08-07 at 10:36 -0400, Bryan Schumaker wrote:
> On 08/07/2012 10:27 AM, Joerg Roedel wrote:
> > On Tue, Aug 07, 2012 at 10:17:33AM -0400, Bryan Schumaker wrote:
> >> On 08/07/2012 10:15 AM, Joerg Roedel wrote:
> >>> Yes, it reproduces pretty reliable here with Ubuntu 11.10 Server on an
> >>> Intel box with an NFSv3 directory mounted at boot. This is the only box
> >>> I have seen this so far, probably it depends on the config. I attach the
> >>> config of the failing box.
> >>
> >> Interesting.  Are you mounting v4, too?  This code shouldn't be
> >> running for v3... maybe that's why I haven't been able to hit it.
> > 
> > No, I am not using NFSv4 on the box where the BUG happens. I have
> > another box mounting the same directory where the BUG does not trigger
> > with v3.6-rc1. A difference I spotted between the kernels is, that on
> > the failing box NFS is compiled as a module whereas it is compiled into
> > the kernel on the box that works fine. Not sure if that has anything to
> > do with the problem...
> > 
> 
> Your stack trace is showing v4 calls on the failing box, those definitely shouldn't be happening if you're using v3.  Can you double check /etc/fstab and /proc/mounts on a working kernel to be sure?
> 
> My VM has nfs as a module, so I don't think that's the issue... I just started compiling your config to test on my own.

Joerg,

The stack trace definitely shows that the NFS client is attempting an
NFSv4 mount. Are you supplying a 'vers=3' mount option? If not, then
note that recent versions of nfs-utils can be configured to try NFSv4 as
the default mount option, so I'd guess this is why you are hitting an
NFSv4 path.

Bryan,

That said, when looking at the legacy upcall, it seems that if
rpc_queue_upcall fails, then we don't do anything to clear
idmap->idmap_key_cons. Ditto if the call times out, or if the pipe is
closed before the downcall.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
