Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HHRBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:01:48 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:52030 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab1HHRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:01:47 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=azj6Gt-4AAAA:8 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=PoiJNSP8FXPUfPqxG3UA:9 a=AfKvnCsTplZaVKIPVwoA:7 a=CjuIK1q_8ugA:10 a=eJ1lpvm07AkA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'George Spelvin'" <linux@horizon.com>, <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <OF4BB89E7A.F9308AC6-ONC12578E6.00402167-C12578E6.0040598B@transmode.se> <20110808125459.2961.qmail@science.horizon.com>
In-Reply-To: <20110808125459.2961.qmail@science.horizon.com>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Mon, 8 Aug 2011 12:01:45 -0500
Message-ID: <002b01cc55ec$db14fb90$913ef2b0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEmn2rwcwwFwd4jSYRMyJ8lwL5uRJZemUGQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happy to consider this. I have been asking the list for comments about the
idea of dropping the BITS=2 and BITS=4 algorithms altogether which would
make the table size just 256. So far no one has claimed that they actually
care about those algorithms except as 'examples'. The 'Sarwate' algorithm
(which I added as an 8 bit version) is faster and only adds 2x4KB of table.

If no one really uses the smaller but much slower versions I don't see a
reason to keep them.

> -----Original Message-----
> From: George Spelvin [mailto:linux@horizon.com]
> Sent: Monday, August 08, 2011 7:55 AM
> To: joakim.tjernlund@transmode.se; linux@horizon.com
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; linux-
> kernel@vger.kernel.org; rpearson@systemfabricworks.com
> Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
> 
> > -#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> > -#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
> > +#if CRC_LE_BITS > 8
> > +# define LE_TABLE_SIZE 256
> > +#else
> > +# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> > +#endif
> > +#if CRC_BE_BITS > 8
> > +# define BE_TABLE_SIZE 256
> > +#else
> > +# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
> > +#endif
> >
> > -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
> > -static uint32_t crc32table_be[4][BE_TABLE_SIZE];
> > +#define LE_TABLE_ROWS ((CRC_LE_BITS - 1)/8 + 1)
> > +#define BE_TABLE_ROWS ((CRC_BE_BITS - 1)/8 + 1)
> > +
> > +static uint32_t crc32table_le[LE_TABLE_ROWS][LE_TABLE_SIZE];
> > +static uint32_t crc32table_be[BE_TABLE_ROWS][BE_TABLE_SIZE];
> 
> Minor cleanup suggestion: The two different ways of computing
> xE_TABLE_SIZE and xE_TABLE_ROWS is a bit confusing.
> 
> May I recommend choosing one of the following:
> 
> #if CRC_LE_BITS > 8
> # define LE_TABLE_ROWS (CRC_LE_BITS/8)
> # define LE_TABLE_SIZE 256
> #else
> # define LE_TABLE_ROWS 1
> # define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> #endif
> 
> or
> 
> #define LE_TABLE_ROWS ((CRC_LE_BITS - 1)/8 + 1)
> #define LE_TABLE_SIZE (1 << ((CRC_LE_BITS - 1)%8 + 1))
> 
> Either one makes the relationship between the two clearer.

