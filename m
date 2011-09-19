Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1ISVqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:46:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57196 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1ISVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:46:12 -0400
Date: Mon, 19 Sep 2011 22:39:28 +0100
From: James Hogan <james@albanarts.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC PATCH] hidraw: protect hidraw_disconnect() better
Message-ID: <20110919213928.GA1957@balrog>
References: <4E7754DA.30108@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7754DA.30108@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 03:42:34PM +0100, James Hogan wrote:
> The following patch I think fixes a bug in hidraw_disconnect(). However I'm unsure whether it's safe to call device_destroy with the minors_lock held. can the device_destroy ever end up calling hidraw_release, resulting in recursive locking? I've never seen that happen, but I don't understand the inner workings on device_destroy.
> 
> The bug can be revealed with SLAB debugging on (poisoning free'd memory), and:
> cat /dev/hw_random > /dev/hidraw0
> then unplug the device. the disconnect is called, the device_destroy seems to cause "cat"'s write syscall to return a timeout error, so it exits/closes, which frees the hidraw because hidraw->exists==0, then the disconnect function writes to hidraw_table[hidraw->minor] which blows up because hidraw->minor has been poisoned with 0x6b6b6b6b.
> 
> This has been tested on 2.6.39 and appears to fix it, and I'll hopefully be able to test it on the latest kernel tonight.

I have now tested this on a PC with slub_debug on the command line and
Linus' latest tree (3.1-rc6):
$ while [ -e /dev/hidraw0 ]; do echo hello; done > /dev/hidraw0
and unplugged the device.

Before the patch it caused a fault with callstack etc. the first time I
tried it. I tried 30 times with the patch and got no such errors. I
haven't tried anything more hidraw related though.

Cheers
James

> 
> Cheers
> James
> 
> The function hidraw_disconnect() only acquires the hidraw minors_lock
> when clearing the entry in hidraw_table. However the device_destroy()
> call can cause a userland read/write to return with an error. It may
> cause the program to release the file descripter before the disconnect
> is finished. hidraw_disconnect() has already set hidraw->exist to 0,
> which makes hidraw_release() kfree the hidraw structure, which
> hidraw_disconnect() continues to access and even tries to kfree again.
> Similarly if a hidraw_release() occurs after setting hidraw->exist to 0,
> the same thing can happen.
> 
> This is fixed by expanding the mutex critical section to cover the whole
> function from setting hidraw->exist to 0 to freeing the hidraw
> structure, preventing a hidraw_release() from interfering.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  drivers/hid/hidraw.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index c79578b..a8c2b7b 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -510,13 +510,12 @@ void hidraw_disconnect(struct hid_device *hid)
>  {
>  	struct hidraw *hidraw = hid->hidraw;
>  
> +	mutex_lock(&minors_lock);
>  	hidraw->exist = 0;
>  
>  	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
>  
> -	mutex_lock(&minors_lock);
>  	hidraw_table[hidraw->minor] = NULL;
> -	mutex_unlock(&minors_lock);
>  
>  	if (hidraw->open) {
>  		hid_hw_close(hid);
> @@ -524,6 +523,7 @@ void hidraw_disconnect(struct hid_device *hid)
>  	} else {
>  		kfree(hidraw);
>  	}
> +	mutex_unlock(&minors_lock);
>  }
>  EXPORT_SYMBOL_GPL(hidraw_disconnect);
>  
> -- 
> 1.7.2.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
