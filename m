Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560Ab2IGMBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:01:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43909 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760364Ab2IGMBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:01:20 -0400
Message-ID: <5049E208.3040109@redhat.com>
Date: Fri, 07 Sep 2012 14:01:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 3.6 2/2] target: use a bounce buffer in transport_kmap_data_sg
 for 0 or 1-page sglist
References: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>  <1346944410-19850-3-git-send-email-pbonzini@redhat.com>  <1346959768.4162.540.camel@haakon2.linux-iscsi.org>  <50490E73.7070601@redhat.com> <1346988951.4162.595.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1346988951.4162.595.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 05:35, Nicholas A. Bellinger ha scritto:
>> It is not completely correct for virtual backends, for example I think
>> it will always return success for 0-block reads or writes, even if the
>> start LBA is out of range.  This is also something that I saw with
>> PSCSI, and is fixed by these patches.
> 
> Good point !

I spent the morning digging further down the rabbithole, and I found the
following testcases:

REPORT LUNS:
sg_raw -r8 /dev/sdb a0 00 00 00 00 00 00 00 00 08 00 00
    should fail with ILLEGAL REQUEST / INVALID FIELD IN CDB sense
    does not fail

INQUIRY (VPD PAGE != 0, std != 0):
sg_raw /dev/sdb 12 00 83 00 00 00
    should fail with ILLEGAL REQUEST / INVALID FIELD IN CDB sense
    does not fail

MODE SENSE off by one (by two for 10-byte CDB):
sg_raw -r20 /dev/sdb 5a 00 0a 00 00 00 00 00 14 00
    last byte should be 0x1e
    it is 0x00

READ:
Testcase: sg_raw /dev/sdb 28 00 80 00 00 00 00 00 00 00
    should fail with ILLEGAL REQUEST / LBA OUT OF RANGE sense
    does not fail

Plus:

- missing checks on parameter list length for PR OUT with SPEC_I_PT,
UNMAP, SET TARGET PORT GROUPS.  In some cases these could lead to
reading undefined data.

- no checks for OOM in callers of transport_kmem_data_sg.

>> Also, even though it handles zero-size, it doesn't handle a CDB with a
>> small but nonzero allocation length.  If you have such a CDB, you can
>> overflow the sglist. 
> 
> Any particular sg_raw example in mind that can trigger this..?

sg_raw (or even SG_IO) doesn't work because misaligned scatterlists are
bounce-buffered by the block layer in blk_map_rq_user.

However, given the above bugs it's better to attack the callers of
transport_kmem_data_sg one by one.  Again, zero-length CDB support comes
for free.

> Ok, if this is a genuine issue then please show how to trigger with
> sg_raw, and let's plan on merging this as a -rc6 bugfix in order to
> spend some more testing w/ scsi-testsuite across different backends over
> the next week.

Doesn't seem to be too important, it can be done for 3.7 except perhaps
for PSCSI; I'll put the PSCSI patch at the beginning of the series.  I
can make scsi-testsuite patches for the above issues, but I'll be glad
if someone beats me to it.

Paolo
