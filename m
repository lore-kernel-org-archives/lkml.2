Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2LDKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:30:17 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:44537 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2LDKaM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 4 Dec 2012 05:30:12 -0500
Message-Id: <50BDDEBF02000078000ADAAC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 04 Dec 2012 10:30:07 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>, <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: do not leak mode property
References: <1354563168-6609-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1354563168-6609-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.12.12 at 20:32, Olaf Hering <olaf@aepfle.de> wrote:
> be->mode is obtained from xenbus_read, which does a kmalloc for the
> message body. The short string is never released, so do it on blkbk
> remove.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
> 
> !! Not compile tested !!
> 
>  drivers/block/xen-blkback/xenbus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c 
> b/drivers/block/xen-blkback/xenbus.c
> index f58434c..a6585a4 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -366,6 +366,7 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
>  		be->blkif = NULL;
>  	}
>  
> +	kfree(be->mode);

This looks necessary but insufficient - there's nothing really
preventing backend_changed() from being called more than once
for a given device (is simply the handler of xenbus watch). Hence
I think either that function needs to be guarded against multiple
execution (e.g. by removing the watch from that function itself,
if that's permitted by xenbus), or to properly deal with the
effects this has (including but probably not limited to the leaking
of be->mode).

Jan

>  	kfree(be);
>  	dev_set_drvdata(&dev->dev, NULL);
>  	return 0;
> -- 
> 1.8.0.1



