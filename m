Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab0DZPUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:20:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:41934 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0DZPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:20:46 -0400
Subject: Re: request_firmware API exhaust memory
From: Kay Sievers <kay.sievers@vrfy.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Greg KH <greg@kroah.com>, Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100419145934.GA10893@kroah.com>
	 <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
	 <20100425163711.GA20196@kroah.com>
	 <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com>
	 <20100425193658.GA24039@kroah.com>
	 <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
	 <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 17:19:00 +0200
Message-ID: <1272295140.2434.8.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 12:38 +0200, Kay Sievers wrote:
> On Sun, Apr 25, 2010 at 22:09, Tomas Winkler <tomasw@gmail.com> wrote:
> > Said thing is that I don't see where the memory goes.... Anyhow I will
> > try to run valgrin on udev just to be sure.
> 
> Nah, that memory would be freed, if you kill all udev processes, which
> it doesn't.
> 
> The many udev worker processes you see for a few seconds was caused by
> udevd handling events with TIMEOUT= set special. We need to make sure,
> that firmware events run immediately and don't wait for other
> processes to finish. The logic who does that was always creating a new
> worker. I changed this now, but this will not affect the underlying
> problem you are seeing, it will just make the udev workers not grow in
> a timeframe of less than 10 seconds. The change is here:
>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=665ee17def2caa6811ae032ae68ebf8239a18cf8
> but as mentioned, this change is unrelated to the memory leak you are seeing.
> 
> > I'll be glad If someone can run my simple driver I posted and confirm
> > that sees the same problem
> 
> I can confirm that memory gets lost. I suspect for some reason the
> firmware does not get properly cleaned up. If you increase the size of
> the firmware image, it will leak memory much faster.

I guess, the assumption that vfree() will free pages which are allocated
by custom code, and not by vmalloc(), is not true.

The attached changes seem to fix the issue for me.

The custom page array mangling was introduced by David as an optimization
with commit 6e03a201bbe8137487f340d26aa662110e324b20 and this should be
checked, and if needed be fixed.

Cheers,
Kay


diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 985da11..fe4e872 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -162,7 +162,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 			mutex_unlock(&fw_lock);
 			break;
 		}
-		vfree(fw_priv->fw->data);
+		vunmap(fw_priv->fw->data);
 		fw_priv->fw->data = NULL;
 		for (i = 0; i < fw_priv->nr_pages; i++)
 			__free_page(fw_priv->pages[i]);
@@ -176,7 +176,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
-			vfree(fw_priv->fw->data);
+			vunmap(fw_priv->fw->data);
 			fw_priv->fw->data = vmap(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
@@ -184,9 +184,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 				dev_err(dev, "%s: vmap() failed\n", __func__);
 				goto err;
 			}
-			/* Pages will be freed by vfree() */
-			fw_priv->page_array_size = 0;
-			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
 			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
 			break;
@@ -578,7 +575,7 @@ release_firmware(const struct firmware *fw)
 			if (fw->data == builtin->data)
 				goto free_fw;
 		}
-		vfree(fw->data);
+		vunmap(fw->data);
 	free_fw:
 		kfree(fw);
 	}


