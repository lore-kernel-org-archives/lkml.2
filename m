Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0LMOQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:16:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61556 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab0LMOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YsYiNV90DppLBLtUZroKiILaWiqynEjvJJwF6pzTZk7IOGnsZ7RM457a9QNQDdwCRV
         UT37MqXemnWp3lgpJDvc2nyIRrBjWdZA1rL+wpr/kS7+Jucsjm8Gdb8kzjsUhUKyera4
         FT14kh4Of4qDZLWWL1CmIyxSdPMqHuIxdhSWs=
Subject: Re: [PATCH 1/8] Staging: vme_ca91cx42: fix compiler warning on
 64-bit build
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D06248C.7010904@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
	 <4D06248C.7010904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 23:16:08 +0900
Message-ID: <1292249768.1673.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-13 (월), 14:50 +0100, Jiri Slaby:
> On 12/13/2010 02:16 PM, Namhyung Kim wrote:
> > @@ -867,13 +869,13 @@ ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
> >  	 * maximal configured data cycle is used and splits it
> >  	 * automatically for non-aligned addresses.
> >  	 */
> > -	if ((int)addr & 0x1) {
> > +	if (check_aligned(addr, 0x1)) {
> >  		*(u8 *)buf = ioread8(addr);
> >  		done += 1;
> >  		if (done == count)
> >  			goto out;
> >  	}
> > -	if ((int)addr & 0x2) {
> > +	if (check_aligned(addr, 0x2)) {
> 
> It should be IS_ALIGNED(addr, 2) and IS_ALIGNED(addr, 4) respectively
> anyway...
> 

That's what I was looking for, thanks. :)


> > @@ -980,7 +982,7 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
> >  	/* Lock image */
> >  	spin_lock(&(image->lock));
> >  
> > -	pci_addr = (u32)image->kern_base + offset;
> > +	pci_addr = (u32)(unsigned long)image->kern_base + offset;
> 
> No, do not hide bugs here. I see no reason why address returned from
> ioremap couldn't be larger than 32 bits. Actually it is always on 64bit.
> 
> Actually what this code tries to do? Shouldn't it be physical address of
> the PCI resource instead?
> 
> regards,

Sounds reasonable.


-- 
Regards,
Namhyung Kim


