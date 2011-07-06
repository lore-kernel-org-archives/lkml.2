Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1GFIxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:53:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49135 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab1GFIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:53:27 -0400
Date: Wed, 6 Jul 2011 01:53:16 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ram Pai <linuxram@us.ibm.com>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, socketcan@hartkopp.net,
        bhelgaas@google.com, linux@dominikbrodowski.net
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
Message-ID: <20110706085316.GA3543@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
 <CA+55aFwo-48yKu+raRF3B9n1mqd1qV35eDq56Yi+erPygkuTvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwo-48yKu+raRF3B9n1mqd1qV35eDq56Yi+erPygkuTvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 02:30:00PM -0700, Linus Torvalds wrote:
> Gaah. I'm still rather uncomfortable about this, and I wonder about
> patch 2 in particular. It seems that that patch could/should be split
> up: the whole change to "find_resource()" etc looks like prime
> material for a separate patch that splits up that function and
> explains why that change is done.
> 
> Also, quite frankly, by the time you pass in eight different arguments
> (and pretty complex ones at that, with one being the alignment
> function pointer), I start thinking that you should have passed in a
> pointer to a descriptor structure instead. I get the feeling that the
> "resource requirements" really should be a structure instead of lots
> of individual arguments:
> 
> IOW, this part:
> 
> +                     resource_size_t newsize, resource_size_t min,
> +                     resource_size_t max, resource_size_t align,
> +                     resource_size_t (*alignf)(void *,
> +                                               const struct resource *,
> +                                               resource_size_t,
> +                                               resource_size_t),
> +                     void *alignf_data)
> 
> really makes me go
> 
>    struct resource_requirement {
>       resource_size_t min, max, align;
>       resource_size_t (*alignf)(const struct resource *, struct
> resource_requirement *);
>       void *alignf_data);
>    };
> 
> and I'd really change the function argument to take that kind of
> simplified thing instead.
> 
> And that cleanup/re-organization would be prime material for a totally
> independent patch that changes no semantics at all, just prepares for
> the other changes.
> 
> That way the final "patch 2" would be smaller and do the semantic
> changes, instead of being a mix of semantic changes and infrastructure
> changes.
> 
> And some of the cleanup stuff I could merge for 3.0 just to make things easier.
> 
> Hmm?

Here is a cleaned up patch that just adds functionality to kernel/resource.c
It does make a small semantic addition to allocate_resource(), where it reallocates
the resource with a newer size if that resource was already allocated.

Will this be acceptable for 3.0.0?

From: Ram Pai <linuxram@us.ibm.com>
Date: Tue, 5 Jul 2011 23:44:30 -0700
Subject: [PATCH 1/1]  resource: ability to resize an allocated resource

Provides the ability to resize a resource that is already allocated.
This functionality is put in place to support reallocation needs of
pci resources.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 kernel/resource.c |  118 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 99 insertions(+), 19 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 798e2fa..ba727b6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -38,6 +38,14 @@ struct resource iomem_resource = {
 };
 EXPORT_SYMBOL(iomem_resource);
 
+/* constraints to be met while allocating resources */
+struct resource_constraint {
+	resource_size_t min, max, align;
+	resource_size_t (*alignf)(void *, const struct resource *,
+			resource_size_t, resource_size_t);
+	void *alignf_data;
+};
+
 static DEFINE_RWLOCK(resource_lock);
 
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
@@ -384,16 +392,13 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
 }
 
 /*
- * Find empty slot in the resource tree given range and alignment.
+ * Find empty slot in the resource tree with the given range and
+ * alignment constraints
  */
-static int find_resource(struct resource *root, struct resource *new,
-			 resource_size_t size, resource_size_t min,
-			 resource_size_t max, resource_size_t align,
-			 resource_size_t (*alignf)(void *,
-						   const struct resource *,
-						   resource_size_t,
-						   resource_size_t),
-			 void *alignf_data)
+static int __find_resource(struct resource *root, struct resource *old,
+			 struct resource *new,
+			 resource_size_t  size,
+			 struct resource_constraint *constraint)
 {
 	struct resource *this = root->child;
 	struct resource tmp = *new, avail, alloc;
@@ -404,25 +409,26 @@ static int find_resource(struct resource *root, struct resource *new,
 	 * Skip past an allocated resource that starts at 0, since the assignment
 	 * of this->start - 1 to tmp->end below would cause an underflow.
 	 */
-	if (this && this->start == 0) {
-		tmp.start = this->end + 1;
-		this = this->sibling;
+	if (this && this->start == root->start) {
+		tmp.start = (this == old) ? old->start : this->end + 1;
+ 		this = this->sibling;
 	}
 	for(;;) {
 		if (this)
-			tmp.end = this->start - 1;
+			tmp.end = (this == old) ?  this->end : this->start - 1;
 		else
 			tmp.end = root->end;
 
-		resource_clip(&tmp, min, max);
+		resource_clip(&tmp, constraint->min, constraint->max);
 		arch_remove_reservations(&tmp);
 
 		/* Check for overflow after ALIGN() */
 		avail = *new;
-		avail.start = ALIGN(tmp.start, align);
+		avail.start = ALIGN(tmp.start, constraint->align);
 		avail.end = tmp.end;
 		if (avail.start >= tmp.start) {
-			alloc.start = alignf(alignf_data, &avail, size, align);
+			alloc.start = constraint->alignf(constraint->alignf_data, &avail,
+					size, constraint->align);
 			alloc.end = alloc.start + size - 1;
 			if (resource_contains(&avail, &alloc)) {
 				new->start = alloc.start;
@@ -432,14 +438,75 @@ static int find_resource(struct resource *root, struct resource *new,
 		}
 		if (!this)
 			break;
-		tmp.start = this->end + 1;
+		if (this != old)
+			tmp.start = this->end + 1;
 		this = this->sibling;
 	}
 	return -EBUSY;
 }
 
+/*
+ * Find empty slot in the resource tree given range and alignment.
+ */
+static int find_resource(struct resource *root, struct resource *new,
+			resource_size_t size,
+			struct resource_constraint  *constraint)
+{
+	return  __find_resource(root, NULL, new, size, constraint);
+}
+
+/**
+ * reallocate_resource - allocate a slot in the resource tree given range & alignment.
+ *	The resource will be relocated if the new size cannot be reallocated in the
+ *	current location.
+ *
+ * @root: root resource descriptor
+ * @old:  resource descriptor desired by caller
+ * @newsize: new size of the resource descriptor
+ * @constraint: the size and alignment constraints to be met.
+ */
+int reallocate_resource(struct resource *root, struct resource *old,
+			resource_size_t newsize,
+			struct resource_constraint  *constraint)
+{
+	int err=0;
+	struct resource new = *old;
+	struct resource *conflict;
+
+	write_lock(&resource_lock);
+
+	if ((err = __find_resource(root, old, &new, newsize, constraint)))
+		goto out;
+
+	if (resource_contains(&new, old)) {
+		old->start = new.start;
+		old->end = new.end;
+		goto out;
+	}
+
+	if (old->child) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (resource_contains(old, &new)) {
+		old->start = new.start;
+		old->end = new.end;
+	} else {
+		__release_resource(old);
+		*old = new;
+		conflict = __request_resource(root, old);
+		BUG_ON(conflict);
+	}
+out:
+	write_unlock(&resource_lock);
+	return err;
+}
+
+
 /**
- * allocate_resource - allocate empty slot in the resource tree given range & alignment
+ * allocate_resource - allocate empty slot in the resource tree given range & alignment.
+ * 	The resource will be reallocated with a new size if it was already allocated
  * @root: root resource descriptor
  * @new: resource descriptor desired by caller
  * @size: requested resource region size
@@ -459,12 +526,25 @@ int allocate_resource(struct resource *root, struct resource *new,
 		      void *alignf_data)
 {
 	int err;
+	struct resource_constraint constraint;
 
 	if (!alignf)
 		alignf = simple_align_resource;
 
+	constraint.min = min;
+	constraint.max = max;
+	constraint.align = align;
+	constraint.alignf = alignf;
+	constraint.alignf_data = alignf_data;
+
+	if ( new->parent ) {
+		/* resource is already allocated, try reallocating with
+		   the new constraints */
+		return reallocate_resource(root, new, size, &constraint);
+	}
+
 	write_lock(&resource_lock);
-	err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
+	err = find_resource(root, new, size, &constraint);
 	if (err >= 0 && __request_resource(root, new))
 		err = -EBUSY;
 	write_unlock(&resource_lock);
-- 
1.7.4.1

