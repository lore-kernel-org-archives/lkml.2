Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab2DBGzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:55:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:24695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2DBGzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="124372734"
Date: Mon, 2 Apr 2012 09:55:27 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bluetooth: fix deadlock on device reset and power down
Message-ID: <20120402065525.GA29687@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Alexander Holler <holler@ahsoftware.de>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4F77055A.2070502@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F77055A.2070502@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Sat, Mar 31, 2012 at 03:23:38PM +0200, Alexander Holler wrote:
> I've experienced a deadlock on shutdown using kernel 3.3 and tracked
> it down. Because I'm not very familiar with the bluetooth stack I'm
> not sure if the below patch is correct, but it fixed the problem
> here.

Could you please attach deadlock dump?

> 
> Commit 09fd0de5bd8f8ef3317e5365f92f1a13dcd89aa9 introduced a deadlock:
> 
> bluetoothd calls ioctl HCIDEVDOWN
>     hci_sock_ioctl()
>         hci_dev_close()
>             hci_dev_do_close()
>                 hci_dev_lock(hdev);
>                 inquiry_cache_flush();
>                 hci_conn_hash_flush();
>                     hci_conn_del()
>                         cancel_delayed_work_sync()
>                             hci_conn_timeout()
>                                 hci_dev_lock(hdev); /* DEADLOCK */

I am actually not sure that hci_conn_timeout locks hdev. Why do you think
so?

Best regards 
Andrei Emeltchenko 

>                 hci_dev_unlock(hdev);
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  net/bluetooth/hci_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5aeb624..3428036 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -629,8 +629,8 @@ static int hci_dev_do_close(struct hci_dev *hdev)
> 
>  	hci_dev_lock(hdev);
>  	inquiry_cache_flush(hdev);
> -	hci_conn_hash_flush(hdev);
>  	hci_dev_unlock(hdev);
> +	hci_conn_hash_flush(hdev);
> 
>  	hci_notify(hdev, HCI_DEV_DOWN);
> 
> @@ -713,8 +713,8 @@ int hci_dev_reset(__u16 dev)
> 
>  	hci_dev_lock(hdev);
>  	inquiry_cache_flush(hdev);
> -	hci_conn_hash_flush(hdev);
>  	hci_dev_unlock(hdev);
> +	hci_conn_hash_flush(hdev);
> 
>  	if (hdev->flush)
>  		hdev->flush(hdev);

