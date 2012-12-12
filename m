Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2LLIc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:32:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab2LLIc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:32:27 -0500
Date: Wed, 12 Dec 2012 19:32:15 +1100
From: NeilBrown <neilb@suse.de>
To: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block2mtd: throttle writes by calling
 balance_dirty_pages_ratelimited.
Message-ID: <20121212193215.645da577@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BHo7oIwWjoyZBmzX_7tjmjK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BHo7oIwWjoyZBmzX_7tjmjK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



If you create a block2mtd device that is larger than main memory,
and write to all of it, then lots of pages will be dirtied but
they will never be flushed out as nothing calls any variant of
balance_dirty_pages.

It would be nice to call set_page_dirty_balance(), but that isn't exported,
so just call balance_dirty_pages_ratelimited() directly.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mt=
d.c
index 681e2ee..2c3e8e7 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -62,6 +62,7 @@ static int _block2mtd_erase(struct block2mtd_dev *dev, lo=
ff_t to, size_t len)
 				memset(page_address(page), 0xff, PAGE_SIZE);
 				set_page_dirty(page);
 				unlock_page(page);
+				balance_dirty_pages_ratelimited(mapping);
 				break;
 			}
=20
@@ -152,6 +153,7 @@ static int _block2mtd_write(struct block2mtd_dev *dev, =
const u_char *buf,
 			memcpy(page_address(page) + offset, buf, cpylen);
 			set_page_dirty(page);
 			unlock_page(page);
+			balance_dirty_pages_ratelimited(mapping);
 		}
 		page_cache_release(page);
=20

--Sig_/BHo7oIwWjoyZBmzX_7tjmjK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMhBDznsnt1WYoG5AQJBfBAAinJKjQolwjfXbnBHu03RZLNT0ktY/2na
wsldYuD4jOh7z8oSc9pqknejf26ekx2KqDX7RKJ8wU86x3Cv1hOD9UqZOpw84HnR
SH/7idpXyUJ1BhOgyx5LHnpqwXqRR0Ydy10qyheUVLgFLTFUJf+VQ0PMbTSUpwpi
wBRvu4V5htzWOjUnFGwdxxZasMIvCx0t4jbbBFrn7SzP0/iRFPtoJBlSTWRaSM/1
d6BeFbgV90k/wAJSSQ3VQJ7T+393Kb+E7C2cXC1asjk+3q8KJb6vuZdxkMRKLqJB
b8Q9ojLO1mqEz9nX/T0GhixbirWFiUSJcWIkVT2Wd0Yp0uzsoYzVj0OgVt8rO6Qg
ngGz3clBtvATDoCPKxFvwaq4TYoXkG4f3JNwNIoGIaNtfORwEFqFv1z2/hVb1JfC
Yd/E0OEZg3u733ZlPAjx3J4EBAhQdiKemI1p76K9sO5zg0ozgDQPU4EqcHJJLFgh
ttFk4yNXwOQgERZWSIu0JtNWve98rXZfc0SWZzxDt8UGACv/cI0/H2foejjIyVp8
4diZOZMLJaXtdrBY8fOzap6q+aHnD4PtkcBfm75X6VPG8i36eqoKJy07vA9F+J9L
ZbZtQAnxI2ojIZbVLRea6dEzEztraJUuw2mY8HNjkHGOIu/VguFO2IgTC9v5B7Js
XKU5mv6bYEQ=
=sWZ/
-----END PGP SIGNATURE-----

--Sig_/BHo7oIwWjoyZBmzX_7tjmjK--
