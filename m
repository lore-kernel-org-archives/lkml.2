Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1AYSsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:48:46 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60650 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1AYSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:48:45 -0500
Message-ID: <4D3F1B05.3060008@canonical.com>
Date: Tue, 25 Jan 2011 19:48:37 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: p2m: correctly initialize partial p2m
 leave
References: <4D3848DF.9000906@canonical.com> <1295974472.14780.6579.camel@zakaz.uk.xensource.com>
In-Reply-To: <1295974472.14780.6579.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 05:54 PM, Ian Campbell wrote:
> Please always include an inline copy of a patch for easier
> review-by-reply, even if you also include an attachment because your
> mailer mangles patches.
> 
Will try to remember. It easy to forget when the mailer used does show textual
attachments inline.

> Anyway, I suspect the following comment is obsoleted by Jeremy's "just
> do it in place" suggestion but:
> 
> On Thu, 2011-01-20 at 14:38 +0000, Stefan Bader wrote:
>> [...]
>> +                       unsigned long **p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
> 
> I think this would need to be matched by a corresponding RESERVE_BRK of some sort.
> 
> Ian.
> 
> 
Currently the version extending brk is upstream. So we would need this going
upstream as well...

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -61,6 +61,7 @@ static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_T

 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PE
 RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MI
+RESERVE_BRK(p2m_node, PAGE_SIZE);

 static inline unsigned p2m_top_index(unsigned long pfn)
 {

(code above not tested at all)

And for the "do it inline" this could possibly look like this? (I know I am
repeating myself though the value at max_pfn always seemed to be 3L which seemed
to be too consistent for coincidence)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index ddc81a0..fd12d7c 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -241,21 +241,15 @@ void __init xen_build_dynamic_phys_to_machine(void)
                 * As long as the mfn_list has enough entries to completely
                 * fill a p2m page, pointing into the array is ok. But if
                 * not the entries beyond the last pfn will be undefined.
-                * And guessing that the 'what-ever-there-is' does not take it
-                * too kindly when changing it to invalid markers, a new page
-                * is allocated, initialized and filled with the valid part.
                 */
                if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
                        unsigned long p2midx;
-                       unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
-                       p2m_init(p2m);
-
-                       for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
-                               p2m[p2midx] = mfn_list[pfn + p2midx];
-                       }
-                       p2m_top[topidx][mididx] = p2m;
-               } else
-                       p2m_top[topidx][mididx] = &mfn_list[pfn];
+
+                       p2midx = max_pfn % P2M_PER_PAGE;
+                       for ( ; p2midx < P2M_PER_PAGE; p2midx++)
+                               mfn_list[pfn + p2midx] = INVALID_P2M_ENTRY;
+               }
+               p2m_top[topidx][mididx] = &mfn_list[pfn];
        }

        m2p_override_init();

(again completely (not even compile) tested)

-Stefan
