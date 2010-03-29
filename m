Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0C2AYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 20:24:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40797 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381Ab0C2AYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 20:24:53 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269821357.8653.231.camel@localhost>
References: <alpine.DEB.2.00.1003282040480.4731@ernie.pinecrest>
	 <1269821357.8653.231.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sYkyPshXPN5NT1RvlzNu"
Date: Mon, 29 Mar 2010 01:24:45 +0100
Message-ID: <1269822285.8653.251.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] rt28xx: Make PCI_{MAP,UNMAP}_SINGLE type-safe
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sYkyPshXPN5NT1RvlzNu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

To avoid recurrence of bugs such as <http://bugs.debian.org/575726>,
change the type of the first parameter to linux_pci_{map,unmap}_single()
from void * to struct rt_rtmp_adapter *.  Also do not define the macros
PCI_{MAP,UNMAP}_SINGLE() when building the rt2870sta driver; they are
not used and if they were that would be a bug.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>=20
---
 drivers/staging/rt2860/rt_linux.h    |   14 +++++---------
 drivers/staging/rt2860/rt_pci_rbus.c |   12 ++++--------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_=
linux.h
index a7c540f..b370fb2 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -455,10 +455,11 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, un=
signed int SrcBufLen);
  * Device DMA Access related definitions and data structures.
  *************************************************************************=
*********/
 #ifdef RTMP_MAC_PCI
-dma_addr_t linux_pci_map_single(void *handle, void *ptr, size_t size,
-				int sd_idx, int direction);
-void linux_pci_unmap_single(void *handle, dma_addr_t dma_addr, size_t size=
,
-			    int direction);
+struct rt_rtmp_adapter;
+dma_addr_t linux_pci_map_single(struct rt_rtmp_adapter *pAd, void *ptr,
+				size_t size, int sd_idx, int direction);
+void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_ad=
dr,
+			    size_t size, int direction);
=20
 #define PCI_MAP_SINGLE(_handle, _ptr, _size, _sd_idx, _dir) \
 	linux_pci_map_single(_handle, _ptr, _size, _sd_idx, _dir)
@@ -475,11 +476,6 @@ void linux_pci_unmap_single(void *handle, dma_addr_t d=
ma_addr, size_t size,
 #define DEV_ALLOC_SKB(_length) \
 	dev_alloc_skb(_length)
 #endif /* RTMP_MAC_PCI // */
-#ifdef RTMP_MAC_USB
-#define PCI_MAP_SINGLE(_handle, _ptr, _size, _dir) (unsigned long)0
-
-#define PCI_UNMAP_SINGLE(_handle, _ptr, _size, _dir)
-#endif /* RTMP_MAC_USB // */
=20
 /*
  * unsigned long
diff --git a/drivers/staging/rt2860/rt_pci_rbus.c b/drivers/staging/rt2860/=
rt_pci_rbus.c
index e0a0aee..acdf09f 100644
--- a/drivers/staging/rt2860/rt_pci_rbus.c
+++ b/drivers/staging/rt2860/rt_pci_rbus.c
@@ -790,10 +790,9 @@ IRQ_HANDLE_TYPE rt2860_interrupt(int irq, void *dev_in=
stance)
  * invaild or writeback cache
  * and convert virtual address to physical address
  */
-dma_addr_t linux_pci_map_single(void *handle, void *ptr, size_t size,
-				int sd_idx, int direction)
+dma_addr_t linux_pci_map_single(struct rt_rtmp_adapter *pAd, void *ptr,
+				size_t size, int sd_idx, int direction)
 {
-	struct rt_rtmp_adapter *pAd;
 	struct os_cookie *pObj;
=20
 	/*
@@ -812,7 +811,6 @@ dma_addr_t linux_pci_map_single(void *handle, void *ptr=
, size_t size,
 	   sd_idx =3D -1
 	 */
=20
-	pAd =3D (struct rt_rtmp_adapter *)handle;
 	pObj =3D (struct os_cookie *)pAd->OS_Cookie;
=20
 	if (sd_idx =3D=3D 1) {
@@ -826,13 +824,11 @@ dma_addr_t linux_pci_map_single(void *handle, void *p=
tr, size_t size,
=20
 }
=20
-void linux_pci_unmap_single(void *handle, dma_addr_t dma_addr, size_t size=
,
-			    int direction)
+void linux_pci_unmap_single(struct rt_rtmp_adapter *pAd, dma_addr_t dma_ad=
dr,
+			    size_t size, int direction)
 {
-	struct rt_rtmp_adapter *pAd;
 	struct os_cookie *pObj;
=20
-	pAd =3D (struct rt_rtmp_adapter *)handle;
 	pObj =3D (struct os_cookie *)pAd->OS_Cookie;
=20
 	pci_unmap_single(pObj->pci_dev, dma_addr, size, direction);
--=20
1.7.0.3


--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-sYkyPshXPN5NT1RvlzNu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6/zSOe/yOyVhhEJAQLC+RAAx5Y4bOXXbEJ3Yj2rVmUbtrSKTzRh7+uZ
H0Tr1TcgHFzGVM0XKXrautb0Ihqv+8Y5Lxly5SgcdHoxtNLixzUmyIeUBtnp6hWX
OobvmkUnG8DxNIagLIL4QQwW4M5sO0c1qmMn669g5mvCdH5QX78WnH0myvuaDwWq
YmmM6TLjR9Bih+g/mPBHDmfp3gqjZiq/gqmvLRlOcXx+/c+3W4TCX94MPPtcb7vx
Al29cIQw1rqYgQ+S/KxOYHkcUxZB4kklJ5JxPBHNyBFTRh2nvLvCsCs0CbpjPlOU
YJVlipaGIIFhYhTYfW9JB56se5tvh35I1QvuIwiuM+YT6PHYGxkB5/g+5xAjsthp
emglwa64YgCjjzqdWHnS8iuqKrxwcYBfAK0anoMecCqr1KoMu6p9Ec6bvJfKqHRC
Vaff76CEtm38fiMLsh43kXRfB3dWsh7Ww3lYgDfYgQtXbEHWTL4rb7yFVd331cdO
qAayXq5qS4Ui3xBgM0/2tiWJMYvuIl2mO029me2zOR5HIAvXSNLqkZz0tHV/8gAR
Wo5c3uOzezOgzzFgvEKgO/ZMiRIh98ABqtH7h0RXBs8wkZx2VtiGwJq12lhYk014
nleIaZXhZi9Omf8IPmPORjUCQ9Ai0RlM1/7evSbgBfWQ8SVgaJbqugMZYL1GsXHH
PCPekNd5kYY=
=h5wq
-----END PGP SIGNATURE-----

--=-sYkyPshXPN5NT1RvlzNu--
