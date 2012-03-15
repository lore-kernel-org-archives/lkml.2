Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2COFhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 01:37:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34716 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2COFhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 01:37:51 -0400
Date: Thu, 15 Mar 2012 16:37:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the tty tree with the xen-two tree
Message-Id: <20120315163740.c51aed0e3c10234fa3f37a46@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_16_37_40_+1100_k6Qqg1G4myzOx3RS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_16_37_40_+1100_k6Qqg1G4myzOx3RS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/hvc/hvc_xen.c between commits 02e19f9c7cac ("hvc_xen:
implement multiconsole support") and cf8e019b523a ("hvc_xen: introduce
HVC_XEN_FRONTEND") from the xen-two tree and commit d4e33fac2408
("serial: Kill off NO_IRQ") from the tty tree.

The code was moved around.  I fixed it up (see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/hvc/hvc_xen.c
index 83d5c88,a1b0a75..0000000
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@@ -299,262 -193,8 +299,262 @@@ static int xen_initial_domain_console_i
 =20
  void xen_console_resume(void)
  {
 -	if (xencons_irq)
 -		rebind_evtchn_irq(xen_start_info->console.domU.evtchn, xencons_irq);
 +	struct xencons_info *info =3D vtermno_to_xencons(HVC_COOKIE);
 +	if (info !=3D NULL && info->irq)
 +		rebind_evtchn_irq(info->evtchn, info->irq);
 +}
 +
 +static void xencons_disconnect_backend(struct xencons_info *info)
 +{
 +	if (info->irq > 0)
 +		unbind_from_irqhandler(info->irq, NULL);
 +	info->irq =3D 0;
 +	if (info->evtchn > 0)
 +		xenbus_free_evtchn(info->xbdev, info->evtchn);
 +	info->evtchn =3D 0;
 +	if (info->gntref > 0)
 +		gnttab_free_grant_references(info->gntref);
 +	info->gntref =3D 0;
 +	if (info->hvc !=3D NULL)
 +		hvc_remove(info->hvc);
 +	info->hvc =3D NULL;
 +}
 +
 +static void xencons_free(struct xencons_info *info)
 +{
 +	free_page((unsigned long)info->intf);
 +	info->intf =3D NULL;
 +	info->vtermno =3D 0;
 +	kfree(info);
 +}
 +
 +static int xen_console_remove(struct xencons_info *info)
 +{
 +	xencons_disconnect_backend(info);
 +	spin_lock(&xencons_lock);
 +	list_del(&info->list);
 +	spin_unlock(&xencons_lock);
 +	if (info->xbdev !=3D NULL)
 +		xencons_free(info);
 +	else {
 +		if (xen_hvm_domain())
 +			iounmap(info->intf);
 +		kfree(info);
 +	}
 +	return 0;
 +}
 +
 +#ifdef CONFIG_HVC_XEN_FRONTEND
 +static struct xenbus_driver xencons_driver;
 +
 +static int xencons_remove(struct xenbus_device *dev)
 +{
 +	return xen_console_remove(dev_get_drvdata(&dev->dev));
 +}
 +
 +static int xencons_connect_backend(struct xenbus_device *dev,
 +				  struct xencons_info *info)
 +{
 +	int ret, evtchn, devid, ref, irq;
 +	struct xenbus_transaction xbt;
 +	grant_ref_t gref_head;
 +	unsigned long mfn;
 +
 +	ret =3D xenbus_alloc_evtchn(dev, &evtchn);
 +	if (ret)
 +		return ret;
 +	info->evtchn =3D evtchn;
 +	irq =3D bind_evtchn_to_irq(evtchn);
 +	if (irq < 0)
 +		return irq;
 +	info->irq =3D irq;
 +	devid =3D dev->nodename[strlen(dev->nodename) - 1] - '0';
 +	info->hvc =3D hvc_alloc(xenbus_devid_to_vtermno(devid),
 +			irq, &domU_hvc_ops, 256);
 +	if (IS_ERR(info->hvc))
 +		return PTR_ERR(info->hvc);
 +	if (xen_pv_domain())
 +		mfn =3D virt_to_mfn(info->intf);
 +	else
 +		mfn =3D __pa(info->intf) >> PAGE_SHIFT;
 +	ret =3D gnttab_alloc_grant_references(1, &gref_head);
 +	if (ret < 0)
 +		return ret;
 +	info->gntref =3D gref_head;
 +	ref =3D gnttab_claim_grant_reference(&gref_head);
 +	if (ref < 0)
 +		return ref;
 +	gnttab_grant_foreign_access_ref(ref, info->xbdev->otherend_id,
 +			mfn, 0);
 +
 + again:
 +	ret =3D xenbus_transaction_start(&xbt);
 +	if (ret) {
 +		xenbus_dev_fatal(dev, ret, "starting transaction");
 +		return ret;
 +	}
 +	ret =3D xenbus_printf(xbt, dev->nodename, "ring-ref", "%d", ref);
 +	if (ret)
 +		goto error_xenbus;
 +	ret =3D xenbus_printf(xbt, dev->nodename, "port", "%u",
 +			    evtchn);
 +	if (ret)
 +		goto error_xenbus;
 +	ret =3D xenbus_printf(xbt, dev->nodename, "type", "ioemu");
 +	if (ret)
 +		goto error_xenbus;
 +	ret =3D xenbus_transaction_end(xbt, 0);
 +	if (ret) {
 +		if (ret =3D=3D -EAGAIN)
 +			goto again;
 +		xenbus_dev_fatal(dev, ret, "completing transaction");
 +		return ret;
 +	}
 +
 +	xenbus_switch_state(dev, XenbusStateInitialised);
 +	return 0;
 +
 + error_xenbus:
 +	xenbus_transaction_end(xbt, 1);
 +	xenbus_dev_fatal(dev, ret, "writing xenstore");
 +	return ret;
 +}
 +
 +static int __devinit xencons_probe(struct xenbus_device *dev,
 +				  const struct xenbus_device_id *id)
 +{
 +	int ret, devid;
 +	struct xencons_info *info;
 +
 +	devid =3D dev->nodename[strlen(dev->nodename) - 1] - '0';
 +	if (devid =3D=3D 0)
 +		return -ENODEV;
 +
 +	info =3D kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
 +	if (!info)
 +		goto error_nomem;
 +	dev_set_drvdata(&dev->dev, info);
 +	info->xbdev =3D dev;
 +	info->vtermno =3D xenbus_devid_to_vtermno(devid);
 +	info->intf =3D (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 +	if (!info->intf)
 +		goto error_nomem;
 +
 +	ret =3D xencons_connect_backend(dev, info);
 +	if (ret < 0)
 +		goto error;
 +	spin_lock(&xencons_lock);
 +	list_add_tail(&info->list, &xenconsoles);
 +	spin_unlock(&xencons_lock);
 +
 +	return 0;
 +
 + error_nomem:
 +	ret =3D -ENOMEM;
 +	xenbus_dev_fatal(dev, ret, "allocating device memory");
 + error:
 +	xencons_disconnect_backend(info);
 +	xencons_free(info);
 +	return ret;
 +}
 +
 +static int xencons_resume(struct xenbus_device *dev)
 +{
 +	struct xencons_info *info =3D dev_get_drvdata(&dev->dev);
 +
 +	xencons_disconnect_backend(info);
 +	memset(info->intf, 0, PAGE_SIZE);
 +	return xencons_connect_backend(dev, info);
 +}
 +
 +static void xencons_backend_changed(struct xenbus_device *dev,
 +				   enum xenbus_state backend_state)
 +{
 +	switch (backend_state) {
 +	case XenbusStateReconfiguring:
 +	case XenbusStateReconfigured:
 +	case XenbusStateInitialising:
 +	case XenbusStateInitialised:
 +	case XenbusStateUnknown:
 +	case XenbusStateClosed:
 +		break;
 +
 +	case XenbusStateInitWait:
 +		break;
 +
 +	case XenbusStateConnected:
 +		xenbus_switch_state(dev, XenbusStateConnected);
 +		break;
 +
 +	case XenbusStateClosing:
 +		xenbus_frontend_closed(dev);
 +		break;
 +	}
 +}
 +
 +static const struct xenbus_device_id xencons_ids[] =3D {
 +	{ "console" },
 +	{ "" }
 +};
 +
 +
 +static DEFINE_XENBUS_DRIVER(xencons, "xenconsole",
 +	.probe =3D xencons_probe,
 +	.remove =3D xencons_remove,
 +	.resume =3D xencons_resume,
 +	.otherend_changed =3D xencons_backend_changed,
 +);
 +#endif /* CONFIG_HVC_XEN_FRONTEND */
 +
 +static int __init xen_hvc_init(void)
 +{
 +	int r;
 +	struct xencons_info *info;
 +	const struct hv_ops *ops;
 +
 +	if (!xen_domain())
 +		return -ENODEV;
 +
 +	if (xen_initial_domain()) {
 +		ops =3D &dom0_hvc_ops;
 +		r =3D xen_initial_domain_console_init();
 +		if (r < 0)
 +			return r;
 +		info =3D vtermno_to_xencons(HVC_COOKIE);
 +	} else {
 +		ops =3D &domU_hvc_ops;
 +		if (xen_hvm_domain())
 +			r =3D xen_hvm_console_init();
 +		else
 +			r =3D xen_pv_console_init();
 +		if (r < 0)
 +			return r;
 +
 +		info =3D vtermno_to_xencons(HVC_COOKIE);
 +		info->irq =3D bind_evtchn_to_irq(info->evtchn);
 +	}
 +	if (info->irq < 0)
- 		info->irq =3D 0; /* NO_IRQ */
++		info->irq =3D 0;
 +	else
 +		irq_set_noprobe(info->irq);
 +
 +	info->hvc =3D hvc_alloc(HVC_COOKIE, info->irq, ops, 256);
 +	if (IS_ERR(info->hvc)) {
 +		r =3D PTR_ERR(info->hvc);
 +		spin_lock(&xencons_lock);
 +		list_del(&info->list);
 +		spin_unlock(&xencons_lock);
 +		if (info->irq)
 +			unbind_from_irqhandler(info->irq, NULL);
 +		kfree(info);
 +		return r;
 +	}
 +
 +	r =3D 0;
 +#ifdef CONFIG_HVC_XEN_FRONTEND
 +	r =3D xenbus_register_frontend(&xencons_driver);
 +#endif
 +	return r;
  }
 =20
  static void __exit xen_hvc_fini(void)

--Signature=_Thu__15_Mar_2012_16_37_40_+1100_k6Qqg1G4myzOx3RS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYYAkAAoJEECxmPOUX5FEEugP/R4Val93bddIounQhMZgXv/l
Q6tSTiDG0D+PSfM85ArBXjv/y84Cu5pBaUEOBDiidzNbmFPeirfcBVV7vZoD5hHx
F92lTlzbYdt/B67XPt6SHUyTnpWZA9AGZsU0FUJAUihQUUufjzRYqOScrin4dhKm
9QQHKyA27loy60jveqoAgBcsuUxciNl0/yKFi5alR/8/ulqc/rvNxgfeEoN0qZ30
u1H+v3lxlI/3mSitDoWZRs4PYH9vatFxtB1XRoldqwqjD14Df8rXK47k2TqdQxG5
RXbv6VnQqa7e6UgfYAKuwO2drVYVKuKGfZufqc9EI7nXsyqgFeE5cYdPvcxbzzkA
CMF+xRcUVGFaUU08Uzzmz3Fe7neFqZR4gAw7/oidE/kGNbhwOCdhQ05+lke0mIRZ
j5QKdA9pgtX5wzARjC1ZSZzTvFU1OpqTxLtPPejuO1fM0PwWvfchEFsaAJSqqnJv
ic3L6v9dnGene7CQn1jvMyoehyk784eEVBWpVlYPNtCz+WpsdnhG1uzTTQsLW4U+
t0Gl73Ytq3XWPrRXAT3WrgXDIUNiljiRFl4TCgCh/deXkKzXft1x0UwAkVIb6hWW
WMt4HjGfnZic9Z0oBYbazN02tBdAmPMdmJedhTaeWIZhqLhKYd7DBT2tgHPNwAjw
4U5GbkK1cSzMMBv7A5mo
=mJTN
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_16_37_40_+1100_k6Qqg1G4myzOx3RS--
