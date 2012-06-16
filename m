Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2FPNXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:23:42 -0400
Received: from canardo.mork.no ([148.122.252.1]:35953 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab2FPNXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:23:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is not a modulo of the size of section __mod_usb_device_table=44.
Organization: m
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
	<20120615201021.GB14544@kroah.com>
	<CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
	<20120615231220.GC8205@kroah.com>
Date: Sat, 16 Jun 2012 15:23:31 +0200
In-Reply-To: <20120615231220.GC8205@kroah.com> (Greg Kroah-Hartman's message
	of "Fri, 15 Jun 2012 16:12:20 -0700")
Message-ID: <87lijns84s.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Fri, Jun 15, 2012 at 11:02:55PM +0200, Geert Uytterhoeven wrote:
>
>> As "kernel_ulong_t  driver_info" is no longer naturally aligned, the
>> compiler will
>> add implicit padding. But the padding depends on the architecture.
>
> Ah, so we were "lucky" before, nice.

I don't really believe in luck :-)  I think someone has been really
smart here.  Maybe too smart...


>> It can be fixed by adding explicit padding. Probably it should be padded by
>> 7 bytes (not 3), as kernel_ulong_t may require 8-byte alignment on some 64-bit
>> platforms. Or by an explicit alignment attribute.
>> 
>> See also
>>   * commit 8175fe2dda1c93a9c596921c8ed4a0b4baccdefe ("HID: fix
>> hid_device_id for cross compiling")
>>   * commit 7492d4a416d68ab4bd254b36ffcc4e0138daa8ff ("sdio: fix module
>> device table definition for m68k")
>>   * commit 9e2d3cd34a159948dc753a14573e16bffc04dba8 ("[PATCH]
>> mod_devicetable.h fixes")
>
> So would the patch below fix this?  It should force alignment of the
> driver_data field, which is all you want here, right?
>
>> Still, there's a bug in file2alias (which is compiled by the host
>> compiler), in that
>> it may use different padding than the target platform when cross-compiling.
>
> That's not good, but outside of this specific issue, right?  Have we
> just been fortunate it hasn't really hit us yet?
>
> thanks,
>
> greg k-h
>
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 7771d45..6955045 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -122,7 +122,8 @@ struct usb_device_id {
>  	__u8		bInterfaceNumber;
>  
>  	/* not matched against */
> -	kernel_ulong_t	driver_info;
> +	kernel_ulong_t	driver_info
> +		__attribute__((aligned(sizeof(kernel_ulong_t))));
>  };


This feels a lot like papering over the real problem.  It will solve
this instance, but the list of such previous "paper work" that Geert
provided should be enough evidence that this will happen again the next
time someone modifies a device id struct for some subsystem.

And adding forced aligment here feels wrong since there is no good
reason why the (target) compiler shouldn't know the proper alignment for
this structure, is there? OK, "feels wrong" is not a good argument. But
it would be better to solve this problem once and for all.

AFAIK (which admittedly is not much wrt cross building) there is no way
we can make the host built file2alias know the proper aligment for the
structure in the target built modules.  That's the background for this
fix: 

commit 4ce6efed48d736e3384c39ff87bda723e1f8e041
Author: Sam Ravnborg <sam@uranus.ravnborg.org>
Date:   Sun Mar 23 21:38:54 2008 +0100

    kbuild: soften modpost checks when doing cross builds
    
    The module alias support in the kernel have a consistency
    check where it is checked that the size of a structure
    in the kernel and on the build host are the same.
    For cross builds this check does not make sense so detect
    when we do cross builds and silently skip the check in these
    situations.
    This fixes a build bug for a wireless driver when cross building
    for arm.



What I'm now wondering is why didn't this kick in?  I believe we should
find and fix that instead of playing around with the in-kernel structure
alignments.  If that's possible.

BTW, thanks for finding and reporting this at such an early stage,
Geert.


Bjørn
