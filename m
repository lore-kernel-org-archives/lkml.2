Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2FPTLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:11:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38184 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab2FPTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:11:20 -0400
Date: Sat, 16 Jun 2012 12:11:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct
 usb_device_id)=24 is not a modulo of the size of section
 __mod_usb_device_table=44.
Message-ID: <20120616191114.GA10098@kroah.com>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
 <20120615201021.GB14544@kroah.com>
 <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
 <20120615231220.GC8205@kroah.com>
 <87lijns84s.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lijns84s.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 03:23:31PM +0200, Bjørn Mork wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Fri, Jun 15, 2012 at 11:02:55PM +0200, Geert Uytterhoeven wrote:
> >
> >> As "kernel_ulong_t  driver_info" is no longer naturally aligned, the
> >> compiler will
> >> add implicit padding. But the padding depends on the architecture.
> >
> > Ah, so we were "lucky" before, nice.
> 
> I don't really believe in luck :-)  I think someone has been really
> smart here.  Maybe too smart...

No, I think the previous structure was just "lucky" in that it just
happened to be the right alignment.  I say this as I think I was the one
who created that structure years ago.  Or maybe not, this was back in
the 2.3 kernel days, I can't remember what patches I wrote last week...

> >> It can be fixed by adding explicit padding. Probably it should be padded by
> >> 7 bytes (not 3), as kernel_ulong_t may require 8-byte alignment on some 64-bit
> >> platforms. Or by an explicit alignment attribute.
> >> 
> >> See also
> >>   * commit 8175fe2dda1c93a9c596921c8ed4a0b4baccdefe ("HID: fix
> >> hid_device_id for cross compiling")
> >>   * commit 7492d4a416d68ab4bd254b36ffcc4e0138daa8ff ("sdio: fix module
> >> device table definition for m68k")
> >>   * commit 9e2d3cd34a159948dc753a14573e16bffc04dba8 ("[PATCH]
> >> mod_devicetable.h fixes")
> >
> > So would the patch below fix this?  It should force alignment of the
> > driver_data field, which is all you want here, right?
> >
> >> Still, there's a bug in file2alias (which is compiled by the host
> >> compiler), in that
> >> it may use different padding than the target platform when cross-compiling.
> >
> > That's not good, but outside of this specific issue, right?  Have we
> > just been fortunate it hasn't really hit us yet?
> >
> > thanks,
> >
> > greg k-h
> >
> > diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> > index 7771d45..6955045 100644
> > --- a/include/linux/mod_devicetable.h
> > +++ b/include/linux/mod_devicetable.h
> > @@ -122,7 +122,8 @@ struct usb_device_id {
> >  	__u8		bInterfaceNumber;
> >  
> >  	/* not matched against */
> > -	kernel_ulong_t	driver_info;
> > +	kernel_ulong_t	driver_info
> > +		__attribute__((aligned(sizeof(kernel_ulong_t))));
> >  };
> 
> 
> This feels a lot like papering over the real problem.  It will solve
> this instance, but the list of such previous "paper work" that Geert
> provided should be enough evidence that this will happen again the next
> time someone modifies a device id struct for some subsystem.

Hopefully not, if you add another field here, the alignment force will
keep things lined up properly, from what I can tell.  Is that not true?

> And adding forced aligment here feels wrong since there is no good
> reason why the (target) compiler shouldn't know the proper alignment for
> this structure, is there? OK, "feels wrong" is not a good argument. But
> it would be better to solve this problem once and for all.

C doesn't require the structure to be aligned.  Actually the spec says
it doesn't guarantee anything about this, we just "know" that gcc is
going to be semi-sane and try to do the best it can.  Hopefully clang is
also semi-sane as well.

So because of that, we have to give it some guidance, hence the patch.

thanks,

greg k-h
