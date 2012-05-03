Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2ECEoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 00:44:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46599 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2ECEoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 00:44:21 -0400
Date: Thu, 3 May 2012 14:44:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20120503144410.3aab6165a98e4f36bf50fcf5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_May_2012_14_44_10_+1000_RxQTlBB6OJu27XbT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_May_2012_14_44_10_+1000_RxQTlBB6OJu27XbT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-tegra.c between commit ebf20de45304 ("EHCI: update
PM methods in ehci-tegra.c") from the usb.current tree and commit
fe375774bd88 ("usb: host: tegra: code clean up") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-tegra.c
index f214a80,4c1eb61..0000000
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@@ -319,7 -423,37 +308,7 @@@ static int tegra_ehci_setup(struct usb_
  	return retval;
  }
 =20
- struct temp_buffer {
 -#ifdef CONFIG_PM
 -static int tegra_ehci_bus_suspend(struct usb_hcd *hcd)
 -{
 -	struct tegra_ehci_hcd *tegra =3D dev_get_drvdata(hcd->self.controller);
 -	int error_status =3D 0;
 -
 -	error_status =3D ehci_bus_suspend(hcd);
 -	if (!error_status && tegra->power_down_on_bus_suspend) {
 -		tegra_usb_suspend(hcd);
 -		tegra->bus_suspended =3D 1;
 -	}
 -
 -	return error_status;
 -}
 -
 -static int tegra_ehci_bus_resume(struct usb_hcd *hcd)
 -{
 -	struct tegra_ehci_hcd *tegra =3D dev_get_drvdata(hcd->self.controller);
 -
 -	if (tegra->bus_suspended && tegra->power_down_on_bus_suspend) {
 -		tegra_usb_resume(hcd);
 -		tegra->bus_suspended =3D 0;
 -	}
 -
 -	tegra_usb_phy_preresume(tegra->phy);
 -	tegra->port_resuming =3D 1;
 -	return ehci_bus_resume(hcd);
 -}
 -#endif
 -
+ struct dma_aligned_buffer {
  	void *kmalloc_ptr;
  	void *old_xfer_buffer;
  	u8 data[0];
@@@ -426,14 -548,20 +403,20 @@@ static const struct hc_driver tegra_ehc
  	.endpoint_reset		=3D ehci_endpoint_reset,
  	.get_frame_number	=3D ehci_get_frame,
  	.hub_status_data	=3D ehci_hub_status_data,
- 	.hub_control		=3D tegra_ehci_hub_control,
  	.clear_tt_buffer_complete =3D ehci_clear_tt_buffer_complete,
+ 	.relinquish_port	=3D ehci_relinquish_port,
+ 	.port_handed_over	=3D ehci_port_handed_over,
+=20
+ 	/* modified ehci functions for tegra */
+ 	.reset			=3D tegra_ehci_setup,
+ 	.shutdown		=3D tegra_ehci_shutdown,
+ 	.map_urb_for_dma	=3D tegra_ehci_map_urb_for_dma,
+ 	.unmap_urb_for_dma	=3D tegra_ehci_unmap_urb_for_dma,
+ 	.hub_control		=3D tegra_ehci_hub_control,
  #ifdef CONFIG_PM
 -	.bus_suspend		=3D tegra_ehci_bus_suspend,
 -	.bus_resume		=3D tegra_ehci_bus_resume,
 +	.bus_suspend		=3D ehci_bus_suspend,
 +	.bus_resume		=3D ehci_bus_resume,
  #endif
- 	.relinquish_port	=3D ehci_relinquish_port,
- 	.port_handed_over	=3D ehci_port_handed_over,
  };
 =20
  static int setup_vbus_gpio(struct platform_device *pdev)

--Signature=_Thu__3_May_2012_14_44_10_+1000_RxQTlBB6OJu27XbT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPog0aAAoJEECxmPOUX5FETE8P/0s9fIq5U8976G+BvlV5Zupv
KguunRV+kuqnywPTVo/pKiWHmW+H0FIJnF2LgWUBcRB74G2L2RcOcQIsYhC7HFay
CW/k8INybcDP+vN9oyiUucvrKqDnox+cqBqE2iNdzHG3HQfdpaxq+5b0x8INtIli
56FshKd43sInTN6rmYCns0QN2r+rtTiffiwmeBdyC9tc0xiSjPvJKeGKprDVFbk2
Y3eSg3ThTJ/ByYEJNgy0XByCRMmJZ6zdb981gXIRkccflb4wpKCvni6ddJnQVaA9
UsGhd/BYOe30zU2wh8lJbly9H350yynAvSW8+zoodjYTy2ANqOMQ7yd9rVjriuF/
sWb9xXTggl3G+j1+GxHHKvC0A4fKTd2Mep82fgnZvwjyagGiuvzUPpmSeZiKP901
qFMAQMYw224Kf5erR1pFh2SWlDixquRtArUXNVA/ixiXHrQveSkW+C5tlUrzQkXh
WCaXBfsgab4TUQbVVRKwpvB527LZjSotk3P0Jx60VmypFk4J6p0UkbM5eFF97BzS
GJtJNpYx6uHYvTvf3/UZP0hR/iLAgxXFuqwWNPy6ZsH0P60i1Q6bVf9otdFy8ncQ
u9jm/xbpeJWdsKIIk6l3Prfjfy6rhzO+3OdFxM1Ga8XGOpJoUaAUavFk7RMK58pZ
qkYMBuVl0fZjYW/A9SIq
=FefH
-----END PGP SIGNATURE-----

--Signature=_Thu__3_May_2012_14_44_10_+1000_RxQTlBB6OJu27XbT--
