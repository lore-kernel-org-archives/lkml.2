Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2BISM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:12:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37503 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372Ab2BISM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:12:27 -0500
Date: Thu, 9 Feb 2012 18:12:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regmap: add bulk_write() for non-volatile register set
Message-ID: <20120209181224.GK3058@opensource.wolfsonmicro.com>
References: <1328789531-10067-1-git-send-email-ldewangan@nvidia.com>
 <20120209121704.GF3058@opensource.wolfsonmicro.com>
 <4F33BFDE.7020006@nvidia.com>
 <20120209125505.GI3058@opensource.wolfsonmicro.com>
 <4F33FEE7.9080608@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fLj60tP2PZ34xyqD"
Content-Disposition: inline
In-Reply-To: <4F33FEE7.9080608@nvidia.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fLj60tP2PZ34xyqD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 10:44:15PM +0530, Laxman Dewangan wrote:
> On Thursday 09 February 2012 06:25 PM, Mark Brown wrote:

> >That's the whole point with the difference between the bulk and raw APIs
> >though, the raw API skips the byte swapping and the bulk does it.

> Ok, re-going through the apis again about the byte swapping, what I
> understand is that raw_read or raw_write always happen in
> bing-endian regardless of cpu. And bulk read/write supported the
> data which is in the cpu-endianess.

Well, technically raw operations always work with device native data -
it's just that nobody actually makes devices that are little endian so
we've no software support for that.  But pretty much, yes.

> So we need to convert the data from cpu_to_bexx if we want to call
> raw_write from bulk_write. Similarly we need to convert the data
> from bexx_to_cpu when we read from raw-read which is called from
> bulk_read().

Yes.

> If this is case then if we want the data in integer type from
> bulk_write data pointer then just memcpy will be fine like
> unsigned int ival;
> memcpy(&ival, bulk_val_ptr, val_bytes);
> and for calling raw_write, it need to call format_val() so this will
> do byte swapping. This require to duplicate the data pointer to new
> pointer and then do manipulation. Once we do this then we will be
> able to call raw_write() with the new duplicated pointer.

Indeed, taking a copy of the data and modifying it will do the trick.

> This may be require mem alloc/free on every call. It can be avoided
> by allocating memory for size (val_bytes + max_register) in advance
> during init..
> Is it correct?

val_bytes * max_register, and obviously the worst case on that is rather
large.

> >Well, there's no fundamental reason why we can't support cache on raw
> >operations too.  It's not implemented because there's no need for it
> >with any current users rather than because it's impossible.

> Now if we want to support the caching from raw-write then we need to
> either do caching first or device write first.

Yes.

> I am seeing one issue with this approach:
> Whichever is first, if we do caching (which is in loop) and if it
> fails in between inside loop then we may not able to revert it
> or it will be complicate to implement the reversal of old values.
> Also if it is stored in cache first and later if write fails then
> also it will be difficult to revert it.

I'm not overly worried about failed writes, they should essentially
never happen and if they do happen we can always resync with the device
by either reading the registers or discarding the cache (assuming we
didn't completely loose track of the device).  Doing something really
expensive isn't too bad for rare events, and practically speaking if we
fail to write once we'll never succeed.

Besides, when we do get an error we have no way of telling what exactly
the hardware did - even if we see that it got an error on the nth byte
we don't know if it might've done something with that before it
complained or if there was damage to some of the earlier data too.
Upper layers are going to have to implement recovery mechanisms if they
want them.

> - remove the warnings from raw-write...
> - Let allow the reg_write as what it is already  there.
> - Then parse input val pointer and put in cache register by register
>                for (i = 0; i < val_len / map->format.val_bytes; i++) {
>                   memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
>                   ival = map->format.parse_val(map->work_buf);
>                   ret = regcache_write(map, reg + i, ival);
>                   if (ret != 0)
>                       dev_warn("Unable to cache register %d\n", reg +i);
>                }

Hrm, we also need to handle cache bypass and cache only in here - and
for consistency with vanilla write we need to cache before write.
Indeed, we'll need to push all the cache handling down into
_regmap_raw_write() from regmap_reg_write() as that's where writes from
regmap_reg_write() end up.

> It seems modifying raw_write() looks simple if we are able to ignore
> the caching error..
> Let me know your opinion?

We can't ignore errors completely but we don't need to go to great
lengths to handle it due to the issues discussed above.

--fLj60tP2PZ34xyqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNAyCAAoJEBus8iNuMP3dzPMQAJNfrlUrPQVS4aNrIzbs1n2K
uhXb2lRhSkRZHnva0DdMI7qvgbn5e2SZ4yuWEkOsUBWAP70iWOxUz4K3IYpxtdzv
7rnH56vVGgbNjSXcujB0ezCbQexZUP3Jcvd2+ScxedbukKTZir9oXOiKI9JKVFv7
10mSEjKIwyNA75MMyuScr+09icjUZOmyXGv1JjuuKeOquCSehSoF1oj/ZNeEtVYf
2zMYuYNfxgsYAJoRSMHMYIkRDSqU5n8SjSuOdCLQ/Tk3GQHnh+i4g5RvwH7BhPZh
WSMheOA3P1hqmSdTL5xU3nB9Sc9Et81Bvh4Oc76RsdGgETbatT4rVs/XdW1zFIj3
plUzFrNTthOKIk4dYB69FGzoFUhD7iQm8MJ87iH8vPLoEo+QURN1eWpVZ2PcOIVG
rXFv+B4t+AHlSPAN3vJtjReKPAEpZxFTBPClqesP+lVgP9BB8iokFtRfyI2p77Z+
53jWRU7HQNgPifUioOx2s0R3CrE3B153dA7bh7wkJ+Wk3IDknOwMASDQ7oXgN/Gm
jwE6PeNLmWIYbCUab5hUQ5D7oZZnpklYvssmMU52PtpdlC5HEUwU24nbruw5r3Dx
v5/MDZUMgR15uWJeNzD1s1nAJW9a1g9VCusav4aSaHnAQGxKUn/S8phiMU/bFubG
8tvP9riNoHbdPJttKvY4
=P65S
-----END PGP SIGNATURE-----

--fLj60tP2PZ34xyqD--
