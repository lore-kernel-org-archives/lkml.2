Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2H2KOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 06:14:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39245 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2H2KOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 06:14:43 -0400
Date: Wed, 29 Aug 2012 18:14:23 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH -v12 02/15] resources: Add probe_resource()
Message-ID: <20120829101423.GA18856@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
 <1340736849-14875-3-git-send-email-yinghai@kernel.org>
 <CAE9FiQVrUbEzopKfeoQZFNdNszLN96brC+rYuGXQCfZvpi_ETQ@mail.gmail.com>
 <CAE9FiQUXTngUZp2c2dLVRZjFxhXD9e+XYW6Pn0zaHvMt0fB+eA@mail.gmail.com>
 <CA+55aFxLUExCZE1=gQpDT0ip9s+iMRYEVK2QjdCGNk9iympfYA@mail.gmail.com>
 <CA+55aFyb-g77CQNoR72J0pjw76ZCy_nufP=VavT_X3xBg6=G-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyb-g77CQNoR72J0pjw76ZCy_nufP=VavT_X3xBg6=G-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082910-7606-0000-0000-000003294CFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 05:10:43PM -0700, Linus Torvalds wrote:
> On Tue, Aug 28, 2012 at 10:05 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ugh. Ok, looking closer at this,
> 
> Btw, looking at that code, I also found what looks like a potential
> locking bug in allocate_resource().
> 
> The code does
> 
>     if (new->parent)
>        .. reallocate ..
> 
> to check whether a resource was already allocated. HOWEVER, it does so
> without actually holding the resource lock. Which means that
> "new->parent" might in theory change.
> 

:( it was my mistake.

BTW: adjust_resource() also has the same problem. It is also
accessing res->parent without holding the lock.

The following patch enhances your patch to fix that potential race too.


kernel/resource.c |   81 +++++++++++++++++++++++++++++++++----------------------------
  1 file changed, 45 insertions(+), 36 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 34d4588..427ed48 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -462,50 +462,59 @@ static int find_resource(struct resource *root, struct resource *new,
 	return  __find_resource(root, NULL, new, size, constraint);
 }
 
-/**
- * reallocate_resource - allocate a slot in the resource tree given range & alignment.
- *	The resource will be relocated if the new size cannot be reallocated in the
- *	current location.
- *
- * @root: root resource descriptor
- * @old:  resource descriptor desired by caller
- * @newsize: new size of the resource descriptor
- * @constraint: the size and alignment constraints to be met.
- */
-int reallocate_resource(struct resource *root, struct resource *old,
+
+static int __reallocate_resource(struct resource *root, struct resource *old,
 			resource_size_t newsize,
 			struct resource_constraint  *constraint)
 {
-	int err=0;
+	int err;
 	struct resource new = *old;
 	struct resource *conflict;
 
-	write_lock(&resource_lock);
-
-	if ((err = __find_resource(root, old, &new, newsize, constraint)))
-		goto out;
+	err = __find_resource(root, old, &new, newsize, constraint);
+	if (err)
+		return err;
 
 	if (resource_contains(&new, old)) {
 		old->start = new.start;
 		old->end = new.end;
-		goto out;
+		return 0;
 	}
 
-	if (old->child) {
-		err = -EBUSY;
-		goto out;
-	}
+	if (old->child)
+		return -EBUSY;
 
 	if (resource_contains(old, &new)) {
 		old->start = new.start;
 		old->end = new.end;
-	} else {
-		__release_resource(old);
-		*old = new;
-		conflict = __request_resource(root, old);
-		BUG_ON(conflict);
+		return 0;
 	}
-out:
+
+	__release_resource(old);
+	*old = new;
+	conflict = __request_resource(root, old);
+	BUG_ON(conflict);
+	return 0;
+}
+
+/**
+ * reallocate_resource - allocate a slot in the resource tree given range
+ * & alignment. The resource will be relocated if the new size cannot be
+ * reallocated in the current location.
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
+	int err;
+
+	write_lock(&resource_lock);
+	err = __reallocate_resource(root, old, newsize, constraint);
 	write_unlock(&resource_lock);
 	return err;
 }
@@ -544,16 +553,16 @@ int allocate_resource(struct resource *root, struct resource *new,
 	constraint.alignf = alignf;
 	constraint.alignf_data = alignf_data;
 
-	if ( new->parent ) {
+	write_lock(&resource_lock);
+	if (new->parent) {
 		/* resource is already allocated, try reallocating with
 		   the new constraints */
-		return reallocate_resource(root, new, size, &constraint);
+		err = __reallocate_resource(root, new, size, &constraint);
+	} else {
+		err = find_resource(root, new, size, &constraint);
+		if (err >= 0 && __request_resource(root, new))
+			err = -EBUSY;
 	}
-
-	write_lock(&resource_lock);
-	err = find_resource(root, new, size, &constraint);
-	if (err >= 0 && __request_resource(root, new))
-		err = -EBUSY;
 	write_unlock(&resource_lock);
 	return err;
 }
@@ -718,12 +727,12 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
  */
 int adjust_resource(struct resource *res, resource_size_t start, resource_size_t size)
 {
-	struct resource *tmp, *parent = res->parent;
+	struct resource *tmp, *parent;
 	resource_size_t end = start + size - 1;
 	int result = -EBUSY;
 
 	write_lock(&resource_lock);
-
+	parent = res->parent;
 	if (!parent)
 		goto skip;
 

