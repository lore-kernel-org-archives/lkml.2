Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0JCP7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 11:59:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49277 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752495Ab0JCP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 11:59:47 -0400
Date: Sun, 3 Oct 2010 11:59:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Rahul Ruikar <rahul.ruikar@gmail.com>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: file_storage: Fix error path
In-Reply-To: <1286081717-2757-1-git-send-email-rahul.ruikar@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1010031155150.26676-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, Rahul Ruikar wrote:

> call put_device() when device_register() fails.
> 
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/gadget/file_storage.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index a857b7a..2c94318 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3413,6 +3413,7 @@ static int __ref fsg_bind(struct usb_gadget *gadget)
>  
>  		if ((rc = device_register(&curlun->dev)) != 0) {
>  			INFO(fsg, "failed to register LUN%d: %d\n", i, rc);
> +			put_device(&curlun->dev);
>  			goto out;
>  		}
>  		if ((rc = device_create_file(&curlun->dev,

I'm afraid this is wrong as well.  You need to move the 
"kref_get(&fsg->ref);" line up before the device_register call; 
otherwise the lun_release routine will do an unbalanced kref_put.  In 
fact there is a similar bug in the original code, in the failure path 
for the device_create_file calls.

This seems to be a common pattern of mistakes in your patches.  Maybe
you should go through and check all of them; make sure that everything
the release routine _undoes_ is certain to be _done_ before the
device_register call.

Alan Stern

