Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0EQQsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:48:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab0EQQs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:48:29 -0400
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTimZrFv7YWOdy6dvtbzFmwB85FyPntZULmN0f6VN@mail.gmail.com>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <1273589282.1810.10.camel@laptop>
	 <AANLkTimZrFv7YWOdy6dvtbzFmwB85FyPntZULmN0f6VN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 18:48:00 +0200
Message-ID: <1274114880.5605.5236.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 16:25 +0200, Stephane Eranian wrote:
> > Right, but I think the default of inherit is right, and once you do that
> > you basically have to do the per-task-per-cpu thing, otherwise your
> > fancy 16-way will start spending most of its time in cacheline bounces.
> >
> In that case, don't you think you should also ensure that the buffer is
> allocated on the NUMA node of the designated per-thread-per-cpu?
> I don't think it is the case today.

Yeah, something like the below ought to do I guess..

Almost-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9dbe8cd..85e2d32 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2288,6 +2288,19 @@ perf_mmap_to_page(struct perf_mmap_data *data, unsigned long pgoff)
 	return virt_to_page(data->data_pages[pgoff - 1]);
 }
 
+static void *perf_mmap_alloc_page(int cpu)
+{
+	struct page *page;
+	int node;
+
+	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct perf_mmap_data *
 perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 {
@@ -2304,12 +2317,12 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	if (!data)
 		goto fail;
 
-	data->user_page = (void *)get_zeroed_page(GFP_KERNEL);
+	data->user_page = perf_mmap_alloc_page(event->cpu);
 	if (!data->user_page)
 		goto fail_user_page;
 
 	for (i = 0; i < nr_pages; i++) {
-		data->data_pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		data->data_pages[i] = perf_mmap_alloc_page(event->cpu);
 		if (!data->data_pages[i])
 			goto fail_data_pages;
 	}

