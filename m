Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1LLLNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:13:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44525 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1LLLNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:13:17 -0500
Message-ID: <1323688393.2948.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, mingo@elte.hu,
        Oliver Neukum <oneukum@suse.de>
Date: Mon, 12 Dec 2011 12:13:13 +0100
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
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 18:32 +0800, Ming Lei a écrit :
> On Mon, Dec 12, 2011 at 6:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I don't know the driver model, and I don't plan to start learning it
> > now. But if what you said is possible its broken and no memory barriers
> > will fix it.
> 
> IMO, you don't need to learn it, and my example is very simple and common
> kref usage in device drivers, :-)
> 
> Could we only focus on it and see what is problem? and why won't memory
> barrier fix it?
> 
> Anyway, device drivers are the most consumers of kref...

Really, kref is not magical per itself.

Using kref (or any refcounting) doesnt avoid bugs.

In the example you gave, there is a clear bug :

CPU0                            CPU1
                                        A:kref_init(&obj->ref)

B:kref_get(&obj->ref)
C:access obj                    E:access obj
                                        F:kref_put(&ojb->ref)
D:kref_put(obj->ref)


because _nothing_ prevents CPU0 accessing obj right after F:

To solve this problem, you need another way to synchronize accesses.



