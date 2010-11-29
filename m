Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0K2I1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0K2I1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:27:07 -0500
Date: Mon, 29 Nov 2010 10:25:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost: correctly set bits of dirty pages
Message-ID: <20101129082553.GA25759@redhat.com>
References: <20101129054819.24923.26439.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
 <20101129081840.GB25496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129081840.GB25496@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:18:40AM +0200, Michael S. Tsirkin wrote:
> On Mon, Nov 29, 2010 at 01:48:20PM +0800, Jason Wang wrote:
> > When counting pages we should increase it by 1 instead of VHOST_PAGE_SIZE,
> > and also make log_write() can correctly process the request across
> > pages with write_address not start at page boundary.
> > 
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> 
> Thanks, good catch!
> But let's to it in small steps: first, a small patch to fix the bug:
> I think this is equivalent, right?
> 
> Subject: vhost: correctly set bits of dirty pages
> 
> When counting pages we should increase address by 1 instead of
> VHOST_PAGE_SIZE, and also make log_write() can correctly process the
> request across pages with write_address not starting at page boundary.
> 
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

And then this on top:


vhost: better variable name in logging

We really store a page offset in write_address,
so rename it write_page to avoid confusion.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d0a3552..1a3d3ed 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -884,15 +884,15 @@ static int set_bit_to_user(int nr, void __user *addr)
 static int log_write(void __user *log_base,
 		     u64 write_address, u64 write_length)
 {
+	u64 write_page = write_address / VHOST_PAGE_SIZE
 	int r;
 	if (!write_length)
 		return 0;
 	write_length += write_address % VHOST_PAGE_SIZE;
-	write_address /= VHOST_PAGE_SIZE;
 	for (;;) {
 		u64 base = (u64)(unsigned long)log_base;
-		u64 log = base + write_address / 8;
-		int bit = write_address % 8;
+		u64 log = base + write_page / 8;
+		int bit = write_page % 8;
 		if ((u64)(unsigned long)log != log)
 			return -EFAULT;
 		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
@@ -901,7 +901,7 @@ static int log_write(void __user *log_base,
 		if (write_length <= VHOST_PAGE_SIZE)
 			break;
 		write_length -= VHOST_PAGE_SIZE;
-		write_address += 1;
+		write_page += 1;
 	}
 	return r;
 }
