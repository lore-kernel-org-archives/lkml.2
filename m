Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1KDOy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:54:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57256 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1KDOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:54:55 -0400
Subject: Re: virtio-pci new configuration proposal
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20111104142338.GB24452@redhat.com>
References: <1320259767.22582.2.camel@lappy>
	 <8762j2t19l.fsf@rustcorp.com.au> <1320309203.29407.1.camel@lappy>
	 <87lirwrzlg.fsf@rustcorp.com.au> <20111104114033.GA21308@redhat.com>
	 <1320409939.3334.6.camel@lappy> <20111104135113.GA24452@redhat.com>
	 <1320414804.3334.13.camel@lappy>  <20111104142338.GB24452@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 04 Nov 2011 16:53:05 +0200
Message-ID: <1320418385.3334.25.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 16:23 +0200, Michael S. Tsirkin wrote:
> On Fri, Nov 04, 2011 at 03:53:24PM +0200, Sasha Levin wrote:
> > On Fri, 2011-11-04 at 15:51 +0200, Michael S. Tsirkin wrote:
> > > On Fri, Nov 04, 2011 at 02:32:19PM +0200, Sasha Levin wrote:
> > > > On Fri, 2011-11-04 at 13:40 +0200, Michael S. Tsirkin wrote:
> > > > > On Fri, Nov 04, 2011 at 08:14:43PM +1030, Rusty Russell wrote:
> > > > > > > > 3) If we're changing the queue layout, it's a chance to fix a
> > > > > > > >    longstanding bug: let the guest notify the host of preferred
> > > > > > > >    queue size and alignment.
> > > > > > > 
> > > > > > > Yup, we can do that.
> > > > > 
> > > > > We don't need to change all of layout for that - just add another field
> > > > > in the common config structure to supply the alignment.
> > > > 
> > > > How would you do it without changing the layout? Add another optional
> > > > field at the end which will shift offsets based on whether the host and
> > > > guest support this new feature or not?
> > > > 
> > > > This leads to 3 different things which now shift config offsets around.
> > > 
> > > No. Just put the field at offset 24 from the offset specified
> > > by VIRTIO_PCI_CAP_COMMON_CFG.
> > 
> > Two questions here:
> > 
> > - What about backwards compatibility? How would the config space look
> > when we're not using the new layout?
> 
> Exactly as it does now. You don't get to tweak alignment then.
> 
> > - How does it work with 64 bit features which are also located there?
> 
> Basically each field gets an offset.  E.g.
> 24 - features
> 28 - queue alignment
> 
> > > > As you said, the PCI cap list was introduced both to save space (which
> > > > is not the motivation here), and because it's a very efficient
> > > 
> > > It's actually pretty inefficient - there's an overhead of 3 bytes for
> > > each vendor specific option.
> > 
> > It's efficient because while you pay a small price for each optional
> > option it also means that that option is optional and won't clutter the
> > config space if it's not really in use.
> 
> I guess my assumption is that most options will be in use,
> not discarded dead-ends.

I don't know about that. 64 bit features would be pretty rare for now -
and I don't think that setting the alignment will be also enabled by
default.

I think that we're looking at it differently because I assume that any
feature we add at this point would be optional and used only in specific
scenarios, while you think that everything added will be used most of
the time.

> > Think of how the PCI config space would look if all those caps wouldn't
> > have been optional and would instead all of them would have just have
> > been attached to the end of the config space.
> 
> It started out this way, but then they started running out
> of space - it's only 256 bytes - so the capability mechanism
> was invented.
> 
> 
> > > 
> > > > and easy way to manage optional features without requiring tricks
> > > > which move offsets around like we do now.
> > > 
> > > Tricks with offsets only appeared because we had datapath, device
> > > specific and common config in the same place.
> > > feature list isn't needed to fix that.
> > > 
> > > > -- 
> > > > 
> > > > Sasha.
> > 
> > -- 
> > 
> > Sasha.

-- 

Sasha.

