Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1FOFi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 01:38:28 -0400
Received: from ozlabs.org ([203.10.76.45]:34619 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1FOFiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 01:38:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark Wu <dwu@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
In-Reply-To: <4DF0A374.6090504@redhat.com>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au> <4DEF744D.9040702@redhat.com> <87mxhrgba6.fsf@rustcorp.com.au> <20110609091433.GB11773@htj.dyndns.org> <4DF0A374.6090504@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 15 Jun 2011 14:21:51 +0930
Message-ID: <87mxhjzogo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since virtio blk driver doesn't use async probe, it needn't use spinlock to protect ida.
> So remove the lock from patch.

OK, that's fine, but:
> -	if (index_to_minor(index) >= 1 << MINORBITS)
> -		return -ENOSPC;
> +	do {
> +		if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
> +			return -ENOMEM;
> +		err = ida_get_new(&vd_index_ida, &index);
> +	} while (err == -EAGAIN);
> +
> +	if (err)
> +		return err;
> +
> +	if (index_to_minor(index) >= 1 << MINORBITS) {
> +		err =  -ENOSPC;
> +		goto out_free_index;
> +	}

Is this *really* how this is supposed to be used?

Tejun, this is your code.  What do you think of something like this?
(untested)

Subject: ida: Simplified functions for id allocation.

The current hyper-optimized functions are overkill if you simply want
to allocate an id for a device.  Create versions which use an internal
lock.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/idr.h b/include/linux/idr.h
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -146,6 +146,9 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+int ida_simple_get(struct ida *ida, int min_id, int max_id);
+void ida_simple_remove(struct ida *ida, int id);
+
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -34,8 +34,10 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
+#include <linux/mutex.h>
 
 static struct kmem_cache *idr_layer_cache;
+static DEFINE_MUTEX(simple_ida);
 
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
@@ -926,6 +928,52 @@ void ida_destroy(struct ida *ida)
 EXPORT_SYMBOL(ida_destroy);
 
 /**
+ * ida_simple_get - get a new id.
+ * @ida: the (initialized) ida.
+ * @min_id: the minimum id (inclusive)
+ * @max_id: the maximum id (inclusive)
+ *
+ * Allocates an id in the range min_id <= id <= max_id, or returns -ENOSPC.
+ * On allocation failure, returns -ENOMEM.  This function can sleep.
+ *
+ * Use ida_simple_remove() to get rid of an id.
+ */
+int ida_simple_get(struct ida *ida, int min_id, int max_id)
+{
+	int ret;
+
+	mutex_lock(&simple_ida);
+	if (ida_pre_get(ida, GFP_KERNEL)) {
+		int id;
+		ret = ida_get_new_above(ida, min_id, &id);
+		if (!ret) {
+			if (id > max_id) {
+				ida_remove(ida, id);
+				ret = -ENOSPC;
+			} else
+				ret = id;
+		}
+	} else
+		ret = -ENOMEM;
+	mutex_unlock(&simple_ida);
+	return ret;
+}
+EXPORT_SYMBOL(ida_simple_get);
+
+/**
+ * ida_simple_remove - remove an allocated id.
+ * @ida: the (initialized) ida.
+ * @id: the id returned by ida_simple_get.
+ */
+void ida_simple_remove(struct ida *ida, int id)
+{
+	mutex_lock(&simple_ida);
+	ida_remove(ida, id);
+	mutex_unlock(&simple_ida);
+}
+EXPORT_SYMBOL(ida_simple_remove);
+
+/**
  * ida_init - initialize ida handle
  * @ida:	ida handle
  *


