Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0KSSHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0KSSHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:07:12 -0500
Date: Fri, 19 Nov 2010 13:07:02 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, mchehab@redhat.com
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Message-ID: <20101119180702.GB5022@redhat.com>
References: <1285844276.26405.26.camel@cookie.hadess.net>
 <201009300847.43090.dmitry.torokhov@gmail.com>
 <1285861890.26405.37.camel@cookie.hadess.net>
 <20101008003940.GF31804@redhat.com>
 <1290053884.1435.10.camel@novo.hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290053884.1435.10.camel@novo.hadess.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 04:18:03AM +0000, Bastien Nocera wrote:
> On Thu, 2010-10-07 at 20:39 -0400, Jarod Wilson wrote:
> > On Thu, Sep 30, 2010 at 04:51:30PM +0100, Bastien Nocera wrote:
> > > On Thu, 2010-09-30 at 08:47 -0700, Dmitry Torokhov wrote:
> > > > Bastien,
> > ...
> > > >  I'll try
> > > > to get the driver in .37 but after that we should probably move it
> > > > over to the new IR infrastructure...
> > > 
> > > I'm not sure what that would bring us, nor do I have any experience in
> > > using the ir-core. From what I understood, it still needed fleshing out.
> > 
> > There are a few things that still need fleshing out, but nothing really
> > that should have any major impact on a potential port of this driver.
> > 
> > Off the top of my head, the main thing it would give you is the ability to
> > upload your own keymap for the receiver.
> 
> You could already change the keymap...

You could change the mapping for the 6 buttons, but new scancode to
keycode mappings wouldn't be possible. That's assuming the driver actually
does raw IR decode -- the scancodes I see in the key tables in the driver
definitely match decoded NEC that I get when using the Apple remote with
another raw IR receiver (mceusb). Reading through the code though, it
appears the IR signal is decoded in hardware and only the resulting
scancodes are passed along... I wonder if it passes along scancodes for
all NEC signals or if its doing filtering... I have sufficiently equipped
Apple hardware of my own that I suppose I really ought to prod.

> >  Then someone wanting to use more
> > than 6 buttons
> 
> But only for the 6 buttons supported.
> 
> >  or whatever it is might still be able to get the benefits
> > of in-kernel decoding with everything coming through the input layer,
> > rather than using lirc or the like.
> 
> I see very little benefits myself (I mean, unless you're adamant that
> you want to use a remote that's not intended for that computer, but we
> already have lirc user-space driver for doing that),

I don't see why we shouldn't be able to do it in-kernel too, without the
need for any userspace daemon. The bigger win though is probably
de-duplication of keyup/keydown/timer logic. I had similar duplication in
the imon driver (which is also scancode-based), and the code is smaller
and cleaner after being adapted to use ir/rc-core functions.

> and it would remove
> metadata from the events, so we couldn't do "remote filtering" (each
> remote has a semi-random UID, which gets passed in with the events).

No it wouldn't. The lsb of the decoded NEC pulse train contains the ID,
I'm able to see it just fine with other raw IR receivers and some
experimental patches we're kicking around on linux-media.

> When the appleir patch was finally accepted (which means I need to get
> off my arse and do the changes Oliver mentioned), working on UID
> filtering is next on my list of TODOs.

I've got an implementation here using the in-kernel NEC decoder, an Apple
remote any an mceusb transceiver that works. Its not terribly *elegant*,
but it does work. (Executive summary: if not doing pairing, zero out the
pair ID and use the full 32-bit scancode with a default keytable that has
0x00 in the pair ID position. If doing pairing, pass that byte unmodified,
and upload a keymap that matches).

-- 
Jarod Wilson
jarod@redhat.com

