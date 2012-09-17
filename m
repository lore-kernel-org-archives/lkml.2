Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2IQNLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:11:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33152 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2IQNLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:11:51 -0400
Date: Mon, 17 Sep 2012 14:16:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [static analysis] memory corruption in tty/synclink.c on 64bit
Message-ID: <20120917141636.67e4b924@pyramind.ukuu.org.uk>
In-Reply-To: <20120917111819.GA5769@elgon.mountain>
References: <20120917111819.GA5769@elgon.mountain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 14:18:19 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> I don't think anyone really cares about this but just for laughs here
> is the warning:
> 
> drivers/tty/synclink.c:5418 usc_process_rxoverrun_sync() warn: potential memory corrupting cast 8 vs 2 bytes
> drivers/tty/synclink.c:6414 mgsl_reset_tx_dma_buffers() warn: potential memory corrupting cast 8 vs 2 bytes
> drivers/tty/synclink.c:6455 mgsl_reset_rx_dma_buffers() warn: potential memory corrupting cast 8 vs 2 bytes
> drivers/tty/synclink.c:6500 mgsl_free_rx_frame_buffers() warn: potential memory corrupting cast 8 vs 2 bytes
> 
>   6489                  /* reset current buffer for reuse */
>   6490  //              pBufEntry->status = 0;
>   6491  //              pBufEntry->count = DMABUFFERSIZE;
>   6492                  *((unsigned long *)&(pBufEntry->count)) = DMABUFFERSIZE;
> 
> It looks like the commented out code is the correct code and the code
> on line 6492 is the "faster" version?  My static checker complains that
> it would corrupt the next struct elements on 64 bit.  Also it only works
> on little endian systems.
> 
> typedef struct _DMABUFFERENTRY
> {
>         u32 phys_addr;  /* 32-bit flat physical address of data buffer */
>         volatile u16 count;     /* buffer size/data count */
>         volatile u16 status;    /* Control/status field */
>         volatile u16 rcc;       /* character count field */
>         u16 reserved;   /* padding required by 16C32 */
> 
> This was there in the original code when it was merged in 2.2.5pre1.

Should probably be changed to *((u32 *) at least. As it happens as far as
I can see its harmless however.

