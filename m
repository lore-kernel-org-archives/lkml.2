Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1DSUZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:25:06 -0400
Received: from kroah.org ([198.145.64.141]:35569 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1DSURT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:47 2011
Message-Id: <20110419201047.022198849@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, NeilBrown <neilb@suse.de>
Subject: [36/70] mm/thp: use conventional format for boolean attributes
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit e27e6151b154ff6e5e8162efa291bc60196d29ea upstream.

The conventional format for boolean attributes in sysfs is numeric ("0" or
"1" followed by new-line).  Any boolean attribute can then be read and
written using a generic function.  Using the strings "yes [no]", "[yes]
no" (read), "yes" and "no" (write) will frustrate this.

[akpm@linux-foundation.org: use kstrtoul()]
[akpm@linux-foundation.org: test_bit() doesn't return 1/0, per Neil]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/huge_memory.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -244,24 +244,28 @@ static ssize_t single_flag_show(struct k
 				struct kobj_attribute *attr, char *buf,
 				enum transparent_hugepage_flag flag)
 {
-	if (test_bit(flag, &transparent_hugepage_flags))
-		return sprintf(buf, "[yes] no\n");
-	else
-		return sprintf(buf, "yes [no]\n");
+	return sprintf(buf, "%d\n",
+		       !!test_bit(flag, &transparent_hugepage_flags));
 }
+
 static ssize_t single_flag_store(struct kobject *kobj,
 				 struct kobj_attribute *attr,
 				 const char *buf, size_t count,
 				 enum transparent_hugepage_flag flag)
 {
-	if (!memcmp("yes", buf,
-		    min(sizeof("yes")-1, count))) {
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret < 0)
+		return ret;
+	if (value > 1)
+		return -EINVAL;
+
+	if (value)
 		set_bit(flag, &transparent_hugepage_flags);
-	} else if (!memcmp("no", buf,
-			   min(sizeof("no")-1, count))) {
+	else
 		clear_bit(flag, &transparent_hugepage_flags);
-	} else
-		return -EINVAL;
 
 	return count;
 }


