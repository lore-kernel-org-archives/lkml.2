Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2AAVtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 16:49:13 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:25458 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2AAVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 16:49:08 -0500
X-Authority-Analysis: v=2.0 cv=SbB1h4tu c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=eTYCEUmluKo7DLZeygAA:9 a=ScVDJUfc6sXgpvRUPH4A:7 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4F00D4D1.7020506@cfl.rr.com>
Date: Sun, 01 Jan 2012 16:49:05 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Maxim Patlasov <maxim.patlasov@gmail.com>
CC: vgoyal@redhat.com, joe@perches.com, kzak@redhat.com,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com> <4EFD012D.7040602@cfl.rr.com>
In-Reply-To: <4EFD012D.7040602@cfl.rr.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/29/2011 07:09 PM, Phillip Susi wrote:
> Good points.  I also noticed that the read/write functions were only
> being called when not holding the mutex.  If anyone is touching
> nr_sects without the mutex, then everyone must use the read/write
> functions, whether they hold the mutex or not.  Otherwise, a mutex
> holder that touches it directly will race with a non mutex holder
> using the seqcounter.  Vivek, rather than fix the rest of the
> references to nr_sects to use the read/write functions, why not just
> fix the few sites that were accessing it without the mutex to take
> the mutex fist instead of using a seqcounter?

I've been wondering why device-mapper and loop have been able to change device size for years, yet didn't add a seqcounter to do this.  It looks to me like there are plenty of places ( like xen-blkback ) that either call get_capacity() or directly reference nr_sects without holding the bd_mutex.  Does this mean that device-mapper or loop changing capacity on i386 with large block support already has a race condition?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPANTRAAoJEJrBOlT6nu75FjAIAMR6B/Q4o8VDdZGIMw7RoutP
MHdCFPwcxTjc06061E2oRk4NYHGQFhg9NfKK6vmI2enjB+ctVIFyK2qC+Ar13mUp
KkKbqrVbjOM8AOXgEb4VTQMQ6inTUFEvTOx+EGvAw0flJzpfq7zdjw+1P+BM/PrY
LPhxjb8dPeooHmv2TEFFpW0XavkqBM1JHuL9sM2f2g3U9QKU3clNFnrHGY7p1Wxn
FBO2ncqqSdbJKsw2xskdRfMq1x6jXfUeIyXCoNoTrHHPz+80AeHOMWy2Y54dvZMX
J9iKuQlURG5zyQ1eGh96YlRj4f4Z+zFY8h84K3z2i+xR45J4IgNxXD4ewbIPqg8=
=XZQc
-----END PGP SIGNATURE-----
