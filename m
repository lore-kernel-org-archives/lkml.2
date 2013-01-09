Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157Ab3AIUl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:41:57 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:43714 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933894Ab3AIUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:54 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 15:41:54 EST
Date: Wed, 9 Jan 2013 18:34:44 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: fix the oops due to conn->hcon == NULL in
 shutdown case
Message-ID: <20130109203444.GC30225@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"Liu, Chuansheng" <chuansheng.liu@intel.com>,
	"marcel@holtmann.org" <marcel@holtmann.org>,
	"johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1356429857.25456.4.camel@cliu38-desktop-build>
 <20130103220258.GF2114@joana>
 <27240C0AC20F114CBF8149A2696CBE4A1FB42B@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1FB42B@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

* Liu, Chuansheng <chuansheng.liu@intel.com> [2013-01-04 00:55:26 +0000]:

> 
> 
> > -----Original Message-----
> > From: Gustavo Padovan [mailto:gustavo@padovan.org]
> > Sent: Friday, January 04, 2013 6:03 AM
> > To: Liu, Chuansheng
> > Cc: marcel@holtmann.org; johan.hedberg@gmail.com;
> > linux-bluetooth@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] Bluetooth: fix the oops due to conn->hcon == NULL in
> > shutdown case
> > 
> > Hi Chuansheng,
> > 
> > * Chuansheng Liu <chuansheng.liu@intel.com> [2012-12-25 18:04:17 +0800]:
> > 
> > >
> > > Meet one panic issue as below stack:
> 
> 
> > > Disassemble the code:
> > > base address of __sco_sock_close is 0xc184f410
> > > 0xc184f4f8 <+232>:   lock decl 0x8(%ebx) < == crash here, ebx is 0x0,
> > >
> > > the related source code is:
> > > (gdb) l *0xc184f4f8
> > > 0xc184f4f8 is in __sco_sock_close (arch/x86/include/asm/atomic.h:123)
> > > 119     static inline int atomic_dec_and_test(atomic_t *v)
> > > 123             asm volatile(LOCK_PREFIX "decl %0; sete %1"
> > >
> > > The whole call stack is:
> > > sys_shutdown()
> > >   sco_sock_shutdown()
> > >     __sco_sock_close()
> > >       hci_conn_put()
> > >         atomic_dec_and_test()
> > >
> > > Due to the conn->hcon is NULL, and the member hcon->refcnt is at offset 0x8,
> > > so "BUG: unable to handle kernel NULL pointer dereference at 00000008"
> > > appears.
> Could you add the above crash info to indicate where crashed? Thanks.
> 
> > >
> > > Here fix it that adding the condition if conn->hcon is NULL, just like
> > > in sco_chan_del().
> > >
> > > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > > ---
> > >  net/bluetooth/sco.c |    6 ++++--
> > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> > > index 531a93d..190f70c 100644
> > > --- a/net/bluetooth/sco.c
> > > +++ b/net/bluetooth/sco.c
> > > @@ -355,8 +355,10 @@ static void __sco_sock_close(struct sock *sk)
> > >  		if (sco_pi(sk)->conn) {
> > >  			sk->sk_state = BT_DISCONN;
> > >  			sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
> > > -			hci_conn_put(sco_pi(sk)->conn->hcon);
> > > -			sco_pi(sk)->conn->hcon = NULL;
> > > +			if (sco_pi(sk)->conn->hcon) {
> > > +				hci_conn_put(sco_pi(sk)->conn->hcon);
> > > +				sco_pi(sk)->conn->hcon = NULL;
> > > +			}
> > >  		} else
> > >  			sco_chan_del(sk, ECONNRESET);
> > >  		break;
> > 
> > Please check if the following patch fixes the issue for you:
> > 
> > commit ae5668c1fc155d3034d0eedcdb52798390975a39 (HEAD, master)
> > Author: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> > Date:   Thu Jan 3 19:59:28 2013 -0200
> > 
> >     Bluetooth: Check if the hci connection exists in SCO shutdown
> > 
> >     Checking only for sco_conn seems to not be enough and lead to NULL
> >     dereferences in the code, check for hcon instead.
> > 
> >     <1>[11340.226404] BUG: unable to handle kernel NULL pointer
> > dereference at
> >     0000000
> >     8
> >     <4>[11340.226619] EIP is at __sco_sock_close+0xe8/0x1a0
> >     <4>[11340.226629] EAX: f063a740 EBX: 00000000 ECX: f58f4544 EDX:
> > 00000000
> >     <4>[11340.226640] ESI: dec83e00 EDI: 5f9a081f EBP: e0fdff38 ESP:
> > e0fdff1c
> >     <0>[11340.226674] Stack:
> >     <4>[11340.226682]  c184db87 c1251028 dec83e00 e0fdff38 c1754aef
> > dec83e00
> >     00000000
> >     e0fdff5c
> >     <4>[11340.226718]  c184f587 e0fdff64 e0fdff68 5f9a081f e0fdff5c
> > c1751852
> >     d7813800
> >     62262f10
> >     <4>[11340.226752]  e0fdff70 c1753c00 00000000 00000001 0000000d
> > e0fdffac
> >     c175425c
> >     00000041
> >     <0>[11340.226793] Call Trace:
> >     <4>[11340.226813]  [<c184db87>] ? sco_sock_clear_timer+0x27/0x60
> >     <4>[11340.226831]  [<c1251028>] ? local_bh_enable+0x68/0xd0
> >     <4>[11340.226846]  [<c1754aef>] ? lock_sock_nested+0x4f/0x60
> >     <4>[11340.226862]  [<c184f587>] sco_sock_shutdown+0x67/0xb0
> >     <4>[11340.226879]  [<c1751852>] ? sockfd_lookup_light+0x22/0x80
> >     <4>[11340.226897]  [<c1753c00>] sys_shutdown+0x30/0x60
> >     <4>[11340.226912]  [<c175425c>] sys_socketcall+0x1dc/0x2a0
> >     <4>[11340.226929]  [<c149ba78>] ? trace_hardirqs_on_thunk+0xc/0x10
> >     <4>[11340.226944]  [<c18860f1>] syscall_call+0x7/0xb
> >     <4>[11340.226960]  [<c1880000>] ? restore_cur+0x5e/0xd7
> >     <0>[11340.226969] Code: <f0> ff 4b 08 0f 94 c0 84 c0 74 20 80 7b 19 01 74
> >     2f b8 0a 00 00
> > 
> >     Reported-by: Chuansheng Liu <chuansheng.liu@intel.com>
> >     Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> > 
> > diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> > index 531a93d..57f250c 100644
> > --- a/net/bluetooth/sco.c
> > +++ b/net/bluetooth/sco.c
> > @@ -352,7 +352,7 @@ static void __sco_sock_close(struct sock *sk)
> > 
> >  	case BT_CONNECTED:
> >  	case BT_CONFIG:
> > -		if (sco_pi(sk)->conn) {
> > +		if (sco_pi(sk)->conn->hcon) {
> Your fix is incomplete, at least it should be:
> 		if ( (sco_pi(sk)->conn) && (sco_pi(sk)->conn->hcon)) {
> Otherwise, it will bring another crash case. So could you add signed-off-by me also?

Can you point any code flow that can crash with my patch? Otherwise I'm just
pushing this patch. I don't think we need to check for sco_pi(sk)->conn here.

	Gustavo
