Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0HCLVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:21:23 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:47623 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab0HCLVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:21:21 -0400
X-ASG-Debug-ID: 1280834479-7f4600060000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C57FBAD.1080809@fusionio.com>
Date: Tue, 3 Aug 2010 13:21:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <stable@kernel.org>, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>,
        <scst-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <linux-raid@vger.kernel.org>, <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>
X-ASG-Orig-Subj: Re: [PATCH 1/2 block#for-2.6.36] bio, fs: update RWA_MASK, READA
 and  SWRITE to match the corresponding BIO_RW_* bits
Subject: Re: [PATCH 1/2 block#for-2.6.36] bio, fs: update RWA_MASK, READA
 and  SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk> <4C57E722.5060809@kernel.org> <4C57FA57.2000601@kernel.dk>
In-Reply-To: <4C57FA57.2000601@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1280834479
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03 13:15, Jens Axboe wrote:
> On 2010-08-03 11:53, Tejun Heo wrote:
>> Commit a82afdf (block: use the same failfast bits for bio and request)
>> moved BIO_RW_* bits around such that they match up with REQ_* bits.
>> Unfortunately, fs.h hard coded RW_MASK, RWA_MASK, READ, WRITE, READA
>> and SWRITE as 0, 1, 2 and 3, and expected them to match with BIO_RW_*
>> bits.  READ/WRITE didn't change but BIO_RW_AHEAD was moved to bit 4
>> instead of bit 1, breaking RWA_MASK, READA and SWRITE.
>>
>> This patch updates RWA_MASK, READA and SWRITE such that they match the
>> BIO_RW_* bits again.  A follow up patch will update the definitions to
>> directly use BIO_RW_* bits so that this kind of breakage won't happen
>> again.
>>
>> Neil also spotted missing RWA_MASK conversion.
>>
>> Stable: The offending commit a82afdf was released with v2.6.32, so
>> this patch should be applied to all kernels since then but it must
>> _NOT_ be applied to kernels earlier than that.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-and-bisected-by: Vladislav Bolkhovitin <vst@vlnb.net>
>> Root-caused-by: Neil Brown <neilb@suse.de>
>> Cc: Jens Axobe <axboe@kernel.dk>
>            ^^^^^
> 
> (Too) common typo :-)
> 
> Anyway, applied to for-2.6.36, thanks a lot.

Irk, we have an issue:

In file included from fs/coda/psdev.c:48:
include/linux/coda_psdev.h:91:1: warning: "REQ_WRITE" redefined
In file included from include/linux/fs.h:11,
                 from include/linux/proc_fs.h:5,
                 from fs/coda/psdev.c:31:
include/linux/blk_types.h:154:1: warning: this is the location of the previous definition

And from include/linux/coda_psdev.h:

#define REQ_ASYNC  0x1
#define REQ_READ   0x2
#define REQ_WRITE  0x4
#define REQ_ABORT  0x8

which unfortunately seem to not be under __KERNEL__ protection, but
there are things like wait_queue_head_t structs there as well so should
be safe to change.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
