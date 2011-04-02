Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1DBCVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 22:21:11 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57514 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754225Ab1DBCVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 22:21:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Fw+Gh6uxvbhm+m5mapmYVzKwerKGhnxOnHfJzLPTuwQrqdlqw6oFFUOHCqe/ouThQ+ic8yW13RsTDolmYiNre1irk529bXXmnIlFzwU7Z/Ccx8mDl5iucfwtGA+5/38s;
Date: Fri, 1 Apr 2011 19:21:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org
Subject: Re: Lenovo resume from suspends hangs in i915_gpu_busy or so
Message-ID: <20110401192106.2cca8cd7@jbarnes-x200>
In-Reply-To: <20110402002410.GL6464@gamma.logic.tuwien.ac.at>
References: <20110401021055.GB6071@gamma.logic.tuwien.ac.at>
	<20110401051511.GE9128@gamma.logic.tuwien.ac.at>
	<20110401090817.01717af0@jbarnes-desktop>
	<20110402002410.GL6464@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011 09:24:10 +0900
Norbert Preining <preining@logic.at> wrote:
> > Hm, ok so on resume we're checking GPU busyness, which is normal,
> > but end up hanging on the spinlock?  Do you see what scrolls by
> > above the text you took a picture of (probably a "task hung"
> > message?).
> 
> More than what I can see on the screen shot I cannot grasp.
> 
> > Does this happen reliably?  Does a previous kernel work ok?
> 
> Reliable: yes
> Previous: I don't know, but I can try out some older git release.
>    which one do you suggest?
>   (I got the laptop recently so I don't have a long history with that
> one)

Well I'd start with something like 2.6.37, I think that's the first
release that had IPS.  At least it's good that you can reproduce it
easily...  Can you add something like this to your kernel to see why
the gpu_busy call might be hanging?  I'm guessing we hang trying to
take the spinlock; if so enabling lockdep debugging might tell us who
else took it.

Thanks,
Jesse

diff --git a/drivers/gpu/drm/i915/i915_dma.c
b/drivers/gpu/drm/i915/i915_dma.c index 8cb7f93..47fb29a 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1790,14 +1790,18 @@ bool i915_gpu_busy(void)
        struct drm_i915_private *dev_priv;
        bool ret = false;
 
+       DRM_ERROR("entering busy check, trying to take lock\n");
+       
        spin_lock(&mchdev_lock);
        if (!i915_mch_dev)
                goto out_unlock;
+       DRM_ERROR("got lock, returning current busy status\n");
        dev_priv = i915_mch_dev;
 
        ret = dev_priv->busy;
 
 out_unlock:
+       DRM_ERROR("unlock & return\n");
        spin_unlock(&mchdev_lock);
 
        return ret;
