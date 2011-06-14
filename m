Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1FNQiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:38:05 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:57558 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1FNQiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:38:02 -0400
Date: Tue, 14 Jun 2011 20:37:07 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Dan Carpenter <error27@gmail.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Mike Thomas <rmthomas@sciolus.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/easycap: Fix bytesperline calculation
Message-ID: <20110614163707.GA29015@tugrik.mns.mnsspb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru> <bcbeb6b7c5ab7624ea59b072f74347fa8e6a6350.1307967011.git.kirr@mns.spb.ru> <6F5C1D715B2DA5498A628E6B9C124F0401AD319280@hasmsx504.ger.corp.intel.com> <cover.1307967011.git.kirr@mns.spb.ru> <bcbeb6b7c5ab7624ea59b072f74347fa8e6a6350.1307967011.git.kirr@mns.spb.ru> <20110613123659.GG3583@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401AD319280@hasmsx504.ger.corp.intel.com> <20110613123659.GG3583@shale.localdomain>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 04:23:45PM +0300, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Kirill Smelkov [mailto:kirr@mns.spb.ru]
> > Sent: Monday, June 13, 2011 3:19 PM
> > To: Greg Kroah-Hartman
> > Cc: Winkler, Tomas; Mike Thomas; devel@driverdev.osuosl.org; linux-
> > kernel@vger.kernel.org; Kirill Smelkov
> > Subject: [PATCH 5/5] staging/easycap: Fix bytesperline calculation
> > 
> > As described above fillin_formats()
> > 
> > """
> >     /*
> >      *  THE 16-BIT easycap_format.mask HAS MEANING:
> >      *    (least significant) BIT  0:     0 => PAL, 25 FPS;   1 => NTSC, 30 FPS
> >      *                        BITS 2-4:   RESERVED FOR DIFFERENTIATING STANDARDS
> >      *                        BITS 5-7:   NUMBER OF BYTES PER PIXEL
> >      *                        BIT  8:     0 => NATIVE BYTE ORDER;  1 => SWAPPED
> >      *                        BITS 9-10:  RESERVED FOR OTHER BYTE PERMUTATIONS
> >      *                        BIT 11:     0 => UNDECIMATED;    1 => DECIMATED
> >      *                        BIT 12:     0 => OFFER FRAMES;   1 => OFFER FIELDS
> >      *                        BIT 13:     0 => FULL FRAMERATE; 1 => REDUCED
> >      *     (most significant) BITS 14-15: RESERVED FOR OTHER FIELD/FRAME
> > OPTIONS
> >      *  IT FOLLOWS THAT:
> >      *     bytesperpixel IS         ((0x00E0 & easycap_format.mask) >> 5)
> >      *     byteswaporder IS true IF (0 != (0x0100 & easycap_format.mask))
> >      *
> >      *     decimatepixel IS true IF (0 != (0x0800 & easycap_format.mask))
> >      *
> >      *       offerfields IS true IF (0 != (0x1000 & easycap_format.mask))
> >      */
> > """
> > 
> > bytes-per-pixel is stored in bits 5-7 of calculated mask.
> > 
> > But when calculating bytes-per-line we were extracting wrong value instead
> > of bytes-per-pixel, which was usually 2 times bigger -- e.g. for PAL YUV 422 I
> > was getting ((mask3 & 0x00F0) >> 4) = 4 bytes instead of 2.
> > 
> > The error here is that even in comments there is a line saying
> > 
> >      *     bytesperpixel IS         ((0x00E0 & easycap_format.mask) >> 5)
> > 
> > but we were using
> >                                     ((0x00F0 & easycap_format.mask) >> 4)
> > 
> > With 2 times bigger bytesperpixel and automatically bytesperline, the video
> > was shown halfheight'ed, which is understandable if we look at video-
> > memory layout:
> > 
> >     <------- bytesperline -------->
> >     <- real bpl ->
> > 
> >     x0----------y0  x1-----------y1
> >     x2----------y2  x3-----------y3
> > 
> >     xn----------yn  xn-----------yn
> >     <garbage>
> > 
> > for each line, we should display width pixels, then move to next line with
> > bytesperline, and oops, if bytesperline = 2*real-bytesperlin, we'll skip one
> > line and move to next-next line, and so only half lines will be shown.
> > 
> > Initially I've debugged the problem with my video application[1], but I've
> > checked that after this patch both rawv (mine app) and tvtime work
> > correctly.
> > 
> > [1] http://repo.or.cz/w/rawv.git
> > 
> > P.S. why at all we use those mask/shifts? Why not use bitfields?
> 
> First of all  I have feeling this code history beyond this driver.  
> Second there possible issues with bit fields related to endianity and efficiency. I'm not sure it applies also in this driver 

I'd agree about endianity, but if I see it correctly, in this driver
easycap_format.mask is used only as internal driver flags not writtent
to hardware registers. So endianity should be out of scope here.

As to efficiency, in essence the compiler generates almost the same
shifts and masks for accessing bitfields as a human would do, so there
should be no difference, especially when we are not talking about
hot-path code.

And also, if endianity matters, there is always possibility to do
something like this (from drivers/atm/fore200e.h):

    /* bitfields endian games */

    #if defined(__LITTLE_ENDIAN_BITFIELD)
    #define BITFIELD2(b1, b2)                    b1; b2;
    #define BITFIELD3(b1, b2, b3)                b1; b2; b3;
    #define BITFIELD4(b1, b2, b3, b4)            b1; b2; b3; b4;
    #define BITFIELD5(b1, b2, b3, b4, b5)        b1; b2; b3; b4; b5;
    #define BITFIELD6(b1, b2, b3, b4, b5, b6)    b1; b2; b3; b4; b5; b6;
    #elif defined(__BIG_ENDIAN_BITFIELD)
    #define BITFIELD2(b1, b2)                                    b2; b1;
    #define BITFIELD3(b1, b2, b3)                            b3; b2; b1;
    #define BITFIELD4(b1, b2, b3, b4)                    b4; b3; b2; b1;
    #define BITFIELD5(b1, b2, b3, b4, b5)            b5; b4; b3; b2; b1;
    #define BITFIELD6(b1, b2, b3, b4, b5, b6)    b6; b5; b4; b3; b2; b1;
    #else
    #error unknown bitfield endianess
    #endif


    /* ATM cell header (minus HEC byte) */

    typedef struct atm_header {
        BITFIELD5(
            u32 clp :  1,    /* cell loss priority         */
            u32 plt :  3,    /* payload type               */
            u32 vci : 16,    /* virtual channel identifier */
            u32 vpi :  8,    /* virtual path identifier    */
            u32 gfc :  4     /* generic flow control       */
       )
    } atm_header_t;


to me, it's the sanest approach to C bitfields and endianity. Only we'd
better have those BITFIELDX in include/linux/bitfield.h


> context and I agree it looks ugly here , yet I personally usually avoid using bit fields. 
> 
> > 
> > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > Cc: Mike Thomas <rmthomas@sciolus.org>
> > Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> 
> 
> Acked-by:  Tomas Winkler <tomas.winkler@intel.com>

Did you try running it? How come this bug was undiscovered for so long?



On Mon, Jun 13, 2011 at 03:36:59PM +0300, Dan Carpenter wrote:
> It warms my heart to see a beautiful commit message like that,
> complete with diagrams.  :)

Thanks. It's a warm fuzzy feeling to receive feedback of this kind :)
thanks again.

> > 
> > P.S. why at all we use those mask/shifts? Why not use bitfields?
> 
> Because this is crap code from the staging dir.

I see, thanks.
Kirill
