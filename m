Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0FBNru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:47:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53355 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755062Ab0FBNrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:47:49 -0400
Date: Wed, 2 Jun 2010 09:47:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] USB-BKL: Remove BKL use in uhci-debug
In-Reply-To: <1275426285-9088-5-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1006020944450.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Arnd Bergmann wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> BKL was not really needed, just came from earlier push downs.

Yes.

> The only part that's a bit dodgy is the lseek function. Would
> need another lock or atomic access to fpos on 32bit?
> Better to have a libfs lseek

It doesn't matter.  Anyone who tries to do lseeks on this file 
from two different threads, simultaneously, deserves what they get.

> @@ -539,11 +534,11 @@ static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
>  		new = file->f_pos + off;
>  		break;
>  	}
> +
> +	/* XXX: Can size shrink? */
>  	if (new < 0 || new > up->size) {
> -		unlock_kernel();
>  		return -EINVAL;
>  	}
> -	unlock_kernel();
>  	return (file->f_pos = new);
>  }

This comment isn't needed; the size cannot change after the file has 
been opened.

Alan Stern

