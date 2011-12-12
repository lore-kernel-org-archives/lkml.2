Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1LLWzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:55:22 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:50580 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LLWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:55:21 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Date: Mon, 12 Dec 2011 23:56:47 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        gregkh@suse.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu
References: <20111210104341.592561407@chello.nl> <201112121120.16326.oneukum@suse.de> <20111212193040.GA13131@kroah.com>
In-Reply-To: <20111212193040.GA13131@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112122356.47545.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Dezember 2011, 20:30:40 schrieb Greg KH:
> On Mon, Dec 12, 2011 at 11:20:16AM +0100, Oliver Neukum wrote:
> > Am Montag, 12. Dezember 2011, 10:57:31 schrieb Ming Lei:
> > > On Mon, Dec 12, 2011 at 4:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > On Mon, 2011-12-12 at 11:48 +0800, Ming Lei wrote:
> > > >> For kref, maybe it is still multiple operations done on one cpu vs them
> > > >> being visible on another, but seems a bit implicit, see the common kref
> > > >> usage below:
> > > >>
> > > >> CPU0                            CPU1
> > > >>                                         A:kref_init(&obj->ref)
> > > >
> > > > how does CPU0 get a ref to obj?
> > > 
> > > Suppose open/close/read/.. context is run on CPU0, and driver .probe/.release
> > > context(hotplug context) is run on CPU1. There are a few examples on
> > > usb driver(eg. usb-skeleton.c, ...)
> > 
> > USB generally relies on an implied barrier just as:
> > 
> >         /* we can register the device now, as it is ready */
> >         retval = usb_register_dev(interface, &skel_class);
> > 
> > Generally reference counting cannot help you if kfree() is involved
> 
> So, Oliver, you don't have any objection to this patch removing the
> barriers in kref, right?  Originally you added them, I just wanted to
> make sure before I applied this.

I do not remember any more why I introduced this.

I guess I worried not about the increment, but the decrement.
Which makes me wonder what happens if you don't intend
to get the kref again, but need to make sure it is usually freed,
like:

CPU A								CPU B

kref_get(p)
start_io(p)
									[interrupt from IO]
									kref_put(p)

You need an ordering primitive between start_io() and kref_get()
or the counter could go negative.
I think I was worried about it missing.

	Regards
		Oliver
