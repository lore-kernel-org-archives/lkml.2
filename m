Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab0JQWgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 18:36:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34660 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab0JQWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 18:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qOL2JRNyjFKSxhqWOX8P0C/8XymegQYTLA+sQGnD5heUItkkIIUIZ2XS2P0TGfOCKo
         gINESiPE5XhWqCelPlUcnyQ5R9oun+XJ4jh5dB/HEDQQNoLdmmjCPBSWaeqyWmVuMuG5
         V807XJhXJsdseGV/4uxqCPGj6faaP1aSxLKms=
MIME-Version: 1.0
In-Reply-To: <1286310944-25035-2-git-send-email-x0095840@ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
	<1286310944-25035-2-git-send-email-x0095840@ti.com>
Date: Mon, 18 Oct 2010 01:36:32 +0300
Message-ID: <AANLkTin+n8KsHz2jTtkbk2MnuiANrxpskThYU9FVu3CE@mail.gmail.com>
Subject: Re: [PATCHv3 01/11] staging: tidspbridge: replace iommu custom for
 opensource implementation
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: gregkh@suse.de, felipe.contreras@nokia.com, ameya.palande@nokia.com,
        nm@ti.com, Hiroshi.DOYU@nokia.com, ohad@wizery.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 11:35 PM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> Now the tidspbridge uses the API's from
> iovmm module.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>

NAK. This patch doesn't work... I guess it's supposed to.

So far I've found these errors, but it still doesn't work, maybe we
should start thinking of reverting the whole iommu stuff:

diff --git a/drivers/staging/tidspbridge/core/io_sm.c
b/drivers/staging/tidspbridge/core/io_sm.c
index 842b8db..16cf246 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -541,6 +541,14 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 					ae_proc[ndx].ul_dsp_va *
 					hio_mgr->word_size, page_size[i]);
 				ndx++;
+			} else {
+				u32 tmp_curr;
+				tmp_curr = iommu_kmap(mmu, va_curr, pa_curr, page_size[i],
+						IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+				if (IS_ERR_VALUE(tmp_curr)) {
+					status = (int)tmp_curr;
+					goto func_end;
+				}
 			}
 			pa_curr += page_size[i];
 			va_curr += page_size[i];
@@ -593,6 +601,15 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 					"DSP_VA 0x%x\n", ae_proc[ndx].ul_gpp_pa,
 					ae_proc[ndx].ul_dsp_va);
 				ndx++;
+			} else {
+				u32 tmp_curr;
+				tmp_curr = iommu_kmap(mmu,
+						hio_mgr->ext_proc_info.ty_tlb[i].ul_dsp_virt,
+						hio_mgr->ext_proc_info.ty_tlb[i].ul_gpp_phys,
+						0x100000,
+						IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+				if (IS_ERR_VALUE(tmp_curr))
+					status = (int)tmp_curr;
 			}
 		}
 		if (status)
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c
b/drivers/staging/tidspbridge/core/tiomap3430.c
index c2f5105..92774fc 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -1195,7 +1195,7 @@ static int get_io_pages(struct mm_struct *mm,
u32 uva, unsigned pages,
 	struct page *pg;

 	for (i = 0; i < pages; i++) {
-		pa = user_va2_pa(mm, uva);
+		pa = user_va2_pa(mm, uva + i * PAGE_SIZE);

 		if (!pfn_valid(__phys_to_pfn(pa)))
 			break;


-- 
Felipe Contreras
