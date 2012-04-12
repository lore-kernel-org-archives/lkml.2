Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2DLKOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab2DLKOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:14:04 -0400
Date: Thu, 12 Apr 2012 13:14:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, qemu-devel@nongnu.org
Subject: Re: [PATCH 3/3] virtio_balloon: Bugfixes for PAGE_SIZE != 4k
Message-ID: <20120412101157.GA13172@redhat.com>
References: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
 <1334208995-29985-4-git-send-email-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334208995-29985-4-git-send-email-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 03:36:35PM +1000, David Gibson wrote:
> The virtio_balloon device is specced to always operate on 4k pages.  The
> virtio_balloon driver has a feeble attempt at reconciling this with a
> lerge kernel page size, but it is (a) exactly wrong (it shifts the pfn in
> the wrong direction) and (b) insufficient (it doesn't issue multiple 4k
> balloon requests for each guest page, or correct other accounting values
> for the different in page size).
> 
> This patch fixes the various problems.  It has been tested with a powerpc
> guest kernel configured for 64kB base page size, running under qemu.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  drivers/virtio/virtio_balloon.c |   32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 553cc1f..834b7f9 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -60,13 +60,20 @@ static struct virtio_device_id id_table[] = {
>  	{ 0 },
>  };
>  
> -static u32 page_to_balloon_pfn(struct page *page)
> +#define BALLOON_PAGE_ORDER	(PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT)
> +#define PAGES_PER_ARRAY(_a)	(ARRAY_SIZE(_a) >> BALLOON_PAGE_ORDER)
> +
> +static void page_to_balloon_pfns(u32 pfns[], unsigned int n, struct page *page)
>  {
> -	unsigned long pfn = page_to_pfn(page);
> +	unsigned long bpfn = page_to_pfn(page) << BALLOON_PAGE_ORDER;
> +	u32 *p = &pfns[n << BALLOON_PAGE_ORDER];
> +	int i;
>  
>  	BUILD_BUG_ON(PAGE_SHIFT < VIRTIO_BALLOON_PFN_SHIFT);
> -	/* Convert pfn from Linux page size to balloon page size. */
> -	return pfn >> (PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT);
> +
> +	/* Enter a balloon pfn for each 4k subpage of the Linux page */
> +	for (i = 0; i < (1 << BALLOON_PAGE_ORDER); i++)
> +		p[i] = bpfn + i;
>  }
>  
>  static void balloon_ack(struct virtqueue *vq)
> @@ -84,7 +91,8 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq,
>  {
>  	struct scatterlist sg;
>  
> -	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * n);
> +	sg_init_one(&sg, vb->pfns,
> +		    sizeof(vb->pfns[0]) * (n << BALLOON_PAGE_ORDER));
>  
>  	init_completion(&vb->acked);
>  
> @@ -102,7 +110,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  	unsigned int n;
>  
>  	/* We can only do one array worth at a time. */
> -	num = min(num, ARRAY_SIZE(vb->pfns));
> +	num = min(num, PAGES_PER_ARRAY(vb->pfns));
>  
>  	for (n = 0; n < num; n++) {
>  		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
> @@ -116,7 +124,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  			msleep(200);
>  			break;
>  		}
> -		vb->pfns[n] = page_to_balloon_pfn(page);
> +		page_to_balloon_pfns(vb->pfns, n, page);
>  		totalram_pages--;
>  		vb->num_pages++;
>  		list_add(&page->lru, &vb->pages);
> @@ -134,7 +142,7 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
>  	unsigned int i;
>  
>  	for (i = 0; i < num; i++) {
> -		__free_page(pfn_to_page(pfns[i]));
> +		__free_page(pfn_to_page(pfns[i << BALLOON_PAGE_ORDER]));
>  		totalram_pages++;
>  	}
>  }
> @@ -145,12 +153,12 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  	unsigned int n;
>  
>  	/* We can only do one array worth at a time. */
> -	num = min(num, ARRAY_SIZE(vb->pfns));
> +	num = min(num, PAGES_PER_ARRAY(vb->pfns));
>  
>  	for (n = 0; n < num; n++) {
>  		page = list_first_entry(&vb->pages, struct page, lru);
>  		list_del(&page->lru);
> -		vb->pfns[n] = page_to_balloon_pfn(page);
> +		page_to_balloon_pfns(vb->pfns, n, page);
>  		vb->num_pages--;
>  	}
>  
> @@ -244,13 +252,13 @@ static inline s64 towards_target(struct virtio_balloon *vb)
>  	vb->vdev->config->get(vb->vdev,
>  			      offsetof(struct virtio_balloon_config, num_pages),
>  			      &v, sizeof(v));
> -	target = le32_to_cpu(v);
> +	target = le32_to_cpu(v) >> BALLOON_PAGE_ORDER;
>  	return target - vb->num_pages;
>  }
>  
>  static void update_balloon_size(struct virtio_balloon *vb)
>  {
> -	__le32 actual = cpu_to_le32(vb->num_pages);
> +	__le32 actual = cpu_to_le32(vb->num_pages << BALLOON_PAGE_ORDER);
>  
>  	vb->vdev->config->set(vb->vdev,
>  			      offsetof(struct virtio_balloon_config, actual),
> -- 
> 1.7.9.5

Good catch!

Unfortunately I find the approach a bit convoluted.
It also looks like when host asks for 5 balloon pages
you interpret this as 0 where 16 is probably saner
on a 64K system.

I think it's easier if we just keep doing math in
balloon pages. I also get confused by shift operations,
IMO / and * are clearer where they are applicable.
Something like the below would make more sense I think.

I also wrote up a detailed commit log, so we have
the bugs and the expected consequences listed explicitly.

I'm out of time for this week - so completely untested, sorry.
Maybe you could try this out? That would be great.
Thanks!

--->
virtio_balloon: fix handling of PAGE_SIZE != 4k

As reported by David Gibson, current code handles PAGE_SIZE != 4k
completely wrong which can lead to guest memory corruption errors.

- page_to_balloon_pfn is wrong: e.g. on system with 64K page size
 it gives the same pfn value for 16 different pages.

- we also need to convert back to linux pfns when we free.

- for each linux page we need to tell host about multiple balloon
  pages, but code only adds one pfn to the array.

Warning: patch is completely untested.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 9e95ca6..e641e35 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -60,13 +60,23 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+/* Balloon device works in 4K page units. So each page is
+ * pointed to by multiple balloon pages. */
+#define VIRTIO_BALLOON_PAGES_PER_PAGE (PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 
 	BUILD_BUG_ON(PAGE_SHIFT < VIRTIO_BALLOON_PFN_SHIFT);
 	/* Convert pfn from Linux page size to balloon page size. */
-	return pfn >> (PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT);
+	return pfn * VIRTIO_BALLOON_PAGES_PER_PAGE;
+}
+
+static struct page *balloon_pfn_to_page(u32 pfn)
+{
+	BUG_ON(pfn % VIRTIO_BALLOON_PAGES_PER_PAGE);
+	return pfn_to_page(pfn / VIRTIO_BALLOON_PAGES_PER_PAGE);
 }
 
 static void balloon_ack(struct virtqueue *vq)
@@ -96,12 +106,24 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 	wait_for_completion(&vb->acked);
 }
 
+static void set_page_pfns(u32 pfns[], struct page *page)
+{
+	unsigned int i;
+
+	/* Set balloon pfns pointing at this page.
+	 * Note that the first pfn points at start of the page. */
+	for (i = 0; i < VIRTIO_BALLOON_PAGES_PER_PAGE; i++)
+		pfns[i] = page_to_balloon_pfn(page) + i;
+}
+
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
-	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
+	for (vb->num_pfns = 0; vb->num_pfns < num;
+	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE)
+		int i;
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 					__GFP_NOMEMALLOC | __GFP_NOWARN);
 		if (!page) {
@@ -113,9 +135,9 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 			msleep(200);
 			break;
 		}
-		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
+		set_page_pfns(vb->pfns + vb->num_pfns, page);
+		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
 		totalram_pages--;
-		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
 	}
 
@@ -130,8 +152,9 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
 {
 	unsigned int i;
 
-	for (i = 0; i < num; i++) {
-		__free_page(pfn_to_page(pfns[i]));
+	/* Find pfns pointing at start of each page, get pages and free them. */
+	for (i = 0; i < num; i += VIRTIO_BALLOON_PAGES_PER_PAGE) {
+		__free_page(balloon_pfn_to_page(pfns[i]));
 		totalram_pages++;
 	}
 }
@@ -143,11 +166,12 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
 
-	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
+	for (vb->num_pfns = 0; vb->num_pfns < num;
+	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE)
 		page = list_first_entry(&vb->pages, struct page, lru);
 		list_del(&page->lru);
-		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
-		vb->num_pages--;
+		set_page_pfns(vb->pfns, &vb->num_pfns, page);
+		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
 
 	/*
