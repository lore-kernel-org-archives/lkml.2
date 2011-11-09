Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab1KIUfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:35:55 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51497 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab1KIUfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:35:52 -0500
Date: Wed, 9 Nov 2011 21:35:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>
Cc: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: fix size decoding error on K8
Message-ID: <20111109203546.GI14181@aftab>
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
 <20111109144258.GD30472@aftab>
 <4EBA98A1.90902@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EBA98A1.90902@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

On Wed, Nov 09, 2011 at 04:13:37PM +0100, Niklas Söderlund wrote:
> The decoding table from the documentation:
> 
> cs_mode		size (mb)
> 0		32
> 1		64
> 2		128
> 3		128
> 4		256
> 5		512
> 6		256
> 7		512
> 8		1024
> 9		1024
> 10		2048
> 
> The original code:
> 
> if (cs_mode == 3 || cs_mode == 8)
> 	return 32 << (cs_mode - 1);
> else
> 	return 32 << cs_mode;
> 
> The code tries to compensate for the irregularity in the decoding
> table but fails for cs_mode greater or equal to 4. It fails because:
> 
> - It do not consider the cumulating effect of reoccurring sizes for
> all values of cs_mode. It only tries for the special cases and it
> only succeeds in one.
> 
> - It do not consider the out of order values of cs_mode values 4-7:
> 256, 512, 256, 512.

Agreed, thanks for reporting this. However, I removed the static tables
at the time because I didn't want to carry unnecessary weight around for
no reason (tables were static back then). And I know, they're small but
dead weight like that tends to accumulate.

Your approach is ok with creating the lookup table on the stack but how
about the following instead - it is much smaller and it is only code,
no need for stack memory at all. It should give you the proper mapping,
IINM.

--
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c9eee6d33e9a..3702f20d784e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1132,12 +1132,12 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 		return ddr2_cs_size(cs_mode, dclr & WIDTH_128);
 	}
 	else if (pvt->ext_model >= K8_REV_D) {
+		unsigned diff;
 		WARN_ON(cs_mode > 10);
 
-		if (cs_mode == 3 || cs_mode == 8)
-			return 32 << (cs_mode - 1);
-		else
-			return 32 << cs_mode;
+		diff = cs_mode / 3 + (unsigned)(cs_mode > 5);
+
+		return 32 << (cs_mode - diff);
 	}
 	else {
 		WARN_ON(cs_mode > 6);
--

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
