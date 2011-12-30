Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1L3AJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 19:09:22 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5395 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1L3AJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 19:09:20 -0500
X-Authority-Analysis: v=2.0 cv=UP9f7Vjy c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=NMiDtSFvQFt2tOEb3ssA:9 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EFD012D.7040602@cfl.rr.com>
Date: Thu, 29 Dec 2011 19:09:17 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Maxim Patlasov <maxim.patlasov@gmail.com>
CC: vgoyal@redhat.com, joe@perches.com, kzak@redhat.com,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com>
In-Reply-To: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/29/2011 12:06 PM, Maxim Patlasov wrote:
> Phillip,
> 
> The patch seems to have some problems:
> 
> 1. Typo in part_nr_sects_write_begin:
> 
>> +	write_seqcount_begin(&seq);
> 
> It should be write_seqcount_begin(seq). Similar issue in
> part_nr_sects_write_end().
> 
> 2. part_nr_sects_write_begin/end is never called.
> 
> 3. part->seq should be initialized with seqcount_init().
> 
> Btw, do we really need both part_nr_sects_write_begin and
> part_nr_sects_write_end? What about:

Good points.  I also noticed that the read/write functions were only being called when not holding the mutex.  If anyone is touching nr_sects without the mutex, then everyone must use the read/write functions, whether they hold the mutex or not.  Otherwise, a mutex holder that touches it directly will race with a non mutex holder using the seqcounter.  Vivek, rather than fix the rest of the references to nr_sects to use the read/write functions, why not just fix the few sites that were accessing it without the mutex to take the mutex fist instead of using a seqcounter?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJO/QEtAAoJEJrBOlT6nu756LYH/jPZrhv9svf9TX0orH0eZJSY
UmF3UYffWOexarz5Xppb42so+LedZLtJ5Ya7oQvcWQ5UuSRW6LNLH3tOoutmRVp5
6q5ReaEAp61neE7D2dkqJ9XjSBz7v+I/+CfNMRKhkVNq1n41UpV3iw4qYFBR3DR7
BSyfNPJlXXNU2tSJi1hT/ZsEM1/9bHKiB3yeoipln7CvRjNFjSBVyiDIFX/xl5wD
QlLKFesgxSGkYCVfdYtkdT4XybDydUIKWzVXIllFvZgqrBNnLEvwOWlhiCV93YJe
jYKHk2oWt7pSxxn3Vz8WlUbf5Jt1k/oresb6I7oVtR8c5Xutmk/HsLOT8K43YlM=
=TIs3
-----END PGP SIGNATURE-----
