Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2EORtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:49:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43700 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab2EORtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:49:08 -0400
Subject: Re: [V2 PATCH 4/9] macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only
 when skb is built successfully
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <20120502034206.11782.91643.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034206.11782.91643.stgit@amd-6168-8-1.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 10:44:03 -0700
Message-ID: <1337103843.8220.22.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051517-3534-0000-0000-0000086642DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 11:42 +0800, Jason Wang wrote:
> Current the SKBTX_DEV_ZEROCOPY is set unconditionally after
> zerocopy_sg_from_iovec(), this would lead NULL pointer when macvtap
> fails to build zerocopy skb because destructor_arg was not
> initialized. Solve this by set this flag after the skb were built
> successfully.

I thought this flag was needed for zerocopy skb free even in err case.
I've checked it back again, it's OK to move the flag after the skb
successfully built. Or we can fix it by modify skb free with
destructor_arg NULL check as below:
...
skb_release_data() {
...
                if (skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY) {
                        struct ubuf_info *uarg;

                        uarg = skb_shinfo(skb)->destructor_arg;
                        if (uarg && uarg->callback)
                                uarg->callback(uarg);
                }

...
}
Thanks
Shirley

