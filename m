Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2HOUQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:16:07 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39005 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab2HOUQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:16:02 -0400
Date: Wed, 15 Aug 2012 15:15:27 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Sirrix AG <tpmdd@sirrix.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Rajiv Andrade <mail@srajiv.net>, Seiji Munetoh <munetoh@jp.ibm.com>,
        Stefan Berger <stefanb@us.ibm.com>,
        Reiner Sailer <sailer@watson.ibm.com>, Kylene Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] tpm: Do not dereference NULL pointer if
 acpi_os_map_memory() fails.
Message-ID: <20120815201527.GC27618@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1208072247490.3227@swampdragon.chaosbits.net>
 <20120808180750.GA24016@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808180750.GA24016@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081520-8974-0000-0000-00000C3ACC57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

> > Unfortunately we just get NULL back, so we can't really tell the user
> > exactely what went wrong, but we can at least avoid crashing and
> > return an error (-EIO seemed more generic and more suitable here than
> > -ENOMEM or something else, so I picked that).
> 
> Thanks Jesper. I'd made some updates to tpm_bios.c recently but this
> should still apply. I'll let you know if not.

  Of course I'm wrong here, this code moved over into tpm_acpi.c. If you
can resubmit on top of my staging tree, I will apply it there.

git://github.com/shpedoikal/linux.git v3.6-rc1-tpmdd-staging

> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/char/tpm/tpm_bios.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> >   Compile tested only.
> > 
> > diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
> > index 0636520..0c5c274 100644
> > --- a/drivers/char/tpm/tpm_bios.c
> > +++ b/drivers/char/tpm/tpm_bios.c
> > @@ -410,6 +410,11 @@ static int read_log(struct tpm_bios_log *log)
> >  	log->bios_event_log_end = log->bios_event_log + len;
> > 
> >  	virt = acpi_os_map_memory(start, len);
> > +	if (!virt) {

  Also please add kfree(log->bios_event_log); in this error path.

Thanks,
Kent

> > +		printk("%s: ERROR - Unable to map memory\n",
> > +			__func__);
> > +		return -EIO;
> > +	}
> > 
> >  	memcpy(log->bios_event_log, virt, len);
> > 
> > -- 
> > 1.7.11.4
> > 
> > 
> > -- 
> > Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> > Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> > Plain text mails only, please.
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

