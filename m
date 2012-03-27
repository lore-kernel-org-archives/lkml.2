Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2C0I1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:27:01 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:36522 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753368Ab2C0I07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:26:59 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 04:26:59 EDT
Message-ID: <1332836421.5395.338.camel@thor.local>
Subject: Re: WARNING: at drivers/gpu/drm/radeon/radeon_object.c:236
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Tue, 27 Mar 2012 10:20:21 +0200
In-Reply-To: <1332829303.2882.52.camel@pasglop>
References: <20120326213250.GA16328@redhat.com>
	 <1332829303.2882.52.camel@pasglop>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1.0 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2012-03-27 at 17:21 +1100, Benjamin Herrenschmidt wrote:
>         On Mon, 2012-03-26 at 17:32 -0400, Dave Jones wrote:
>         > Seeing this in Linus' tree as of v3.3-6972-ge22057c
>         
>         Same WARN_ON hit here on a G5 with rv350

Thanks for the report, guys. Does the patch below help?


diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index f441d58..ad9d450 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -233,7 +233,17 @@ int radeon_bo_pin_restricted(struct radeon_bo *bo, u32 domain, u64 max_offset,
 		bo->pin_count++;
 		if (gpu_addr)
 			*gpu_addr = radeon_bo_gpu_offset(bo);
-		WARN_ON_ONCE(max_offset != 0);
+
+		if (max_offset != 0) {
+			u64 domain_start;
+
+			if (domain == RADEON_GEM_DOMAIN_VRAM)
+				domain_start = bo->rdev->mc.vram_start;
+			else
+				domain_start = bo->rdev->mc.gtt_start;
+			WARN_ON_ONCE((*gpu_addr - domain_start) > max_offset);
+		}
+
 		return 0;
 	}
 	radeon_ttm_placement_from_domain(bo, domain);


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
