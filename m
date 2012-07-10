Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2GJOU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:20:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58643 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753867Ab2GJOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:20:22 -0400
Date: Tue, 10 Jul 2012 10:20:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Christian Lamparter <chunkeey@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RESEND AGAIN][PATCH] pcmcia: move unbind/rebind into
 dev_pm_ops.complete
In-Reply-To: <201207100119.25214.chunkeey@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.1207101010360.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Christian Lamparter wrote:

> > > So, my question now: Would you accept the pcmcia patch if I add the
> > > "USB: Don't rebind..." as a reference to why the re-add needs to be
> > > done in complete? Or do you think that I should bug the pm people
> > > (and Alan - since he wrote that it is "not allowed") in this case
> > > so I can link their official answer to this patch?
> > 
> > Well I could grab it and give it a little bit of testing in linux-next.
> > But I'd be super-reluctant to send such a patch upstream without
> > detailed input from Alan/Greg/Rafael/Dominik/etc.
> Alright, I've added them in the 'CC'.
> 
> To Alan:
> Can you please tell me, if you (still) know the details why the "re-add"
> is not allowed in _resume callback (see patch message & commit id from
> above: USB: Don't rebind before "complete")?

It's a little complicated.  The basic idea is that the PM core needs to
send suspend and resume messages to every device in the right order,
and it can't do that if new devices are being added at the same time.  
That's one of the main reasons we created the "prepare" and "complete" 
callbacks.

However the situation really isn't quite that rigid.  In particular, 
adding new children during a resume callback shouldn't cause much of
problem because the children don't need to be resumed anyway (since 
they were never suspended).  On the other hand, if you do it you will 
get a dev_warn() from the PM core, something like "parent should not be 
sleeping".

Still, it is considered bad form and should be avoided if possible.

Alan Stern

