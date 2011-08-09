Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1HIP24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:28:56 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:58509 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab1HIP2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:28:54 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=3CAT4r-dEVgA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=azj6Gt-4AAAA:8 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=1w_FFOCr1u3z5AF8e_0A:9 a=CjuIK1q_8ugA:10 a=eJ1lpvm07AkA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'George Spelvin'" <linux@horizon.com>, <akpm@linux-foundation.org>,
        <fzago@systemfabricworks.com>, <joakim.tjernlund@transmode.se>,
        <linux-kernel@vger.kernel.org>
References: <4E40C55F.8070703@systemfabricworks.com> <20110809112114.3943.qmail@science.horizon.com>
In-Reply-To: <20110809112114.3943.qmail@science.horizon.com>
Subject: RE: [patch v3 6/7] crc32: add-slicing-by-8.diff
Date: Tue, 9 Aug 2011 10:28:50 -0500
Message-ID: <011501cc56a9$0b1ca470$2155ed50$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIDK6rucvy9/Lgf2Z8wF3Eaox0enJSm+fLA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: George Spelvin [mailto:linux@horizon.com]
> Sent: Tuesday, August 09, 2011 6:21 AM
> To: akpm@linux-foundation.org; fzago@systemfabricworks.com;
> joakim.tjernlund@transmode.se; linux-kernel@vger.kernel.org;
> linux@horizon.com; rpearson@systemfabricworks.com
> Subject: Re: [patch v3 6/7] crc32: add-slicing-by-8.diff
> 
> While writing up some documentation of this algorithm, I came up with
> a potential speedup.  Or, at least, realized why slicing by more than
> 4 is so much faster than slicing by 4 or less.
> 
> Note that the inner loop of the algorithm is as follows:
> 
> +#  define DO_CRC8a (tab[7][(q) & 255] ^ \
> +		tab[6][(q >> 8) & 255] ^ \
> +		tab[5][(q >> 16) & 255] ^ \
> +		tab[4][(q >> 24) & 255])
> +#  define DO_CRC8b (tab[3][(q) & 255] ^ \
> +		tab[2][(q >> 8) & 255] ^ \
> +		tab[1][(q >> 16) & 255] ^ \
> +		tab[0][(q >> 24) & 255])
> 
> +	for (--b; middle_len; --middle_len) {
> +		u32 q;
> +		q = crc ^ *++b;
> +		crc = DO_CRC8a;
> +		q = *++b;
> +		crc ^= DO_CRC8b;
>  	}
> 
> Note the data dependencies: DO_CRC8a depends on the
> previous crc, which depends on the previous DO_CRC8b.
> But DO_CRC8b does not depend on anything except the
> input data at *++b.

I think you've got it. That is exactly why it works. The hardware is pretty
good at finding the parallelism since this code runs at almost 2X the speed
of the CRC4 loop.

> 
> It would increase parallelism to schedule DO_CRC8b before DO_CRC8a,
> to start those loads before the previous crc value is available.
> 
> Maybe the compiler and/pr processor can find this parallelism already,
> but if not, it might be useful to try reordering it:
> 
> #  define DO_CRC8a(x) (tab[7][(x) & 255] ^ \
> 		tab[6][((x) >> 8) & 255] ^ \
> 		tab[5][((x) >> 16) & 255] ^ \
> 		tab[4][((x) >> 24) & 255])
> #  define DO_CRC8b(x) (tab[3][(x) & 255] ^ \
> 		tab[2][((x) >> 8) & 255] ^ \
> 		tab[1][((x) >> 16) & 255] ^ \
> 		tab[0][((x) >> 24) & 255])
> 
> 	for ( ; middle_len; --middle_len, b += 2) {
> 		u32 q = DO_CRC8b(b[1]);
> 		crc ^= b[0];
> 		crc = q ^ DO_CRC8a(crc);
> 	}

