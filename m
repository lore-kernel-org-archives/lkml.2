Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab0LTRND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:13:03 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:60172 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab0LTRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VkkM+kFsNU7e7xAvuhJz70+8uGbX/i6MftXtG+dnV8bO5a/AWXFiIIE5jh6pCY81G5
         d0exPtkg/PxxVRgmu24eZaUuIpR66c+HTjYDwUChvsNH4lHc18syBkXEmGW9uIBWovJd
         TTxLZmSX1OpBcH/ja/Wyv1v6CrSIuxOJGwujE=
Message-ID: <4D0F8E98.9070500@kernel.org>
Date: Mon, 20 Dec 2010 18:12:56 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
References: <201012201105.08993.Martin@lichtvoll.de>
In-Reply-To: <201012201105.08993.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/20/2010 11:05 AM, Martin Steigerwald wrote:
> Hi!
> 
> top - 10:49:07 up 3 days, 14:24,  8 users,  load average: 2.31, 2.62, 2.28
> Tasks: 198 total,   2 running, 194 sleeping,   0 stopped,   2 zombie
> Cpu(s):  6.8%us, 93.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  
> 0.0%st
> Mem:   2073660k total,  1941152k used,   132508k free,   153876k buffers
> Swap:  4000180k total,   243452k used,  3756728k free,   676612k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                               
>   735 root      20   0     0    0    0 R 85.2  0.0 137:28.94 scsi_eh_11
> 
> I don't see anything in dmesg. Everything appears to work as normal, 
> except for the slowness. Which got a bit better upon renicing scsi_eh_11 
> to 19 (not knowing whether its really safe, but it works for now).
> 
> Interrupts appear to be within usual range as well:

Can you please apply the following patch, trigger the problem and
attach the kernel log?

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..c748b5a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -888,12 +888,19 @@ void ata_eh_fastdrain_timerfn(unsigned long arg)
  */
 static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)
 {
+	static int xxx;
 	int cnt;

 	/* already scheduled? */
 	if (ap->pflags & ATA_PFLAG_EH_PENDING)
 		return;

+	if (!(ap->pflags & ATA_PFLAG_LOADING) && xxx < 16) {
+		ata_port_printk(ap, KERN_WARNING, "XXX ata_eh_set_pending()\n");
+		dump_stack();
+		xxx++;
+	}
+
 	ap->pflags |= ATA_PFLAG_EH_PENDING;

 	if (!fastdrain)

-- 
tejun
