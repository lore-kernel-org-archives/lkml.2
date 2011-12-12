Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1LLLHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:07:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:44624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1LLLG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:06:59 -0500
Message-ID: <1323687948.16764.74.camel@twins>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
In-Reply-To: <CACVXFVNUGTu-gF=jkNg37cmc1wKFvycYojs96VS8eowyLsJ8fg@mail.gmail.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.295857663@chello.nl>
	 <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	 <1323529084.16764.5.camel@twins>
	 <CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
	 <1323546551.2822.14.camel@laptop>
	 <CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
	 <1323607627.16764.13.camel@twins>
	 <CACVXFVOYj+Mmph8WGQUdcGS8t-GPr9y3crPuz0SrBCtOmCvstQ@mail.gmail.com>
	 <1323617738.16764.21.camel@twins> <1323636148.16764.44.camel@twins>
	 <CACVXFVMDEeDBkAdv=AkRZuOH1sNdMGjR3PeHYMVLhwR+FB8gOg@mail.gmail.com>
	 <1323680078.16764.45.camel@twins>
	 <CACVXFVPOsUrEEDT=iMZyrvaX3G_XqWpVOJyz24=FPTtB_9J9HQ@mail.gmail.com>
	 <1323684748.16764.62.camel@twins>
	 <CACVXFVNUGTu-gF=jkNg37cmc1wKFvycYojs96VS8eowyLsJ8fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 12 Dec 2011 12:05:48 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 18:32 +0800, Ming Lei wrote:
> On Mon, Dec 12, 2011 at 6:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I don't know the driver model, and I don't plan to start learning it
> > now. But if what you said is possible its broken and no memory barriers
> > will fix it.
> 
> IMO, you don't need to learn it, and my example is very simple and common
> kref usage in device drivers, :-)

One needs to know the callchains and device driver core code leading up
to those .open, .close, .read, .probe and .release callbacks. That's a
lot of code.

Also, non of that is relevant. The kref interface is very simple.
kref_set cannot and should not have any concurrency.

It it not for kref_set() to finalize the object (there is no requirement
kref_set is the last operation before you publish the object).

As per Oliver's reply, your USB example uses usb_register_dev() to
pushlish the object and that includes the LOCK and UNLOCK from my
example; it also illustrates you do need to know the entire device model
in order to talk sensibly about these callbacks you mentioned.

You already said that external means should be used to ensure no
kref_get() is issued after the final kref_put(). This too is only
possible if you use locks one way or another and I bet that if you go
look at the device model you'll find plenty around device_unregister().

These two constraints alone are enough to remove both memory barriers
from the kref code.


