Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2KGDGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:06:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2KGDGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:06:41 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, aquini@redhat.com
Subject: [PATCH v11 1/7] mm: adjust address_space_operations.migratepage() return code
Date: Wed,  7 Nov 2012 01:05:48 -0200
Message-Id: <74bc30697313206e1225f6fc658bc5952b588dcc.1352256085.git.aquini@redhat.com>
In-Reply-To: <cover.1352256081.git.aquini@redhat.com>
References: <cover.1352256081.git.aquini@redhat.com>
In-Reply-To: <cover.1352256081.git.aquini@redhat.com>
References: <cover.1352256081.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces MIGRATEPAGE_SUCCESS as the default return code
for address_space_operations.migratepage() method and documents the
expected return code for the same method in failure cases.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
 fs/hugetlbfs/inode.c    |  4 ++--
 include/linux/migrate.h |  7 +++++++
 mm/migrate.c            | 22 +++++++++++-----------
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c5bc355..bdeda2c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -608,11 +608,11 @@ static int hugetlbfs_migrate_page(struct address_space *mapping,
 	int rc;
 
 	rc = migrate_huge_page_move_mapping(mapping, newpage, page);
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 	migrate_page_copy(newpage, page);
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index ce7e667..a4e886d 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -7,6 +7,13 @@
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
+/*
+ * Return values from addresss_space_operations.migratepage():
+ * - negative errno on page migration failure;
+ * - zero on page migration success;
+ */
+#define MIGRATEPAGE_SUCCESS		0
+
 #ifdef CONFIG_MIGRATION
 
 extern void putback_lru_pages(struct list_head *l);
diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..98c7a89 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -286,7 +286,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 		/* Anonymous page without mapping */
 		if (page_count(page) != 1)
 			return -EAGAIN;
-		return 0;
+		return MIGRATEPAGE_SUCCESS;
 	}
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -356,7 +356,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	}
 	spin_unlock_irq(&mapping->tree_lock);
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 /*
@@ -372,7 +372,7 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	if (!mapping) {
 		if (page_count(page) != 1)
 			return -EAGAIN;
-		return 0;
+		return MIGRATEPAGE_SUCCESS;
 	}
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -399,7 +399,7 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	page_unfreeze_refs(page, expected_count - 1);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 /*
@@ -486,11 +486,11 @@ int migrate_page(struct address_space *mapping,
 
 	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, mode);
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	migrate_page_copy(newpage, page);
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(migrate_page);
 
@@ -513,7 +513,7 @@ int buffer_migrate_page(struct address_space *mapping,
 
 	rc = migrate_page_move_mapping(mapping, newpage, page, head, mode);
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	/*
@@ -549,7 +549,7 @@ int buffer_migrate_page(struct address_space *mapping,
 
 	} while (bh != head);
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(buffer_migrate_page);
 #endif
@@ -814,7 +814,7 @@ skip_unmap:
 		put_anon_vma(anon_vma);
 
 uncharge:
-	mem_cgroup_end_migration(mem, page, newpage, rc == 0);
+	mem_cgroup_end_migration(mem, page, newpage, rc == MIGRATEPAGE_SUCCESS);
 unlock:
 	unlock_page(page);
 out:
@@ -987,7 +987,7 @@ int migrate_pages(struct list_head *from,
 			case -EAGAIN:
 				retry++;
 				break;
-			case 0:
+			case MIGRATEPAGE_SUCCESS:
 				break;
 			default:
 				/* Permanent failure */
@@ -1024,7 +1024,7 @@ int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
 			/* try again */
 			cond_resched();
 			break;
-		case 0:
+		case MIGRATEPAGE_SUCCESS:
 			goto out;
 		default:
 			rc = -EIO;
-- 
1.7.11.7

