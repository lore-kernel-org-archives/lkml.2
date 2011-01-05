Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1AEPDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:03:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1AEPC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:02:59 -0500
Message-ID: <4D2487F9.8030704@redhat.com>
Date: Wed, 05 Jan 2011 16:02:17 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH 1/2 v2] kref: add kref_test_and_get
References: <4CFF3DA4.5060705@jp.fujitsu.com>	 <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com>	 <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com>	 <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com>	 <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com>	 <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com>	 <4D23423A.60707@redhat.com> <1294157114.3579.102.camel@edumazet-laptop>
In-Reply-To: <1294157114.3579.102.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add kref_test_and_get() function, which atomically add a reference only if
refcount is not zero. This prevent to add a reference to an object that is
already being removed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 include/linux/kref.h |    1 +
 lib/kref.c           |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 6cc38fc..90b9e44 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -23,6 +23,7 @@ struct kref {
 
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
+int kref_test_and_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 
 #endif /* _KREF_H_ */
diff --git a/lib/kref.c b/lib/kref.c
index d3d227a..e7a6e10 100644
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
