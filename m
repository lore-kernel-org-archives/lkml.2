Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab1INKUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 06:20:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33427 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab1INKUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 06:20:04 -0400
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Lin Ming <mlin@ss.pku.edu.cn>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Andrew Morton <akpm@google.com>
In-Reply-To: <alpine.DEB.2.02.1109140543590.29782@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>
	 <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>
	 <CAF1ivSZQ=KKC0gAk93eMVwLSCbeEWr=k6YszuE=sb1+Ue521vw@mail.gmail.com>
	 <alpine.DEB.2.02.1109140543590.29782@p34.internal.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:20:08 +0200
Message-ID: <1315995608.2361.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 septembre 2011 à 05:47 -0400, Justin Piszcz a écrit :
> 
> On Wed, 14 Sep 2011, Lin Ming wrote:
> 
> > On Mon, Sep 12, 2011 at 6:44 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Hi, Justin
> >
> > There is a similar bug report at:
> > http://marc.info/?t=131594190600005&r=1&w=2
> >
> > The attached patch from Shaohua fixed the bug.
> >
> > Could you have a try it?
> >
> 
> Hi Lin/LKML,
> 
> Can you please provide text patch files for what you want me to apply?
> I did read that e-mail thread and that could be the culprit, I will patch
> and apply as soon as someone points to to the patch locations :)

diff --git a/mm/filemap.c b/mm/filemap.c
index 645a080..7771871 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -827,13 +827,14 @@ unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 {
 	unsigned int i;
 	unsigned int ret;
-	unsigned int nr_found;
+	unsigned int nr_found, nr_skip;
 
 	rcu_read_lock();
 restart:
 	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
 				(void ***)pages, NULL, start, nr_pages);
 	ret = 0;
+	nr_skip = 0;
 	for (i = 0; i < nr_found; i++) {
 		struct page *page;
 repeat:
@@ -856,6 +857,7 @@ repeat:
 			 * here as an exceptional entry: so skip over it -
 			 * we only reach this from invalidate_mapping_pages().
 			 */
+			nr_skip++;
 			continue;
 		}
 
@@ -876,7 +878,7 @@ repeat:
 	 * If all entries were removed before we could secure them,
 	 * try again, because callers stop trying once 0 is returned.
 	 */
-	if (unlikely(!ret && nr_found))
+	if (unlikely(!ret && nr_found > nr_skip))
 		goto restart;
 	rcu_read_unlock();
 	return ret;


