Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0INPVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:21:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0INPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:21:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shirley Ma <mashirle@us.ibm.com>
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host kernel
Date: Tue, 14 Sep 2010 17:21:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, David Miller <davem@davemloft.net>,
        mst@redhat.com, xiaohui.xin@intel.com, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1284410580.13351.10.camel@localhost.localdomain> <4C8F3C77.7010302@redhat.com> <1284476719.13351.35.camel@localhost.localdomain>
In-Reply-To: <1284476719.13351.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141721.13202.arnd@arndb.de>
X-Provags-ID: V02:K0:YEGKGTRC7kggDb2wOHuITznQ/jOr2aTkYpdSnK2oJLL
 b9ywsRuDwy6Vxahl4XPHahM9qbt7jVDSz8dkyYoLHeN7wX3Pid
 9/4m4FYE6xV4MaOSrai9wnYY2wSZ4bFIHnNSilRs2wewKcMsHB
 kw/6ZKB7a74f3EVQKQoShCO2iUXk4eNCnu/bpojOJsljhHrhgb
 n1d5oJJBRlTx7vVk3fPcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 September 2010, Shirley Ma wrote:
> On Tue, 2010-09-14 at 11:12 +0200, Avi Kivity wrote:
>
> > That's what io_submit() is for.  Then io_getevents() tells you what
> > "a 
> > while" actually was.
> 
> This macvtap zero copy uses iov buffers from vhost ring, which is
> allocated from guest kernel. In host kernel, vhost calls macvtap
> sendmsg. macvtap sendmsg calls get_user_pages_fast to pin these buffers'
> pages for zero copy.
> 
> The patch is relying on how vhost handle these buffers. I need to look
> at vhost code (qemu) first for addressing the questions here.

I guess the best solution would be to make macvtap_aio_write return
-EIOCBQUEUED when a packet gets passed down to the adapter, and
call aio_complete when the adapter is done with it.

This would change the regular behavior of macvtap into a model where
every write on the file blocks until the packet has left the machine,
which gives us better flow control, but does slow down the traffic
when we only put one packet at a time into the queue.

It also allows the user to call io_submit instead of write in order
to do an asynchronous submission as Avi was suggesting.

	Arnd
