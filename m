Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0FWPtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:49:14 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:45624 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752684Ab0FWPtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:49:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jmRfl7uUDKx5Ij5pZe6T6kWFozuuwa8X4Ee7EulW9LrfoCGU7N1TpvKI0V4Gw7Gti/EEMv+XFRkUzOHlAM2KBaof5oXrUF3lqabgUXjjT2z9rWqj+4+ssfmI+L3utJxs;
Date: Wed, 23 Jun 2010 08:47:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, nanhai.zou@intel.com,
       Benny Halevy <bhalevy@panasas.com>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, "Jin, Gordon" <gordon.jin@intel.com>
Subject: Re: [patch] i915: take struct_mutex in i915_dma_cleanup()
Message-ID: <20100623084718.2dfe6e7f@virtuousgeek.org>
In-Reply-To: <20100623111954.GA16433@bicker>
References: <20100623111954.GA16433@bicker>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 13:19:55 +0200
Dan Carpenter <error27@gmail.com> wrote:

> intel_cleanup_ring_buffer() calls drm_gem_object_unreference() (as
> opposed to drm_gem_object_unreference_unlocked()) so it needs to be
> called with "struct_mutex" held.  If we don't hold the lock, it triggers
> a BUG_ON(!mutex_is_locked(&dev->struct_mutex));
> 
> I also audited the other places that call intel_cleanup_ring_buffer()
> and they all hold the lock so they're OK.
> 
> This was introduced in: 8187a2b70e3 "drm/i915: introduce
> intel_ring_buffer structure (V2)" and it's a regression from v2.6.34.
> 
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=16247
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Reported-by: Benny Halevy <bhalevy@panasas.com>
> Tested-by: Benny Halevy <bhalevy@panasas.com>

Reminds me, Gordon can you add module unload testing to your set of
basic daily tests?  To unload you need to unbind the fbcon interface
first, my script is like this:

echo 0 > /sys/class/vtconsole/vtcon1/bind
rmmod i915
rmmod drm_kms_helper
rmmod drm
modprobe i915
echo 1 > /sys/class/vtconsole/vtcon1/bind

If unload and re-load doesn't work please file a bug and see if you can
bisect it.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
