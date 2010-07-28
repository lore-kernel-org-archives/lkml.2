Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0G1T3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:29:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33022 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0G1T3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:29:06 -0400
Message-ID: <4C5084A6.9060303@kernel.org>
Date: Wed, 28 Jul 2010 12:27:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Ralph Campbell <infinipath@qlogic.com>
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>	 <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>	 <4C4FD04B.5090503@zytor.com> <1280336548.30808.489.camel@mulgrave.site>	 <4C506E9B.4070501@zytor.com> <1280340633.30808.583.camel@mulgrave.site> <4C507728.3000207@zytor.com>
In-Reply-To: <4C507728.3000207@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C5084CD.02C2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 11:30 AM, H. Peter Anvin wrote:
> On 07/28/2010 11:10 AM, James Bottomley wrote:
>>
>> So I don't understand the problem.  Proper shutdown of the old kernel
>> will halt all the DMA engines (by design ... we can't have DMA ongoing
>> if the next action might be power off).  The only case I know where DMA
>> engines may be active is the crash kernel case.
>>
> 
> I'm not sure I fully understand the exact problem, either; not being
> familiar with this putative "logging" facility of the Qlogic devices.
> My point was largely that if a device causes failures because of the
> choice of the allocation order, then we have a much bigger problem and
> papering over it by trying to muck with the allocation order is just wrong.
> 
> This logging facility of Qlogic is DMA, no more, no less.  It needs to
> be shut down on a "overwrite" kexec, where we replace one kernel with
> another, as opposed to a crash dump kexec, where we use a reserved chunk
> of virgin memory.  What I don't know/understand at the moment is if
> there is something "special" about this particular logging facility,
> e.g. if the Qlogic card ignore the bus mastering control bit -- which
> would be reckless but I can see someone having the bright idea to do that.
> 
> Yinghai, do you have any more detail, or know who would?  Also copying
> the Qlogic Infinipath maintainer email...

when I was debug memblock with x86, found the strange crash when high/low.

then use kexec with "memtest" in command line, and the early memtest does find

some bad memory. 

then I add more print about EPT physical address for first kernel,

it does show that range is used by qla driver in first kernel.

I built all needed drivers in kernel so can pxeboot the kernel on all test platforms easily.

Thanks

Yinghai


---
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/scsi/qla2xxx/qla_init.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_init.c
+++ linux-2.6/drivers/scsi/qla2xxx/qla_init.c
@@ -1327,8 +1327,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *v
 			goto try_eft;
 		}
 
-		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
-		    FCE_SIZE / 1024);
+		qla_printk(KERN_INFO, ha, "Allocated (%d KB) at %p for FCE...\n",
+		    FCE_SIZE / 1024, tc);
 
 		fce_size = sizeof(struct qla2xxx_fce_chain) + FCE_SIZE;
 		ha->flags.fce_enabled = 1;
@@ -1354,8 +1354,8 @@ try_eft:
 			goto cont_alloc;
 		}
 
-		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for EFT...\n",
-		    EFT_SIZE / 1024);
+		qla_printk(KERN_INFO, ha, "Allocated (%d KB) at %p for EFT...\n",
+		    EFT_SIZE / 1024, tc);
 
 		eft_size = EFT_SIZE;
 		ha->eft_dma = tc_dma;
@@ -1383,8 +1383,8 @@ cont_alloc:
 		}
 		return;
 	}
-	qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware dump...\n",
-	    dump_size / 1024);
+	qla_printk(KERN_INFO, ha, "Allocated (%d KB) at %p for firmware dump...\n",
+	    dump_size / 1024, ha->fw_dump);
 
 	ha->fw_dump_len = dump_size;
 	ha->fw_dump->signature[0] = 'Q';
