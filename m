Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2CXSra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 14:47:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46846 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2CXSr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 14:47:28 -0400
Date: Sat, 24 Mar 2012 14:42:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, eric.piel@tremplin-utc.net,
        vojcek@tlen.pl, dsdt@gaugusch.at, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
Message-ID: <20120324184238.GB13978@phenom.dumpdata.com>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
 <4F6CD79A.8020805@zytor.com>
 <201203240242.07724.trenn@suse.de>
 <4F6D2AF8.3070707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6D2AF8.3070707@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F6E16A8.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2. We create a new simple header (just a magic number, an identifier
>    for the type of data, and a length) for each of the early-initrd
>    objects:
> 
> 	struct early_initrd_header {
> 		u64 magic;	/* 0xa5a46ce422d8f5a1 */

Probably should also have:
		u32 version;

in case we decide to expand this structure in the future, and:
> 		u32 type;	/* 1 = file data, 2 = ACPI, 3 = microcode... */
> 		u32 length;	/* Length of data object */
> 	};

and encapsulate the whole thing in a 4K union?

> 
>    XXX: Should we make this a defined endianness (presumably
>    bigendian), or use host-endianness?  I would guess the former might
>    be better...

Perhaps the header should be in big-endian (that is the same as the network
byte order, right?) and each sub-type can define its own endian?

The sub-types could be:
	struct microcode_type {
		u64	magic;
		u32	version;
#define BIG_ENDIAN	1<<1
#define LITTLE_ENDIAN	1<<2
		u32	flags;
	}

and that could be attached to the end of the 'early_initrd_header' ?

> 
> Either of these allow one piece of code to quickly bypass bits that
> doesn't belong to it.
> 
> Thoughts?
> 
> 	-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
