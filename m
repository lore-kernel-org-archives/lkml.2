Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0D0Mn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:43:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:51468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab0D0Mn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:43:28 -0400
Subject: Re: request_firmware API exhaust memory
From: David Woodhouse <dwmw2@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>, dhowells@redhat.com
Cc: Tomas Winkler <tomasw@gmail.com>, Greg KH <greg@kroah.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <s2yac3eb2511004270505g4ded10f5k5322850e8b58790f@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100419145934.GA10893@kroah.com>
	 <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
	 <20100425163711.GA20196@kroah.com>
	 <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com>
	 <20100425193658.GA24039@kroah.com>
	 <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
	 <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
	 <1272295140.2434.8.camel@yio.site>
	 <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com>
	 <s2yac3eb2511004270505g4ded10f5k5322850e8b58790f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 13:43:07 +0100
Message-ID: <1272372187.5484.3981.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 14:05 +0200, Kay Sievers wrote:
> 
> The patch I posted makes the issue go away. It's still not the right
> fix, because the pages are only get freed when the device id cleaned
> up, not on calling release_firmware. But it should illustrate the
> underlying issue, and that there is no leaked memory anymore.
> 
> >  I think this needs some more review.
> 
> If David does not fix it, it probably just needs to be reverted. And
> instead of implementing our own "memory management", we should rather
> add a vrealloc(), and the firmware loader should use that. 

The whole point was to avoid the vrealloc(). We really don't want to be
screwing with page tables, globally, for each page written from
userspace.

This untested patch attempts to put the page array into the 'struct
firmware' so that we can free it from release_firmware().

It would actually be nice if we could make that the _primary_ method of
returning data to drivers, and we could ditch the vmap() requirement
altogether... drivers which really need it to be virtually contiguous
can depend on CONFIG_MMU and do the vmap() for themselves.

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 985da11..cc9a79b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -162,8 +162,13 @@ static ssize_t firmware_loading_store(struct device *dev,
 			mutex_unlock(&fw_lock);
 			break;
 		}
-		vfree(fw_priv->fw->data);
+		vunmap(fw_priv->fw->data);
 		fw_priv->fw->data = NULL;
+		if (fw_priv->fw->pages) {
+			for (i = 0; i < PFN_UP(fw_priv->fw->size); i++)
+				__free_page(fw_priv->fw->pages[i]);
+			kfree(fw_priv->fw->pages);
+		}
 		for (i = 0; i < fw_priv->nr_pages; i++)
 			__free_page(fw_priv->pages[i]);
 		kfree(fw_priv->pages);
@@ -176,7 +181,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
-			vfree(fw_priv->fw->data);
+			vunmap(fw_priv->fw->data);
 			fw_priv->fw->data = vmap(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
@@ -184,7 +189,9 @@ static ssize_t firmware_loading_store(struct device *dev,
 				dev_err(dev, "%s: vmap() failed\n", __func__);
 				goto err;
 			}
-			/* Pages will be freed by vfree() */
+			/* Pages are now owned by 'struct firmware' */
+			fw_priv->fw->pages = fw_priv->pages;
+			fw_priv->pages = NULL;
 			fw_priv->page_array_size = 0;
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
@@ -571,6 +578,7 @@ void
 release_firmware(const struct firmware *fw)
 {
 	struct builtin_fw *builtin;
+	int i;
 
 	if (fw) {
 		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
@@ -578,7 +586,12 @@ release_firmware(const struct firmware *fw)
 			if (fw->data == builtin->data)
 				goto free_fw;
 		}
-		vfree(fw->data);
+		vunmap(fw->data);
+		if (fw->pages) {
+			for (i = 0; i < PFN_UP(fw->size); i++)
+				__free_page(fw->pages[i]);
+			kfree(fw->pages);
+		}
 	free_fw:
 		kfree(fw);
 	}


-- 
dwmw2

