Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2GBIwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:52:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64726 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2GBIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:52:48 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <4FCD272E.1020300@codeaurora.org>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org>
 <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com> <4FCD272E.1020300@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Jul 2012 11:52:27 +0300
Message-ID: <CAK=WgbZu1hYOd27r259b2v48VFYeOZ4UE5sD2awZDxgBgjAsXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 12:22 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 05/30/12 05:38, Ohad Ben-Cohen wrote:
>> On Wed, May 30, 2012 at 11:42 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>> -     /* the rproc will only be released after its refcount drops to zero */
>>>> -     kref_put(&rproc->refcount, rproc_release);
>>>> +     /* unroll rproc_alloc. TODO: we may want to let the users do that */
>>>> +     put_device(&rproc->dev);
>>> Yes I think we want rproc_free() to actually call put_device() the last
>>> time and free the resources.
>> Yeah that was one of the options I considered.
>>
>> In general, we have three options here:
>> 1. Remove this last put_device invocation, and require users to call
>> rproc_free() even after they call rproc_unregister().
>> 2. Let rproc_unregister() still do this, by calling rproc_free().
>> 3. Let rproc_unregister() still do this, by invoking put_device().
>>
>> I think that (1) looks better since it makes the interface symmetric
>> and straight forward.
>>
>> (2) and (3) may be simper because users only need to call
>> rproc_unregister and that's it.
>>
>> I eventually decided against (1) because I was concerned it will only
>> confuse users at this point.
>>
>> But if you think that (1) is nicer too then maybe we should go ahead
>> and do that change.
>
> Option 1 is nicer and it also follows the model other subsystems have
> put forth such as the input subsystem.

>From 0fbf3004c1a52ae4c0554366409a2bfe401801ef Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Jul 2012 11:41:16 +0300
Subject: [PATCH] remoteproc: simplify unregister/free interfaces

Simplify the unregister/free interfaces, and make them easier
to understand and use, by moving to a symmetric and consistent
alloc() -> register() -> unregister() -> free() flow.

To create and register an rproc instance, one needed to invoke
rproc_alloc() followed by rproc_register().

To unregister and free an rproc instance, one now needs to invoke
rproc_unregister() followed by rproc_free().

Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 Documentation/remoteproc.txt         | 21 ++++++++-------------
 drivers/remoteproc/omap_remoteproc.c |  5 ++++-
 drivers/remoteproc/remoteproc_core.c | 25 ++++++++-----------------
 3 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
index 70a048c..ad6ded4 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.txt
@@ -120,14 +120,14 @@ int dummy_rproc_example(struct rproc *my_rproc)
       On success, the new rproc is returned, and on failure, NULL.

       Note: _never_ directly deallocate @rproc, even if it was not registered
-      yet. Instead, if you just need to unroll rproc_alloc(), use rproc_free().
+      yet. Instead, when you need to unroll rproc_alloc(), use rproc_free().

   void rproc_free(struct rproc *rproc)
     - Free an rproc handle that was allocated by rproc_alloc.
-      This function should _only_ be used if @rproc was only allocated,
-      but not registered yet.
-      If @rproc was already successfully registered (by calling
-      rproc_register()), then use rproc_unregister() instead.
+      This function essentially unrolls rproc_alloc(), by decrementing the
+      rproc's refcount. It doesn't directly free rproc; that would happen
+      only if there are no other references to rproc and its refcount now
+      dropped to zero.

   int rproc_register(struct rproc *rproc)
     - Register @rproc with the remoteproc framework, after it has been
@@ -143,19 +143,14 @@ int dummy_rproc_example(struct rproc *my_rproc)
       probed.

   int rproc_unregister(struct rproc *rproc)
-    - Unregister a remote processor, and decrement its refcount.
-      If its refcount drops to zero, then @rproc will be freed. If not,
-      it will be freed later once the last reference is dropped.
-
+    - Unroll rproc_register().
       This function should be called when the platform specific rproc
       implementation decides to remove the rproc device. it should
       _only_ be called if a previous invocation of rproc_register()
       has completed successfully.

-      After rproc_unregister() returns, @rproc is _not_ valid anymore and
-      it shouldn't be used. More specifically, don't call rproc_free()
-      or try to directly free @rproc after rproc_unregister() returns;
-      none of these are needed, and calling them is a bug.
+      After rproc_unregister() returns, @rproc is still valid, and its
+      last refcount should be decremented by calling rproc_free().

       Returns 0 on success and -EINVAL if @rproc isn't valid.

diff --git a/drivers/remoteproc/omap_remoteproc.c
b/drivers/remoteproc/omap_remoteproc.c
index f45230c..0f1afc9 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -214,7 +214,10 @@ static int __devexit omap_rproc_remove(struct
platform_device *pdev)
 {
 	struct rproc *rproc = platform_get_drvdata(pdev);

-	return rproc_unregister(rproc);
+	rproc_unregister(rproc);
+	rproc_free(rproc);
+
+	return 0;
 }

 static struct platform_driver omap_rproc_driver = {
diff --git a/drivers/remoteproc/remoteproc_core.c
b/drivers/remoteproc/remoteproc_core.c
index c0c0311..ac2d7163 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1485,7 +1485,7 @@ static struct device_type rproc_type = {
  * On success the new rproc is returned, and on failure, NULL.
  *
  * Note: _never_ directly deallocate @rproc, even if it was not registered
- * yet. Instead, if you just need to unroll rproc_alloc(), use rproc_free().
+ * yet. Instead, when you need to unroll rproc_alloc(), use rproc_free().
  */
 struct rproc *rproc_alloc(struct device *dev, const char *name,
 				const struct rproc_ops *ops,
@@ -1539,14 +1539,13 @@ struct rproc *rproc_alloc(struct device *dev,
const char *name,
 EXPORT_SYMBOL(rproc_alloc);

 /**
- * rproc_free() - free an rproc handle that was allocated by rproc_alloc
+ * rproc_free() - unroll rproc_alloc()
  * @rproc: the remote processor handle
  *
- * This function should _only_ be used if @rproc was only allocated,
- * but not registered yet.
+ * This function decrements the rproc dev refcount.
  *
- * If @rproc was already successfully registered (by calling rproc_register()),
- * then use rproc_unregister() instead.
+ * If no one holds any reference to rproc anymore, then its refcount would
+ * now drop to zero, and it would be freed.
  */
 void rproc_free(struct rproc *rproc)
 {
@@ -1558,19 +1557,14 @@ EXPORT_SYMBOL(rproc_free);
  * rproc_unregister() - unregister a remote processor
  * @rproc: rproc handle to unregister
  *
- * Unregisters a remote processor, and decrements its refcount.
- * If its refcount drops to zero, then @rproc will be freed. If not,
- * it will be freed later once the last reference is dropped.
- *
  * This function should be called when the platform specific rproc
  * implementation decides to remove the rproc device. it should
  * _only_ be called if a previous invocation of rproc_register()
  * has completed successfully.
  *
- * After rproc_unregister() returns, @rproc is _not_ valid anymore and
- * it shouldn't be used. More specifically, don't call rproc_free()
- * or try to directly free @rproc after rproc_unregister() returns;
- * none of these are needed, and calling them is a bug.
+ * After rproc_unregister() returns, @rproc isn't freed yet, because
+ * of the outstanding reference created by rproc_alloc. To decrement that
+ * one last refcount, one still needs to call rproc_free().
  *
  * Returns 0 on success and -EINVAL if @rproc isn't valid.
  */
@@ -1593,9 +1587,6 @@ int rproc_unregister(struct rproc *rproc)

 	device_del(&rproc->dev);

-	/* unroll rproc_alloc. TODO: we may want to let the users do that */
-	put_device(&rproc->dev);
-
 	return 0;
 }
 EXPORT_SYMBOL(rproc_unregister);
-- 
1.7.10.rc3.743.gaa3bb87
