Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2FEE75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 00:59:57 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42265 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FEE74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 00:59:56 -0400
Date: Mon, 4 Jun 2012 23:59:50 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Victor Miasnikov <vvm@tut.by>
Cc: Greg KH <gregkh@linuxfoundation.org>, KY Srinivasan <kys@microsoft.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by
 default
Message-ID: <20120605045950.GB3118@burratino>
References: <20120527010903.GA18244@kroah.com>
 <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
 <20120528203518.GA12623@kroah.com>
 <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by>
 <20120601092017.GE22821@kroah.com>
 <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
 <20120601162629.GA11812@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120602012249.GA7783@kroah.com>
 <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Victor Miasnikov wrote:

> + see tranlate from Russian language issue described by Maksim Kramarenko:
> http://lists.debian.org/debian-russian/2012/01/msg00324.html

>> Correct, that is loaded without error, sleep and wake, for a small exception:
>>
>> At the conclusion of the system through the halt or when sending a
>> signal shutdown by ACPI to power down the console fell errors:
>> http://www.k-max.name/wp-content/uploads/2012/01/hyper-v.png
[That image shows the message

  exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
  ata1.00: failed command: STANDBY IMMEDIATE
]
>> Errors do not interfere with work, but sneaking suspicion about
>> future problems with the hard drive ...
[...]
>> in general, the source of the problem as follows:
>> After [VVM: turn On in kernel source]  Hyper-V modules [compile and
>> start use], a hard disk was determined as 2 with the same UUID.
[...]
>> connected to a drive:
>> http://www.k-max.name/wp-content/uploads/2012/01/hdd-e1327750214479.png
>> it is defined as a 2:
>> http://www.k-max.name/wp-content/uploads/2012/01/2hdd.png
>> Naturally, the same UUID:
>> http://www.k-max.name/wp-content/uploads/2012/01/blkid.png
>> That's what tells us the directory / dev:
>> http://www.k-max.name/wp-content/uploads/2012/01/uuid.png

Thanks --- I think this is what Greg was asking for.

If I understand correctly, the problem is that ata_piix and hv_storvsc
both claim the (virtual) hard disk.  That sounds worth fixing.  The
patch works by making ata_piix skip the disk during enumeration if
hv_storvsc is enabled as a built-in driver or module.

A workaround is to blacklist the ata_piix module.  However, that means
losing access to CD and DVD drives which are exposed by ata_piix and
not hv_storvsc.

Hoping that clarifies,
Jonathan
