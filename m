Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab1BPBbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:31:55 -0500
Received: from kroah.org ([198.145.64.141]:39290 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291Ab1BPAV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:37 2011
Message-Id: <20110216001437.059165660@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Marchand <jmarchan@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [120/272] kref: add kref_test_and_get
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Marchand <jmarchan@redhat.com>

commit e4a683c899cd5a49f8d684a054c95bd115a0c005 upstream.

Add kref_test_and_get() function, which atomically add a reference only if
refcount is not zero. This prevent to add a reference to an object that is
already being removed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kref.h |    1 +
 lib/kref.c           |   12 ++++++++++++
 2 files changed, 13 insertions(+)

--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -23,6 +23,7 @@ struct kref {
 
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
+int kref_test_and_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 
 #endif /* _KREF_H_ */
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -37,6 +37,18 @@ void kref_get(struct kref *kref)
 }
 
 /**
+ * kref_test_and_get - increment refcount for object only if refcount is not
+ * zero.
+ * @kref: object.
+ *
+ * Return non-zero if the refcount was incremented, 0 otherwise
+ */
+int kref_test_and_get(struct kref *kref)
+{
+	return atomic_inc_not_zero(&kref->refcount);
+}
+
+/**
  * kref_put - decrement refcount for object.
  * @kref: object.
  * @release: pointer to the function that will clean up the object when the


