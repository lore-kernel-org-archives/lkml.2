Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161251Ab2JXWEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:04:33 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35687 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746Ab2JXWEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:04:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org, liuj97@gmail.com
Subject: Re: [PATCH 1/2] ACPI: Fix stale pointer access to flags.lockable
Date: Thu, 25 Oct 2012 00:08:26 +0200
Message-ID: <1588310.r9ljFmyoH6@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350482142.28185.0.camel@misato.fc.hp.com>
References: <1350318870-5700-1-git-send-email-toshi.kani@hp.com> <507E090C.2070607@jp.fujitsu.com> <1350482142.28185.0.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 of October 2012 07:55:42 Toshi Kani wrote:
> On Wed, 2012-10-17 at 10:25 +0900, Yasuaki Ishimatsu wrote:
> > 2012/10/16 1:34, Toshi Kani wrote:
> > > During hot-remove, acpi_bus_hot_remove_device() calls ACPI _LCK
> > > method when device->flags.lockable is set. However, this device
> > > pointer is stale since the target acpi_device object has been
> > > already kfree'd by acpi_bus_trim().
> > > 
> > > The flags.lockable indicates whether or not this ACPI object
> > > implements _LCK method. Fix the stable pointer access by replacing
> > > it with acpi_get_handle() to check if _LCK is implemented.
> > > 
> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > 
> > Looks good to me.
> > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> Thanks Yasuaki for reviewing!

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


> > > ---
> > >   drivers/acpi/scan.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > > index 1fcb867..ed87f43 100644
> > > --- a/drivers/acpi/scan.c
> > > +++ b/drivers/acpi/scan.c
> > > @@ -97,6 +97,7 @@ void acpi_bus_hot_remove_device(void *context)
> > >   	struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
> > >   	struct acpi_device *device;
> > >   	acpi_handle handle = ej_event->handle;
> > > +	acpi_handle temp;
> > >   	struct acpi_object_list arg_list;
> > >   	union acpi_object arg;
> > >   	acpi_status status = AE_OK;
> > > @@ -117,13 +118,16 @@ void acpi_bus_hot_remove_device(void *context)
> > >   		goto err_out;
> > >   	}
> > >   
> > > +	/* device has been freed */
> > > +	device = NULL;
> > > +
> > >   	/* power off device */
> > >   	status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
> > >   	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
> > >   		printk(KERN_WARNING PREFIX
> > >   				"Power-off device failed\n");
> > >   
> > > -	if (device->flags.lockable) {
> > > +	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &temp))) {
> > >   		arg_list.count = 1;
> > >   		arg_list.pointer = &arg;
> > >   		arg.type = ACPI_TYPE_INTEGER;
> > > 
> > 
> > 
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
